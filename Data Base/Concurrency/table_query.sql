-- Banking schema: account
-- Run against PostgreSQL, e.g.:
--   psql -d your_db -f 01_account.sql

DROP TABLE IF EXISTS account CASCADE;

CREATE TABLE account (
    id      BIGINT PRIMARY KEY,
    balance NUMERIC(12, 2) NOT NULL DEFAULT 0 CHECK (balance >= 0),
    name    VARCHAR(255) NOT NULL
);

INSERT INTO account (id, balance, name) VALUES
    (1, 1500.00, 'Alice Johnson'),
    (2, 275.50, 'Bob Smith'),
    (3, 10250.75, 'Carol Williams'),
    (4, 0.00, 'David Brown'),
    (5, 890.25, 'Eva Garcia');
