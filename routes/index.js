var express = require('express');
var router = express.Router();
var mongo = require('../lib/mongo');
const fetch = require('node-fetch');
const pusher = require('../lib/pusher');
const { v4: uuidv4 } = require('uuid');
const YELP_SEARCH_URL = 'https://api.yelp.com/v3/businesses/search';
const ACCESS_LENGTH_CODE = 4;
const METERS_PER_MILE = 1609.34;
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

router.get('/happy-birthday-tzuyu', (req, res) => {
  res.send('<img src=\"https://kpopping.com/uploads/documents/Tzuyu1419.jpeg\" height = \"500\"> <img src=\"https://www.knetizen.com/wp-content/uploads/2019/05/TWICE-Tzuyu.jpg\" height = \"500\">' +
  '<img src=\"https://i.redd.it/nuekhv9mt6j31.jpg\" height = \"500\"> <img src=\"https://pm1.narvii.com/6348/6640f21db5291e524af46988cbff7252807a5e3c_hq.jpg\" height = \"500\">' +
'<img src=\"https://papers.co/wallpaper/papers.co-hq84-kpop-twice-tzuyu-girl-night-camping-40-wallpaper.jpg\" height = \"500\"> <img src=\"https://3.bp.blogspot.com/-FeWL5jRoOmU/XEJfqbhXePI/AAAAAAAAC9s/7hw_kqXeeQsiItY7dNTMaeihSB0ilmZfQCEwYBhgL/s1600/Tzuyu%2B%2528Twice%2529%2B-%2BChou%2BTzu-Yu%2BLatest%2Bphotos%2B-%2Bwww.profileaz.com%2B%252812%2529.jpg\" height = \"500\">' +
'<img src=\"https://i.redd.it/7pn8bn1dss911.jpg\" height = \"500\"> <img src=\"https://kpopping.com/uploads/documents/TenderHeart0614-1188135559274713088-EH0a83SUwAArxj1.jpeg\" height = \"500\">' +
'<img src=\"https://i.pinimg.com/originals/15/6a/0f/156a0f0c74564286a259eb30ef56d286.jpg\" height = \"500\"> <img src=\"https://pbs.twimg.com/media/DitiWC7U0AAtUkv.jpg\" height = \"500\">')
})

router.get("/kevin", (req,res) => {
  res.send("<script>function secret() {document.getElementById(\"audio\").play();}</script><audio id=\"audio\" src=\"secret.mp3\"></audio><p style=\"text-align:center;width:100%;font-size:75vh;\" onclick=\"secret()\">🤡</p>");
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
  res.json({accessCode:accessCode});
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
      res.status(409).json({'error':'Name already exists!'});
    }
  }
  // if group does not exist
  else {
    res.status(400).json({'error':'Access Code is invalid!'});
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
    //Sending Yelp API request on /businesses/search endpoint
    const meters = Math.min(Math.floor(doc['maxDistance'] * METERS_PER_MILE), 4000);

    const params = {
      headers:{'Authorization': 'Bearer ' + process.env.YELP_API, 'content-type':'application/json'},
      method:  'get'
    }
    const url = YELP_SEARCH_URL + '?latitude=' + doc['latitude'] + '&longitude=' + doc['longitude'] + '&radius=' + meters + '&categories=' + doc['categories'].toString();
    console.log(url);
    fetch(url, params)
    .then(data=>data.json())
    .then(json=>console.log(json));

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
