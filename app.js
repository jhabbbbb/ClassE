var app = require('http').createServer(handler)
var io = require('socket.io')(app);
var fs = require('fs');

app.listen(12345);

function handler (req, res) {
  fs.readFile(__dirname + '/index.html',
  function (err, data) {
    if (err) {
      res.writeHead(500);
      return res.end('Error loading index.html');
    }

    res.writeHead(200);
    res.end(data);
  });
}

io.on('connection', function (socket) {
  socket.emit('news', { hello: 'hello dude' });
  socket.on('my other event', function (data) {
    console.log(data);
  });
  socket.on('messageC2S', function(data) {
    console.log(data);
    io.emit('messageS2C', {message: data.message});
  })
});