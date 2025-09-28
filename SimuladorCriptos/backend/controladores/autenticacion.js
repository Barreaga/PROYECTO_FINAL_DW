
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const basedatos = require('../config/basedatos');

const registrar = async (req, res) => {
    const { nombre, email, password } = req.body;
    
    try {
        const [existente] = await basedatos.promise().query(
            'SELECT id FROM usuarios WHERE email = ?', 
            [email]
        );
        
        if (existente.length > 0) {
            return res.status(400).json({ mensaje: 'El usuario ya existe' });
        }

        const salt = await bcrypt.genSalt(10);
        const passwordHasheado = await bcrypt.hash(password, salt);

        const [resultado] = await basedatos.promise().query(
            'INSERT INTO usuarios (nombre, email, password) VALUES (?, ?, ?)',
            [nombre, email, passwordHasheado]
        );

        const token = jwt.sign(
            { id: resultado.insertId, email, esadmin: false },
            process.env.JWT_SECRET || 'secret',
            { expiresIn: '24h' }
        );

        res.status(201).json({
            mensaje: 'Usuario registrado exitosamente',
            token,
            usuario: { id: resultado.insertId, nombre, email, esadmin: false }
        });
    } catch (error) {
        res.status(500).json({ mensaje: 'Error del servidor', error: error.message });
    }
};

const login = async (req, res) => {
    const { email, password } = req.body;

    try {
        const [usuarios] = await basedatos.promise().query(
            'SELECT * FROM usuarios WHERE email = ? AND activo = TRUE',
            [email]
        );

        if (usuarios.length === 0) {
            return res.status(400).json({ mensaje: 'Credenciales inválidas' });
        }

        const usuario = usuarios[0];
        const coincide = await bcrypt.compare(password, usuario.password);

        if (!coincide) {
            return res.status(400).json({ mensaje: 'Credenciales inválidas' });
        }

        const token = jwt.sign(
            { id: usuario.id, email: usuario.email, esadmin: usuario.esadmin },
            process.env.JWT_SECRET || 'secret',
            { expiresIn: '24h' }
        );

        res.json({
            mensaje: 'Login exitoso',
            token,
            usuario: {
                id: usuario.id,
                nombre: usuario.nombre,
                email: usuario.email,
                saldo: usuario.saldo,
                esadmin: usuario.esadmin
            }
        });
    } catch (error) {
        res.status(500).json({ mensaje: 'Error del servidor', error: error.message });
    }
};

module.exports = { registrar, login };