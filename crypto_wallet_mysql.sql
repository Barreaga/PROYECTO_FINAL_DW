-- =====================================================
-- SCRIPT DE CREACIÓN DE BASE DE DATOS CRYPTO WALLET
-- Base de datos: MySQL
-- Generado desde migraciones de Django
-- =====================================================

-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS crypto_wallet_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE crypto_wallet_db;

-- =====================================================
-- TABLA: usuarios (Modelo Usuario personalizado)
-- =====================================================
CREATE TABLE usuarios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    password VARCHAR(128) NOT NULL,
    last_login DATETIME(6) NULL,
    is_superuser BOOLEAN NOT NULL DEFAULT FALSE,
    email VARCHAR(150) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_staff BOOLEAN NOT NULL DEFAULT FALSE,
    creado_en DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    INDEX idx_usuarios_email (email),
    INDEX idx_usuarios_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: monedas (Criptomonedas)
-- =====================================================
CREATE TABLE monedas (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    simbolo VARCHAR(10) NOT NULL UNIQUE,
    coingecko_id VARCHAR(50) NULL,
    creado_en DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    INDEX idx_monedas_simbolo (simbolo),
    INDEX idx_monedas_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: precios (Precios históricos de monedas)
-- =====================================================
CREATE TABLE precios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    precio_usd DECIMAL(18,2) NOT NULL,
    fecha DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    moneda_id BIGINT NOT NULL,
    INDEX idx_precios_moneda_fecha (moneda_id, fecha DESC),
    INDEX idx_precios_fecha (fecha DESC),
    FOREIGN KEY (moneda_id) REFERENCES monedas(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: wallet (Billeteras de usuarios)
-- =====================================================
CREATE TABLE wallet (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    balance DECIMAL(18,8) NOT NULL DEFAULT 0.00000000,
    usuario_id BIGINT NOT NULL,
    moneda_id BIGINT NOT NULL,
    UNIQUE KEY unique_usuario_moneda (usuario_id, moneda_id),
    INDEX idx_wallet_usuario (usuario_id),
    INDEX idx_wallet_moneda (moneda_id),
    INDEX idx_wallet_balance (balance),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (moneda_id) REFERENCES monedas(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: transacciones (Transacciones de usuarios)
-- =====================================================
CREATE TABLE transacciones (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(20) NOT NULL,
    cantidad DECIMAL(18,8) NOT NULL,
    precio_usd DECIMAL(18,2) NULL,
    descripcion TEXT NULL,
    fecha DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    wallet_id BIGINT NOT NULL,
    wallet_destino_id BIGINT NULL,
    INDEX idx_transacciones_wallet_fecha (wallet_id, fecha DESC),
    INDEX idx_transacciones_tipo_fecha (tipo, fecha DESC),
    INDEX idx_transacciones_fecha (fecha DESC),
    FOREIGN KEY (wallet_id) REFERENCES wallet(id) ON DELETE CASCADE,
    FOREIGN KEY (wallet_destino_id) REFERENCES wallet(id) ON DELETE CASCADE,
    CHECK (tipo IN ('compra', 'venta', 'transferencia'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLAS DEL SISTEMA DJANGO (auth, contenttypes, etc.)
-- =====================================================

-- Tabla de tipos de contenido de Django
CREATE TABLE django_content_type (
    id INT AUTO_INCREMENT PRIMARY KEY,
    app_label VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    UNIQUE KEY django_content_type_app_label_model_76bd3d3b_uniq (app_label, model)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de permisos de Django
CREATE TABLE auth_permission (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    content_type_id INT NOT NULL,
    codename VARCHAR(100) NOT NULL,
    UNIQUE KEY auth_permission_content_type_id_codename_01ab375a_uniq (content_type_id, codename),
    FOREIGN KEY (content_type_id) REFERENCES django_content_type(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de grupos de Django
CREATE TABLE auth_group (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de permisos de grupos
CREATE TABLE auth_group_permissions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    group_id INT NOT NULL,
    permission_id INT NOT NULL,
    UNIQUE KEY auth_group_permissions_group_id_permission_id_0cd325b0_uniq (group_id, permission_id),
    FOREIGN KEY (group_id) REFERENCES auth_group(id),
    FOREIGN KEY (permission_id) REFERENCES auth_permission(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de permisos de usuarios
CREATE TABLE usuarios_usuario_groups (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    usuario_id BIGINT NOT NULL,
    group_id INT NOT NULL,
    UNIQUE KEY usuarios_usuario_groups_usuario_id_group_id_b3c71f80_uniq (usuario_id, group_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (group_id) REFERENCES auth_group(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE usuarios_usuario_user_permissions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    usuario_id BIGINT NOT NULL,
    permission_id INT NOT NULL,
    UNIQUE KEY usuarios_usuario_user_permissions_usuario_id_permission_id_43338c45_uniq (usuario_id, permission_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (permission_id) REFERENCES auth_permission(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de sesiones de Django
CREATE TABLE django_session (
    session_key VARCHAR(40) PRIMARY KEY,
    session_data LONGTEXT NOT NULL,
    expire_date DATETIME(6) NOT NULL,
    INDEX django_session_expire_date_a5c62663 (expire_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de migraciones de Django
CREATE TABLE django_migrations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    app VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    applied DATETIME(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de log de administración
CREATE TABLE django_admin_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    action_time DATETIME(6) NOT NULL,
    object_id LONGTEXT NULL,
    object_repr VARCHAR(200) NOT NULL,
    action_flag SMALLINT UNSIGNED NOT NULL,
    change_message LONGTEXT NOT NULL,
    content_type_id INT NULL,
    user_id BIGINT NOT NULL,
    FOREIGN KEY (content_type_id) REFERENCES django_content_type(id),
    FOREIGN KEY (user_id) REFERENCES usuarios(id),
    INDEX django_admin_log_content_type_id_c4bce8eb (content_type_id),
    INDEX django_admin_log_user_id_c564eba6 (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- DATOS INICIALES
-- =====================================================

-- Insertar tipos de contenido básicos
INSERT INTO django_content_type (app_label, model) VALUES
('usuarios', 'usuario'),
('monedas', 'moneda'),
('monedas', 'precio'),
('wallet', 'wallet'),
('transacciones', 'transaccion'),
('auth', 'permission'),
('auth', 'group'),
('contenttypes', 'contenttype'),
('sessions', 'session'),
('admin', 'logentry');

-- Insertar monedas principales
INSERT INTO monedas (nombre, simbolo, coingecko_id, creado_en) VALUES
('Bitcoin', 'BTC', 'bitcoin', NOW()),
('Ethereum', 'ETH', 'ethereum', NOW()),
('Binance Coin', 'BNB', 'binancecoin', NOW()),
('Cardano', 'ADA', 'cardano', NOW()),
('Solana', 'SOL', 'solana', NOW()),
('Polkadot', 'DOT', 'polkadot', NOW()),
('Dogecoin', 'DOGE', 'dogecoin', NOW()),
('Avalanche', 'AVAX', 'avalanche-2', NOW()),
('Chainlink', 'LINK', 'chainlink', NOW()),
('Polygon', 'MATIC', 'matic-network', NOW());

-- =====================================================
-- COMENTARIOS Y DOCUMENTACIÓN
-- =====================================================

/*
ESTRUCTURA DE LA BASE DE DATOS CRYPTO WALLET

1. USUARIOS:
   - Sistema de autenticación personalizado con email
   - Campos: id, email, nombre, password, is_active, is_staff, creado_en

2. MONEDAS:
   - Catálogo de criptomonedas disponibles
   - Integración con CoinGecko API
   - Campos: id, nombre, simbolo, coingecko_id, creado_en

3. PRECIOS:
   - Historial de precios de las monedas
   - Actualización automática desde APIs
   - Campos: id, moneda_id, precio_usd, fecha

4. WALLET:
   - Billeteras de usuarios por moneda
   - Restricción única: un wallet por usuario por moneda
   - Campos: id, usuario_id, moneda_id, balance

5. TRANSACCIONES:
   - Registro de todas las operaciones
   - Tipos: compra, venta, transferencia
   - Campos: id, wallet_id, tipo, cantidad, precio_usd, descripcion, fecha, wallet_destino_id

ÍNDICES OPTIMIZADOS:
- Búsquedas por usuario y moneda
- Consultas de transacciones por fecha
- Precios históricos ordenados
- Autenticación por email

RESTRICCIONES:
- Integridad referencial con CASCADE
- Validación de tipos de transacción
- Unicidad en combinaciones críticas
*/