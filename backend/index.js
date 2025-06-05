require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const Redis = require('redis');

const app = express();
app.use(express.json());
app.use(cors());

// Подключение к Postgres
const pgPool = new Pool({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
});

// Подключение к Redis
const redisClient = Redis.createClient({
    socket: {
        host: process.env.REDIS_HOST,
        port: process.env.REDIS_PORT,
    },
});
redisClient.connect();

// Простейшие endpoint’ы
app.get('/api/portfolios', (req, res) => {
    return res.json([]);
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`Backend listening on port ${PORT}`));
