-- !!! ��� 3 ������������ ������
-- ������� ��� 28 �������, ����� �� �������� ������ 5 ���������, �� ��� ��� �� ����� ������ �� - ����� ���� �������� 

-- 1.	�������� ������ ����, � ������� ����� ������ ������.

SELECT [books].[b_id]
	,[b_name]
	,COUNT([a_id]) AS [auth_num]
FROM [books]
LEFT JOIN [m2m_books_authors] ON [books].[b_id] = [m2m_books_authors].[b_id]
GROUP BY [books].[b_id]
	,[books].[b_name]
HAVING COUNT([a_id]) > 1;



-- 2.	�������� ������ ����, ����������� ����� � ������ �����.

SELECT [books].[b_id]
	,[b_name]
FROM [books]
LEFT JOIN [m2m_books_genres] ON [books].[b_id] = [m2m_books_genres].[b_id]
GROUP BY [books].[b_id]
	,[b_name]
HAVING COUNT([g_id]) = 1;



-- 3.	�������� ��� ����� � �� ������� (������������ �������� ���� �� �����������).

SELECT [books].[b_id]
	,[b_name]
	,STRING_AGG([g_name], ', ') WITHIN
GROUP (
		ORDER BY [g_name] ASC
		) AS [b_genres]
FROM [books]
LEFT JOIN [m2m_books_genres] ON [books].[b_id] = [m2m_books_genres].[b_id]
LEFT JOIN [genres] ON [m2m_books_genres].[g_id] = [genres].[g_id]
GROUP BY [books].[b_id]
	,[b_name];



-- 4.	�������� ���� ������� �� ����� ����������� ��� ������� � ����� �������, � ��-����� ��� 
-- �������� (������������ ��� �������, �������� ���� � ������ �� �����-������).

WITH [author_id_info]
AS (
	SELECT [authors].[a_id]
		,[a_name]
		,[m2m_books_authors].[b_id] AS [book_id]
		,[m2m_books_genres].[g_id] AS [genre_id]
	FROM [authors]
	LEFT JOIN [m2m_books_authors] ON [authors].[a_id] = [m2m_books_authors].[a_id]
	LEFT JOIN [m2m_books_genres] ON [m2m_books_authors].[b_id] = [m2m_books_genres].[b_id]
	)
	,[books_info]
AS (
	SELECT [a_id]
		,[a_name]
		,STRING_AGG([b_name], ', ') WITHIN
	GROUP (
			ORDER BY [b_name] ASC
			) AS [a_books]
	FROM (
		SELECT DISTINCT [a_id]
			,[a_name]
			,[b_name]
		FROM [author_id_info]
		LEFT JOIN [books] ON [book_id] = [b_id]
		GROUP BY [a_id]
			,[a_name]
			,[b_name]
		) AS [books_no_duplicates]
	GROUP BY [a_id]
		,[a_name]
	)
	,[genres_info]
AS (
	SELECT [a_id]
		,[a_name]
		,STRING_AGG([g_name], ', ') WITHIN
	GROUP (
			ORDER BY [g_name] ASC
			) AS [a_genres]
	FROM (
		SELECT DISTINCT [a_id]
			,[a_name]
			,[g_name]
		FROM [author_id_info]
		LEFT JOIN [genres] ON [genre_id] = [g_id]
		GROUP BY [a_id]
			,[a_name]
			,[g_name]
		) AS [genres_no_duplicates]
	GROUP BY [a_id]
		,[a_name]
	)
SELECT [books_info].[a_id]
	,[books_info].[a_name]
	,[a_books]
	,[a_genres]
FROM [books_info]
JOIN [genres_info] ON [books_info].[a_id] = [genres_info].[a_id]
ORDER BY [a_id];



-- 5.	�������� ������ ����, ������� �����-���� ���� ����� ����������.

SELECT [b_id]
	,[b_name]
FROM [books]
WHERE [b_id] IN (
		SELECT DISTINCT [sb_book]
		FROM [subscriptions]
		);



-- 6.	�������� ������ ����, ������� ����� �� ��������� ������� �� ����.

SELECT DISTINCT [b_id]
	,[b_name]
FROM [books]
LEFT JOIN [subscriptions] ON [b_id] = [sb_book]
WHERE [sb_book] IS NULL;



-- 7.	�������� ������ ����, �� ���� ��������� ������� ������ �� ��������� �� ����� � ��-�������.

SELECT [b_id]
	,[b_name]
