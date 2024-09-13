const { MongoClient } = require('mongodb');

const uri = process.env.MONGODB_URI || 'mongodb://localhost:27017';
const dbName = process.env.MONGODB_DBNAME || 'guestbook';

let client;

async function connectDB() {
  if (!client) {
    client = new MongoClient(uri);
    try {
      await client.connect();
      console.log('Connected to MongoDB');
    } catch (error) {
      console.error('Error connecting to MongoDB:', error);
      throw error; // Rethrow the error after logging it
    }
  }
  return client.db(dbName);
}

async function getGuestbookCollection() {
  const db = await connectDB();
  return db.collection('guestbook');
}

module.exports = {
  connectDB,
  getGuestbookCollection
};
