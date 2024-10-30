const express = require('express');
const router = express.Router();
const pool = require('../db'); 

router.get('/', async (req, res) => {
    try {
      const result = await pool.query('SELECT * FROM Lignes_Facture');
      res.json(result.rows);
    } catch (err) {
      console.error(err.message);
      res.status(500).send('Erreur serveur');
    }
  });

router.get('/:id', async (req, res) => {
    const factureId = req.params.id;
    try {
      const result = await pool.query('SELECT * FROM Lignes_Facture WHERE facture_id = $1', [factureId]);
      res.json(result.rows);
    } catch (err) {
      console.error(err.message);
      res.status(500).send('Erreur serveur');
    }
  });  

  module.exports = router;