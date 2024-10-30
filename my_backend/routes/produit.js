const express = require('express');
const router = express.Router();
const pool = require('../db'); 

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
});

router.get('/l/lastId', async(req, res) => {
  try{
    const result = await pool.query('SELECT produit_id FROM Produits ORDER BY produit_id DESC LIMIT 1');
    res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur', err.message);
  }
})


router.post('/', async (req, res) => {
  const { nom_produit, description, prix, quantite_en_stock, categorie } = req.body;

  try {
    const result = await pool.query(
      `INSERT INTO Produits (nom_produit, description, prix, quantite_en_stock, categorie, date_ajout) 
       VALUES ($1, $2, $3, $4, $5, CURRENT_TIMESTAMP) 
       RETURNING *`,
      [nom_produit, description, prix, quantite_en_stock, categorie]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
});

  module.exports = router;