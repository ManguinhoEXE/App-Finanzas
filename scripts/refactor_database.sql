-- ============================================
-- REFACTORIZACION DE BASE DE DATOS
-- Aura App - Supabase Native
-- ============================================
-- Ejecutar este script completo en el SQL Editor de Supabase
-- ============================================

-- PASO 1: Crear tablas nuevas (nombres limpios, sin prefijos Django)
-- ============================================

-- Tabla: users (sin password, sin last_login)
CREATE TABLE IF NOT EXISTS users (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text NOT NULL UNIQUE,
  created_at timestamptz DEFAULT now() NOT NULL
);

-- Tabla: access_keys
CREATE TABLE IF NOT EXISTS access_keys (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  key text NOT NULL UNIQUE,
  used boolean DEFAULT false NOT NULL,
  used_at timestamptz,
  created_at timestamptz DEFAULT now() NOT NULL
);

-- Tabla: expenses (sin prefijo expenses_)
CREATE TABLE IF NOT EXISTS expenses (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  usuario bigint NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  categoria text NOT NULL,
  fecha date NOT NULL,
  descripcion text NOT NULL,
  valor numeric(12,2) NOT NULL CHECK (valor >= 0),
  compartido boolean DEFAULT false NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL
);

-- Tabla: saving_goals (sin prefijo savings_)
CREATE TABLE IF NOT EXISTS saving_goals (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  owner bigint NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name text NOT NULL,
  description text DEFAULT '' NOT NULL,
  target_amount numeric(15,2) NOT NULL CHECK (target_amount > 0),
  current_amount numeric(15,2) DEFAULT 0 NOT NULL CHECK (current_amount >= 0),
  currency text DEFAULT 'COP' NOT NULL,
  deadline date,
  is_shared boolean DEFAULT false NOT NULL,
  status text DEFAULT 'ACTIVE' NOT NULL CHECK (status IN ('ACTIVE','COMPLETED','PAUSED','CANCELLED')),
  created_at timestamptz DEFAULT now() NOT NULL,
  updated_at timestamptz DEFAULT now() NOT NULL
);

-- Tabla: saving_movements (sin prefijo savings_, sin saving_goal_participants)
CREATE TABLE IF NOT EXISTS saving_movements (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  goal bigint NOT NULL REFERENCES saving_goals(id) ON DELETE CASCADE,
  "user" bigint NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type text NOT NULL CHECK (type IN ('DEPOSIT','WITHDRAW','ADJUSTMENT')),
  amount numeric(15,2) NOT NULL CHECK (amount > 0),
  description text DEFAULT '' NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL
);

-- PASO 2: Crear índices optimizados
-- ============================================

