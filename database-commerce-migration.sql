SET XACT_ABORT ON;
BEGIN TRANSACTION;

IF COL_LENGTH('dbo.Videos', 'Price') IS NULL
    ALTER TABLE dbo.Videos ADD Price DECIMAL(18, 0) NOT NULL
        CONSTRAINT DF_Videos_Price DEFAULT 50000 WITH VALUES;

IF OBJECT_ID('dbo.Carts', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Carts (
        CartId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Username NVARCHAR(50) NOT NULL REFERENCES dbo.Users(Username) ON DELETE CASCADE,
        VideoId NVARCHAR(50) NOT NULL REFERENCES dbo.Videos(VideoId) ON DELETE CASCADE,
        Quantity INT NOT NULL CHECK (Quantity BETWEEN 1 AND 10),
        CreatedAt DATETIME DEFAULT GETDATE(),
        CONSTRAINT UQ_Carts_User_Video UNIQUE (Username, VideoId)
    );
END;

IF OBJECT_ID('dbo.Orders', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Orders (
        OrderId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Username NVARCHAR(50) NOT NULL REFERENCES dbo.Users(Username) ON DELETE CASCADE,
        ReceiverName NVARCHAR(100) NOT NULL,
        ReceiverPhone NVARCHAR(20) NOT NULL,
        ReceiverAddress NVARCHAR(255) NOT NULL,
        Note NVARCHAR(500) NULL,
        PaymentMethod NVARCHAR(20) NOT NULL DEFAULT 'COD',
        Status NVARCHAR(30) NOT NULL DEFAULT 'NEW',
        TotalAmount DECIMAL(18, 0) NOT NULL DEFAULT 0,
        CreatedAt DATETIME DEFAULT GETDATE(),
        CONSTRAINT CK_Orders_Status CHECK (Status IN
            ('NEW', 'CONFIRMED', 'PREPARING', 'SHIPPING', 'DELIVERING', 'DELIVERED', 'CANCELED', 'RETURNED'))
    );
END;

IF OBJECT_ID('dbo.OrderItems', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.OrderItems (
        OrderItemId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        OrderId INT NOT NULL REFERENCES dbo.Orders(OrderId) ON DELETE CASCADE,
        VideoId NVARCHAR(50) NULL REFERENCES dbo.Videos(VideoId) ON DELETE SET NULL,
        Title NVARCHAR(200) NOT NULL,
        Poster NVARCHAR(50) NULL,
        Price DECIMAL(18, 0) NOT NULL,
        Quantity INT NOT NULL CHECK (Quantity BETWEEN 1 AND 10)
    );
END;

COMMIT TRANSACTION;
