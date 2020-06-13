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
  res.send('Hi Victor.');
})

router.get('/%F0%9F%91%81%F0%9F%91%84%F0%9F%91%81', (req, res) => {
  let r = '';
  for (let i = 0; i < 10000; i++) {
    r += '(👁👄👁)'
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

// Create a group
router.put('/create-group', async (req, res) => {
  // Generate an access code
  let accessCode = (uuidv4().split('-'))[0].substring(0, ACCESS_LENGTH_CODE);

  // Parse body
  let groupName = req.body['groupName'];
  let name = req.body['name'];
  let maxDistance = req.body['maxDistance'];
  let latitude = req.body['latitude'];
  let longitude = req.body['longitude'];

  // Database Document
  let group = {
    'accessCode': accessCode,
    'groupName': groupName,
    'maxDistance': maxDistance,
    'latitude': latitude,
    'longitude': longitude,
    'members': [name],
    'categories': [],
    'restuarant-pool': {},
    'category-finishers': [],
    'swipe-finishers': []
  };

  // keep generating accessCodes until a valid one is generated
  while (true) {
    // finds a doc with access code
    let doc = await mongo.findDocument(accessCode, 'group');
    // if doc does not exist
    if (doc == null) {
      // create the doc
      mongo.addDocument(group, 'group');
      break;
    }
    // retry access code
    accessCode = (uuidv4().split('-'))[0].substring(0, ACCESS_LENGTH_CODE);
    group['accessCode'] = accessCode;
  }
  // respond with the access code
  res.send(accessCode);
});

// Join a group
router.put('/join-group', async (req, res) => {
  // Parse body
  let accessCode = req.body['accessCode'];
  let name = req.body['name'];

  // finds group
  let doc = await mongo.findDocument(accessCode, 'group');
  // if group exists
  if (doc) {
    // if name is valid
    if (!doc['members'].includes(name)) {
      // add members 
      doc['members'].push(name);
      //  update document
      mongo.updateDocument(accessCode, 'members', doc['members'], 'group');
      // Send pusher triggerEvent
      pusher.triggerEvent(accessCode, 'onGuestJoin', doc['members']);
      res.sendStatus(200);
    }
    else {
      res.status(409).send('Name already exists!');
    }
  }
  // if group does not exist
  else {
    res.status(400).send('Access Code is Invalid!');
  }
});

// Host starts category
router.put('/start-category', (req, res) => {
  // Parse body
  let accessCode = req.body['accessCode'];
  // Broadcast categories to channel
  pusher.triggerEvent(accessCode, 'onCategoryStart', CATEGORIES);
  res.json(CATEGORIES);
});

// User finishes entering categories
router.put('/set-categories', async (req, res) => {
  // Parse body
  let accessCode = req.body['accessCode'];
  let name = req.body['name'];
  let categories = req.body['categories'];

  // finds group
  let doc = await mongo.findDocument(accessCode, 'group');

  // join categories and group categories
  doc['categories'] = [...doc['categories'], ...categories]
  // remove duplicates
  doc['categories'] = [...(new Set(doc['categories']))]
  // add name to finished list
  doc['category-finishers'].push(name);

  //  update document
  mongo.updateDocument(accessCode, 'categories', doc['categories'], 'group');
  mongo.updateDocument(accessCode, 'category-finishers', doc['category-finishers'], 'group');

  // notify people still choosing onCategoryEnd
  let remaining = new Set(doc['members']);
  doc['category-finishers'].forEach(name => remaining.delete(name));
  pusher.triggerEvent(accessCode, 'onCategoryEnd', [...remaining]);
  // if all done, notify onSwipeStart
  if (remaining.size == 0) {
    // TODO: GET THE RESTAURANTS FROM YELP
    let restaurants = [];
    pusher.triggerEvent(accessCode, 'onSwipeStart', restaurants);
  }
  res.sendStatus(200);
});

// User finishes swiping
router.put('/submit-swipes', async (req, res) => {
  // Parse body
  let accessCode = req.body['accessCode'];
  let name = req.body['name']
  let swipes = req.body['swipes'];

  // finds group
  const doc = await mongo.findDocument(accessCode, 'group');

  // count each vote in restaurant-pool
  swipes.forEach(swipe => {
    if (doc['restuarant-pool'].hasOwnProperty(swipe)) {
      doc['restuarant-pool'] += 1;
    }
    else {
      doc['restuarant-pool'] = 1;
    }
  })
  // add name to finished list
  doc['swipe-finishers'].push(name);

  //  update document
  mongo.updateDocument(accessCode, 'restaurant-pool', doc['restaurant-pool'], 'group');
  mongo.updateDocument(accessCode, 'swipe-finishers', doc['swipe-finishers'], 'group');

  // notify people still choosing onSwipeEnd
  let remaining = new Set(doc['members']);
  doc['swipe-finishers'].forEach(name => remaining.delete(name));
  pusher.triggerEvent(accessCode, 'onSwipeEnd', [...remaining]);
  // if all done, notify onResultFound
  if (remaining.size == 0) {
    // TODO: GET TOP 3 Restaurants
    let topRestaurants = [];
    pusher.triggerEvent(accessCode, 'onResultFound', topRestaurants);
  }
  res.sendStatus(200);
});

module.exports = router;
