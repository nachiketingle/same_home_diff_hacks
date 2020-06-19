var express = require('express');
var router = express.Router();
var mongo = require('../lib/mongo');
const fetch = require('node-fetch');
const pusher = require('../lib/pusher');
const dispatcher = require('../lib/dispatcher');
const {
  v4: uuidv4
} = require('uuid');
const YELP_BUSINESSES_URL = 'https://api.yelp.com/v3/businesses/';
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
  'vietnamese': 'Vietnamese',
  'bubbletea': 'Boba',
  'coffee': 'Coffee & Tea',
  'donuts': 'Donuts',
  'icecream': 'Ice Cream & Frozen Yogurt',
  'poke': 'Poke'
};

router.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '../public', 'index.html'));
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

router.get("/kevin", (req, res) => {
  res.send("<script>function secret() {document.getElementById(\"audio\").play();}</script><audio id=\"audio\" src=\"secret.mp3\"></audio><p style=\"text-align:center;width:100%;font-size:75vh;\" onclick=\"secret()\">🤡</p>");
})

router.get("/egg", (req, res) => {
  res.send("<style>.shake {animation: .2s shake infinite;animation-delay: 21.5s;}@keyframes shake {0% { transform: skewX(-10deg); }50% { transform: skewX(10deg); }100% { transform: skewX(-10deg); }}</style><script>function egg() {document.getElementById(\"audio\").play();document.getElementById(\"egg\").classList.add(\"shake\");}</script><audio id=\"audio\" src=\"yijianmei.mp3\"></audio><p id=\"egg\"style=\"text-align:center;width:100%;font-size:75vh;\" onclick=\"egg()\">🥚</p>");
})

router.get("/kasper", (req, res) => {
  let r = "";
  for (let i = 0; i < 1229; i++) {
    r += "👻"
  }
  res.send(r);
})

router.get('/mongo', (req, res) => {
  mongo.viewDB('group', (docs) => res.json(docs));
})

router.delete('/mongo', (req, res) => {
  mongo.clearCollection('group');
  mongo.clearCollection('restaurants');
  res.send(200);
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
    'joinable': true,
    'maxDistance': maxDistance,
    'latitude': latitude,
    'longitude': longitude,
    'members': [name],
    'categories': [],
    'restaurant-pool': {},
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
  res.json({
    accessCode: accessCode
  });
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
    // if group is joinable
    if (doc['joinable']) {
      // if name is valid
      if (!doc['members'].includes(name)) {
        // add members
        doc['members'].push(name);
        //  update document
        mongo.updateDocument(accessCode, 'members', doc['members'], 'group');
        // Send pusher triggerEvent
        pusher.triggerEvent(accessCode, 'onGuestJoin', doc['members']);
        res.status(200).json({
          'message': 'Success',
          'groupName': doc['groupName'],
          'members': doc['members']
        });
      } else {
        res.status(409).json({
          'error': 'Name already exists!'
        });
      }
    }
    else {
      res.status(409).json({
        'error': 'Group has already started voting!'
      });
    }
  }
  // if group does not exist
  else {
    res.status(400).json({
      'error': 'Access Code is invalid!'
    });
  }
});

router.put('/poke', (req, res) => {
  // Parse body
  let accessCode = req.body['accessCode'];
  let from = req.body['from'];
  let to = req.body['to'];
  pusher.triggerEvent(accessCode, 'onPoke', { from: from, to: to });
})

// Host starts category
router.put('/start-category', (req, res) => {
  // Parse body
  let accessCode = req.body['accessCode'];
  // Set joinable status to false
  mongo.updateDocument(accessCode, 'joinable', false, 'group');
  // Broadcast categories to channel
  pusher.triggerEvent(accessCode, 'onCategoryStart', CATEGORIES);
  res.json(CATEGORIES);
});

