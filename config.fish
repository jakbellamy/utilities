    #aliases--------------------------------------
alias d0='npm i express cors body-parser'
alias d1='touch index.js && mkdir src && cd src/ && mkdir models && mkdir controllers && mkdir routes && cd routes && touch routes.js && cd .. && cd .. && atom . && npm i express cors lodash body-parser mongoose'
alias dev='cd && cd Dev/'
alias supreme='cd && cd Dev/_supreme/supremeMongo'
alias supremeStart='supreme && atom . && npm start'

    #functions------------------------------------
function rmAll
   set -l arr (ls *)
   for file in $arr
       rm $file
   end
end

function newSandbox
 cd
 cd Dev/_sandbox
 if test -e ~/Dev/_sandbox/(date +'%Y-%m-%d')
     cd (date +'%Y-%m-%d')
     touch script(math (count *.js) + 1).js
     atom .
 else
     mkdir (date +'%Y-%m-%d')
     cd (date +'%Y-%m-%d')
     touch script0.js
     atom .
 end
end

function title_case -a string
  set -l matches (string match -r -a '\b[a-z]' $string)

  for match in $matches
    set -l upper (echo $match | tr a-z A-Z)
    set string (echo (string replace -r '\b[a-z]' $upper $string))
  end

  echo $string
end

function printFile -a file
  printf '%s\n' (less $file)
end

function writeIndex -a name
  echo > index.js "//dependencies
  const express = require('express');
  const bodyParser = require('body-parser');
  const mongoose = require('mongoose');
  const cors = require('cors');

  //node init
  const app = express().use(cors());
  const PORT = 5000;

  //DB connection init
  mongoose.Promise = global.Promise;
  mongoose.connect('mongodb://localhost:27017/$name, {useNewUrlParser: true, useUnifiedTopology: true});

  //init app w/ body parser
  app
  .use(bodyParser.urlencoded({extended: true}))
  .use(bodyParser.json());

  //router setup
  const router = require('./src/routes/routes.js');
  router(app);

  //test serve @ root ('/')
  app.get('/', (req, res) => {
     res.send(`Node and Express are running on port: \${PORT}`);
     console.log('server hit at root')
  });

  //listen @ PORT
  app.listen(PORT, () => {
     console.log(`Your server is running on port: \${PORT}`);
  });"
end

function genMen -a name
  set -l count (count *)
  if begin ; test -e ./package.json ; and test $count = 1 ; end
    touch index.js
    writeIndex $name
    mkdir ./src/
    cd ./src/
    mkdir ./routes/
    mkdir ./controllers/
    mkdir ./models/
    mkdir ./middleware/
    cd ./routes/ && touch routes.js
    cd ../..
    atom .
    npm i express cors lodash body-parser mongoose
  else
    echo "no package.json found in this directory. cd into an empty node directory"
  end
end

function genModel -a name upperName attributes
  set -l arr (string split ',' $attributes)
  echo > "src/models/"$name".js" "const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const "$upperName"Schema = new Schema({"
  for val in $arr
    set -l spl (string split ':' $val)
    set -l at $spl[1]
    set -l type (title_case $spl[2])

    echo >> "src/models/"$name".js" "   "$at":{
   type: "$type",
   required: true
  },"
  end

  sed -i '' '$ s/.$//' src/models/$name.js
  echo >> "src/models/"$name".js" "});

  module.exports =  mongoose.model('$upperName', "$upperName"Schema);"
end

function gen -a name attributes
  if begin ; test -e ./package.json ; and test -e src/models ; and test -e src/controllers ; and test -e src/routes ; end
    touch 'src/models/'$name'.js'
    touch 'src/controllers/'$name'Controller.js'
    set -l upperName (title_case $name)

    genModel $name $upperName $attributes
  else
    echo "error: make sure youre in a scaffolded node directory" \n"if in a blank directory, npm init --yes && genMen <api name>"
  end
end
