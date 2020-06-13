var express = require('express');
var router = express.Router();
var mongo = require('../lib/mongo');
const pusher = require('../lib/pusher');
const { v4: uuidv4 } = require('uuid');
const ACCESS_LENGTH_CODE = 4;
const CATEGORIES = {
  'tradamerican': 'American',
  'asianfusion': 'Asian Fushion',
  'bbq': 'Barbeque',
  'breakfast_brunch': 'Breakfast & Brunch',
  'buffets': 'Buffets',
  'burgers': 'Burgers',
  'cafes': 'Cafes',
  'chicken_wings': 'Chicken Wings',
  'chinese': 'Chinese',
  'comfortfood': 'Comfort Food',
  'korean': 'Korean',
  'japanese': 'Japanese',
  'thai': 'Thai',
  'vegetarian': 'Vegetarian',
  'vietnamese': 'Vietnamese'
};

router.get('/', (req, res) => {
  res.send("Hi Victor.");
})

router.get("/%F0%9F%91%81%F0%9F%91%84%F0%9F%91%81", (req,res) => {
  let r = "";
  for(let i = 0; i < 10000; i++) {
    r += "(👁👄👁)"
  }
  res.send(r);
})

router.get("/kevin", (req,res) => {
  res.send("<p style=\"text-align:center;width:100%;font-size:75vh;\">🤡</p>");
})

router.get("/kasper", (req,res) => {
  let r = "";
  for(let i = 0; i < 1229; i++) {
    r += "👻"
  }
  res.send(r);
})

router.get('/mongo', (req, res) => {
  mongo.viewDB('group', (docs) => res.json(docs))
})

router.get('/get-restaurants', (req, res) => {
  let list = [{
    'name': 'In-N-Out',
    'id': 'WavvLdfdP6g8aZTtbBQHTw',
    'rating': 4.5,
    'review_count': 5296,
    'price': '$',
    'latitude': 37.7670169511878, 'longitude': -122.42184275, 'photos': [
      'https://s3-media2.fl.yelpcdn.com/bphoto/CPc91bGzKBe95aM5edjhhQ/o.jpg',
      'https://s3-media4.fl.yelpcdn.com/bphoto/FmXn6cYO1Mm03UNO5cbOqw/o.jpg',
      'https://s3-media4.fl.yelpcdn.com/bphoto/HZVDyYaghwPl2kVbvHuHjA/o.jpg']
  },
  {
    'name': 'mcdonalds',
    'id': 'WavvLdfdP6g8aZTtbBQHTw',
    'rating': 1.2,
    'review_count': 5453356,
    'price': '$',
    'latitude': 31.7670169511878, 'longitude': -121.42184275, 'photos': [
      'https://s3-media2.fl.yelpcdn.com/bphoto/CPc91bGzKBe95aM5edjhhQ/o.jpg',
      'https://s3-media4.fl.yelpcdn.com/bphoto/FmXn6cYO1Mm03UNO5cbOqw/o.jpg',
      'https://s3-media4.fl.yelpcdn.com/bphoto/HZVDyYaghwPl2kVbvHuHjA/o.jpg']
  },
  {
    'name': 'icecream',
    'id': 'WavvLdfdP6g8aZTtbBQHTw',
    'rating': 5.3,
    'review_count': 556,
    'price': '$',
    'latitude': 31.7670169511878, 'longitude': -121.42184275, 'photos': [
      'https://s3-media2.fl.yelpcdn.com/bphoto/CPc91bGzKBe95aM5edjhhQ/o.jpg',
      'https://s3-media4.fl.yelpcdn.com/bphoto/FmXn6cYO1Mm03UNO5cbOqw/o.jpg',
      'https://s3-media4.fl.yelpcdn.com/bphoto/HZVDyYaghwPl2kVbvHuHjA/o.jpg']
  }
  ];
  res.json(list);
})

router.put('/create-group', async (req, res) => {
  // Generate an access code
  let accessCode = (uuidv4().split('-'))[0].substring(0, ACCESS_LENGTH_CODE);

  // Parse body
  let groupName = req.body['groupName'];
  let name = req.body['name'];
  let maxDistance = req.body['maxDistance'];
  let latitude = req.body['latitude'];
  let longitude = req.body['longitude'];

  let group = {
    'accessCode': accessCode,
    'groupName': groupName,
    'maxDistance': maxDistance,
    'latitude': latitude,
    'longitude': longitude,
    'members': [name],
    'categories': {},
    'restuarant-pool': {}
  };

  while (true) {
    let doc = await mongo.findDocument(accessCode, 'group');
    console.log(doc);
    if (doc == null) {
      mongo.addDocument(group, 'group');
      break;
    }
    accessCode = (uuidv4().split('-'))[0].substring(0, ACCESS_LENGTH_CODE);
    group['accessCode'] = accessCode;
  }

  res.send(accessCode);
});

router.put('/join-group', async (req, res) => {
  // Parse body
  let accessCode = req.body['accessCode'];
  let name = req.body['name'];

  const doc = await mongo.findDocument(accessCode, 'group');
  console.log(doc)
  if (doc['members'].includes(name)) {
    res.sendStatus(409);
    return;
  }
  doc['members'].push(name);

  mongo.updateDocument(accessCode, 'members', doc['members'], 'group');

  // Send pusher triggerEvent
  pusher.triggerEvent(accessCode, 'onGuestJoin', JSON.stringify(doc['members']));
  res.sendStatus(200);
});

router.put('/start-category', (req, res) => {
  // Parse body
  let accessCode = req.body['accessCode'];
  pusher.triggerEvent(accessCode, 'onCategoryStart', JSON.stringify(CATEGORIES));
  res.json(CATEGORIES);
});

router.put('/set-categories', (req, res) => {
  // Parse body
  let accessCode = req.body['accessCode'];
  let categories = req.body['categories'];

  res.sendStatus(200);
});

router.put('/submit-swipes', (req, res) => {
  // Parse body
  let accessCode = req.body['accessCode'];
  let swipes = req.body['swipes'];

  res.sendStatus(200);
});

module.exports = router;
