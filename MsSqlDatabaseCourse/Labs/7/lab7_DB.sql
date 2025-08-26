-- 1.	������� �������� ���������, �������:
--		a.	��������� ������ ����� ��� ��������� �����;
--		b.	�������� ����������� ��������, ����		 ���� �� ���� ���-����� ������� ����������� ������� � ���� ������������ 
--		�������� ������-���� ����� ������� �m2m_books_genres� (�.�. � ����� ����� ��� ��� ����� ����).

--DROP PROCEDURE ADD_2_RAND_GENRES
--GO

CREATE PROCEDURE ADD_2_RAND_GENRES
AS
BEGIN
	DECLARE @b_id INT;
	DECLARE @g_id INT;

	DECLARE books_cursor CURSOR LOCAL FAST_FORWARD
	FOR
	SELECT [b_id]
	FROM [books];

	DECLARE genres_cursor CURSOR LOCAL FAST_FORWARD
	FOR
	SELECT TOP 2 [g_id]
	FROM [genres]
	ORDER BY NEWID();

	DECLARE @fetch_b_cursor INT;
	DECLARE @fetch_g_cursor INT;

	SET XACT_ABORT ON;

	BEGIN TRANSACTION;

	BEGIN TRY
		OPEN books_cursor;

		FETCH NEXT
		FROM books_cursor
		INTO @b_id

		SET @fetch_b_cursor = @@FETCH_STATUS;

		WHILE @fetch_b_cursor = 0
		BEGIN
			OPEN genres_cursor;

			FETCH NEXT
			FROM genres_cursor
			INTO @g_id;

			SET @fetch_g_cursor = @@FETCH_STATUS;

			WHILE @fetch_g_cursor = 0
			BEGIN
				INSERT INTO [m2m_books_genres] (
					[b_id]
					,[g_id]
					)
				VALUES (
					@b_id
					,@g_id
					)

				FETCH NEXT
				FROM genres_cursor
				INTO @g_id;

				SET @fetch_g_cursor = @@FETCH_STATUS;
			END -- inner while

			FETCH NEXT
			FROM books_cursor
			INTO @b_id

			SET @fetch_b_cursor = @@FETCH_STATUS;

			CLOSE genres_cursor;
		END -- outer while

		CLOSE books_cursor;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION;

			PRINT 'Transaction was rolled back'
		END

		-- 2627 - ��� ������ ������� ���������� ��������� ������ 
		IF ERROR_NUMBER() = 2627
		BEGIN
			-- 50 000 - � ����� �������� ���������� ����������������� ���� ������
			THROW 50000
				,'��������� ������������ ������ ��� ���������� � ������� ''m2m_books_genres'''
				,1;
		END
		ELSE
		BEGIN
			DECLARE @ErrorMess NVARCHAR(4000);

			SET @ErrorMess = CONCAT (
					'��������� ������ ��� ���������� ��������� ������: '
					,ERROR_MESSAGE()
					,'; ����� ������: '
					,ERROR_NUMBER()
					);

			THROW 50001
				,@ErrorMess
				,1;
		END

		RETURN;
	END CATCH

	COMMIT TRANSACTION;

	PRINT 'Transaction successed';
END;
GO
	---- For checking of correctness
	--DELETE FROM [m2m_books_genres]
	--INSERT INTO [m2m_books_genres]
	--([b_id], [g_id])
	--VALUES (1,1)
	--SELECT * FROM [m2m_books_genres]
	--EXECUTE ADD_2_RAND_GENRES;
	--SELECT * FROM [m2m_books_genres]
	
	
	
--2.	������� �������� ���������, �������:
	--		a.	����������� �������� ���� �b_quantity� ��� ���� ���� � ��� ����;
	--		b.	�������� ����������� ��������, ���� �� ����� ���������� �������� ����-��� ���������� ����������� 
	--		���� �������� �������� 50.
	
--DROP PROCEDURE DOUBLE_BOOKS_QUANTITY
--GO

