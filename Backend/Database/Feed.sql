INSERT INTO TransactionTypes (Name, CreatedAt)
VALUES
    ('Deposit', GETUTCDATE()),
    ('Withdrawal', GETUTCDATE()),
    ('Transfer', GETUTCDATE()),
    ('Payment', GETUTCDATE()),
    ('Refund', GETUTCDATE());

INSERT INTO TransactionParties (Name, ContactInfo, CreatedAt)
VALUES
    ('Alice Johnson', 'alice@example.com', GETUTCDATE()),
    ('Bob Smith', 'bob@example.com', GETUTCDATE()),
    ('Charlie Brown', 'charlie@example.com', GETUTCDATE()),
    ('Diana Prince', 'diana@example.com', GETUTCDATE()),
    ('Edward King', 'edward@example.com', GETUTCDATE());

INSERT INTO Transactions (Amount, RoutinePeriodType, DoneAt, CreatedAt, TransactionTypeId, TransactionPartyId)
VALUES
    (1000.50, 'Monthly', GETUTCDATE(), GETUTCDATE(), 1, 1),
    (250.00, 'Weekly', GETUTCDATE(), GETUTCDATE(), 2, 2),
    (500.75, 'OneTime', GETUTCDATE(), GETUTCDATE(), 3, 3),
    (1200.00, NULL, GETUTCDATE(), GETUTCDATE(), 4, 4),
    (300.25, 'Quarterly', GETUTCDATE(), GETUTCDATE(), 5, 5);