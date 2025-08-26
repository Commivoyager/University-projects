-- Решены все 17 заданий

-- 1.	Показать всю информацию об авторах.
SELECT *
FROM [authors]



-- 2.	Показать всю информацию о жанрах.
SELECT *
FROM [genres]
ORDER BY [g_id]



-- 3.	Показать без повторений идентификаторы книг, 
-- которые были взяты читателями.
SELECT DISTINCT [sb_book]
FROM [subscriptions]



-- 4.	Показать по каждой книге, которую читатели брали 
-- в библиотеке, количество выдач этой книги читателям.
SELECT [sb_book]
	,COUNT([sb_book]) AS [quantity]
FROM [subscriptions]
GROUP BY [sb_book]



-- 5.	Показать, сколько всего читателей 
-- зарегистрировано в библиотеке.

-- !!! Не совсем ясно, что понимать под понятием 
-- "зарегистрирован", потому что в задании №16 этой же ЛР
-- регистрация определяется с момента взятия 1-ой книги.
-- Судя, по таблице subscriptions, пользователь с id = 2,
-- книг не брал. Поэтому решим двумя способами

-- 1 способ - считаем по таблице подписчиков
SELECT COUNT([s_id]) AS [quantity]
FROM [subscribers]

-- 2 способ - считаем по таблице подписок
SELECT COUNT(DISTINCT [sb_subscriber]) AS [quantity]
FROM [subscriptions]



-- 6.	Показать, сколько всего раз читателям выдавались 
-- книги.
SELECT COUNT(sb_id) AS [quantity]
FROM [subscriptions]



-- 7.	Показать, сколько читателей брало книги в библиотеке.
SELECT COUNT(DISTINCT sb_subscriber)
FROM [subscriptions]



-- 8.	Показать первую и последнюю даты выдачи книги 
-- читателю.
SELECT [sb_subscriber]
	,MIN([sb_start]) AS [first_date]
	,MAX([sb_start]) AS [last_date]
FROM [subscriptions]
GROUP BY [sb_subscriber]



-- 9.	Показать список авторов в обратном алфавитном 
-- порядке (т.е. «Я -> А»).
SELECT [a_name]
FROM [authors]
ORDER BY [a_name] DESC 



-- 10.	Показать книги, количество экземпляров которых 
-- меньше среднего по библиотеке.
SELECT [b_name]
	,[b_quantity]
FROM [books]
WHERE [b_quantity] < (
		SELECT AVG(CAST([b_quantity] AS FLOAT))
		FROM [books]
		)



-- 11.	Показать идентификаторы и даты выдачи книг 
--за первый год работы библиотеки (первым годом работы 
--библиотеки считать все даты с первой выдачи книги по 
--31-е декабря (включительно) того года, когда 
--библиотека начала работать).

SELECT [sb_book],
	[sb_start]
FROM [subscriptions]
WHERE [sb_start] >= (
		SELECT MIN([sb_start])
		FROM [subscriptions]
		)
	AND [sb_start] < DATEFROMPARTS(YEAR((
				SELECT MIN([sb_start])
				FROM [subscriptions]
				)) + 1, 1, 1)



-- 12.	Показать идентификатор одного (любого) читателя, 
--взявшего в библиотеке больше всего книг.

SELECT TOP 1 [sb_subscriber],
	COUNT([sb_id]) AS [book_quant]
FROM [subscriptions]
GROUP BY [sb_subscriber]
ORDER BY [book_quant] DESC



-- 13.	Показать идентификаторы всех «самых читающих 
--читателей», взявших в библиоте-ке больше всего книг.

-- 1 вариант выполнения задания - с помощью ранжирования

SELECT [sb_subscriber]
	,[quantity]
FROM (
	SELECT [sb_subscriber]
		,[quantity]
		,RANK() OVER (
			ORDER BY [quantity] DESC
			) AS [rank]
	FROM (
		SELECT [sb_subscriber]
			,COUNT([sb_id]) AS [quantity]
		FROM [subscriptions]
		GROUP BY [sb_subscriber]
		) AS [books_quantity]
	) AS [ranked_quantity]
WHERE [rank] = 1;	

-- 2 вариант выполнения задания - с помощью MAX

WITH [books_quantity]
AS (
	SELECT [sb_subscriber]
		,COUNT([sb_id]) AS [quantity]
	FROM [subscriptions]
	GROUP BY [sb_subscriber]
	)

SELECT [sb_subscriber]
	,[quantity]
FROM [books_quantity]
WHERE [quantity] = (
		SELECT MAX([quantity])
		FROM [books_quantity]
		);



-- 14.	Показать идентификатор «читателя-рекордсмена», 
-- взявшего в библиотеке больше книг, чем любой другой 
-- читатель.

WITH [ranked_quantity]
AS (
	SELECT [sb_subscriber]
		,[quantity]
		,RANK() OVER (
			ORDER BY [quantity] DESC
			) AS [rank]
	FROM (
		SELECT [sb_subscriber]
			,COUNT([sb_id]) AS [quantity]
		FROM [subscriptions]
		GROUP BY [sb_subscriber]
		) AS [books_quantity]
	)
	,[counted_rank]
AS (
	SELECT [rank]
		,COUNT([rank]) AS [count]
	FROM [ranked_quantity]
	GROUP BY [rank]
	)

SELECT [sb_subscriber]
	,[quantity]
FROM [ranked_quantity]
JOIN [counted_rank] ON [ranked_quantity].[rank] = [counted_rank].[rank]
WHERE [ranked_quantity].[rank] = 1
	AND [counted_rank].[count] = 1



-- 15.	Показать, сколько в среднем экземпляров книг 
-- есть в библиотеке.

SELECT AVG(CAST([b_quantity] AS FLOAT))
FROM [books]



-- 16.	Показать в днях, сколько в среднем времени 
--читатели уже зарегистрированы в библиотеке (временем 
--регистрации считать диапазон от первой даты получения 
--читателем книги до текущей даты).

SELECT AVG(CAST(DATEDIFF(day, [reg_date], CONVERT(DATE, GETDATE())) AS FLOAT))
FROM (
	SELECT [sb_subscriber]
		,MIN([sb_start]) AS [reg_date]
	FROM [subscriptions]
	GROUP BY [sb_subscriber]
	) AS [registrations]



-- 17.	Показать, сколько книг было возвращено и не 
--возвращено в библиотеку (СУБД должна оперировать 
--исходными значениями поля sb_is_active (т.е. «Y» и «N»), 
--а по-сле подсчёта значения «Y» и «N» должны быть 
--преобразованы в «Returned» и «Not returned»).

SELECT (
		CASE 
			WHEN [sb_is_active] = 'Y'
				THEN 'Not returned'
			ELSE 'Returned'
			END
		) AS [ret_sign]
	,COUNT([sb_id]) AS [quantity]
FROM [subscriptions]
GROUP BY (
		CASE 
			WHEN [sb_is_active] = 'Y'
				THEN 'Not returned'
			ELSE 'Returned'
			END
		)