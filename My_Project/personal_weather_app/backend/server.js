const WebSocket = require('ws');
const wss = new WebSocket.Server({ host: '192.168.25.18', port:3000 });

let clients = {};

wss.on('connection', ws => {
    let clientId = null;

    ws.on('message', message => {
        try{
            const data = JSON.parse(message);

            if(data.sender && !clientId){
                clientId = data.sender;
                clients[clientId] = ws;
                console.log(`Client ${clientId} connected`);
            }

            if (data.receiver && data.message && clients[data.receiver]) {
                clients[data.receiver].send(JSON.stringify({
                    sender: data.sender,
                    message: data.message
                }));
            }else {
                console.log("Invalid message data or receiver not found.");
            }
        }catch (error) {
            console.error('Invalid JSON', error);
        }

    });

    ws.on('close', () => {
        if (clientId && clients[clientId]) {
            console.log(`Client ${clientId} disconnected`);
            delete clients[clientId]; 
        }
    });
});

console.log('WebSocket server is running on ws://192.168.25.18:3000');