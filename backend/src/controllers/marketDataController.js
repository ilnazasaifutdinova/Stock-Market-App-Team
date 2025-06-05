const redisClient = require('../repositories/redisClient'); // экспорт клиента
const fetch = require('node-fetch');
module.exports = {
    getBySymbol: async (req, res) => {
        const symbol = req.params.symbol.toUpperCase();
        try {
            // Сначала проверяем Redis
            const cached = await redisClient.get(symbol);
            if (cached) return res.json(JSON.parse(cached));

            // Если нет в кэше, делаем запрос к внешнему API (например, Marketstack)
            const apiKey = process.env.MARKETSTACK_KEY;
            const resp = await fetch(`http://api.marketstack.com/v1/eod?access_key=${apiKey}&symbols=${symbol}`);
            const json = await resp.json();
            // Подготавливаем данные: берем последние X дней и текущую цену
            const history = json.data.map(d => ({ date: d.date, price: d.close }));
            const currentPrice = history[history.length - 1].price;
            const result = { symbol, currentPrice, history };

            // Кэшируем в Redis на 10 минут
            await redisClient.setEx(symbol, 600, JSON.stringify(result));
            res.json(result);
        } catch (err) {
            res.status(500).json({ error: 'Server error.' });
        }
    }
};
