const express = require('express');
const router = express.Router();
const pool = require('../db'); 

router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM Factures');
    res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
});

router.get('/lastId', async(req, res) => {
  try{
    const result = await pool.query('SELECT facture_id FROM Factures ORDER BY facture_id DESC LIMIT 1')
    res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
})

router.get('/:id', async(req, res) => {
  const facture_id = req.params.facture_id;
  
  try{
    const result = await pool.query('SELECT * FROM Factures WHERE facture_id = $1', [facture_id]);
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
})

router.post('/', async (req, res) => {
  const { facture_id, client_id, montant_total, statut, date_paiement } = req.body;
  if (!client_id || !montant_total || !statut ) {
    return res.status(400).send('Données d\'entrée manquantes ou incorrectes');
  }

  try {
    const client = await pool.query('SELECT * FROM Clients WHERE client_id = $1', [client_id]);

    if (client.rows.length === 0) {
      return res.status(400).send('Client non trouvé');
    }

    const result = await pool.query(
      'INSERT INTO Factures (facture_id, client_id, montant_total, statut, date_paiement) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [facture_id, client_id, montant_total, statut, date_paiement]
    );

    const facture = result.rows[0];
    res.json(facture);
    
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur : ' + err.message);
  }
});

router.get('/client/:clientId', async (req, res) => {
  const { clientId } = req.params;

  try {
    const result = await pool.query('SELECT * FROM Factures WHERE client_id = $1', [clientId]);
    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Erreur lors de la récupération des factures' });
  }
});

router.patch('/:id', async (req, res) => {
  const { id } = req.params;
  const updates = req.body; // Contient seulement les champs à mettre à jour

  const query = `
    UPDATE factures 
    SET client_id = $1, date_facture = $2, montant_total = $3, statut = $4, date_paiement = $5 
    WHERE client_id = $6
    RETURNING *;
  `;

  const values = [
    updates.client_id,
    updates.date_facture,
    updates.montant_total,
    updates.statut,
    updates.date_paiement,
    id
  ];

  try {
    const result = await pool.query(query, values);
    
    // Vérifiez le résultat ici
    //console.log('Résultat de la mise à jour:', result);
    res.status(200).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ message: 'Erreur lors de la mise à jour du client coté backend', error });
  }
});

module.exports = router;
