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

router.get('/lastId', async(req, res) => {
  try{
    const result = await pool.query('SELECT facture_id FROM Factures ORDER BY facture_id DESC LIMIT 1')
    res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
})

// Route pour ajouter une facture avec des lignes de facture
router.post('/', async (req, res) => {
  const { facture_id, client_id, date_facture, montant_total, statut, date_paiement, lignes } = req.body;

  // Validation des données d'entrée
  if (!client_id || !date_facture || !montant_total || !statut || !Array.isArray(lignes)) {
    return res.status(400).send('Données d\'entrée manquantes ou incorrectes');
  }

  // Vérifiez si le client existe
  try {
    const client = await pool.query('SELECT * FROM Clients WHERE client_id = $1', [client_id]);

    if (client.rows.length === 0) {
      return res.status(400).send('Client non trouvé');
    }

    // Ajout de la facture
    const result = await pool.query(
      'INSERT INTO Factures (facture_id, client_id, date_facture, montant_total, statut, date_paiement) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [facture_id, client_id, date_facture, montant_total, statut, date_paiement]
    );

    const facture = result.rows[0];

    // Ajout des lignes de facture 
    const lignesPromises = lignes.map(async (ligne) => {
      const { ligne_id, produit_id, quantite, prix_unitaire } = ligne;

      // Validation des données de ligne
      if (!produit_id || !quantite || !prix_unitaire ) {
        throw new Error('Données de ligne manquantes ou incorrectes');
      }

      console.log(`Inserting line item: ligne_id=${ligne_id}, facture_id=${facture.facture_id}, produit_id=${produit_id}, quantite=${quantite}, prix_unitaire=${prix_unitaire}`);

      return pool.query(
        'INSERT INTO Lignes_Facture (ligne_id, facture_id, produit_id, quantite, prix_unitaire) VALUES ($1, $2, $3, $4, $5) RETURNING *',
        [ligne_id, facture.facture_id, produit_id, quantite, prix_unitaire]
      );
    });

    // Attendez que toutes les promesses soient résolues
    await Promise.all(lignesPromises);

    res.json(facture);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur : ' + err.message);
  }
});


module.exports = router;