FROM [books]
WHERE [b_id] NOT IN (
		SELECT DISTINCT [sb_book]
		FROM [subscriptions]
		WHERE [sb_is_active] = 'Y'
		);



-- 8.	�������� �����, ���������� �������� �/��� �������� (������������� ��� � ����-������� � �� �����).

SELECT [books].[b_id]
	,[b_name]
	-- ���� �������� ������ � �����������, �� �� ������� ��������� � 1 ���� ����� �������
	,STRING_AGG([a_name], ', ') WITHIN
GROUP (
		ORDER BY [a_name] ASC
		) AS [a_names]
FROM [books]
JOIN [m2m_books_authors] ON [books].[b_id] = [m2m_books_authors].[b_id]
JOIN (
	SELECT [a_id]
		,[a_name]
	FROM [authors]
	WHERE [a_name] IN (
			'�.�. ������'
			,'�. ������'
			)
	) AS [need_auth] ON [m2m_books_authors].[a_id] = [need_auth].[a_id]
GROUP BY [books].[b_id]
	,[b_name];



-- 9.	�������� �����, ���������� ������� � ������������ � �����������.

-- ������� ��� ������������� JOIN

SELECT [b_id]
	,[b_name]
FROM [books]
-- ���������� �������� ����� ��� ����, � ������� ����� 2 ������ (��� ������ �������)
WHERE [b_id] IN (
		SELECT [b_id]
		FROM [m2m_books_authors]
		GROUP BY [b_id]
		HAVING COUNT([a_id]) = 2
		)
	AND [b_id] IN (
		SELECT [b_id]
		FROM [m2m_books_authors]
		WHERE [a_id] IN (
				SELECT [a_id]
				FROM [authors]
				WHERE [a_name] IN (
						'�. ����������'
						,'�. �������'
						)
				)
		GROUP BY [b_id]
		-- ����� ��������� ���� ����� ��������� ��, ������� �������� ������������ ��� ������� � �����������. 
		-- ���� � ������� �������� ��� ���� (�� ���������� �������), �� ����� ����� ���� �������� ����� ��������, 
		-- ����� ������� ����� ���������� ��� ������� � ����������� � ���-�� ������, � �� ������ ���� � ������
		HAVING COUNT([a_id]) = 2
		);



-- 10.	�������� �������, ���������� ����� ����� �����.

SELECT [authors].[a_id]
	,[a_name]
	,COUNT([b_id]) AS [b_num]
FROM [authors]
JOIN [m2m_books_authors] ON [m2m_books_authors].[a_id] = [authors].[a_id]
GROUP BY [authors].[a_id]
	,[a_name]
HAVING COUNT([b_id]) > 1;



-- 11.	�������� �����, ����������� � ����� ��� ������ �����.

WITH [counted_genres]
AS (
	SELECT [books].[b_id]
		,[b_name]
		,COUNT([g_id]) AS [genres_num]
	FROM [books]
	JOIN [m2m_books_genres] ON [books].[b_id] = [m2m_books_genres].[b_id]
	GROUP BY [books].[b_id]
		,[b_name]
	)
SELECT [b_id]
	,[b_name]
	,[genres_num]
FROM [counted_genres]
WHERE [genres_num] > 1;



-- 12.	�������� ���������, � ������� ������ �� ����� ������ ����� �����.

WITH [taken_books]
AS (
	SELECT [sb_subscriber]
		,COUNT([sb_book]) AS [taken_num]
	FROM [subscriptions]
	WHERE [sb_is_active] = 'Y'
	GROUP BY [sb_subscriber]
	)
SELECT [s_id]
	,[s_name]
	,[taken_num]
FROM [subscribers]
JOIN [taken_books] ON [s_id] = [sb_subscriber]
WHERE [taken_num] > 1;



-- 13.	��������, ������� ����������� ������ ����� ������ ������ ���������.

WITH [active_subscriptions]
AS (
	SELECT [sb_book]
	FROM [subscriptions]
	WHERE [sb_is_active] = 'Y'
	)
SELECT [b_id]
	,[b_name]
	,COUNT([sb_book]) AS [taken_num]
FROM [books]
LEFT JOIN [active_subscriptions] ON [b_id] = [sb_book]
GROUP BY [b_id]
	,[b_name];



-- 14.	�������� ���� ������� � ���������� ����������� ���� �� ������� ������.

SELECT [authors].[a_id]
	,[a_name]
	,SUM([b_quantity]) AS [books_num]
