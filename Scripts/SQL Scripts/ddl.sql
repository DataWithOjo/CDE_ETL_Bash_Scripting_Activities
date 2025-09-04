-- Change accounts columns from TEXT to appropriate types
ALTER TABLE dev.accounts
ALTER COLUMN id TYPE INT USING id::INT,
ALTER COLUMN lat TYPE NUMERIC USING lat::NUMERIC,
ALTER COLUMN long TYPE NUMERIC USING long::NUMERIC,
ALTER COLUMN sales_rep_id TYPE INT USING sales_rep_id::INT;

-- Change orders columns from TEXT to appropriate types
ALTER TABLE dev.orders
ALTER COLUMN id TYPE INT USING id::INT,
ALTER COLUMN account_id TYPE INT USING account_id::INT,
ALTER COLUMN occurred_at TYPE TIMESTAMPTZ USING occurred_at::TIMESTAMPTZ,
ALTER COLUMN standard_qty TYPE INTEGER USING standard_qty::INTEGER,
ALTER COLUMN gloss_qty TYPE INTEGER USING gloss_qty::INTEGER,
ALTER COLUMN poster_qty TYPE INTEGER USING poster_qty::INTEGER,
ALTER COLUMN total TYPE INTEGER USING total::INTEGER,
ALTER COLUMN standard_amt_usd TYPE NUMERIC(12,2) USING standard_amt_usd::NUMERIC,
ALTER COLUMN gloss_amt_usd TYPE NUMERIC(12,2) USING gloss_amt_usd::NUMERIC,
ALTER COLUMN poster_amt_usd TYPE NUMERIC(12,2) USING poster_amt_usd::NUMERIC,
ALTER COLUMN total_amt_usd TYPE NUMERIC(12,2) USING total_amt_usd::NUMERIC;

-- Change region columns from TEXT to appropriate types
ALTER TABLE dev.region
ALTER COLUMN id TYPE INT USING id::INT

-- Change sales_reps columns from TEXT to appropriate types
ALTER TABLE dev.sales_reps
ALTER COLUMN id TYPE INT USING id::INT,
ALTER COLUMN region_id TYPE INT USING region_id::INT;

-- Change web_events columns from TEXT to appropriate types
ALTER TABLE dev.web_events
ALTER COLUMN id TYPE INT USING id::INT,
ALTER COLUMN account_id TYPE INT USING account_id::INT,
ALTER COLUMN occurred_at TYPE TIMESTAMPTZ USING occurred_at::TIMESTAMPTZ

