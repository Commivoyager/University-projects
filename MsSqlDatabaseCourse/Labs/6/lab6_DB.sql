-- Выполненны задания: 1, 2, 3, 4, 5, 9

-- 1.	Создать хранимую функцию, получающую на вход идентификатор читателя и воз-вращающую список идентификаторов 
-- книг, которые он уже прочитал и вернул в библиотеку.

--DROP FUNCTION [dbo].[GET_RETURNED_BOOKS_ID]
--GO

CREATE FUNCTION GET_RETURNED_BOOKS_ID (@subscriber_id INT)
RETURNS @returned_books TABLE ([ret_b_id] INT)
AS
BEGIN
	INSERT @returned_books
	SELECT [sb_book] AS [ret_b_id]
	FROM [subscriptions]
	WHERE [sb_is_active] = 'N'
		AND [sb_subscriber] = @subscriber_id
	ORDER BY [sb_start]

	RETURN
END;
GO

--SELECT * FROM GET_RETURNED_BOOKS_ID(1)



-- 2.	Создать хранимую функцию, возвращающую список первого диапазона свободных значений автоинкрементируемых 
-- первичных ключей в указанной таблице (напри-мер, если в таблице есть первичные ключи 1, 4, 8, то первый свободный 
-- диапазон — это значения 2 и 3).

-- Так как в MS SQL не поддерживается динамический SQL внутри хранимых функций, данное задание выполнено для 
-- конкретной таблицы - subscriptions

--DROP FUNCTION [dbo].[GET_FREE_AUTHO_INC_KEYS_SUBSCRIPTIONS]
--GO

CREATE FUNCTION GET_FREE_AUTHO_INC_KEYS_SUBSCRIPTIONS ()
RETURNS @free_keys_table TABLE ([key] INT)
AS
BEGIN
	DECLARE @start_id INT;
	DECLARE @end_id INT;

	DECLARE free_autho_inc_keys_cursor CURSOR LOCAL FAST_FORWARD
	FOR
	SELECT TOP 1 [start_id]
		,[end_id]
	FROM (
		SELECT [sb_id] + 1 AS [start_id]
			,(
				SELECT MIN([sb_id]) - 1
				FROM [subscriptions] AS [temp]
				WHERE [temp].[sb_id] > [intermediate].[sb_id]
				) AS [end_id]
		FROM [subscriptions] AS [intermediate]
		
		UNION
		
		SELECT 1 AS [start_id]
			,(
				SELECT MIN([sb_id]) - 1
				FROM [subscriptions]
				) AS [end_id]
		) AS [interv_data]
	WHERE [start_id] <= [end_id]
	ORDER BY [start_id]
		,[end_id];

	OPEN free_autho_inc_keys_cursor;

	FETCH NEXT
	FROM free_autho_inc_keys_cursor
	INTO @start_id
		,@end_id;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		WHILE @start_id <= @end_id
		BEGIN
			INSERT @free_keys_table ([key])
			VALUES (@start_id);

			SET @start_id = @start_id + 1;
		END;

		FETCH NEXT
		FROM free_autho_inc_keys_cursor
		INTO @start_id
			,@end_id;
	END;

	CLOSE free_autho_inc_keys_cursor;

	DEALLOCATE free_autho_inc_keys_cursor;

	RETURN;
END;
GO

--SELECT * FROM GET_FREE_AUTHO_INC_KEYS_SUBSCRIPTIONS()



-- 3.	Создать хранимую функцию, получающую на вход идентификатор читателя и воз-вращающую 1, если у читателя на руках
-- сейчас менее десяти книг, и 0 в противном случае.

--DROP FUNCTION [dbo].[CHECK_BOOKS_NUM_LESS_TEN]
--GO

CREATE FUNCTION CHECK_BOOKS_NUM_LESS_TEN (@subscriber_id INT)
RETURNS INT
AS
BEGIN
	DECLARE @result INT = 0;

	IF (
			(
				SELECT COUNT(sb_id)
				FROM [subscriptions]
				WHERE [sb_subscriber] = @subscriber_id
					AND [sb_is_active] = 'Y'
				) < 10
			)
	BEGIN
		SET @result = 1;
	END;

	RETURN @result;
END;
GO

--SELECT dbo.CHECK_BOOKS_NUM_LESS_TEN(3);



-- 4.	Создать хранимую функцию, получающую на вход год издания книги и возвращаю-щую 1, если книга издана менее 
-- ста лет назад, и 0 в противном случае.
----DROP FUNCTION [dbo].[CHECK_BOOKS_MORE_100_YEARS]
----GO
CREATE FUNCTION CHECK_BOOKS_MORE_100_YEARS (@publ_year INT)
RETURNS INT
AS
BEGIN
	DECLARE @res INT = 0;

	IF (
			(
				SELECT YEAR(CONVERT(DATE, GETDATE()))
				) - @publ_year < 100
			)
	BEGIN
		SET @res = 1;
	END;

	RETURN @res;
END;
GO

