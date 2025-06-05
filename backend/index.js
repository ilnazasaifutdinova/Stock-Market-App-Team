require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const Redis = require('redis');
const authMiddleware = require('./src/middlewares/authMiddleware');

const app = express();
app.use(express.json());
app.use(cors());

const pgPool = new Pool({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
});

const redisClient = Redis.createClient({
    socket: { host: process.env.REDIS_HOST, port: process.env.REDIS_PORT }
});
redisClient.connect().catch(console.error);

// Routes
const userController = require('./src/controllers/userController');
const portfolioController = require('./src/controllers/portfolioController');
const marketDataController = require('./src/controllers/marketDataController');

// Регистрация/Логин (без authMiddleware)
app.post('/api/register', userController.register);
app.post('/api/login', userController.login);

// Маршруты, требующие JWT
app.get('/api/me', authMiddleware, userController.me);
app.get('/api/portfolios', authMiddleware, portfolioController.getAll);
app.post('/api/portfolios', authMiddleware, portfolioController.create);
app.delete('/api/portfolios/:id', authMiddleware, portfolioController.remove);

app.get('/api/marketdata/:symbol', marketDataController.getBySymbol);

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`Backend listening on port ${PORT}`));
