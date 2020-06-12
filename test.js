const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 5000;

// Configuring body parser middleware
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.get('/create-group', (req, res) => {
  var ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;

  res.send(ip);
});

app.set('trust proxy', true)
app.listen(port, () => console.log(`Hello world app listening on port ${port}!`))
