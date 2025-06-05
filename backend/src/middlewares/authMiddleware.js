const jwt = require('jsonwebtoken');

module.exports = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    if (!authHeader) return res.status(401).json({ error: 'Token missing.' });
    const token = authHeader.split(' ')[1];
    try {
        const user = jwt.verify(token, process.env.JWT_SECRET);
        req.user = user; // { userId, email, isPremium }
        next();
    } catch {
        res.status(401).json({ error: 'Invalid or expired token.' });
    }
};
