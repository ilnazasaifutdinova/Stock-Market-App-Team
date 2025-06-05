CREATE TABLE IF NOT EXISTS portfolios (
                                          id SERIAL PRIMARY KEY,
                                          user_id INT REFERENCES users(id),
    name VARCHAR(100) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
    );

