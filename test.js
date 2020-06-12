const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
var crypto = require('crypto');


const app = express();
const port = 5000;

// Configuring body parser middleware
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.put('/create-group', (req, res) => {
  var ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
  ip = ip + (Math.random() * 1000).toString(10);
  var name = req.body['name']
  console.log(name)
  var hash = crypto.createHash('md5').update(ip).digest('hex');
  res.send(hash.substring(0, 6) + " " + name);
});

app.set('trust proxy', true)
app.listen(port, () => console.log(`Hello world app listening on port ${port}!`))
