const pool = require('../repositories/dbPool');

module.exports = {
    getAll: async (req, res) => {
        try {
            const { rows } = await pool.query('SELECT id, name, currency, created_at FROM portfolios WHERE user_id = $1', [req.user.userId]);
            res.json(rows);
        } catch {
            res.status(500).json({ error: 'Server error.' });
        }
    },
    create: async (req, res) => {
        const { name } = req.body;
        if (!name) return res.status(400).json({ error: 'Name is required.' });
        try {
            const { rows } = await pool.query(
                'INSERT INTO portfolios(user_id, name, currency, created_at) VALUES($1, $2, $3, NOW()) RETURNING id, name, currency',
                [req.user.userId, name, req.user.currency || 'USD']
            );
            res.status(201).json(rows[0]);
        } catch {
            res.status(500).json({ error: 'Server error.' });
        }
    },
    remove: async (req, res) => {
        const id = req.params.id;
        try {
            await pool.query('DELETE FROM portfolios WHERE id = $1 AND user_id = $2', [id, req.user.userId]);
            res.sendStatus(204);
        } catch {
            res.status(500).json({ error: 'Server error.' });
        }
    }
};
