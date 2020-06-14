var Pusher = require('pusher');

module.exports = {
  triggerEvent: (accessCode, event, message) => {
    var pusher = new Pusher({
      appId: process.env.PUSHER_APP_ID,
      key: process.env.PUSHER_KEY,
      secret: process.env.PUSHER_SECRET,
      cluster: 'us3',
      encrypted: true
    });
    console.log(`Triggering Channel ${accessCode} Event ${event} Message ${message}`);
    pusher.trigger(accessCode, event, {
      'event': event,
      'message': message
    });
  }
}
