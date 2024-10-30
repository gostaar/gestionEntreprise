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

router.post('/', async (req, res) => {
  const { facture_id, client_id, date_facture, montant_total, statut, date_paiement, lignes } = req.body;

  if (!client_id || !date_facture || !montant_total || !statut || !Array.isArray(lignes)) {
    return res.status(400).send('Données d\'entrée manquantes ou incorrectes');
  }

  try {
    const client = await pool.query('SELECT * FROM Clients WHERE client_id = $1', [client_id]);

    if (client.rows.length === 0) {
      return res.status(400).send('Client non trouvé');
    }

    const result = await pool.query(
      'INSERT INTO Factures (facture_id, client_id, date_facture, montant_total, statut, date_paiement) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [facture_id, client_id, date_facture, montant_total, statut, date_paiement]
    );

    const facture = result.rows[0];

    const lignesPromises = lignes.map(async (ligne) => {
      const { ligne_id, produit_id, quantite, prix_unitaire } = ligne;

      if (!produit_id || !quantite || !prix_unitaire ) {
        throw new Error('Données de ligne manquantes ou incorrectes');
      }

      return pool.query(
        'INSERT INTO Lignes_Facture (ligne_id, facture_id, produit_id, quantite, prix_unitaire) VALUES ($1, $2, $3, $4, $5) RETURNING *',
        [ligne_id, facture.facture_id, produit_id, quantite, prix_unitaire]
      );
    });

    await Promise.all(lignesPromises);

    res.json(facture);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur : ' + err.message);
  }
});


module.exports = router;
