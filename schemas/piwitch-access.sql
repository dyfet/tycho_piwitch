-- This exists because ansible mysql user setup cannot handle auth plugins.
-- I may alter the permission model of sipwitchqt so it can drop root and
-- then add a similarly contained piwitch user for the server.

CREATE USER IF NOT EXISTS 'www-data'@'localhost' IDENTIFIED VIA unix_socket;
GRANT INSERT, SELECT, DELETE ON piwitch.* TO 'www-data'@'localhost';

-- Future will include sipwitch user to drop server privs in init.
-- Maybe we even fix in ansible...?

CREATE USER IF NOT EXISTS 'sipwitch'@'localhost' IDENTIFIED VIA unix_socket;
GRANT INSERT, SELECT, DELETE ON piwitch.* TO 'sipwitch'@'localhost';

FLUSH PRIVILEGES;


