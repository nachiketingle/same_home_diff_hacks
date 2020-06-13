const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
var tasks = require('./src/tasks.js')
var Pusher = require('pusher');

var pusher = new Pusher({
  appId: '1018493',
  key: '04d5685fb9e5355b3a15',
  secret: '2cca5e65ec6137944af4',
  cluster: 'us3',
  encrypted: true
});

pusher.trigger('my-channel', 'my-event', {
  'message': 'hello world'
});

const app = express();
const PORT = 5000;

// Configuring body parser middleware
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// --------------------------- End points --------------------------------------
app.put('/create-group', tasks.createGroup);

app.put('/join-group', tasks.joinGroup);

app.put('/start-category', tasks.startCategory);

app.put('/set-categories', tasks.setCategories);

app.put('/submit-swipes', tasks.submitSwipes);
// -----------------------------------------------------------------------------

app.set('trust proxy', true)
app.listen(PORT, () => console.log(`listening on port ${PORT}!`))
