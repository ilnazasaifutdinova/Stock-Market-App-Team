//backend/src/repositories/redisClient.js

const Redis = require('redis');

const redisClient = Redis.createClient({
    socket: {
        host: process.env.REDIS_HOST,
        port: process.env.REDIS_PORT,
    },
});

//Do not forget to connect immediately
redisClient.connect().catch(console.error);

module.exports = redisClient;