-- Expenses
CREATE INDEX IF NOT EXISTS idx_expenses_usuario_fecha ON expenses (usuario, fecha DESC, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_expenses_compartido ON expenses (compartido) WHERE compartido = true;
CREATE INDEX IF NOT EXISTS idx_expenses_fecha ON expenses (fecha);

-- Saving Goals
CREATE INDEX IF NOT EXISTS idx_goals_owner ON saving_goals (owner, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_goals_shared ON saving_goals (is_shared, created_at DESC) WHERE is_shared = true;
CREATE INDEX IF NOT EXISTS idx_goals_status ON saving_goals (status) WHERE status = 'ACTIVE';

-- Saving Movements
CREATE INDEX IF NOT EXISTS idx_movements_goal ON saving_movements (goal, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_movements_user ON saving_movements ("user");

-- Access Keys
CREATE INDEX IF NOT EXISTS idx_keys_key_used ON access_keys (key) WHERE used = false;

-- PASO 3: Crear Stored Procedures críticositicos
-- ============================================

-- SP 1: sp_activate_key (previene race condition con SELECT FOR UPDATE)
CREATE OR REPLACE FUNCTION sp_activate_key(p_key text, p_name text)
RETURNS json AS $$
DECLARE
  v_key_record record;
  v_user record;
BEGIN
  -- Buscar y bloquear la llave
  SELECT * INTO v_key_record
  FROM access_keys
  WHERE key = p_key
  FOR UPDATE;

  -- Verificar que existe
  IF v_key_record IS NULL THEN
    RETURN json_build_object('error', 'La llave ingresada no es valida.');
  END IF;

  -- Verificar que no fue usada
  IF v_key_record.used = true THEN
    RETURN json_build_object('error', 'La llave ya fue utilizada anteriormente.');
  END IF;

  -- Buscar o crear usuario
  SELECT * INTO v_user FROM users WHERE name = p_name;
  IF NOT FOUND THEN
    INSERT INTO users (name) VALUES (p_name) RETURNING * INTO v_user;
  END IF;

  -- Marcar llave como usada
  UPDATE access_keys
  SET used = true, used_at = now()
  WHERE id = v_key_record.id;

  -- Retornar usuario
  RETURN json_build_object(
    'id', v_user.id,
    'name', v_user.name
  );
END;
$$ LANGUAGE plpgsql;

-- SP 2: sp_deposit (previene race condition y overdraft)
CREATE OR REPLACE FUNCTION sp_deposit(
  p_goal_id bigint,
  p_user_id bigint,
  p_amount numeric,
  p_description text DEFAULT ''
)
RETURNS json AS $$
DECLARE
  v_goal record;
  v_new_amount numeric;
  v_movement record;
BEGIN
  -- Obtener y bloquear la meta
  SELECT * INTO v_goal
  FROM saving_goals
  WHERE id = p_goal_id
  FOR UPDATE;

  -- Verificar que existe
  IF v_goal IS NULL THEN
    RETURN json_build_object('error', 'Meta no encontrada.');
  END IF;

  -- Verificar estado ACTIVE
  IF v_goal.status != 'ACTIVE' THEN
    RETURN json_build_object('error', 'No se pueden registrar depositos en una meta que no esta activa.');
  END IF;

  -- Validar monto
  IF p_amount < 0.01 THEN
    RETURN json_build_object('error', 'El monto debe ser mayor a 0.');
  END IF;

  -- Crear movimiento
  INSERT INTO saving_movements (goal, "user", type, amount, description)
  VALUES (p_goal_id, p_user_id, 'DEPOSIT', p_amount, p_description)
  RETURNING * INTO v_movement;

  -- Actualizar monto actual
  v_new_amount := v_goal.current_amount + p_amount;
  UPDATE saving_goals
  SET current_amount = v_new_amount, updated_at = now()
  WHERE id = p_goal_id;

  -- Verificar si completó la meta
  IF v_new_amount >= v_goal.target_amount THEN
    UPDATE saving_goals
    SET status = 'COMPLETED'
    WHERE id = p_goal_id;
  END IF;

  -- Retornar resultado
  RETURN json_build_object(
    'detail', 'Deposito registrado exitosamente.',
    'movement', json_build_object(
      'id', v_movement.id,
      'goal', v_movement.goal,
      'user', v_movement."user",
      'type', v_movement.type,
      'amount', v_movement.amount,
      'description', v_movement.description,
      'created_at', v_movement.created_at
    ),
    'goal', (SELECT row_to_json(sg) FROM saving_goals sg WHERE id = p_goal_id)
  );
END;
$$ LANGUAGE plpgsql;

-- SP 3: sp_withdraw (previene race condition y overdraft)
CREATE OR REPLACE FUNCTION sp_withdraw(
  p_goal_id bigint,
  p_user_id bigint,
  p_amount numeric,
  p_description text DEFAULT ''
)
RETURNS json AS $$
DECLARE
  v_goal record;
  v_new_amount numeric;
  v_movement record;
BEGIN
  -- Obtener y bloquear la meta
  SELECT * INTO v_goal
  FROM saving_goals
  WHERE id = p_goal_id
  FOR UPDATE;

  -- Verificar que existe
  IF v_goal IS NULL THEN
    RETURN json_build_object('error', 'Meta no encontrada.');
  END IF;

  -- Verificar estado ACTIVE
  IF v_goal.status != 'ACTIVE' THEN
    RETURN json_build_object('error', 'No se pueden registrar retiros en una meta que no esta activa.');
  END IF;

  -- Verificar saldo suficiente
  IF p_amount > v_goal.current_amount THEN
    RETURN json_build_object('error', 'Saldo insuficiente para realizar este retiro.');
  END IF;

  -- Validar monto
  IF p_amount < 0.01 THEN
    RETURN json_build_object('error', 'El monto debe ser mayor a 0.');
  END IF;

  -- Crear movimiento
  INSERT INTO saving_movements (goal, "user", type, amount, description)
  VALUES (p_goal_id, p_user_id, 'WITHDRAW', p_amount, p_description)
  RETURNING * INTO v_movement;

  -- Actualizar monto actual
  v_new_amount := v_goal.current_amount - p_amount;
  UPDATE saving_goals
  SET current_amount = v_new_amount, updated_at = now()
  WHERE id = p_goal_id;

  -- Retornar resultado
  RETURN json_build_object(
    'detail', 'Retiro registrado exitosamente.',
    'movement', json_build_object(
      'id', v_movement.id,
      'goal', v_movement.goal,
      'user', v_movement."user",
      'type', v_movement.type,
      'amount', v_movement.amount,
      'description', v_movement.description,
      'created_at', v_movement.created_at
    ),
    'goal', (SELECT row_to_json(sg) FROM saving_goals sg WHERE id = p_goal_id)
  );
END;
$$ LANGUAGE plpgsql;

-- PASO 4: Habilitar RLS (Row Level Security) - Opcional pero recomendado
-- ============================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE access_keys ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE saving_goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE saving_movements ENABLE ROW LEVEL SECURITY;

-- Políticas permisivas (RLS habilitado pero sin restricciones)
-- La app maneja la lógica de acceso
CREATE POLICY "Allow all on users" ON users FOR ALL USING (true);
CREATE POLICY "Allow all on access_keys" ON access_keys FOR ALL USING (true);
CREATE POLICY "Allow all on expenses" ON expenses FOR ALL USING (true);
CREATE POLICY "Allow all on saving_goals" ON saving_goals FOR ALL USING (true);
CREATE POLICY "Allow all on saving_movements" ON saving_movements FOR ALL USING (true);

-- PASO 5: Eliminar tablas viejas de Django (después de verificar migración)
-- ============================================

-- ⚠️ EJECUTAR SOLO DESPUÉS DE VERIFICAR QUE LA MIGRACIÓN FUNCIONA ⚠️

-- DROP TABLE IF EXISTS savings_savinggoalparticipant CASCADE;
-- DROP TABLE IF EXISTS savings_savingmovement CASCADE;
-- DROP TABLE IF EXISTS savings_savinggoal CASCADE;
-- DROP TABLE IF EXISTS expenses_expense CASCADE;
-- DROP TABLE IF EXISTS authentication_accesskey CASCADE;
-- DROP TABLE IF EXISTS authentication_user CASCADE;

-- ============================================
-- FIN DEL SCRIPT
-- ============================================
