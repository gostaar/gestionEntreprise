// db.js
const { Pool } = require('pg');

// Configuration de la base de données PostgreSQL
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'gestion_entreprise',
  password: '1234',
  port: 5432,
});

module.exports = pool;