CREATE PROCEDURE DOUBLE_BOOKS_QUANTITY
AS
BEGIN
	DECLARE @avg_books_num DOUBLE PRECISION;

	BEGIN TRANSACTION;

	UPDATE [books]
	SET [b_quantity] = [b_quantity] * 2;

	SET @avg_books_num = (
			SELECT AVG([b_quantity])
			FROM [books]
			);

	IF (@avg_books_num > 50)
	BEGIN
		ROLLBACK TRANSACTION;

		PRINT 'Transaction was rolled back';
	END
	ELSE
	BEGIN
		COMMIT TRANSACTION;

		PRINT 'Transaction successed';
	END
END
GO
	---- For checking of correctness
	--SELECT * FROM [books];
	--EXECUTE DOUBLE_BOOKS_QUANTITY;
	--SELECT * FROM [books];



-- 3.	�������� �������, �������, ������ ������������ �����������, ������������ �� ��������� ������:
		--a.	������ ������ ������ ������� ���������� �������� �� ���� � ���������-��� � ���������� ���� � �� �������� 
		--�� �������� �� ���������� ������� �subscriptions� (�� ����� �� ����������);
		--b.	������ ������ ������ ������������� �������� ���� �sb_is_active� ������� subscriptions � �Y� �� �N� � 
		--�������� � �� �������� �� ������� ������� (�� ����� ��� ����������).

-- ������ ��� ������ a - ��������� ���-�� ���� (�������/������)
-- ������������� ������ ��� �������
SELECT @@SPID AS [session_id];

SET IMPLICIT_TRANSACTIONS ON;
-- ����� �� ������� ���������� ������������� ���������� - READ UNCOMMITTED
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

BEGIN TRANSACTION;

SELECT COUNT([sb_id]) AS [issued]
FROM [subscriptions]
WHERE [sb_is_active] = 'Y'

SELECT COUNT([sb_id]) AS [returned]
FROM [subscriptions]
WHERE [sb_is_active] = 'N'

-- �������� ���������� ������ ��� ������� � ���� ������ �������� ������ �������� ������ b
--WAITFOR DELAY '00:00:10';
COMMIT TRANSACTION;


-- ������ ��� ������ b - ���������� ����������� �������
SELECT @@SPID AS [session_id]

SET IMPLICIT_TRANSACTIONS ON;

BEGIN TRANSACTION;

UPDATE [subscriptions]
SET [sb_is_active] = CASE 
		WHEN [sb_is_active] = 'Y'
			THEN 'N'
		WHEN [sb_is_active] = 'N'
			THEN 'Y'
		END;

-- �������� ���������� ���������� ��� ������� � ���� ������ ��������� ������ �������� ������ a
WAITFOR DELAY '00:00:05';

COMMIT TRANSACTION;



-- 4.	�������� �������, �������, ������ ������������ �����������, ������������ �� ��������� ������:
		--	a.	������ ������ ������ ������� ���������� �������� �� ���� � ���������-��� � ���������� ����;
		--	b.	������ ������ ������ ������������� �������� ���� �sb_is_active� ������� �subscriptions� � �Y� �� �N� 
		--	� �������� ��� ��������� � ��������� ������-����������, ����� ���� ������ ����� � ������ ������ � �������� 
		--	������ ��-������� (�������� ����������).
--����������� ��������� ���� ��� ���������� ������� ������� ��, �� ����� � ��-��� ���������� ���������� ������� 
--�������, �������� ���� ����������� ��� ���� �������������� ���� ������� ��������������� ����������.

---- ��������� ��������� SNAPSHOT
--ALTER DATABASE [library] SET ALLOW_SNAPSHOT_ISOLATION ON;

-- ����� a - ������
SELECT @@SPID AS [session_id];

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
--SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
--SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;

SELECT COUNT([sb_id]) AS [issued]
FROM [subscriptions]
WHERE [sb_is_active] = 'Y'

