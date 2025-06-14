const redisClient = require('../repositories/redisClient'); // client's export
const fetch = require('node-fetch');
module.exports = {
    getBySymbol: async (req, res) => {
        const symbol = req.params.symbol.toUpperCase();
        try {
            //Check Redis in the first place
            const cached = await redisClient.get(symbol);
            if (cached) return res.json(JSON.parse(cached));

            //If nothing is in cache, then make a request to public API (For instance, Marketstack)
            const apiKey = process.env.MARKETSTACK_KEY;
            const resp = await fetch(`http://api.marketstack.com/v1/eod?access_key=${apiKey}&symbols=${symbol}`);
            const json = await resp.json();
            //Prepare the data: catch the last X days and currect price
            const history = json.data.map(d => ({ date: d.date, price: d.close }));
            const currentPrice = history[history.length - 1].price;
            const result = { symbol, currentPrice, history };

            //Caching in Redis for 10 minutes
            await redisClient.setEx(symbol, 600, JSON.stringify(result));
            res.json(result);
        } catch (err) {
            res.status(500).json({ error: 'Server error.' });
        }
    }
};
