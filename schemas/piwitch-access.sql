-- This exists because ansible mysql user setup cannot handle auth plugins.
-- I may alter the permission model of sipwitchqt so it can drop root and
-- then add a similarly contained piwitch user for the server.

CREATE USER IF NOT EXISTS 'sipwitch'@'localhost' IDENTIFIED VIA unix_socket;
GRANT INSERT, SELECT, DELETE, UPDATE ON piwitch.* TO 'sipwitch'@'localhost';

FLUSH PRIVILEGES;


