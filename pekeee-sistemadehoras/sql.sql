-- create_users_table.sql

-- Create the users table to store user identifiers and hours played
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each user
    identifier VARCHAR(255) NOT NULL UNIQUE, -- Unique identifier for each user
    horas INT DEFAULT 0 -- Number of hours played, default is 0
);
