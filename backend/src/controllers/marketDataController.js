const fetch = require('node-fetch');
const redisClient = require('../repositories/redisClient');

module.exports = {
    getBySymbol: async (req, res) => {
        const symbol = req.params.symbol.toUpperCase();
        const timeframe = req.query.timeframe || '1M'; // Accept timeframe parameter

        try {
            // Check Redis cache first
            const cacheKey = `${symbol}_${timeframe}`;
            const cached = await redisClient.get(cacheKey);
            if (cached) return res.json(JSON.parse(cached));

            // If not in cache, fetch from Finnhub
            const apiKey = process.env.FINNHUB_API_KEY;
            const baseUrl = 'https://finnhub.io/api/v1';

            // Get current quote
            const quoteResp = await fetch(`${baseUrl}/quote?symbol=${symbol}&token=${apiKey}`);
            const quoteData = await quoteResp.json();

            // Get historical data
            const now = Math.floor(Date.now() / 1000);
            const from = now - (timeframe === '1W' ? 604800 :
                timeframe === '1M' ? 2592000 :
                    timeframe === '3M' ? 7776000 :
                        timeframe === '6M' ? 15552000 : 31536000);

            const candleResp = await fetch(
                `${baseUrl}/stock/candle?symbol=${symbol}&resolution=D&from=${from}&to=${now}&token=${apiKey}`
            );
            const candleData = await candleResp.json();

            const result = {
                quote: quoteData,
                candles: candleData
            };

            // Cache for 5 minutes
            await redisClient.setEx(cacheKey, 300, JSON.stringify(result));
            res.json(result);
        } catch (err) {
            console.error(err);
            res.status(500).json({ error: 'Failed to fetch market data' });
        }
    }
};