SELECT COUNT([sb_id]) AS [returned]
FROM [subscriptions]
WHERE [sb_is_active] = 'N'

COMMIT TRANSACTION;

-- ��� ������
SELECT @@TRANCOUNT AS [active_transactions_num]


-- ����� b - ������ (����������)
SELECT @@SPID AS [session_id];

--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION;

UPDATE [subscriptions]
SET [sb_is_active] = CASE 
		WHEN [sb_is_active] = 'Y'
			THEN 'N'
		WHEN [sb_is_active] = 'N'
			THEN 'Y'
		END
WHERE [sb_subscriber] % 2 != 0;

WAITFOR DELAY '00:00:10';

ROLLBACK TRANSACTION;

-- ��� ������
SELECT @@TRANCOUNT AS [active_transactions_num]

/*
���������

���������:
���������� a (��) - ������
���������� b (��) - ������

������ ���������� �� ����� ��������� �� ����������� ������, ��������� �������� ��, ��������� � �� ��� ������
��������� ����� ������� ���:
	��� ��������� ��� ������� �� �� ������� ��
	��� ��������� ��� ������� �� �� ����� ���������� ��
	��� ��������� ��� ������� �� ����� ������ ��

������� ��������������� ��:
	READ UNCOMMITTED
		�������� ������
		��������� ������
		������ ����� ������ = ��������
	READ COMMITTED
		�������� ������
		���������, ���� �� ���������� �b => ������ ����� ������ = ��������
		������ ����� ������ = ��������
	REPEATABLE READ - � ������ ������ ��� ��, ��� � READ COMMITED
		�������� ������
		���������, ���� �� ���������� �b => ������ ����� ������ = ��������
		������ ����� ������ = ��������
	SNAPSHOT
		�������� ������
		�� �� �������� ������ ��� ��������
		������ ����� ������ = ��������
	SERIALIZABLE - � ������ ������ ��� ��, ��� � READ COMMITED, REPEATABLE READ
		�������� ������
		���������, ���� �� ���������� �b => ������ ����� ������ = ��������
		������ ����� ������ = ��������
*/



-- 5.	�������� ���, � ������� ������, ������������� �������� ���� �sb_is_active� ���-���� �subscriptions� � �Y� �� 
-- �N� � ��������, ����� ����� ������������ ����� �� �������� ���������� � ������ ������������� �������� �������� 
-- ���������� � ������� ������������.

-- 10 - ������������, ��� HIGH
SET DEADLOCK_PRIORITY 10;

BEGIN TRANSACTION;

UPDATE [subscriptions]
SET [sb_is_active] = CASE 
		WHEN [sb_is_active] = 'Y'
			THEN 'N'
		WHEN [sb_is_active] = 'N'
			THEN 'Y'
		END;

COMMIT TRANSACTION;



-- 6.	������� �� ������� �subscriptions� �������, ������������ ������� ������������-��� ����������, � ������� ������ 
-- �������� �������� ����������, � ���������� ��������, ���� ������� ��������������� ���������� ������� 
-- �� REPEATABLE READ.

CREATE TRIGGER [sbscrptns_upd_transaction] ON [subscriptions]
AFTER UPDATE
AS
DECLARE @isolation_lvl_val NVARCHAR(50) = (
		SELECT [transaction_isolation_level]
		FROM [sys].[dm_exec_sessions]
		WHERE [session_id] = @@SPID
		);
-- REPEATABLE READ ����������� ��� 3
IF (@isolation_lvl_val != 3)
BEGIN
	RAISERROR (
			'UPDATE Transaction rolled back because its isolation level doesnt match REPEATABLE READ'
			,16
			,1
			);

	ROLLBACK TRANSACTION;

	RETURN;
END;
GO
	----For checking of correctness
	--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	----SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	--UPDATE [subscriptions]
	--SET [sb_is_active] = CASE 
	--	WHEN [sb_is_active] = 'Y' THEN 'N'
	--	WHEN [sb_is_active] = 'N' THEN 'Y'
	--	END
	--SELECT * FROM [subscriptions];



