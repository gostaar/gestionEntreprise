const express = require('express');
const router = express.Router();
const pool = require('../db'); 

router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM Clients ORDER BY client_id ASC');
    res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
});

router.get('/lastId', async (req, res) => {
  try{
    const result = await pool.query('SELECT client_Id FROM Clients ORDER BY client_Id DESC LIMIT 1')
    res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
})

router.get('/:id', async (req, res) => {
  const client_Id = req.params.id;
  try {
    const result = await pool.query('SELECT * FROM Clients WHERE client_id = $1', [client_Id]);
    
    if (result.rows.length === 0) {
      return res.status(404).send('Client non trouvé');
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
});

router.post('/', async (req, res) => {
  const { client_Id, nom, prenom, email, telephone, adresse, ville, code_postal, pays, numero_tva } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO Clients ( client_id, nom, prenom, email, telephone, adresse, ville, code_postal, pays, numero_tva) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *',
      [client_Id, nom, prenom, email, telephone, adresse, ville, code_postal, pays, numero_tva]
    );
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
});

router.patch('/:id', async (req, res) => {
  const { id } = req.params;
  const updates = req.body; // Contient seulement les champs à mettre à jour
  const query = `
    UPDATE clients 
    SET nom = $1, prenom = $2, email = $3, telephone = $4, adresse = $5, ville = $6, code_postal = $7, pays = $8, numero_tva = $9 
    WHERE client_id = $10
    RETURNING *;
  `;

  const values = [
    updates.nom,
    updates.prenom,
    updates.email,
    updates.telephone,
    updates.adresse,
    updates.ville,
    updates.code_postal,
    updates.pays,
    updates.numero_tva,
    id
  ];

  try {
    const result = await pool.query(query, values);
    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Client non trouvé' });
    }
    res.status(200).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ message: 'Erreur lors de la mise à jour du client coté backend', error });
  }
});

module.exports = router;