// User finishes entering categories
router.put('/set-categories', async (req, res) => {
  // Parse body
  let accessCode = req.body['accessCode'];
  let name = req.body['name'];
  let categories = JSON.parse(req.body['categories']);
  let restaurants = [];

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
  console.log("Remaining:", [...remaining])
  res.status(200).json([...remaining]);

  // if all done, notify onSwipeStart
  if (remaining.size == 0) {
    // wait for client screen transition
    await new Promise(r => setTimeout(r, 1000));
    // Sending Yelp API request on /businesses/search endpoint
    const meters = Math.min(Math.floor(doc['maxDistance'] * METERS_PER_MILE), 4000);
    let params = {
      headers: {
        'Authorization': 'Bearer ' + dispatcher.getApiKey(),
        'content-type': 'application/json'
      },
      method: 'get'
    }
    let url = YELP_BUSINESSES_URL + 'search?latitude=' + doc['latitude'] + '&longitude=' + doc['longitude'] + '&radius=' + meters + '&categories=' + doc['categories'].toString() + '&limit=5';
    fetch(url, params)
      .then(data => data.json())
      .then(json => {
        let ids = [];
        // append all business ids to ids array
        json['businesses'].forEach(element => ids.push(element['id']));
        console.log(ids);

        let restaurantsFinished = 0;
        // Get business details for yelp
        ids.forEach((id) => {
          let params = {
            headers: {
              'Authorization': 'Bearer ' + dispatcher.getApiKey(),
              'content-type': 'application/json'
            },
            method: 'get'
          }
          // Get businesses detials (except reviews)
          url = YELP_BUSINESSES_URL + id;
          fetch(url, params)
            .then(dataDetails => dataDetails.json())
            .then(jsonDetails => {
              getRestaurantDetails(jsonDetails, restaurants, YELP_BUSINESSES_URL + jsonDetails["id"], async () => {
                if (++restaurantsFinished == ids.length) {
                  console.log(restaurants);
                  let restaurantDoc = {
                    'accessCode': accessCode,
                    'restaurants': restaurants
                  };
                  // update restaurants
                  await mongo.addDocument(restaurantDoc, 'restaurants');
                  // finds group
                  pusher.triggerEvent(accessCode, 'onSwipeStart', "You can start swiping!");
                }
              });
            });
        });
      });
  }
});

function getRestaurantDetails(jsonDetails, restaurants, url, done) {
  let params = {
    headers: {
      'Authorization': 'Bearer ' + dispatcher.getApiKey(),
      'content-type': 'application/json'
    },
    method: 'get'
  }

  console.log(url);
  // Get business reviews
  url = url + '/reviews';
  fetch(url, params)
    .then(data => data.json())
    .then(reviewJson => {
      let restaurant = {};
      restaurant['name'] = jsonDetails['name'];
      restaurant['id'] = jsonDetails['id'];
      restaurant['rating'] = jsonDetails['rating'];
      restaurant['review_count'] = jsonDetails['review_count'];
      restaurant['price'] = jsonDetails['price'];
      let coordinates = jsonDetails['coordinates'];
      restaurant['latitude'] = coordinates['latitude'];
      restaurant['longitude'] = coordinates['longitude'];
      restaurant['photos'] = jsonDetails['photos'];
      restaurant['reviews'] = [];
      restaurants.push(restaurant);
      getReview(reviewJson, restaurant);
      done();
    });
}

function getReview(json, restaurant) {
  json['reviews'].forEach((review) => {
    let r = {};
    r['rating'] = review['rating'];
    r['time'] = review['time_created'];
    r['text'] = review['text'];
    restaurant['reviews'].push(r);
  });
}

router.get('/restaurants', async (req, res) => {
  let accessCode = req.query['accessCode'];
  // finds group
  const doc = await mongo.findDocument(accessCode, 'restaurants');

  if (doc) {
    res.json(doc['restaurants']);
  }
  else {
    res.status(400).json({
      'error': 'Access Code is invalid!'
    })
  }
})

// User finishes swiping
router.put('/submit-swipes', async (req, res) => {
  // Parse body
  let accessCode = req.body['accessCode'];
  let name = req.body['name'];
  let swipes = JSON.parse(req.body['swipes']);

  // finds group
  const doc = await mongo.findDocument(accessCode, 'group');

  // count each vote in restaurant-pool
  swipes.forEach(swipe => {
    if (doc['restaurant-pool'].hasOwnProperty(swipe)) {
      doc['restaurant-pool'][swipe] += 1;
    } else {
      doc['restaurant-pool'][swipe] = 1;
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
  res.status(200).json([...remaining]);

  // if all done, notify onResultFound
  console.log(remaining.size);
  if (remaining.size == 0) {
    // wait client screen transition
    await new Promise(r => setTimeout(r, 1000));
    // Sort the lists by value
    let keys = Object.keys(doc['restaurant-pool']);
    keys.sort((a, b) => {
      return doc['restaurant-pool'][b] - doc['restaurant-pool'][a];
    })
    // GET top 3 Restaurants
    let topRestaurants = keys.slice(0, 3);
    console.log(topRestaurants);
    pusher.triggerEvent(accessCode, 'onResultFound', topRestaurants);
    // delete group after a delay
    setTimeout(() => {
      mongo.deleteDocument(accessCode, 'group')
      mongo.deleteDocument(accessCode, 'restaurants')
    }, 10000)
  }
});

module.exports = router;
