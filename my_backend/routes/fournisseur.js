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

  router.get('/lastId', async (req, res) =>{
    try{
      const result = await pool.query('SELECT fournisseurId FROM Fournisseurs ORDER BY clientId DESC LIMIT 1')
      res.json(result.rows);
    } catch (e) {
      console.error(e.message);
      res.status(500).send('Erreur serveur');
    }
  })
  
  router.post('/', async (req, res) => {
    const { nom, prenom, email, telephone, adresse, ville, code_postal, pays } = req.body;
    try {
      const result = await pool.query(
        'INSERT INTO fournisseurs (nom, prenom, email, telephone, adresse, ville, code_postal, pays) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *',
        [nom, prenom, email, telephone, adresse, ville, code_postal, pays]
      );
      res.json(result.rows[0]);
    } catch (err) {
      console.error(err.message);
      res.status(500).send('Erreur serveur');
    }
  });
  


  module.exports = router;