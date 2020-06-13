var express = require('express');
var router = express.Router();
var mongo = require('mongodb');
const { v4: uuidv4 } = require('uuid');
const { MongoClient } = require('mongodb');

const ACCESS_CODE_LENGTH = 6

const url = process.env.MONGO_URL;
console.log(url);
const client = new MongoClient(url);
const dbName = 'tzuyu';


router.put('/create-group', (req, res) => {
  // Generate an access code
  var accessCode = (uuidv4().split("-"))[0];

  // Parse body
  var groupName = req.body['groupName'];
  var name = req.body['name'];
  var maxDistance = req.body['maxDistance'];
  var latitude = req.body['latitude'];
  var longitude = req.body['longitude'];

  res.send(accessCode);
});

router.put('/join-group', (req, res) => {
  // Parse body
  var accessCode = req.body['accessCode'];
  var name = req.body['name'];

  res.sendStatus(200);
});

router.put('/start-category', (req, res) => {
  // Parse body
  var accessCode = req.body['accessCode'];

  res.sendStatus(200);
});

router.put('/set-categories', (req, res) => {
  // Parse body
  var accessCode = req.body['accessCode'];
  var categories = req.body['categories'];

  res.sendStatus(200);
});

router.put('/submit-swipes', (req, res) => {
  // Parse body
  var accessCode = req.body['accessCode'];
  var swipes = req.body['swipes'];

  res.sendStatus(200);
});

module.exports = router;
