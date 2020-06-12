const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
var tasks = require('./src/tasks.js')

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
