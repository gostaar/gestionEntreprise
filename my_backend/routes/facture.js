// routes/factures.js
const express = require('express');
const router = express.Router();
const pool = require('../db'); // Assurez-vous d'importer votre instance de pool

// Route pour obtenir toutes les factures
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM Factures');
    res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
});

// Route pour ajouter une facture avec des lignes de facture
router.post('/', async (req, res) => {
  const { client_id, date_facture, montant_total, statut, date_paiement, lignes } = req.body;
  const client = await pool.query('SELECT * FROM Clients WHERE client_id = $1', [client_id]);

  // Vérifiez si le client existe
  if (client.rows.length === 0) {
    return res.status(400).send('Client non trouvé');
  }

  try {
    // Ajout de la facture
    const result = await pool.query(
      'INSERT INTO Factures (client_id, date_facture, montant_total, statut, date_paiement) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [client_id, date_facture, montant_total, statut, date_paiement]
    );

    const facture = result.rows[0];

    // Ajout des lignes de facture
    const lignesPromises = lignes.map(ligne => {
      const { produit_id, quantite, prix_unitaire } = ligne;
      return pool.query(
        'INSERT INTO Lignes_Facture (facture_id, produit_id, quantite, prix_unitaire) VALUES ($1, $2, $3, $4) RETURNING *',
        [facture.facture_id, produit_id, quantite, prix_unitaire]
      );
    });

    // Attendez que toutes les promesses soient résolues
    await Promise.all(lignesPromises);

    res.json(facture);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
});

module.exports = router;
