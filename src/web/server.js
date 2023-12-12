const http = require('http');
const express = require('express');
const path = require('path');
const app = express();
app.use(express.json());
app.use(express.static(__dirname + '/public'));// default URL for website
//app.use(express.static(path.join(__dirname, '../www')));

console.log(path.join(__dirname + '/public'));

app.use('/', function(req,res){
  res.sendFile(path.join(__dirname + '/public/index.html'));
});

//app.use('/css/index.css', function(req,res){
//    res.sendFile(path.join(__dirname + '/css/index.css'));
//  });

app.listen(3000, function() {
  console.log('App Listening to port 3000');
});




//const server = http.createServer(app);
//const port = 3000;
//server.listen(port);console.debug('Server listening on port ' + port);
