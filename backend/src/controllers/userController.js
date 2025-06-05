const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const pool = require('../repositories/dbPool'); // pgPool, экспортируется
module.exports = {
    register: async (req, res) => {
        const { email, password } = req.body;
        if (!email || !password) return res.status(400).json({ error: 'Email and password are required.' });
        try {
            const hashed = await bcrypt.hash(password, 10);
            const result = await pool.query(
                'INSERT INTO users(email, password_hash, created_at, is_premium) VALUES($1, $2, NOW(), false) RETURNING id, email',
                [email, hashed]
            );
            return res.status(201).json(result.rows[0]);
        } catch (err) {
            if (err.code === '23505') return res.status(409).json({ error: 'User already exists.' });
            return res.status(500).json({ error: 'Server error.' });
        }
    },
    login: async (req, res) => {
        const { email, password } = req.body;
        if (!email || !password) return res.status(400).json({ error: 'Email and password are required.' });
        try {
            const { rows } = await pool.query('SELECT id, email, password_hash, is_premium FROM users WHERE email = $1', [email]);
            if (!rows.length) return res.status(401).json({ error: 'Invalid credentials.' });
            const user = rows[0];
            const match = await bcrypt.compare(password, user.password_hash);
            if (!match) return res.status(401).json({ error: 'Invalid credentials.' });
            const payload = { userId: user.id, email: user.email, isPremium: user.is_premium };
            const accessToken = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '15m' });
            return res.json({ accessToken });
        } catch (err) {
            return res.status(500).json({ error: 'Server error.' });
        }
    },
    me: (req, res) => {
        // authMiddleware добавил в req.user { userId, email, isPremium }
        const { userId, email, isPremium } = req.user;
        res.json({ userId, email, isPremium });
    }
};
