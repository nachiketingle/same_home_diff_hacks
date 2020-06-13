const { MongoClient } = require('mongodb');
const url = process.env.MONGO_URL;
const client = new MongoClient(url);
const dbName = 'SHDF';

module.exports = {
  addDocument: async function(group, collection){
    try {
     await client.connect();
     console.log("Connected correctly to server");
     const db = client.db(dbName);

     // Use the collection "people"
     const col = db.collection(collection);

     // Insert a single document, wait for promise so we can read it back
     const p = await col.insertOne(group);

    } catch (err) {
     console.log(err.stack);
   }

   finally {
     await client.close();
   }
  }
}
