const functions = require('firebase-functions');
const express = require('express');
const engines = require('consolidate');
const {google} = require('googleapis');

const API_KEY = functions.config().takeoutmap.apikey; // Prepare to set functions:config takeout.apikey
const SHEET_ID = functions.config().takeoutmap.sheetid; // Prepare to set functions:config takeout.sheetid

const app = express();
app.engine('hbs', engines.handlebars);
app.set('views', './views');
app.set('view engine', 'hbs');

app.get('/', (request, response) => {
  response.set('Cache-Control', 'public, max-age=300, s-maxage=600');
  response.render('index');
})

app.get('/api/shops', async (request, response) => {
  const sheetRows = await getSheetData();
  response.json({shops: sheetRows});
});

async function getSheetData() {
  const params = {
    spreadsheetId: SHEET_ID,
    range: 'shops!A2:G2000'
  };
  const sheets = google.sheets({version: 'v4', auth: API_KEY});
  const response = await new Promise((resolve, reject) => {
    sheets.spreadsheets.values.get(params, (err, res) => {
      err ? reject(err) : resolve(res);
    });
  });

  const rows = response.data.values;
  let shops = new Array();
  if (rows.length) {
    rows.map((row) => {
      const name  = row[0];
      const addr  = row[1];
      const flag  = row[2];
      const phone = row[3];
      const lat   = row[4];
      const lng   = row[5];
      const web   = row[6];

      if (!name || !lat || !lng || flag == "FALSE") {
        return;
      }

      const shopData = {
        'name':  name,
        'addr':  addr,
        'flag':  flag,
        'phone': phone,
        'lat':   lat,
        'lng':   lng,
        'web':   web
      };

      shops.push(shopData);
    });
    return shops;
  } else {
    console.log('No data found.');
  }
}

exports.app = functions.https.onRequest(app);