FROM [authors]
LEFT JOIN [m2m_books_authors] ON [authors].[a_id] = [m2m_books_authors].[a_id]
LEFT JOIN [books] ON [m2m_books_authors].[b_id] = [books].[b_id]
GROUP BY [authors].[a_id]
	,[a_name];



-- 15.	�������� ���� ������� � ���������� ���� (�� ����������� ����, � ����� ��� ����-���) �� ������� ������

SELECT [a_name]
	,COUNT([b_id]) AS [b_num]
FROM [authors]
LEFT JOIN [m2m_books_authors] ON [authors].[a_id] = [m2m_books_authors].[a_id]
GROUP BY [authors].[a_id]
	,[authors].[a_name];



-- 16.	�������� ���� ���������, �� ��������� �����, � ���������� �������������� ���� �� ������� ������ ��������

SELECT [s_id]
	,[s_name]
	,COUNT([sb_book]) AS [not_ret_books]
FROM [subscribers]
JOIN [subscriptions] ON [s_id] = [sb_subscriber]
WHERE [sb_is_active] = 'Y'
GROUP BY [s_id]
	,[s_name];



-- 17.	�������� ���������� ������, �.�. ��� ����� � �� ���������� ���, ������� ����� ���� ������ ���� ����� ����������.

SELECT [g_name]
	,COUNT([sb_id]) AS [taken_num]
FROM [genres]
LEFT JOIN [m2m_books_genres] ON [genres].[g_id] = [m2m_books_genres].[g_id]
LEFT JOIN [subscriptions] ON [b_id] = [sb_book]
GROUP BY [genres].[g_id]
	,[g_name];



-- 18.	�������� ����� �������� ����, �.�. ���� (��� �����, ���� �� ���������), ������-����� � �������� ����� 
-- �������� ����� ���� �����.

-- 1 ������� ���������� ������� - ����� ��������� ��������� + MAX

WITH [prepared_data]
AS (
	SELECT [genres].[g_name] AS [g_name]
		,COUNT([genres].[g_id]) AS [subscr_num]
	FROM [subscriptions]
	JOIN [m2m_books_genres] ON [subscriptions].[sb_book] = [m2m_books_genres].[b_id]
	JOIN [genres] ON [m2m_books_genres].[g_id] = [genres].[g_id]
	GROUP BY [genres].[g_id]
		,[genres].[g_name]
	)
SELECT [g_name]
	,[subscr_num]
FROM [prepared_data]
WHERE [subscr_num] = (
		SELECT MAX([subscr_num])
		FROM [prepared_data]
		);

-- 2 ������� ���������� ������� - ����� ��������� ��������� + ����������� �������

WITH [prepared_data]
AS (
	SELECT [g_name]
		,COUNT([genres].[g_id]) AS [subscr_num]
		,RANK() OVER (
			ORDER BY COUNT([genres].[g_id]) DESC
			) AS [rank]
	FROM [subscriptions]
	JOIN [m2m_books_genres] ON [subscriptions].[sb_book] = [m2m_books_genres].[b_id]
	JOIN [genres] ON [m2m_books_genres].[g_id] = [genres].[g_id]
	GROUP BY [genres].[g_id]
		,[g_name]
	)
SELECT [g_name]
	,[subscr_num]
FROM [prepared_data]
WHERE [rank] = 1;



-- 19.	�������� ������� ���������� ������, �.�. ������� �������� �� ����, ������� ��� 
-- �������� ����� ����� ������� �����.

SELECT AVG(CAST([genres_num] AS FLOAT)) AS [avrg_genres]
FROM (
	SELECT COUNT([sb_id]) AS [genres_num]
	FROM [genres]
	LEFT JOIN [m2m_books_genres] ON [m2m_books_genres].[g_id] = [genres].[g_id]
	LEFT JOIN [subscriptions] ON [b_id] = [sb_book]
	GROUP BY [genres].[g_id]
	) AS [counted_genres];



-- 20.	�������� ������� ���������� ������, �.�. ��������� �������� �� ����, ������� ��� 
-- �������� ����� ����� ������� �����.

WITH [genres_popularity]
AS (
	SELECT
		--[g_name],
		--	[genres].[g_id],
		COUNT([sb_book]) AS [taken_num]
	FROM [genres]
	LEFT JOIN [m2m_books_genres] ON [genres].[g_id] = [m2m_books_genres].[g_id]
	LEFT JOIN [subscriptions] ON [m2m_books_genres].[b_id] = [subscriptions].[sb_book]
	GROUP BY [genres].[g_id]
		,[g_name]
	)