-- 7.	������� �������� �������, ����������� �������������� �������� � ������, ���� ����������� ��� ������� (���������: 
-- ��� ������ ����� ������� ������ ��� MS SQL Server):
	--a.	����� ����������������� ���������� ��������;
	--b.	������� �������� �� ��������� ����������.

--DROP FUNCTION NO_NESTED_AUTOCOMMITT;
--GO

CREATE FUNCTION NO_NESTED_AUTOCOMMITT ()
RETURNS INT
	WITH SCHEMABINDING
AS
BEGIN
	DECLARE @autocommitt_mode INT;
	-- ���� true - ������ �������� IMPLICIT_TRANSACTION ����������� � OFF
	IF (@@OPTIONS & 2 = 0)
	BEGIN
		SET @autocommitt_mode = 1;
	END
	ELSE
	BEGIN
		SET @autocommitt_mode = 0;
	END

	IF (
			@autocommitt_mode = 0
			AND @@TRANCOUNT >= 2
			)
	BEGIN
		RETURN CAST('�������� ����� ����������������� ����������, ��� ���� ������� �������� �� ��������� ����������' AS INT);
	END

	RETURN 0;
END;
GO
	----For checking of correctness
	--SET IMPLICIT_TRANSACTIONS OFF;
	--SELECT dbo.NO_NESTED_AUTOCOMMITT();
	--SET IMPLICIT_TRANSACTIONS ON;
	--SELECT dbo.NO_NESTED_AUTOCOMMITT();
	--SET IMPLICIT_TRANSACTIONS OFF;
	--BEGIN TRANSACTION;
	--SELECT dbo.NO_NESTED_AUTOCOMMITT();
	--WHILE(@@TRANCOUNT != 0)
	--BEGIN
	--	COMMIT TRANSACTION;
	--END
	--SET IMPLICIT_TRANSACTIONS ON;
	--BEGIN TRANSACTION;
	--SELECT dbo.NO_NESTED_AUTOCOMMITT();
	--WHILE(@@TRANCOUNT != 0)
	--BEGIN
	--	COMMIT TRANSACTION;
	--END



-- 8.	������� �������� ���������, ����������� ������� ���������� ������� � ������-��� ������� ����� �������, ����� ��� 
-- ���������� ����������� ���������� ���-���, ���� ���� ��� ���������� ����� ���������� ������� ������������ �������- 
-- ������������.

--DROP PROCEDURE ROWS_COUNTER;
--GO

CREATE PROCEDURE ROWS_COUNTER @table_name NVARCHAR(150)
	,@rows_num INT OUTPUT
AS
DECLARE @counter_query NVARCHAR(max) = CONCAT (
		'SET @num = (SELECT COUNT (1) FROM ['
		,@table_name
		,'])'
		);

-- ��� ����������� ����������� ������
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

EXECUTE sp_executesql @counter_query
	,N'@num INT OUT'
	,@rows_num OUTPUT;
GO
	----For checking of correctness
	---- �������� ������ ���������
	----SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	--DECLARE @result INT;
	--SET IMPLICIT_TRANSACTIONS OFF;
	--EXECUTE ROWS_COUNTER 'genres', @result OUTPUT;
	--SELECT @result;

	---- ������� ������
	--SET IMPLICIT_TRANSACTIONS OFF;
	--BEGIN TRANSACTION;
	--DECLARE @i INT = 0;
	--WHILE (@i < 1000)
	--BEGIN
	--	INSERT INTO [genres]
	--	([g_name])
	--	VALUES
	--		(CONCAT('Genre', @i));
	--	SET @i = @i + 1;
	--END
	--WAITFOR DELAY '00:00:05';
	--SELECT * FROM [genres];
	--ROLLBACK TRANSACTION;
	--SELECT * FROM [genres];