-- Used to create stored procedures we will use in piwitch.
-- The most common use will be for database updates

drop procedure if exists PiWitchAddColumnUnlessExists;
delimiter '//'

-- Add a column to a table if it does not already exist
-- use case example:
-- call PiWitchAddColumnUnlessExists('identity', 'user', 'varchar(32) not null default abc');

create procedure PiWitchAddColumnUnlessExists(
    IN tableName tinytext,
    IN fieldName tinytext,
    IN fieldDef text)
begin
    IF NOT EXISTS (
        SELECT * FROM information_schema.COLUMNS
        WHERE column_name=fieldName
        and table_name=tableName
        and table_schema='piwitch'
    ) THEN
        set @ddl=CONCAT('ALTER TABLE ','piwitch.',tableName,
            ' ADD COLUMN ',fieldName,' ',fieldDef);
		prepare stmt from @ddl;
		execute stmt;
	END IF;
end;
//

delimiter ';'

