//dependencies
const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const cors = require('cors');

//node init
const app = express().use(cors());
const PORT = 5000;

//DB CONNECTION init
mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost:27017/$argv', {useNewUrlParser: true,  useUnifiedTopology: true});

//init app w/ body parser
app
  .use(bodyParser.urlencoded({extended: true}))
  .use(bodyParser.json());

//router setup *leave commented until router is written*
// const router = require('./src/routes/routes.js');
// router(app);

//test serve @ root ('/')
app.get('/', (req, res) => {
  res.send(`Node and Express are running on port: ${PORT}`);
  console.log('server hit at root')
});

//listen @ PORT
app.listen (PORT, () => {
  console.log(`Your server is running at port: ${PORT}`);
});
