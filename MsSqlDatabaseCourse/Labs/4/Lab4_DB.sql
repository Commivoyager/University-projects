-- Решены все 13 заданий

-- 1.	Добавить в базу данных информацию о троих новых читателях: «Орлов О.О.», «Со-колов С.С.», 
-- «Беркутов Б.Б.».
INSERT INTO [subscribers] ([s_name])
VALUES (N'Орлов О.О.')
	,(N'Соколов С.С.')
	,(N'Беркутов Б.Б.');

-- SELECT * FROM [subscribers]
-- 2.	Отразить в базе данных информацию о том, что каждый из троих добавленных чита-телей 20-го 
-- января 2016-го года на месяц взял в библиотеке книгу «Курс теоретиче-ской физики».
INSERT INTO [subscriptions] (
	[sb_subscriber]
	,[sb_book]
	,[sb_start]
	,[sb_finish]
	,[sb_is_active]
	)
VALUES (
	8
	,6
	,CONVERT(DATE, '2016-01-20')
	,DATEADD(month, 1, CONVERT(DATE, '2016-01-20'))
	,CASE 
		WHEN DATEADD(month, 1, CONVERT(DATE, '2016-01-20')) < CONVERT(DATE, GETDATE())
			THEN N'N'
		ELSE N'Y'
		END
	)
	,(
	9
	,6
	,CONVERT(DATE, '2016-01-20')
	,DATEADD(month, 1, CONVERT(DATE, '2016-01-20'))
	,CASE 
		WHEN DATEADD(month, 1, CONVERT(DATE, '2016-01-20')) < CONVERT(DATE, GETDATE())
			THEN N'N'
		ELSE N'Y'
		END
	)
	,(
	10
	,6
	,CONVERT(DATE, '2016-01-20')
	,DATEADD(month, 1, CONVERT(DATE, '2016-01-20'))
	,CASE 
		WHEN DATEADD(month, 1, CONVERT(DATE, '2016-01-20')) < CONVERT(DATE, GETDATE())
			THEN N'N'
		ELSE N'Y'
		END
	);

-- 3.	Добавить в базу данных пять любых авторов и десять книг этих авторов (по две на каждого); 
-- если понадобится, добавить в базу данных соответствующие жанры. От-разить авторство добавленных 
-- книг и их принадлежность к соответствующим жан-рам.
INSERT INTO [authors] (a_name)
VALUES (N'Джордж Оруэлл')
	,(N'Агата Кристи')
	,(N'Дж.Р.Р. Толкин')
	,(N'Рэй Брэдбери')
	,(N'Джейн Остин');

INSERT INTO [books] (
	[b_name]
	,[b_year]
	,[b_quantity]
	)
VALUES (
	N'1984'
	,1949
	,15
	)
	,(
	N'Скотный двор'
	,1945
	,10
	)
	,(
	N'Убийство в Восточном экспрессе'
	,1934
	,20
	)
	,(
	N'Десять негритят'
	,1939
	,18
	)
	,(
	N'Властелин колец'
	,1954
	,25
	)
	,(
	N'Хоббит'
	,1937
	,22
	)
	,(
	N'451 градус по Фаренгейту'
	,1953
	,12
	)
	,(
	N'Вино из одуванчиков'
	,1957
	,8
	)
	,(
	N'Гордость и предубеждение'
	,1813
	,30
	)
	,(
	N'Эмма'
	,1815
	,28
	);

INSERT INTO [genres] ([g_name])
VALUES (N'Антиутопия')
	,(N'Детектив')
	,(N'Научная фантастика')
	,(N'Роман');

INSERT INTO [m2m_books_authors] (
	[b_id]
	,[a_id]
	)
VALUES (
	8
	,8
	)
	,(
	9
	,8
	)
	,(
	10
	,9
	)
	,(
	11
	,9
	)
	,(
	12
	,10
	)
	,(
	13
	,10
	)
	,(
	14
	,11
	)
	,(
	15
	,11
	)
	,(
	16
	,12
	)
	,(
	17
	,12
	);

