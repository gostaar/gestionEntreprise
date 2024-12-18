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

router.get('/lastId', async(req, res) => {
  try{
    const result = await pool.query('SELECT ligne_id FROM Lignes_Facture ORDER BY ligne_id DESC LIMIT 1')
    res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
})

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
  
router.post('/', async (req, res) => {
  const { facture_id, produit_id, quantite, prix_unitaire } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO Lignes_Facture (facture_id, produit_id, quantite, prix_unitaire) VALUES ($1, $2, $3, $4) RETURNING *',
      [facture_id, produit_id, quantite, prix_unitaire]
    );

    const facture = result.rows[0];
    res.json(facture);
    
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur : ' + err.message);
  }
});



  module.exports = router;