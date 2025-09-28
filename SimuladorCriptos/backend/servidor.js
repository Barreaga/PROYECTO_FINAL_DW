
const express = require('express');
const cors = require('cors');
require('dotenv').config();

const rutasAuth = require('./rutas/auth');
const rutasUsuarios = require('./rutas/usuarios');
const rutasCriptos = require('./rutas/criptos');
const rutasTransacciones = require('./rutas/transacciones');

const app = express();

app.use(cors());
app.use(express.json());

app.use('/api/auth', rutasAuth);
app.use('/api/usuarios', rutasUsuarios);
app.use('/api/criptos', rutasCriptos);
app.use('/api/transacciones', rutasTransacciones);

app.get('/', (req, res) => {
    res.json({ mensaje: 'API del Simulador de Criptomonedas funcionando' });
});

const PUERTO = process.env.PUERTO || 5000;
app.listen(PUERTO, () => {
    console.log(`Servidor corriendo en puerto ${PUERTO}`);
});