const express = require('express');
const router = express.Router();
const pool = require('../db'); 

router.get('/', async (req, res) => {
    try {
      const result = await pool.query('SELECT * FROM Comptes');
      res.json(result.rows);
    } catch (err) {
      console.error(err.message);
      res.status(500).send('Erreur serveur');
    }
  });

router.post('/', async (req, res) => {
  const { nomCompte, typeCompte, montantDebit, montantCredit, solde, dateCreation } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO Comptes (nom_compte, type_compte, debit, credit, solde, date_creation) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [nomCompte, typeCompte, montantDebit, montantCredit, solde, dateCreation]
    );
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
});

router.get('/lastId', async (req, res) => {
  try{
    const result = await pool.query('SELECT compte_id FROM comptes ORDER BY compte_id DESC LIMIT 1')
    res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
})
  
  module.exports = router;