-- ������ ��� 17 �������

-- 1.	�������� ��� ���������� �� �������.
SELECT *
FROM [authors]



-- 2.	�������� ��� ���������� � ������.
SELECT *
FROM [genres]
ORDER BY [g_id]



-- 3.	�������� ��� ���������� �������������� ����, 
-- ������� ���� ����� ����������.
SELECT DISTINCT [sb_book]
FROM [subscriptions]



-- 4.	�������� �� ������ �����, ������� �������� ����� 
-- � ����������, ���������� ����� ���� ����� ���������.
SELECT [sb_book]
	,COUNT([sb_book]) AS [quantity]
FROM [subscriptions]
GROUP BY [sb_book]



-- 5.	��������, ������� ����� ��������� 
-- ���������������� � ����������.

-- !!! �� ������ ����, ��� �������� ��� �������� 
-- "���������������", ������ ��� � ������� �16 ���� �� ��
-- ����������� ������������ � ������� ������ 1-�� �����.
-- ����, �� ������� subscriptions, ������������ � id = 2,
-- ���� �� ����. ������� ����� ����� ���������

-- 1 ������ - ������� �� ������� �����������
SELECT COUNT([s_id]) AS [quantity]
FROM [subscribers]

-- 2 ������ - ������� �� ������� ��������
SELECT COUNT(DISTINCT [sb_subscriber]) AS [quantity]
FROM [subscriptions]



-- 6.	��������, ������� ����� ��� ��������� ���������� 
-- �����.
SELECT COUNT(sb_id) AS [quantity]
FROM [subscriptions]



-- 7.	��������, ������� ��������� ����� ����� � ����������.
SELECT COUNT(DISTINCT sb_subscriber)
FROM [subscriptions]



-- 8.	�������� ������ � ��������� ���� ������ ����� 
-- ��������.
SELECT [sb_subscriber]
	,MIN([sb_start]) AS [first_date]
	,MAX([sb_start]) AS [last_date]
FROM [subscriptions]
GROUP BY [sb_subscriber]



-- 9.	�������� ������ ������� � �������� ���������� 
-- ������� (�.�. �� -> ��).
SELECT [a_name]
FROM [authors]
ORDER BY [a_name] DESC 



-- 10.	�������� �����, ���������� ����������� ������� 
-- ������ �������� �� ����������.
SELECT [b_name]
	,[b_quantity]
FROM [books]
WHERE [b_quantity] < (
		SELECT AVG(CAST([b_quantity] AS FLOAT))
		FROM [books]
		)



-- 11.	�������� �������������� � ���� ������ ���� 
--�� ������ ��� ������ ���������� (������ ����� ������ 
--���������� ������� ��� ���� � ������ ������ ����� �� 
--31-� ������� (������������) ���� ����, ����� 
--���������� ������ ��������).

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



-- 12.	�������� ������������� ������ (������) ��������, 
--�������� � ���������� ������ ����� ����.

SELECT TOP 1 [sb_subscriber],
	COUNT([sb_id]) AS [book_quant]
FROM [subscriptions]
GROUP BY [sb_subscriber]
ORDER BY [book_quant] DESC



-- 13.	�������� �������������� ���� ������ �������� 
--���������, ������� � ��������-�� ������ ����� ����.

-- 1 ������� ���������� ������� - � ������� ������������

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

-- 2 ������� ���������� ������� - � ������� MAX

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



-- 14.	�������� ������������� ���������-�����������, 
-- �������� � ���������� ������ ����, ��� ����� ������ 
-- ��������.

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



-- 15.	��������, ������� � ������� ����������� ���� 
-- ���� � ����������.

SELECT AVG(CAST([b_quantity] AS FLOAT))
FROM [books]



-- 16.	�������� � ����, ������� � ������� ������� 
--�������� ��� ���������������� � ���������� (�������� 
--����������� ������� �������� �� ������ ���� ��������� 
--��������� ����� �� ������� ����).

SELECT AVG(CAST(DATEDIFF(day, [reg_date], CONVERT(DATE, GETDATE())) AS FLOAT))
FROM (
	SELECT [sb_subscriber]
		,MIN([sb_start]) AS [reg_date]
	FROM [subscriptions]
	GROUP BY [sb_subscriber]
	) AS [registrations]



-- 17.	��������, ������� ���� ���� ���������� � �� 
--���������� � ���������� (���� ������ ����������� 
--��������� ���������� ���� sb_is_active (�.�. �Y� � �N�), 
--� ��-��� �������� �������� �Y� � �N� ������ ���� 
--������������� � �Returned� � �Not returned�).

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