SELECT DISTINCT PERCENTILE_DISC(0.5) WITHIN
GROUP (
		ORDER BY [taken_num]
		) OVER () AS [median]
FROM [genres_popularity];



-- 21.	�������� ���������, ������� ����� ������������� ����� (�.�. �����, ������������ ����������� � 
-- ������������� ���������� ������).

WITH [step_1]
AS (
	SELECT [b_id]
		,RANK() OVER (
			ORDER BY COUNT([b_id]) DESC
			) AS [rank]
	FROM [m2m_books_genres]
	GROUP BY [b_id]
	)
	,[step_2]
AS (
	SELECT [b_id]
	FROM [step_1]
	WHERE [rank] = 1
	)
SELECT DISTINCT [s_id]
	,[s_name]
FROM [subscriptions]
JOIN [subscribers] ON [subscriptions].[sb_subscriber] = [subscribers].[s_id]
WHERE [sb_book] IN (
		SELECT [b_id]
		FROM [step_2]
		);



-- 22.	�������� ��������� ����������� ���������� ������ (�� �����, ����� �� ��� �����, 
-- ������ �� ������� ��������� ������������ � ������ ������, ��� �� ������ ����� ���� 
-- �� ������ ������, ������ �� ������� ��������� � ���������� ���������� ���-���).

SELECT TOP 1 [genres_num]
	,[s_id]
	,[s_name]
FROM (
	SELECT [s_id]
		,[s_name]
		,COUNT(DISTINCT g_id) AS [genres_num]
	FROM [m2m_books_genres]
	JOIN [subscriptions] ON [sb_book] = [b_id]
	JOIN [subscribers] ON [sb_subscriber] = [s_id]
	GROUP BY [s_id]
		,[s_name]
	) AS [counted_genres]



-- 23.	�������� ��������, ��������� �������� � ���������� �����.

-- ���� �� ������������� ����������, ����� ��������, ��� ������������� �������� sb_id �� 
-- ������� subscriptions ����� ������ ����������� �� �������� ������ �����, ������ � ����� �� 
-- ������-�� ���� ��������� (������ � ����� ������� ��������������� 100 ����� ����� ������ ����)

SELECT [s_id]
	,[s_name]
FROM [subscribers]
WHERE [s_id] = (
		SELECT [sb_subscriber]
		FROM [subscriptions]
		WHERE [sb_id] = (
				SELECT MAX([sb_id])
				FROM [subscriptions]
				WHERE [sb_start] = (
						SELECT MAX([sb_start])
						FROM [subscriptions]
						)
				)
		);



-- 24.	�������� �������� (��� ���������, ���� �� �������� ���������), ������ ����� ��������� � ���� 
-- ����� (��������� ������ ������, ����� ����� �� ����������).

SELECT [s_id]
	,[s_name]
	,DATEDIFF(day, [sb_start], CONVERT(DATE, GETDATE())) AS [days_num]
FROM [subscribers]
JOIN [subscriptions] ON [s_id] = [sb_subscriber]
WHERE [sb_is_active] = 'Y'
	AND DATEDIFF(day, [sb_start], CONVERT(DATE, GETDATE())) = (
		SELECT TOP 1 DATEDIFF(day, [sb_start], CONVERT(DATE, GETDATE())) AS [diff]
		FROM [subscriptions]
		WHERE [sb_is_active] = 'Y'
		ORDER BY [diff] DESC
		);



-- 25.	��������, ����� ����� (��� �����, ���� �� ���������) ������ �������� ���� 
-- � ���� ��������� ����� � ����������.

WITH [last_dates]
AS (
	SELECT [sb_subscriber] AS [s_id]
		,[sb_book] AS [b_id]
		,[sb_start]
	FROM [subscriptions] AS [outer]
	WHERE [sb_start] = (
			SELECT TOP 1 [sb_start]
			FROM [subscriptions] AS [inner]
			WHERE [outer].[sb_subscriber] = [inner].[sb_subscriber]
			ORDER BY [sb_start] DESC
			)
	)
SELECT [subscribers].[s_id]
	,[s_name]
	,[sb_start] AS [visit_date]
	,STRING_AGG([b_name], ', ') WITHIN
GROUP (
		ORDER BY [b_name] ASC
		) AS [book_names]
