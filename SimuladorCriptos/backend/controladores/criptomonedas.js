
const basedatos = require('../config/basedatos');

const obtenerCriptomonedas = async (req, res) => {
    try {
        const [criptos] = await basedatos.promise().query(
            'SELECT * FROM criptomonedas WHERE activa = TRUE'
        );
        res.json(criptos);
    } catch (error) {
        res.status(500).json({ mensaje: 'Error al obtener criptomonedas', error: error.message });
    }
};

const obtenerPrecios = async (req, res) => {
    try {
        const [precios] = await basedatos.promise().query(
            'SELECT id, simbolo, precioactual FROM criptomonedas WHERE activa = TRUE'
        );
        res.json(precios);
    } catch (error) {
        res.status(500).json({ mensaje: 'Error al obtener precios', error: error.message });
    }
};

module.exports = { obtenerCriptomonedas, obtenerPrecios };