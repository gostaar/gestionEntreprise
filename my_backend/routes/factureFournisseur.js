const express = require('express');
const router = express.Router();
const pool = require('../db'); 

router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM factureFournisseur');
    res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
});

router.get('/facture/lastId', async (req, res) => {
  try {
    const result = await pool.query('SELECT facture_id FROM facturefournisseur ORDER BY facture_id DESC LIMIT 1');

    res.json(result.rows); // Renvoie uniquement la dernière facture
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
});


router.post('/', async (req, res) => {
  const { facture_id, fournisseur_id, date_facture, montant_total, statut, date_paiement } = req.body;

  if (!fournisseur_id || !date_facture || !montant_total || !statut) {
    return res.status(400).send('Données d\'entrée manquantes ou incorrectes');
  }

  try {
    const fournisseur = await pool.query('SELECT * FROM fournisseurs WHERE fournisseur_id = $1', [fournisseur_id]);

    if (fournisseur.rows.length === 0) {
      return res.status(400).send('Fournisseur non trouvé');
    }

    const result = await pool.query(
      'INSERT INTO facturefournisseur (facture_id, fournisseur_id, date_facture, montanttotal, statut, date_paiement) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [facture_id, fournisseur_id, date_facture, montant_total, statut, date_paiement]
    );

    const facture = result.rows[0];
    return res.json(facture); // Utiliser `return` ici aussi par précaution
  } catch (err) {
    console.error(err.message);
    return res.status(500).send('Erreur serveur : ' + err.message); // `return` ici pour arrêter l'exécution
  }
});

router.get('/fournisseur/:id', async (req, res) => {
  const fournisseurId = req.params.id;
  try {
    const result = await pool.query('SELECT * FROM facturefournisseur WHERE fournisseur_id = $1', [fournisseurId]);
    
    res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Erreur serveur');
  }
});




module.exports = router;