var Pusher = require('pusher');

var pusher = new Pusher({
  appId: process.env.PUSHER_APP_ID,
  key: process.env.PUSHER_KEY,
  secret: process.env.PUSHER_SECRET,
  cluster: 'us3',
  encrypted: true
});

module.exports = {
  triggerEvent: (accessCode, event, message) => {
    console.log(accessCode, event, message);

    pusher.trigger(accessCode, event, {
      'message': message
    });
  }
}