INSERT INTO [m2m_books_genres] (
	[b_id]
	,[g_id]
	)
VALUES (
	8
	,9
	)
	,(
	9
	,9
	)
	,(
	10
	,10
	)
	,(
	11
	,10
	)
	,(
	12
	,6
	)
	,(
	13
	,6
	)
	,(
	14
	,11
	)
	,(
	15
	,11
	)
	,(
	16
	,12
	)
	,(
	17
	,12
	);

-- 4.	Отметить все выдачи с идентификаторами ≤50 как возвращённые.
UPDATE [subscriptions]
SET [sb_is_active] = 'N'
WHERE [sb_id] <= 50;

--SELECT * FROM [subscriptions];
-- 5.	Для всех выдач, произведённых до 1-го января 2012-го года, 
-- уменьшить значение дня выдачи на 3.
UPDATE [subscriptions]
SET [sb_start] = DATEADD(day, - 3, [sb_start])
WHERE [sb_start] = CONVERT(DATE, '2012-01-01');

--SELECT * FROM [subscriptions]
-- 6.	Отметить как невозвращённые все выдачи, полученные читателем с идентификато-ром 2.
UPDATE [subscriptions]
SET [sb_is_active] = 'Y'
WHERE [sb_subscriber] = 2;

--SELECT * FROM [subscriptions] 
-- 7.	Удалить информацию обо всех выдачах читателям книги с идентификатором 1.
DELETE
FROM [subscriptions]
WHERE [sb_book] = 1;

-- SELECT * FROM [subscriptions]
-- 8.	Удалить все книги, относящиеся к жанру «Классика».
DELETE
FROM [books]
WHERE [b_id] IN (
		SELECT [books].[b_id]
		FROM [books]
		JOIN [m2m_books_genres] ON [books].[b_id] = [m2m_books_genres].[b_id]
		JOIN [genres] ON [m2m_books_genres].[g_id] = [genres].[g_id]
		WHERE [g_name] = 'Классика'
		);

-- SELECT * FROM [books]
-- 9.	Удалить информацию обо всех выдачах книг, произведённых после 20-го числа лю-бого 
-- месяца любого года.
DELETE
FROM [subscriptions]
WHERE DAY([sb_start]) > 20;

-- SELECT * FROM [subscriptions]
-- 10.	Добавить в базу данных жанры «Политика», «Психология», «История».
MERGE INTO [genres]
USING (
	VALUES (N'Политика')
		,(N'Психология')
		,(N'История')
	) AS [src]([g_name])
	ON [genres].[g_name] = [src].[g_name]
WHEN NOT MATCHED
	THEN
		INSERT ([g_name])
		VALUES ([src].[g_name]);
			--SELECT * FROM [genres] ORDER BY [g_id]
			11.

Создать таблицу “subscribers_tmp” с такой же структурой
	,как у таблицы “subscribers”.Поместить в таблицу “subscribers_tmp” информацию о десяти случайных подписчи - ках.Скопировать(без повторений) содержимое таблицы “subscribers_tmp” в таблицу “subscribers”;

в случае совпадения первичных ключей добавить к существующему имени читателя слово « [OLD] ».

-- Создание талицы [subscribers_tmp] такой же по структуре, что и [subscribers]
SELECT *
INTO [subscribers_tmp]
FROM [subscribers]
WHERE 1 = 0;

-- Заполнение таблицы [subscribers_tmp]:
-- В таблицу [subscribers_tmp] вставляются произвольные читатели из таблицы [subscribers].
-- Так как в [subscribers] изначально может быть меньше 10 записей - в общем табличном выражении 
-- рекурсивно генерируется таблица, в которой только одно поле (числовое), но записей в такой таблице
-- ровно 10. Далее с помощью CROSS JOIN эта сгенерированная таблица объединяется с таблицей [subscribers],
-- Таким образом можно взять гарантированно 10 штук читателей (условимся, что [subscribers] изначально 
-- не была пустой). Случайный порядок обеспечивается за счёт NEWID(). 
--
-- [s_id] != 4 - условие наложено просто чтобы в таблицу [subscribers_tmp] не попал читатель 
-- с таким идентификатором, чтобы в результате выполнения основного задания у соответствующего читателя
-- не было приписано слово [OLD]
SET IDENTITY_INSERT [subscribers_tmp] ON;

