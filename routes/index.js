var express = require('express');
var router = express.Router();
const { v4: uuidv4 } = require('uuid');

router.get('/get-restuarants', (req, res) => {
  var list = [{"name": "In-N-Out",
              "id": "WavvLdfdP6g8aZTtbBQHTw",
              "rating": 4.5,
              "review_count": 5296,
              "price":"$",
              "latitude":37.7670169511878, "longitude": -122.42184275, "photos": [
              "https://s3-media2.fl.yelpcdn.com/bphoto/CPc91bGzKBe95aM5edjhhQ/o.jpg",
              "https://s3-media4.fl.yelpcdn.com/bphoto/FmXn6cYO1Mm03UNO5cbOqw/o.jpg",
              "https://s3-media4.fl.yelpcdn.com/bphoto/HZVDyYaghwPl2kVbvHuHjA/o.jpg"]},
              {"name": "mcdonalds",
              "id": "WavvLdfdP6g8aZTtbBQHTw",
              "rating": 1.2,
              "review_count": 5453356,
              "price":"$",
              "latitude":31.7670169511878, "longitude": -121.42184275, "photos": [
              "https://s3-media2.fl.yelpcdn.com/bphoto/CPc91bGzKBe95aM5edjhhQ/o.jpg",
              "https://s3-media4.fl.yelpcdn.com/bphoto/FmXn6cYO1Mm03UNO5cbOqw/o.jpg",
              "https://s3-media4.fl.yelpcdn.com/bphoto/HZVDyYaghwPl2kVbvHuHjA/o.jpg"]},
              {"name": "icecream",
              "id": "WavvLdfdP6g8aZTtbBQHTw",
              "rating": 5.3,
              "review_count": 556,
              "price":"$",
              "latitude":31.7670169511878, "longitude": -121.42184275, "photos": [
              "https://s3-media2.fl.yelpcdn.com/bphoto/CPc91bGzKBe95aM5edjhhQ/o.jpg",
              "https://s3-media4.fl.yelpcdn.com/bphoto/FmXn6cYO1Mm03UNO5cbOqw/o.jpg",
              "https://s3-media4.fl.yelpcdn.com/bphoto/HZVDyYaghwPl2kVbvHuHjA/o.jpg"]}
              ];
  res.json(list);
})

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
