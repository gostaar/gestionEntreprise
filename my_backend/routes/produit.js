const express = require('express');
const router = express.Router();
const pool = require('../db'); // Assurez-vous d'importer votre instance de pool

// Route pour obtenir tous les clients
router.get('/', async (req, res) => {
    try {
      const result = await pool.query('SELECT * FROM Produits');
      res.json(result.rows);
    } catch (err) {
      console.error(err.message);
      res.status(500).send('Erreur serveur');
    }
  });

router.get('/:id', async (req, res) => {
  const produitId = req.params.id;
  try {
    const result = await pool.query('SELECT * FROM Produits WHERE produit_id = $1', [produitId]);
    res.json(result.rows);
  } catch(err) {
    console.error(err.message);
      res.status(500).send('Erreur serveur');
  }
})
  module.exports = router;