--SELECT dbo.CHECK_BOOKS_MORE_100_YEARS(1926);



-- 5.	Создать хранимую процедуру, обновляющую все поля типа DATE (если такие есть) всех записей указанной 
-- таблицы на значение текущей даты.

--DROP PROCEDURE [dbo].[UPDATE_DATE_TO_CURR]
--GO

-- Смысл: в строке @fields_enum_for_update_query описать действия по обновлению столбцов с типом DATE в 
-- переданной таблице, то есть получится примерно такая строка: 
-- '[column1] = CONVERT(DATE, GETDATE()),[column2] = CONVERT(DATE, GETDATE()),[column3] = ...'
-- Затем эта строка подставляется в UPDATE-запрос после SET => все столбцы c типом DATE обновятся 
CREATE PROCEDURE UPDATE_DATE_TO_CURR @table_name NVARCHAR(150)
	WITH EXECUTE AS OWNER
AS
DECLARE @fields_enum_for_update_query NVARCHAR(max) = '';
DECLARE @update_dates_to_curr_query NVARCHAR(1000);
DECLARE @get_date_fields_enum_for_update_query NVARCHAR(1000) = '
	DECLARE @date_field_name NVARCHAR(150)
	DECLARE all_date_fields_cursor CURSOR LOCAL FAST_FORWARD FOR
		SELECT column_name AS [date_col]
		FROM [information_schema].[columns]
		WHERE [table_name] = ''_TABLE_NAME_PLACEHOLDER_''
			AND [data_type] = ''DATE'';
	OPEN all_date_fields_cursor;
	FETCH NEXT FROM all_date_fields_cursor INTO @date_field_name;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @fields_enum = CONCAT(@fields_enum, ''['', @date_field_name, ''] = CONVERT(date, GETDATE()),'');
		FETCH NEXT FROM all_date_fields_cursor INTO @date_field_name;
	END
	CLOSE all_date_fields_cursor;
	DEALLOCATE all_date_fields_cursor;
	SET @fields_enum = LEFT(@fields_enum, LEN(@fields_enum)-1);
	';

SET @get_date_fields_enum_for_update_query = REPLACE(@get_date_fields_enum_for_update_query, '_TABLE_NAME_PLACEHOLDER_', @table_name);

EXECUTE sp_executesql @get_date_fields_enum_for_update_query
	,N'@fields_enum NVARCHAR(max) OUT'
	,@fields_enum_for_update_query OUTPUT;;

SET @update_dates_to_curr_query = '
		UPDATE [_TABLE_NAME_PLACEHOLDER_]
		SET _FIELDS_ENUM_PLACEHOLDER
	';
SET @update_dates_to_curr_query = REPLACE(@update_dates_to_curr_query, '_TABLE_NAME_PLACEHOLDER_', @table_name)
SET @update_dates_to_curr_query = REPLACE(@update_dates_to_curr_query, '_FIELDS_ENUM_PLACEHOLDER', @fields_enum_for_update_query)

EXECUTE sp_executesql @update_dates_to_curr_query;
GO

--SELECT * FROM [subscriptions];
--EXECUTE UPDATE_DATE_TO_CURR 'subscriptions';
--SELECT * FROM [subscriptions];



-- 9.	Создать хранимую процедуру, автоматически создающую и наполняющую данными таблицу «arrears», в которой должны 
-- быть представлены идентификаторы и имена читателей, у которых до сих пор находится на руках хотя бы одна книга, по 
-- которой дата возврата установлена в прошлом относительно текущей даты.

--DROP PROCEDURE [dbo].[CREATE_ARREARS_INFO]
--GO

CREATE PROCEDURE CREATE_ARREARS_INFO
AS
BEGIN
	IF NOT EXISTS (
			SELECT [name]
			FROM sys.tables
			WHERE [name] = 'arrears'
			)
	BEGIN
		CREATE TABLE [arrears] (
			[id] INTEGER NOT NULL
			,[name] NVARCHAR(150) NOT NULL
			,FOREIGN KEY ([id]) REFERENCES [subscribers]([s_id])
			);
	END
	ELSE
	BEGIN
		TRUNCATE TABLE [arrears];
	END;

	INSERT INTO [arrears] (
		[id]
		,[name]
		)
	SELECT [s_id] AS [id]
		,[s_name] AS [name]
	FROM [subscriptions] AS [ids]
	JOIN [subscribers] AS [names] ON [ids].[sb_subscriber] = [names].[s_id]
	WHERE (
			SELECT COUNT([sb_id])
			FROM [subscriptions]
			WHERE [sb_finish] < CONVERT(DATE, GETDATE())
				AND [sb_is_active] = 'Y'
				AND [sb_subscriber] = [ids].[sb_subscriber]
			GROUP BY [sb_subscriber]
			) > 0
	GROUP BY [names].[s_id]
		,[names].[s_name]
END;
GO

--DROP TABLE [arrears];
--EXECUTE CREATE_ARREARS_INFO;
--SELECT * FROM [arrears];