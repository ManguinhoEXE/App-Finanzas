-- ============================================
-- INGRESOS FEATURE - ESQUEMA
-- Aura App - Supabase Native
-- ============================================
-- Ejecutar este script completo en el SQL Editor de Supabase
-- ============================================

-- PASO 1: Agregar columna salary_type a users
-- ============================================
ALTER TABLE users ADD COLUMN IF NOT EXISTS salary_type text DEFAULT 'fixed' CHECK (salary_type IN ('fixed', 'variable'));

-- PASO 2: Agregar columna accumulated_balance a users
-- ============================================
ALTER TABLE users ADD COLUMN IF NOT EXISTS accumulated_balance numeric(15,2) DEFAULT 0 NOT NULL;

-- PASO 3: Crear tabla de ingresos
-- ============================================
CREATE TABLE IF NOT EXISTS incomes (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  usuario bigint NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  categoria text NOT NULL,
  fecha date NOT NULL,
  descripcion text NOT NULL,
  valor numeric(12,2) NOT NULL CHECK (valor > 0),
  created_at timestamptz DEFAULT now() NOT NULL
);

-- PASO 4: Crear indices para incomes
-- ============================================
CREATE INDEX IF NOT EXISTS idx_incomes_usuario_fecha ON incomes (usuario, fecha DESC, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_incomes_fecha ON incomes (fecha);

-- PASO 5: Actualizar sp_update_salary para aceptar salary_type
-- ============================================
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

-- PASO 6: SP para actualizar accumulated_balance
-- ============================================
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

-- PASO 7: Actualizar sp_login para devolver salary_type y accumulated_balance
-- ============================================
CREATE OR REPLACE FUNCTION sp_login(p_name text, p_password text)
RETURNS json AS $$
DECLARE
  v_user record;
  v_partner_id bigint;
  v_partner_name text;
BEGIN
  -- Buscar usuario por nombre
  SELECT * INTO v_user FROM users WHERE name = p_name;
  
  IF NOT FOUND THEN
    RETURN json_build_object('error', 'Usuario no encontrado.');
  END IF;

  -- Devolver datos del usuario incluyendo nuevos campos
  RETURN json_build_object(
    'id', v_user.id,
    'name', v_user.name,
    'friend_code', v_user.friend_code,
    'guide', v_user.guide,
    'salary', v_user.salary,
    'salary_type', v_user.salary_type,
    'accumulated_balance', v_user.accumulated_balance,
    'partner_id', v_user.partner_id,
    'partner_name', (SELECT name FROM users WHERE id = v_user.partner_id)
  );
END;
$$ LANGUAGE plpgsql;

-- PASO 8: Políticas RLS para incomes
-- ============================================
ALTER TABLE incomes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all on incomes" ON incomes FOR ALL USING (true);

-- ============================================
-- FIN DEL SCRIPT
-- ============================================
