require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const morgan = require('morgan');
const path = require('path');
const fs = require('fs').promises;
const { getGuestbookCollection } = require('./db');

const app = express();

// Serve static HTML files from the 'views' directory
app.use(express.static(path.join(__dirname, 'views')));

// Middleware to parse form data
app.use(bodyParser.urlencoded({ extended: true }));

// Middleware to log HTTP requests
app.use(morgan('combined'));

// Set the view engine for serving HTML files
app.set('view engine', 'html');
app.engine('html', async (filePath, options, callback) => {
  const file = await fs.readFile(filePath, 'utf-8');
  return callback(null, file);
});

// Define the default listen address and port from env variables
const { LISTEN_ADDRESS = '0.0.0.0', LISTEN_PORT = 3000 } = process.env;

// Create a collection if it doesn't exist
const createCollection = async () => {
  try {
    const collection = await getGuestbookCollection();
    console.log('Guestbook collection is ready.');
    // Creating index for optimal sorting by created_at
    await collection.createIndex({ created_at: -1 });
  } catch (error) {
    console.error('Error creating guestbook collection:', error);
  }
};

// Route to display the guestbook entries
app.get('/', async (req, res) => {
  try {
    const filePath = path.join(__dirname, 'views', 'index.html');
    res.sendFile(filePath);
  } catch (error) {
    res.status(500).send('Error displaying guestbook page');
  }
});

// Route to handle new guestbook entries
app.post('/sign', async (req, res) => {
  const { name, message } = req.body;
  if (!name || !message) {
    return res.status(400).send('Name and message are required');
  }
  try {
    const collection = await getGuestbookCollection();
    await collection.insertOne({
      name,
      message,
      created_at: new Date()
    });
    res.redirect('/');
  } catch (error) {
    res.status(500).send(`Error adding guestbook entry: ${error.message}`);
  }
});

// API route to return guestbook entries as JSON
app.get('/entries', async (req, res) => {
  try {
    const collection = await getGuestbookCollection();
    const entries = await collection.find().sort({ created_at: -1 }).toArray();
    res.json(entries);  // Send the entries as JSON
  } catch (error) {
    res.status(500).send(`Error fetching guestbook entries: ${error.message}`);
  }
});

// Health check endpoint
app.get('/healthz', (req, res) => {
  res.status(200).send('OK');
});

// Start the server only after ensuring the DB is ready
app.listen(LISTEN_PORT, LISTEN_ADDRESS, async () => {
  await createCollection();
  console.log(`Server is listening on ${LISTEN_ADDRESS}:${LISTEN_PORT}`);
});
