-- Run in KT_QT. Adds demo video orders without replacing existing data.
SET XACT_ABORT ON;
BEGIN TRANSACTION;

IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE Username = 'user01')
    THROW 50001, 'Demo user user01 does not exist.', 1;

DECLARE @videoId NVARCHAR(50), @price DECIMAL(18, 0);
SELECT TOP 1 @videoId = VideoId, @price = Price
FROM dbo.Videos WHERE Active = 1 ORDER BY VideoId;
IF @videoId IS NULL
    THROW 50002, 'No active video is available for demo orders.', 1;

DECLARE @createdOrders TABLE (OrderId INT);
INSERT INTO dbo.Orders
    (Username, ReceiverName, ReceiverPhone, ReceiverAddress, Note, PaymentMethod, Status, TotalAmount)
OUTPUT inserted.OrderId INTO @createdOrders
SELECT 'user01', N'User 01', '0912345678', N'Demo address',
    '[DEMO_VIDEO_STATUS] ' + s.Status, 'COD', s.Status, @price
FROM (VALUES ('NEW'), ('CONFIRMED'), ('PREPARING'), ('SHIPPING'),
    ('DELIVERING'), ('DELIVERED'), ('CANCELED'), ('RETURNED')) AS s(Status)
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.Orders o
    WHERE o.Username = 'user01' AND o.Note = '[DEMO_VIDEO_STATUS] ' + s.Status
);

INSERT INTO dbo.OrderItems (OrderId, VideoId, Title, Poster, Price, Quantity)
SELECT o.OrderId, v.VideoId, v.Title, v.Poster, v.Price, 1
FROM @createdOrders o CROSS JOIN dbo.Videos v WHERE v.VideoId = @videoId;

COMMIT TRANSACTION;

SELECT OrderId, Username, Status, PaymentMethod, TotalAmount
FROM dbo.Orders WHERE Username = 'user01' AND Note LIKE '[[]DEMO_VIDEO_STATUS]%'
ORDER BY OrderId;
