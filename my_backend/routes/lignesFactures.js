const express = require('express');
const router = express.Router();
const pool = require('../db'); 

// Route pour obtenir toutes les Lignes factures
router.get('/', async (req, res) => {
    try {
      const result = await pool.query('SELECT * FROM Lignes_Facture');
      res.json(result.rows);
    } catch (err) {
      console.error(err.message);
      res.status(500).send('Erreur serveur');
    }
  });

// Route pour obtenir un lignes_facture par ID
router.get('/:id', async (req, res) => {
    const lignes_factureId = req.params.id;
    try {
      const result = await pool.query('SELECT * FROM Lignes_Facture WHERE ligne_id = $1', [lignes_factureId]);
      
      if (result.rows.length === 0) {
        return res.status(404).send('lignes facture non trouvé');
      }
      
      res.json(result.rows[0]);
    } catch (err) {
      console.error(err.message);
      res.status(500).send('Erreur serveur');
    }
  });  

  module.exports = router;