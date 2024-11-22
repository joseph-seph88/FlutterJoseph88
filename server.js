const express = require('express');
const path = require('path'); 
const http = require('http');
const socketIo = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);
const PORT = 3000;

app.use(express.static(path.join(__dirname, 'public')));  

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

io.on('connection', (socket) => {
  console.log('새로운 사용자가 연결되었습니다:', socket.id);

  socket.on('sendMessage', (message) => {
    try{
      const parsedMessage = typeof message === 'string' ? JSON.parse(message) : message;
      console.log('Received message:', parsedMessage);
      io.emit('receiveMessage', parsedMessage);
    }catch(error){
      console.error('Failed to parse message:', error);
    }
  });

  socket.on('disconnect', () => {
    console.log('사용자가 연결을 종료했습니다:', socket.id);
  });


});

server.listen(PORT, () => {
  console.log(`서버가 http://localhost:${PORT}에서 실행 중입니다.`);
});
