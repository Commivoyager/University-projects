-- 1.	Создать хранимую процедуру, которая:
--		a.	добавляет каждой книге два случайных жанра;
--		b.	отменяет совершённые действия, если		 хотя бы одна опе-рация вставки завершилась ошибкой в силу дублирования 
--		значения первич-ного ключа таблицы «m2m_books_genres» (т.е. у такой книги уже был такой жанр).

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

		-- 2627 - код ошибки вставки дубликатов первичных ключей 
		IF ERROR_NUMBER() = 2627
		BEGIN
			-- 50 000 - с этого значения начинаются пользоывательские коды ошибок
			THROW 50000
				,'Произошло дублирование записи при добавлении в таблицу ''m2m_books_genres'''
				,1;
		END
		ELSE
		BEGIN
			DECLARE @ErrorMess NVARCHAR(4000);

			SET @ErrorMess = CONCAT (
					'Произошла ошибка при добавлении случайных жанров: '
					,ERROR_MESSAGE()
					,'; Номер ошибки: '
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
	
	
	
--2.	Создать хранимую процедуру, которая:
	--		a.	увеличивает значение поля «b_quantity» для всех книг в два раза;
	--		b.	отменяет совершённое действие, если по итогу выполнения операции сред-нее количество экземпляров 
	--		книг превысит значение 50.
	
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



-- 3.	Написать запросы, которые, будучи выполненными параллельно, обеспечивали бы следующий эффект:
		--a.	первый запрос должен считать количество выданных на руки и возвращён-ных в библиотеку книг и не зависеть 
		--от запросов на обновление таблицы «subscriptions» (не ждать их завершения);
		--b.	второй запрос должен инвертировать значения поля «sb_is_active» таблицы subscriptions с «Y» на «N» и 
		--наоборот и не зависеть от первого запроса (не ждать его завершения).

-- Запрос для пункта a - получение кол-ва книг (выборка/чтение)
-- идентификатор сессии для отладки
SELECT @@SPID AS [session_id];

SET IMPLICIT_TRANSACTIONS ON;
-- Чтобы не ожидать завершения конкурирующих транзакций - READ UNCOMMITTED
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

BEGIN TRANSACTION;

SELECT COUNT([sb_id]) AS [issued]
FROM [subscriptions]
WHERE [sb_is_active] = 'Y'

SELECT COUNT([sb_id]) AS [returned]
FROM [subscriptions]
WHERE [sb_is_active] = 'N'

-- Задержка транзакции чтения для попытки в этот момент обновить данные запросом пункта b
--WAITFOR DELAY '00:00:10';
COMMIT TRANSACTION;


-- Запрос для пункта b - обновление содержимого таблицы
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

-- Задержка транзакции обновления для попытки в этот момент прочитать данные запросом пункта a
WAITFOR DELAY '00:00:05';

COMMIT TRANSACTION;



-- 4.	Написать запросы, которые, будучи выполненными параллельно, обеспечивали бы следующий эффект:
		--	a.	первый запрос должен считать количество выданных на руки и возвращён-ных в библиотеку книг;
		--	b.	второй запрос должен инвертировать значения поля «sb_is_active» таблицы «subscriptions» с «Y» на «N» 
		--	и наоборот для читателей с нечётными иденти-фикаторами, после чего делать паузу в десять секунд и отменять 
		--	данное из-менение (отменять транзакцию).
--Исследовать поведение СУБД при выполнении первого запроса до, во время и по-сле завершения выполнения второго 
--запроса, повторив этот эксперимент для всех поддерживаемых СУБД уровней изолированности транзакций.

---- Включение поддержки SNAPSHOT
--ALTER DATABASE [library] SET ALLOW_SNAPSHOT_ISOLATION ON;

-- Пункт a - чтение
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

-- Для дебага
SELECT @@TRANCOUNT AS [active_transactions_num]


-- Пункт b - запись (обновление)
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

-- Для дебага
SELECT @@TRANCOUNT AS [active_transactions_num]

/*
Результат

Обозначим:
Транзакция a (Та) - чтение
Транзакция b (Тб) - запись

Каждую транзакцию Та будем запускать на определённом уровне, поочерёдно запуская Тб, перебирая у неё все уровни
Результат будет таписан так:
	что прочитали при запуске Та до запуска Тб
	что прочитали при запуске Та во время запущенной Тб
	что прочитали при запуске Та после отката Тб

Уровень изолированности Та:
	READ UNCOMMITTED
		исходные данные
		изменённые данные
		данные после отката = исходные
	READ COMMITTED
		исходные данные
		зависание, пока не завершится Тb => данные после отката = исходные
		данные после отката = исходные
	REPEATABLE READ - в данном случае так же, как и READ COMMITED
		исходные данные
		зависание, пока не завершится Тb => данные после отката = исходные
		данные после отката = исходные
	SNAPSHOT
		исходные данные
		те же исходные данные без задержек
		данные после отката = исходные
	SERIALIZABLE - в данном случае так же, как и READ COMMITED, REPEATABLE READ
		исходные данные
		зависание, пока не завершится Тb => данные после отката = исходные
		данные после отката = исходные
*/



-- 5.	Написать код, в котором запрос, инвертирующий значения поля «sb_is_active» таб-лицы «subscriptions» с «Y» на 
-- «N» и наоборот, будет иметь максимальные шансы на успешное завершение в случае возникновения ситуации взаимной 
-- блокировки с другими транзакциями.

-- 10 - приоритетнее, чем HIGH
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



-- 6.	Создать на таблице «subscriptions» триггер, определяющий уровень изолированно-сти транзакции, в котором сейчас 
-- проходит операция обновления, и отменяющий операцию, если уровень изолированности транзакции отличен 
-- от REPEATABLE READ.

CREATE TRIGGER [sbscrptns_upd_transaction] ON [subscriptions]
AFTER UPDATE
AS
DECLARE @isolation_lvl_val NVARCHAR(50) = (
		SELECT [transaction_isolation_level]
		FROM [sys].[dm_exec_sessions]
		WHERE [session_id] = @@SPID
		);
-- REPEATABLE READ представлен как 3
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



-- 7.	Создать хранимую функцию, порождающую исключительную ситуацию в случае, если выполняются оба условия (подсказка: 
-- эта задача имеет решение только для MS SQL Server):
	--a.	режим автоподтверждения транзакций выключен;
	--b.	функция запущена из вложенной транзакции.

--DROP FUNCTION NO_NESTED_AUTOCOMMITT;
--GO

CREATE FUNCTION NO_NESTED_AUTOCOMMITT ()
RETURNS INT
	WITH SCHEMABINDING
AS
BEGIN
	DECLARE @autocommitt_mode INT;
	-- Если true - значит значение IMPLICIT_TRANSACTION установлено в OFF
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
		RETURN CAST('Выключен режим автоподтверждения транзакций, при этом функция запущена из вложенной транзакции' AS INT);
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



-- 8.	Создать хранимую процедуру, выполняющую подсчёт количества записей в указан-ной таблице таким образом, чтобы она 
-- возвращала максимально корректные дан-ные, даже если для достижения этого результата придётся пожертвовать произво- 
-- дительностью.

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

-- Для максимально корректного чтения
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

EXECUTE sp_executesql @counter_query
	,N'@num INT OUT'
	,@rows_num OUTPUT;
GO
	----For checking of correctness
	---- Проверка работы процедуры
	----SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	--DECLARE @result INT;
	--SET IMPLICIT_TRANSACTIONS OFF;
	--EXECUTE ROWS_COUNTER 'genres', @result OUTPUT;
	--SELECT @result;

	---- Вставка данных
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