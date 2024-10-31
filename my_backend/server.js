// server.js
const express = require('express');
const app = express();
const port = 3000;
const clientsRoutes = require('./routes/client');
const facturesRoutes = require('./routes/facture');
const comptesRoutes = require('./routes/compte');
const produitsRoutes = require('./routes/produit');
const transactionsRoutes = require('./routes/transaction');
const utilisateursRoutes = require('./routes/utilisateur');
const lignesFactureRoutes = require('./routes/lignesFactures');
const fournisseurRoutes = require('./routes/fournisseur');
const facturefournisseurRoutes = require('./routes/factureFournisseur');

// Middleware pour parser les requêtes JSON
app.use(express.json());

// Utilisation des routes
app.use('/clients', clientsRoutes);
app.use('/factures', facturesRoutes);
app.use('/comptes', comptesRoutes);
app.use('/produits', produitsRoutes);
app.use('/transactions', transactionsRoutes);
app.use('/utilisateurs', utilisateursRoutes);
app.use('/lignesFactures', lignesFactureRoutes);
app.use('/fournisseurs', fournisseurRoutes);
app.use('/facturefournisseur', facturefournisseurRoutes);

// Démarrer le serveur
app.listen(port, () => {
  console.log(`Serveur backend actif sur http://localhost:${port}`);
});
