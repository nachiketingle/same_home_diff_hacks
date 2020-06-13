var crypto = require('crypto');
var mongo = require('mongodb');

const ACCESS_CODE_LENGTH = 6

module.exports = {
  createGroup: function(req, res){
    // Generate an access code
    var ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
    ip = ip + (Math.random() * 1000).toString(10);
    var hash = crypto.createHash('md5').update(ip).digest('hex');

    // Parse body
    var groupName = req.body['groupName'];
    var name = req.body['name'];
    var maxDistance = req.body['maxDistance'];
    var latitude = req.body['latitude'];
    var longitude = req.body['longitude'];

    res.send(hash.substring(0, ACCESS_CODE_LENGTH));
  },
  joinGroup: function(req, res){
    // Parse body
    var accessCode = req.body['accessCode'];
    var name = req.body['name'];

    res.sendStatus(200);
  },
  startCategory: function(req, res){
    // Parse body
    var accessCode = req.body['accessCode'];

    res.sendStatus(200);
  },
  setCategories: function(req, res){
    // Parse body
    var accessCode = req.body['accessCode'];
    var categories = req.body['categories'];

    res.sendStatus(200);
  },
  submitSwipes: function(req, res){
    // Parse body
    var accessCode = req.body['accessCode'];
    var swipes = req.body['swipes'];

    res.sendStatus(200);
  }
}
