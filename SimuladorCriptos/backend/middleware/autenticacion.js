
const jwt = require('jsonwebtoken');

const middlewareAutenticacion = (req, res, next) => {
    const token = req.header('Authorization')?.replace('Bearer ', '');
    
    if (!token) {
        return res.status(401).json({ mensaje: 'No hay token, acceso denegado' });
    }

    try {
        const decodificado = jwt.verify(token, process.env.JWT_SECRET || 'secret');
        req.usuario = decodificado;
        next();
    } catch (error) {
        res.status(401).json({ mensaje: 'Token no válido' });
    }
};

const middlewareAdmin = (req, res, next) => {
    if (!req.usuario.esadmin) {
        return res.status(403).json({ mensaje: 'Acceso denegado. Se requiere administrador.' });
    }
    next();
};

module.exports = { middlewareAutenticacion, middlewareAdmin };