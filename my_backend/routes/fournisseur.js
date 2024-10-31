const express = require('express');
const router = express.Router();
const pool = require('../db'); 

router.get('/', async (req, res) => {
    try {
      const result = await pool.query('SELECT * FROM fournisseurs');
      res.json(result.rows);
    } catch (err) {
      console.error(err.message);
      res.status(500).send('Erreur serveur');
    }
  });

router.get('/:id', async (req, res) => {
  const fournisseurId = req.params.id;
  try {
    const result = await pool.query('SELECT * FROM fournisseurs WHERE fournisseur_id = $1', [fournisseurId]);
    
    if (result.rows.length === 0) {
      return res.status(404).send('Fournisseur non trouvé');
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
});

  module.exports = router;