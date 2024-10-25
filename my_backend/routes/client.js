const express = require('express');
const router = express.Router();
const pool = require('../db'); // Assurez-vous d'importer votre instance de pool

// Route pour obtenir tous les clients
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM Clients');
    res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
});

// Route pour ajouter un client
router.post('/', async (req, res) => {
  const { nom, prenom, email, telephone, adresse, ville, code_postal, pays } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO Clients (nom, prenom, email, telephone, adresse, ville, code_postal, pays) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *',
      [nom, prenom, email, telephone, adresse, ville, code_postal, pays]
    );
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
});

// Route pour obtenir un client par ID
router.get('/:id', async (req, res) => {
  const clientId = req.params.id;
  try {
    const result = await pool.query('SELECT * FROM Clients WHERE client_id = $1', [clientId]);
    
    if (result.rows.length === 0) {
      return res.status(404).send('Client non trouvé');
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
});

module.exports = router;