FROM [subscribers]
LEFT JOIN [last_dates] ON [subscribers].[s_id] = [last_dates].[s_id]
JOIN [books] ON [last_dates].[b_id] = [books].[b_id]
GROUP BY [subscribers].[s_id]
	,[s_name]
	,[sb_start]
ORDER BY [subscribers].[s_id];



-- 26.	�������� ��������� �����, ������� ������ �� ��������� ���� � ����������.

SELECT [s_id]
	,[s_name]
	,[b_id]
	,[b_name]
	,[sb_start]
FROM [subscribers]
JOIN [subscriptions] ON [s_id] = [sb_subscriber]
JOIN [books] ON [sb_book] = [b_id]
WHERE [sb_id] = (
		SELECT MAX([sb_id])
		FROM [subscriptions]
		WHERE [sb_start] = (
				SELECT MAX([sb_start])
				FROM [subscriptions]
				WHERE [sb_subscriber] = [s_id]
				)
		);



-- 27.	�������� ���������� � ���, ����� ����� � �������� ����� ����� � ���������� ���-��� �� ���������

-- ������� � ������ ����, ��� �� ������ ������ �����-�� ����� ����� ��������� (� ������� LEFT JOIN) 
-- !!! ����� ��������� ��������� - ��� �� ���� ������� �������, ����� � ������� CROSS JOIN ���������� 
-- ������ ��������� ��� ������� ������������
WITH [counted_subscr]
AS (
	SELECT [b_id]
		,[b_name]
		,[b_quantity] - ISNULL([active_now], 0) AS [remaining_books]
	FROM [books]
	LEFT JOIN (
		SELECT [sb_book]
			,COUNT([sb_book]) AS [active_now]
		FROM [subscriptions]
		WHERE [sb_is_active] = 'Y'
		GROUP BY [sb_book]
		) AS [counted_subscr] ON [books].b_id = [counted_subscr].[sb_book]
	WHERE [b_quantity] - ISNULL([active_now], 0) > 0
	)
SELECT [s_id]
	,[s_name]
	,[b_id]
	,[b_name]
--,[remaining_books]
FROM [subscribers]
CROSS JOIN [counted_subscr]
ORDER BY [s_id]
	,[b_id];

-- ������� ��� ����� ����, ��� �� ������ ������ �����-�� ����� ����� ���������
SELECT [s_id]
	,[s_name]
	,[b_id]
	,[b_name]
FROM [subscribers]
CROSS JOIN [books]
ORDER BY [s_id]
	,[b_id];



-- 28.	�������� ���������� � ���, ����� ����� (��� �������, ��� �� �� ��� �� ����) ���-��� �� ��������� ����� ����� � ����������.

-- ������� � ������ ����, ��� �� ������ ������ �����-�� ����� ����� ��������� 

WITH [remaining_books]
AS (
	SELECT [b_id]
		,[b_name]
		,(
			[b_quantity] - (
				SELECT COUNT([sb_book])
				FROM [subscriptions]
				WHERE [b_id] = [sb_book]
					AND [sb_is_active] = 'Y'
				)
			) AS [remaining_num]
	FROM [books]
	)
	,[taken_books]
AS (
	SELECT [s_id]
		,[sb_book] AS [b_id]
	FROM [subscribers]
	JOIN [subscriptions] ON [s_id] = [sb_subscriber]
	)
SELECT [s_id]
	,[s_name]
	,[b_id]
	,[b_name]
FROM [subscribers] AS [ext]
CROSS APPLY (
	SELECT [b_id]
		,[b_name]
	FROM [remaining_books]
	WHERE [remaining_num] > 0
		AND [b_id] NOT IN (
			SELECT [b_id]
			FROM [taken_books]
			WHERE [s_id] = [ext].[s_id]
			)
	) AS [available_books]
ORDER BY [s_id]
	,[b_id];

-- ������� ��� ����� ����, ��� �� ������ ������ �����-�� ����� ����� ���������

WITH [taken_books]
AS (
	SELECT [s_id]
		,[sb_book] AS [b_id]
	FROM [subscribers]
	JOIN [subscriptions] ON [s_id] = [sb_subscriber]
	)
SELECT [s_id]
	,[s_name]
	,[b_id]
	,[b_name]
FROM [subscribers] AS [ext]
CROSS JOIN [books]
WHERE [b_id] NOT IN (
		SELECT [b_id]
		FROM [taken_books]
		WHERE [s_id] = [ext].s_id
		)