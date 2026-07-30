-- ============================================
-- REFACTORIZACION DE BASE DE DATOS
-- Aura App - Supabase Native
-- ============================================
-- Ejecutar este script completo en el SQL Editor de Supabase
-- ============================================

-- PASO 1: Crear tablas nuevas (nombres limpios, sin prefijos Django)
-- ============================================

-- Tabla: users
CREATE TABLE IF NOT EXISTS users (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text NOT NULL UNIQUE,
  password_hash text,
  email text UNIQUE,
  friend_code text,
  partner_id bigint REFERENCES users(id),
  guide integer,
  salary numeric,
  salary_type text DEFAULT 'fixed' CHECK (salary_type IN ('fixed', 'variable')),
  accumulated_balance numeric(15,2) DEFAULT 0 NOT NULL,
  migrated boolean DEFAULT false NOT NULL,
  auth_user_id uuid UNIQUE,
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

-- PASO 3: Crear Stored Procedures
-- ============================================

-- SP 1: sp_register_user (registro con bcrypt + Supabase Auth)
CREATE OR REPLACE FUNCTION sp_register_user(p_name text, p_password text, p_email text)
RETURNS json
SECURITY DEFINER
SET search_path = extensions, public, auth
AS $$
DECLARE
  v_user_id BIGINT;
  v_friend_code TEXT;
  v_name_trimmed TEXT;
  v_auth_id uuid;
  v_encrypted_password text;
BEGIN
  IF p_name IS NULL OR trim(p_name) = '' THEN
    RETURN '{"error": "El nombre es requerido"}';
  END IF;

  IF p_password IS NULL OR length(p_password) < 6 THEN
    RETURN '{"error": "La contrasena debe tener al menos 6 caracteres"}';
  END IF;

  IF p_email IS NULL OR p_email = '' THEN
    RETURN '{"error": "El email es requerido"}';
  END IF;

  v_name_trimmed := trim(p_name);

  IF EXISTS (SELECT 1 FROM public.users WHERE lower(name) = lower(v_name_trimmed)) THEN
    RETURN '{"error": "Este nombre ya esta en uso"}';
  END IF;

  IF EXISTS (SELECT 1 FROM auth.users WHERE email = p_email) THEN
    RETURN '{"error": "El email ya esta registrado"}';
  END IF;

  IF EXISTS (SELECT 1 FROM public.users WHERE email = p_email) THEN
    RETURN '{"error": "El email ya esta en uso"}';
  END IF;

  LOOP
    v_friend_code := upper(
      substring(md5(random()::text) from 1 for 4) || '-' ||
      substring(md5(random()::text) from 1 for 4)
    );
    EXIT WHEN NOT EXISTS (SELECT 1 FROM public.users WHERE friend_code = v_friend_code);
  END LOOP;

  v_encrypted_password := crypt(p_password, gen_salt('bf'));

  INSERT INTO auth.users (
    instance_id, id, aud, role, email, encrypted_password,
    email_confirmed_at, confirmation_sent_at,
    raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
    confirmation_token, email_change, email_change_token_new, recovery_token
  ) VALUES (
    '00000000-0000-0000-0000-000000000000',
    gen_random_uuid(),
    'authenticated',
    'authenticated',
    p_email,
    v_encrypted_password,
    NOW(), NOW(),
    '{"provider":"email","providers":["email"]}',
    jsonb_build_object('display_name', v_name_trimmed),
    NOW(), NOW(),
    '', '', '', ''
  )
  RETURNING id INTO v_auth_id;

  INSERT INTO auth.identities (
    provider_id, user_id, identity_data, provider,
    last_sign_in_at, created_at, updated_at
  ) VALUES (
    v_auth_id::text,
    v_auth_id,
    jsonb_build_object('sub', v_auth_id::text, 'email', p_email, 'name', v_name_trimmed),
    'email',
    NOW(), NOW(), NOW()
  );

  INSERT INTO public.users (name, password_hash, friend_code, email, auth_user_id, migrated)
  VALUES (v_name_trimmed, v_encrypted_password, v_friend_code, p_email, v_auth_id, true)
  RETURNING id INTO v_user_id;

  RETURN json_build_object(
    'id', v_user_id,
    'name', v_name_trimmed,
    'friend_code', v_friend_code,
    'guide', NULL,
    'email', p_email,
    'migrated', true,
    'auth_user_id', v_auth_id::text,
    'salary', NULL,
    'salary_type', 'fixed',
    'accumulated_balance', 0,
    'partner_id', NULL,
    'partner_name', NULL
  );
END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION sp_register_user TO anon, authenticated;

-- SP 2: sp_login (autenticacion con verificacion bcrypt)
CREATE OR REPLACE FUNCTION sp_login(p_name text, p_password text)
RETURNS json AS $$
DECLARE
  v_user record;
BEGIN
  SELECT * INTO v_user FROM users WHERE name = p_name;

  IF NOT FOUND THEN
    RETURN json_build_object('error', 'Usuario no encontrado.');
  END IF;

  IF v_user.password_hash IS NOT NULL AND v_user.password_hash != '' THEN
    IF crypt(p_password, v_user.password_hash) != v_user.password_hash THEN
      RETURN json_build_object('error', 'Contrasena incorrecta.');
    END IF;
  END IF;

  RETURN json_build_object(
    'id', v_user.id,
    'name', v_user.name,
    'friend_code', v_user.friend_code,
    'guide', v_user.guide,
    'email', v_user.email,
    'migrated', v_user.migrated,
    'auth_user_id', v_user.auth_user_id::text,
    'salary', v_user.salary,
    'salary_type', v_user.salary_type,
    'accumulated_balance', v_user.accumulated_balance,
    'partner_id', v_user.partner_id,
    'partner_name', (SELECT name FROM users WHERE id = v_user.partner_id)
  );
END;
$$ LANGUAGE plpgsql;

-- SP 3: sp_deposit (previene race condition y overdraft)
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

-- SP 4: sp_withdraw (previene race condition y overdraft)
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

-- SP 5: sp_add_partner (conectar dos usuarios como pareja por codigo de amigo)
CREATE OR REPLACE FUNCTION sp_add_partner(p_friend_code text, p_user_id bigint)
RETURNS json AS $$
DECLARE
  v_partner record;
BEGIN
  SELECT * INTO v_partner FROM users WHERE friend_code = p_friend_code;

  IF NOT FOUND THEN
    RETURN json_build_object('error', 'Codigo de amigo no valido.');
  END IF;

  IF v_partner.id = p_user_id THEN
    RETURN json_build_object('error', 'No puedes agregarte a ti mismo.');
  END IF;

  UPDATE users SET partner_id = v_partner.id WHERE id = p_user_id;
  UPDATE users SET partner_id = p_user_id WHERE id = v_partner.id;

  RETURN json_build_object(
    'partner_id', v_partner.id,
    'partner_name', v_partner.name
  );
END;
$$ LANGUAGE plpgsql;

-- SP 6: sp_remove_partner (desconectar pareja)
CREATE OR REPLACE FUNCTION sp_remove_partner(p_user_id bigint)
RETURNS json AS $$
DECLARE
  v_partner_id bigint;
BEGIN
  SELECT partner_id INTO v_partner_id FROM users WHERE id = p_user_id;

  IF v_partner_id IS NULL THEN
    RETURN json_build_object('error', 'No tienes una pareja conectada.');
  END IF;

  UPDATE users SET partner_id = NULL WHERE id = p_user_id;
  UPDATE users SET partner_id = NULL WHERE id = v_partner_id;

  RETURN json_build_object('detail', 'Pareja eliminada exitosamente.');
END;
$$ LANGUAGE plpgsql;

-- SP 7: sp_complete_guide (marcar onboarding como completado)
CREATE OR REPLACE FUNCTION sp_complete_guide(p_user_id bigint)
RETURNS json AS $$
BEGIN
  UPDATE users SET guide = 1 WHERE id = p_user_id;

  IF NOT FOUND THEN
    RETURN json_build_object('error', 'Usuario no encontrado.');
  END IF;

  RETURN json_build_object('detail', 'Guide completado exitosamente.');
END;
$$ LANGUAGE plpgsql;

-- SP 8: sp_update_salary (actualizar salario y tipo)
CREATE OR REPLACE FUNCTION sp_update_salary(
  p_user_id bigint,
  p_salary numeric DEFAULT 0,
  p_salary_type text DEFAULT 'fixed'
)
RETURNS json AS $$
BEGIN
  UPDATE users
  SET salary = p_salary,
      salary_type = p_salary_type
  WHERE id = p_user_id;

  IF NOT FOUND THEN
    RETURN json_build_object('error', 'Usuario no encontrado.');
  END IF;

  RETURN json_build_object('detail', 'Salario y tipo actualizados exitosamente.');
END;
$$ LANGUAGE plpgsql;

-- SP 9: sp_update_accumulated_balance (actualizar balance acumulado)
CREATE OR REPLACE FUNCTION sp_update_accumulated_balance(
  p_user_id bigint,
  p_balance numeric
)
RETURNS json AS $$
BEGIN
  UPDATE users
  SET accumulated_balance = p_balance
  WHERE id = p_user_id;

  IF NOT FOUND THEN
    RETURN json_build_object('error', 'Usuario no encontrado.');
  END IF;

  RETURN json_build_object('detail', 'Balance acumulado actualizado exitosamente.');
END;
$$ LANGUAGE plpgsql;

-- SP 10: sp_migrate_user (migrar a Supabase Auth con verificacion bcrypt)
CREATE OR REPLACE FUNCTION sp_migrate_user(
  p_user_id bigint,
  p_password text,
  p_email text
) RETURNS json
SECURITY DEFINER
SET search_path = extensions, public, auth
AS $$
DECLARE
  v_user public.users%ROWTYPE;
  v_auth_id uuid;
  v_encrypted_password text;
BEGIN
  SELECT * INTO v_user FROM public.users WHERE id = p_user_id;
  IF NOT FOUND THEN
    RETURN json_build_object('error', 'Usuario no encontrado');
  END IF;

  IF v_user.password_hash IS NULL OR crypt(p_password, v_user.password_hash) != v_user.password_hash THEN
    RETURN json_build_object('error', 'Contrasena incorrecta');
  END IF;

  IF v_user.migrated THEN
    RETURN json_build_object('error', 'El usuario ya fue migrado');
  END IF;

  IF EXISTS (SELECT 1 FROM auth.users WHERE email = p_email) THEN
    RETURN json_build_object('error', 'El email ya esta registrado');
  END IF;

  IF EXISTS (SELECT 1 FROM public.users WHERE email = p_email AND id != p_user_id) THEN
    RETURN json_build_object('error', 'El email ya esta en uso');
  END IF;

  v_encrypted_password := crypt(p_password, gen_salt('bf'));

  INSERT INTO auth.users (
    instance_id, id, aud, role, email, encrypted_password,
    email_confirmed_at, confirmation_sent_at,
    raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
    confirmation_token, email_change, email_change_token_new, recovery_token
  ) VALUES (
    '00000000-0000-0000-0000-000000000000',
    gen_random_uuid(),
    'authenticated',
    'authenticated',
    p_email,
    v_encrypted_password,
    NOW(), NOW(),
    '{"provider":"email","providers":["email"]}',
    jsonb_build_object('display_name', v_user.name),
    NOW(), NOW(),
    '', '', '', ''
  )
  RETURNING id INTO v_auth_id;

  INSERT INTO auth.identities (
    provider_id, user_id, identity_data, provider,
    last_sign_in_at, created_at, updated_at
  ) VALUES (
    v_auth_id::text,
    v_auth_id,
    jsonb_build_object('sub', v_auth_id::text, 'email', p_email, 'name', v_user.name),
    'email',
    NOW(), NOW(), NOW()
  );

  UPDATE public.users
  SET email = p_email,
      auth_user_id = v_auth_id,
      migrated = true
  WHERE id = p_user_id;

  RETURN json_build_object(
    'success', true,
    'auth_user_id', v_auth_id::text
  );
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- Tabla: incomes
CREATE TABLE IF NOT EXISTS incomes (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  usuario bigint NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  categoria text NOT NULL,
  fecha date NOT NULL,
  descripcion text NOT NULL,
  valor numeric(12,2) NOT NULL CHECK (valor > 0),
  created_at timestamptz DEFAULT now() NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_incomes_usuario_fecha ON incomes (usuario, fecha DESC, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_incomes_fecha ON incomes (fecha);

-- PASO 5: Habilitar RLS (Row Level Security) - Opcional pero recomendado
-- ============================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE access_keys ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE incomes ENABLE ROW LEVEL SECURITY;
ALTER TABLE saving_goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE saving_movements ENABLE ROW LEVEL SECURITY;

-- Políticas permisivas (RLS habilitado pero sin restricciones)
-- La app maneja la lógica de acceso
CREATE POLICY "Allow all on users" ON users FOR ALL USING (true);
CREATE POLICY "Allow all on access_keys" ON access_keys FOR ALL USING (true);
CREATE POLICY "Allow all on expenses" ON expenses FOR ALL USING (true);
CREATE POLICY "Allow all on incomes" ON incomes FOR ALL USING (true);
CREATE POLICY "Allow all on saving_goals" ON saving_goals FOR ALL USING (true);
CREATE POLICY "Allow all on saving_movements" ON saving_movements FOR ALL USING (true);

-- PASO 6: Eliminar tablas viejas de Django (después de verificar migración)
-- ============================================

-- ⚠️ EJECUTAR SOLO DESPUÉS DE VERIFICAR QUE LA MIGRACIÓN FUNCIONA ⚠️

-- DROP TABLE IF EXISTS savings_savinggoalparticipant CASCADE;
-- DROP TABLE IF EXISTS savings_savingmovement CASCADE;
-- DROP TABLE IF EXISTS savings_savinggoal CASCADE;
-- DROP TABLE IF EXISTS expenses_expense CASCADE;
-- DROP TABLE IF EXISTS authentication_accesskey CASCADE;
-- DROP TABLE IF EXISTS authentication_user CASCADE;

-- ============================================
-- FUNCIÓN PARA BUSCAR USUARIO POR AUTH_USER_ID (Supabase Auth)
-- ============================================
CREATE OR REPLACE FUNCTION public.sp_get_user_by_auth_id(p_auth_id uuid)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user record;
BEGIN
  SELECT * INTO v_user FROM public.users WHERE auth_user_id = p_auth_id;
  IF NOT FOUND THEN
    RETURN json_build_object('error', 'Usuario no encontrado');
  END IF;

  RETURN json_build_object(
    'id', v_user.id,
    'name', v_user.name,
    'friend_code', v_user.friend_code,
    'guide', v_user.guide,
    'email', v_user.email,
    'migrated', v_user.migrated,
    'auth_user_id', v_user.auth_user_id::text,
    'salary', v_user.salary,
    'salary_type', v_user.salary_type,
    'accumulated_balance', v_user.accumulated_balance,
    'partner_id', v_user.partner_id,
    'partner_name', (SELECT name FROM public.users WHERE id = v_user.partner_id)
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.sp_get_user_by_auth_id TO anon, authenticated;

-- ============================================
-- FIN DEL SCRIPT
-- ============================================
