CREATE TABLE IF NOT EXISTS market_data_cache (
                                                 symbol VARCHAR(10) PRIMARY KEY,
    last_updated TIMESTAMP NOT NULL,
    data JSONB NOT NULL
    );
