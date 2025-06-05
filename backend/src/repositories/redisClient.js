// backend/src/repositories/redisClient.js

const Redis = require('redis');

const redisClient = Redis.createClient({
    socket: {
        host: process.env.REDIS_HOST,
        port: process.env.REDIS_PORT,
    },
});

// Не забываем подключиться сразу
redisClient.connect().catch(console.error);

module.exports = redisClient;
