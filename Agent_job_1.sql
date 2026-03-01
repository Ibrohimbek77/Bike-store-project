

DECLARE @file VARCHAR(3000)


DECLARE file_name_iterator CURSOR FOR 
SELECT name
FROM sys.dm_os_enumerate_filesystem('/home/deathreaper77/Bike_store_datafiles', '*.csv')

OPEN file_name_iterator

FETCH NEXT FROM file_name_iterator INTO @file

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @file LIKE '%[Pp]roducts%.csv'
    BEGIN
        BULK INSERT dbo.Products
        FROM ''' + @file + ''' 
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        );

        INSERT INTO dbo.Logs_audit(Message, Log_time)
        VALUES ('Loaded Products csv', GETDATE());
    END

    IF @file LIKE '%[Cc]ustomers%.csv'
    BEGIN
        BULK INSERT dbo.Customers
        FROM ''' + @file + ''' 
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        );

        INSERT INTO dbo.Logs_audit(Message, Log_time)
        VALUES ('Loaded Customers csv', GETDATE());
    END
    
    IF @file LIKE '%[Oo]rders%.csv'
    BEGIN
        BULK INSERT dbo.Products
        FROM ''' + @file + ''' 
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        );

        INSERT INTO dbo.Logs_audit(Message, Log_time)
        VALUES ('Loaded Orders csv', GETDATE());
    END
    
    IF @file LIKE '%[Ss]taffs%.csv'
    BEGIN
        BULK INSERT dbo.Products
        FROM ''' + @file + ''' 
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        );

        INSERT INTO dbo.Logs_audit(Message, Log_time)
        VALUES ('Loaded Staffs csv', GETDATE());
    END
    
    IF @file LIKE '%[Ss]tores%.csv'
    BEGIN
        BULK INSERT dbo.Products
        FROM ''' + @file + ''' 
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        );

        INSERT INTO dbo.Logs_audit(Message, Log_time)
        VALUES ('Loaded Stores csv', GETDATE());
    END
    
    IF @file LIKE '%[Oo]rder_items%.csv'
    BEGIN
        BULK INSERT dbo.Products
        FROM ''' + @file + ''' 
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        );

        INSERT INTO dbo.Logs_audit(Message, Log_time)
        VALUES ('Loaded Order_items csv', GETDATE());
    END
    
    IF @file LIKE '%[Cc]ategories%.csv'
    BEGIN
        BULK INSERT dbo.Products
        FROM ''' + @file + ''' 
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        );

        INSERT INTO dbo.Logs_audit(Message, Log_time)
        VALUES ('Loaded Categories csv', GETDATE());
    END
    
    IF @file LIKE '%[Ss]tocks%.csv'
    BEGIN
        BULK INSERT dbo.Products
        FROM ''' + @file + ''' 
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        );

        INSERT INTO dbo.Logs_audit(Message, Log_time)
        VALUES ('Loaded Stocks csv', GETDATE());
    END
    
    IF @file LIKE '%[Bb]rands%.csv'
    BEGIN
        BULK INSERT dbo.Products
        FROM ''' + @file + ''' 
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        );

        INSERT INTO dbo.Logs_audit(Message, Log_time)
        VALUES ('Loaded Brands csv', GETDATE());
    END
    
    FETCH NEXT FROM file_name_iterator INTO @file


END

CLOSE file_name_iterator
DEALLOCATE file_name_iterator

