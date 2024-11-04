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

router.post('/', async (req, res) => {
  const { nom, prenom, email, telephone, adresse, ville, code_postal, pays } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO Clients (nom, prenom, email, telephone, adresse, ville, code_postal, pays) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *',
      [nom, prenom, email, telephone, adresse, ville, code_postal, pays]
    );
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
});

router.get('/:id', async (req, res) => {
  const clientId = req.params.id;
  try {
    const result = await pool.query('SELECT * FROM Clients WHERE client_id = $1', [clientId]);
    
    if (result.rows.length === 0) {
      return res.status(404).send('Client non trouvé');
    }
    
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
    updates.codePostal, // Assurez-vous que le nom ici est correct
    updates.pays,
    updates.numeroTva,
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