WITH [Numbers]
AS (
	SELECT 1 AS [num]
	
	UNION ALL
	
	SELECT [num] + 1
	FROM [Numbers]
	WHERE [num] < 10
	)
INSERT INTO [subscribers_tmp] (
	s_id
	,s_name
	)
SELECT TOP 10 [s_id]
	,[s_name]
FROM [Numbers]
CROSS JOIN [subscribers] AS [src]
WHERE [s_id] != 4
ORDER BY NEWID();

SET IDENTITY_INSERT [subscribers_tmp] OFF;
-- Слияние данных для "копирования без повторений"	
SET IDENTITY_INSERT [subscribers] ON;

MERGE [subscribers] AS [dest]
USING (
	SELECT [s_id]
		,[s_name]
	FROM [subscribers_tmp]
	GROUP BY [s_id]
		,[s_name]
	) AS [src]
	ON [src].[s_id] = [dest].[s_id]
WHEN MATCHED
	THEN
		UPDATE
		SET [dest].[s_name] = CONCAT (
				[dest].[s_name]
				,N' [OLD]'
				)
WHEN NOT MATCHED
	THEN
		INSERT (
			[s_id]
			,[s_name]
			)
		VALUES (
			[src].[s_id]
			,[src].[s_name]
			);

SET IDENTITY_INSERT [subscribers] OFF;

-- 12.	Добавить в базу данных читателей с именами «Сидоров С.С.», «Иванов И.И.», «Ор-лов О.О.»; если читатель с 
-- таким именем уже существует, добавить в конец имени нового читателя порядковый номер в квадратных скобках 
-- (например, если при до-бавлении читателя «Сидоров С.С.» выяснится, что в базе данных уже есть четыре таких 
-- читателя, имя добавляемого должно превратиться в «Сидоров С.С. [5]»).
INSERT INTO [subscribers] ([s_name])
SELECT CASE 
		WHEN [s_name] IN (
				SELECT [s_name]
				FROM [subscribers]
				)
			THEN (
					CONCAT (
						[s_name]
						,' ['
						,(
							SELECT COUNT(s_id)
							FROM [subscribers]
							WHERE [s_name] = [new_subscribers].[s_name]
							)
						,']'
						)
					)
		ELSE [s_name]
		END
FROM (
	VALUES (N'Сидоров С.С.')
		,(N'Иванов И.И.')
		,(N'Орлов О.О.')
	) AS [new_subscribers]([s_name]);

-- 13.	Обновить все имена авторов, добавив в конец имени « [+]», если в библиотеке есть более трёх книг 
-- этого автора, или добавив в конец имени « [-]» в противном случае.
UPDATE [authors]
SET [a_name] = (
		SELECT CASE 
				WHEN [books_num] < 3
					THEN (
							SELECT CONCAT (
									[a_name]
									,' [+]'
									)
							)
				ELSE (
						SELECT CONCAT (
								[a_name]
								,' [-]'
								)
						)
				END
		FROM (
			SELECT [authors].[a_id]
				,[a_name]
				,COUNT([m2m_books_authors].[b_id]) AS [books_num]
			FROM [authors]
			LEFT JOIN [m2m_books_authors] ON [authors].[a_id] = [m2m_books_authors].[a_id]
			--JOIN [books]	
			--	ON [m2m_books_authors].[b_id] = [books].[b_id]
			GROUP BY [authors].[a_id]
				,[a_name]
			) AS [prepared_data]
		WHERE [authors].[a_id] = [prepared_data].[a_id]
		);