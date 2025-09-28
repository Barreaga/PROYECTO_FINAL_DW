
const mysql = require('mysql2');
require('dotenv').config();

const conexion = mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'simuladorcripto'
});

conexion.connect((error) => {
    if (error) {
        console.error('Error conectando a la base de datos:', error);
        return;
    }
    console.log('Conectado a la base de datos MySQL');
});

module.exports = conexion;