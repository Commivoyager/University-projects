-- ���������� ������� �����: 3, 7, 9, 11, 15, 16, 17

-- 1.	������� �������������, ����������� �������� ������ ��������� � ����������� ����������� � ������� �������� �� 
-- ����� ����, �� ������������ ������ ����� ��-�������, �� ������� ������� �������������, �.�. �� ����� � �������� ���� 
-- ���� �� ���� �����, ������� �� ������ ��� ������� �� ����������� ������� ����.

CREATE
	OR
ALTER VIEW [debtors_active_books_num]
AS
SELECT [s_id]
	,[s_name]
	,COUNT([sb_book]) AS [book_num]
FROM [subscribers]
JOIN [subscriptions] ON [subscribers].[s_id] = [subscriptions].[sb_subscriber]
JOIN (
	SELECT [sb_subscriber] AS [id]
	FROM [subscriptions]
	WHERE [sb_finish] < CONVERT(DATE, GETDATE())
		AND ([sb_is_active] = 'Y')
	GROUP BY [sb_subscriber]
	) AS [prepared_data] ON [subscribers].[s_id] = [prepared_data].[id]
WHERE [sb_is_active] = 'Y'
GROUP BY [s_id]
	,[s_name];

SELECT *
FROM [debtors_active_books_num];



-- 2.	������� ���������� �������������, ����������� �������� ������ ���� ���� � �� ������ (��� �������: ������ � 
-- �������� �����, ������ � ����� �����, ����������-��� ����� �������).
-- ��������� MS SQL �� ������������ �������� ��������������� ������������� �� ��������������, ���������� � 
-- SELECT-������� ������������ ������� (�� ������������), ������� ��������� ��������� ������� ������� � 
-- ��������� ������ � ��� �� ���� ���������.
-- �������� ������������ �������

CREATE TABLE [books_with_genres] (
	[book_name] NVARCHAR(150) NOT NULL
	,[genres] NVARCHAR(150)
	)

-- ������� �������

TRUNCATE TABLE [books_with_genres];

-- ������������� �������

INSERT INTO [books_with_genres] (
	[book_name]
	,[genres]
	)
SELECT [b_name] AS [book_name]
	,STRING_AGG([g_name], ', ') WITHIN
GROUP (
		ORDER BY [g_name] ASC
		) AS [genres]
FROM [books]
LEFT JOIN [m2m_books_genres] ON [books].[b_id] = [m2m_books_genres].[b_id]
LEFT JOIN [genres] ON [m2m_books_genres].[g_id] = [genres].[g_id]
GROUP BY [b_name];

-- ��� ��� �� ������� � ���������� ������������� ������ ���� ������ ��� �������, ������� �� ���������� 
-- ���������� ���������� ����� (� ������� ��� id), �� �������� ���������� � �������� ������ ���������
-- ������ ��������� ���������� �������
-- �������� ��������� ���������

DROP TRIGGER [upd_bks_w_gnrs_on_m2m_bks_gnrs_ins_del_upd];

DROP TRIGGER [upd_bks_w_gnrs_on_bks_ins];

DROP TRIGGER [upd_bks_w_gnrs_on_bks_upd];

DROP TRIGGER [upd_bks_w_gnrs_on_gnrs_upd];
GO

-- �������, ����������� �� �������, �������� � ���������� ������� � ������� ����� ���� � ������

CREATE TRIGGER [upd_bks_w_gnrs_on_m2m_bks_gnrs_ins_del_upd] ON [m2m_books_genres]
AFTER INSERT
	,DELETE
	,UPDATE
AS
DELETE
FROM [books_with_genres];

INSERT INTO [books_with_genres] (
	[book_name]
	,[genres]
	)
SELECT [b_name] AS [book_name]
	,STRING_AGG([g_name], ', ') WITHIN
GROUP (
		ORDER BY [g_name] ASC
		) AS [genres]
FROM [books]
LEFT JOIN [m2m_books_genres] ON [books].[b_id] = [m2m_books_genres].[b_id]
LEFT JOIN [genres] ON [m2m_books_genres].[g_id] = [genres].[g_id]
GROUP BY [books].[b_id]
	,[b_name]
GO

-- �������, ����������� �� ���������� ������� � ������� ����

CREATE TRIGGER [upd_bks_w_gnrs_on_bks_ins] ON [books]
AFTER INSERT
AS
INSERT [books_with_genres] (
	[book_name]
	,[genres]
	)
SELECT [b_name] AS [book_name]
	,STRING_AGG([g_name], ', ') WITHIN
GROUP (
		ORDER BY [g_name] ASC
		) AS [genres]
FROM [inserted]
LEFT JOIN [m2m_books_genres] ON [m2m_books_genres].[b_id] = [inserted].[b_id]
LEFT JOIN [genres] ON [m2m_books_genres].[g_id] = [genres].[g_id]
GROUP BY [inserted].[b_id]
	,[b_name]
GO

-- �������, ����������� �� ��������� ������� � ������� ����

CREATE TRIGGER [upd_bks_w_gnrs_on_bks_upd] ON [books]
AFTER UPDATE
AS
IF 
	UPDATE ([b_name])

BEGIN
	IF EXISTS (
			SELECT [inserted].[b_id]
			FROM [inserted]
			JOIN [deleted] ON [inserted].[b_id] = [deleted].[b_id]
			WHERE [deleted].[b_name] != [inserted].[b_name]
			)
	BEGIN
		DELETE
		FROM [books_with_genres];

		INSERT [books_with_genres] (
			[book_name]
			,[genres]
			)
		SELECT [b_name] AS [book_name]
			,STRING_AGG([g_name], ', ') WITHIN
		GROUP (
				ORDER BY [g_name] ASC
				) AS [genres]
		FROM [books]
		LEFT JOIN [m2m_books_genres] ON [books].[b_id] = [m2m_books_genres].[b_id]
		LEFT JOIN [genres] ON [m2m_books_genres].[g_id] = [genres].[g_id]
		GROUP BY [books].[b_id]
			,[b_name];

		PRINT '���������� ���������: �������� ������� �� ��������� ����� ����� � [books]';
	END
END
GO

-- �������, ����������� �� ��������� ������� � ������� ������

CREATE TRIGGER [upd_bks_w_gnrs_on_gnrs_upd] ON [genres]
AFTER UPDATE
AS
IF 
	UPDATE ([g_name])

BEGIN
	IF EXISTS (
			SELECT [inserted].[g_id]
			FROM [inserted]
			JOIN [deleted] ON [inserted].[g_id] = [deleted].[g_id]
			WHERE [deleted].[g_name] != [inserted].[g_name]
			)
	BEGIN
		DELETE
		FROM [books_with_genres];

		INSERT [books_with_genres] (
			[book_name]
			,[genres]
			)
		SELECT [b_name] AS [book_name]
			,STRING_AGG([g_name], ', ') WITHIN
		GROUP (
				ORDER BY [g_name] ASC
				) AS [genres]
		FROM [books]
		LEFT JOIN [m2m_books_genres] ON [books].[b_id] = [m2m_books_genres].[b_id]
		LEFT JOIN [genres] ON [m2m_books_genres].[g_id] = [genres].[g_id]
		GROUP BY [books].[b_id]
			,[b_name]

		PRINT '���������� ���������: �������� ������� �� ��������� ����� ����� � [genres]';
	END
END
GO



-- 4.	������� �������������, ����� ������� ���������� �������� ���������� � ���, ����� 
-- ��������� ����� ���� ������ �������� � ����� �� �����.

CREATE
	OR

ALTER VIEW [subscriptions_without_books]
	WITH SCHEMABINDING
AS
SELECT [sb_id]
	,[sb_subscriber]
	,[sb_start]
	,[sb_finish]
	,[sb_is_active]
FROM [dbo].[subscriptions]
--SELECT * FROM [subscriptions_without_books]



-- 5.	������� �������������, ������������ ��� ���������� �� ������� subscriptions, ���������� ���� �� ����� sb_start 
-- � sb_finish � ������ �����-��-�� �ͻ, ��� ��ͻ � ���� ������ � ���� ������ ������� �������� 
-- (�.�. ������������, �������� � �.�.)

CREATE
	OR
ALTER VIEW [subscriptions_week_day]
	WITH SCHEMABINDING
AS
SELECT [sb_id]
	,[sb_subscriber]
	,[sb_book]
	,FORMAT([sb_start], 'yyyy-MM-dd', 'ru-RU') + ' ' + FORMAT([sb_start], 'dddd', 'ru-RU') AS [sb_start]
	,FORMAT([sb_finish], 'yyyy-MM-dd', 'ru-RU') + ' ' + FORMAT([sb_finish], 'dddd', 'ru-RU') AS [sb_finish]
	,[sb_is_active]
FROM [dbo].[subscriptions]
--SELECT * FROM [subscriptions_week_day]



-- 6.	������� �������������, ����������� ���������� � ������, �������� ���� ����� � ������� ������� � ��� ���� 
-- ����������� ����������� ������ ����.

CREATE
	OR

ALTER VIEW [books_upper_case]
	WITH SCHEMABINDING
AS
SELECT [b_id]
	,UPPER([b_name]) AS [b_name]
	,[b_year]
	,[b_quantity]
FROM [dbo].[books];

-- �������� ��������� ���������
DROP TRIGGER [books_upper_case_upd];

DROP TRIGGER [books_upper_case_ins];
GO

CREATE TRIGGER [books_upper_case_upd] ON [books_upper_case]
INSTEAD OF UPDATE
AS
IF (
		UPDATE (b_id)
		)
BEGIN
	RAISERROR (
			'It is forbidden to update the primary key in view [books_upper_case_upd]'
			,16
			,1
			);

	ROLLBACK;
END
ELSE
BEGIN
	UPDATE [books]
	SET [b_name] = [inserted].[b_name]
		,[b_year] = [inserted].[b_year]
		,[b_quantity] = [inserted].[b_quantity]
	FROM [books]
	JOIN [inserted] ON [books].[b_id] = [inserted].[b_id];
END
GO

CREATE TRIGGER [books_upper_case_ins] ON [books_upper_case]
INSTEAD OF INSERT
AS
SET IDENTITY_INSERT [books] ON;

INSERT INTO [books] (
	[b_id]
	,[b_name]
	,[b_year]
	,[b_quantity]
	)
SELECT (
		CASE 
			WHEN [b_id] IS NULL
				OR [b_id] = 0
				THEN IDENT_CURRENT('books') + IDENT_INCR('books') + ROW_NUMBER() OVER (
						ORDER BY (
								SELECT 1
								)
						) - 1
			ELSE [b_id]
			END
		) AS [b_id]
	,[b_name]
	,[b_year]
	,[b_quantity]
FROM [inserted];

SET IDENTITY_INSERT [books] OFF;
GO



-- 8.	������� �������������, ����������� �� ������� m2m_books_authors ����������-������ (� ���������� ���� �
-- ������� ������� ������ ���������������) �������-���, � ��� ���� ����������� �������������� ������ � �������
-- m2m_books_authors (� ������ �������������� �������� ���� � ��� ������� � ����� ������� ������������ ������
-- � ����������� ��������� ���������� �����).

CREATE
	OR
ALTER VIEW [books_and_authors_with_text]
	WITH SCHEMABINDING
AS
SELECT [b_name]
	,[a_name]
FROM [dbo].[books]
JOIN [dbo].[m2m_books_authors] ON [dbo].[books].[b_id] = [dbo].[m2m_books_authors].[b_id]
JOIN [dbo].[authors] ON [dbo].[m2m_books_authors].[a_id] = [dbo].[authors].[a_id];

DROP TRIGGER [books_and_authors_with_text_ins];

DROP TRIGGER [books_and_authors_with_text_upd];

DROP TRIGGER [books_and_authors_with_text_del];
GO

-- ������� ��� ������� ������ ����� ������������� ������� [m2m_books_authors]
-- �������� ��� ������� ������, �������������� ����� ���� �������� (id �����, id ������),
-- ���� (�������� �����, ��� ������)

CREATE TRIGGER [books_and_authors_with_text_ins] ON [books_and_authors_with_text]
INSTEAD OF INSERT
AS
DECLARE @bad_records NVARCHAR(max);
DECLARE @msg NVARCHAR(max);

-- �������� ������� �������������� ��������

WITH [non_existent_names]
AS (
	SELECT [b_name]
		,[a_name]
	FROM [inserted]
	WHERE [b_name] IS NULL
		OR [a_name] IS NULL
		OR PATINDEX('%[^0-9]%', [a_name]) = 0
		AND PATINDEX('%[^0-9]%', [b_name]) > 0
		OR PATINDEX('%[^0-9]%', [a_name]) > 0
		-- AND PATINDEX('%[^0-9]%', [b_name]) > 0
		AND (
			[b_name] NOT IN (
				SELECT [b_name]
				FROM [books]
				)
			OR [a_name] NOT IN (
				SELECT [a_name]
				FROM [authors]
				)
			)
	)
	,[bad_info]
AS (
	SELECT STUFF((
				SELECT ', ([a_name]: ' + ISNULL([a_name], 'NULL') + '; [b_name]: ' + ISNULL([b_name], 'NULL') + ')'
				FROM [non_existent_names]
				FOR XML PATH('')
					,TYPE
				).value('.', 'nvarchar(max)'), 1, 2, '') AS [bad_text]
	)
SELECT @bad_records = [bad_text]
FROM [bad_info]

IF LEN(@bad_records) > 0
BEGIN
	SET @msg = CONCAT (
			'The following records are invalid: '
			,@bad_records
			);

	RAISERROR (
			@msg
			,16
			,1
			);

	ROLLBACK;
END;

-- ���������� �� ������ ������ � ����������� ��������, ������� ������������ ����� ������ (id �����, id ������)

WITH [inserted_id]
AS (
	SELECT [b_name]
		,[a_name]
	FROM [inserted]
	WHERE PATINDEX('%[^0-9]%', [b_name]) = 0
		AND PATINDEX('%[^0-9]%', [a_name]) = 0
	)
INSERT [m2m_books_authors] (
	[b_id]
	,[a_id]
	)
SELECT [b_name]
	,[a_name]
FROM [inserted_id];

-- ���������� �� ������ ������ � ����������� ��������, ������� ������������ ����� ������ (�������� �����, ��� ������)

WITH [inserted_names]
AS (
	SELECT [b_name]
		,[a_name]
	FROM [inserted]
	WHERE PATINDEX('%[^0-9]%', [a_name]) > 0
		AND [b_name] IN (
			SELECT [b_name]
			FROM [books]
			)
		AND [a_name] IN (
			SELECT [a_name]
			FROM [authors]
			)
	)
INSERT [m2m_books_authors] (
	[b_id]
	,[a_id]
	)
SELECT [b_min_id] AS [b_id]
	,[a_min_id] AS [a_id]
FROM (
	SELECT MIN([b_id]) AS [b_min_id]
		,[b_name]
	FROM [books]
	GROUP BY [b_name]
	) AS [books_min_id]
JOIN [inserted_names] ON [books_min_id].[b_name] = [inserted_names].[b_name]
JOIN (
	SELECT MIN([a_id]) AS [a_min_id]
		,[a_name]
	FROM [authors]
	GROUP BY [a_name]
	) AS [authors_min_id] ON [inserted_names].[a_name] = [authors_min_id].[a_name];
GO

-- ������� ��� �������� ������ ����� ������������� �������� [m2m_books_authors]. �������� ��� ������, �������������� 
-- ����� ������ ���� �������� (�������� �����, ��� ������). ��� �������� �������� �������� ��������� ������, ������� 
-- �� ������� "��������" � �������� � ���� ������������ MS SQL Server (��������� ������� deleted ������� �� ����, ��� 
-- ������� ���������� �������� => �������� �������������� �����).
--
-- �������������� ���������, ������ ������� ���������� ���, ���� � ����� �����

CREATE TRIGGER [books_and_authors_with_text_del] ON [books_and_authors_with_text]
INSTEAD OF DELETE
AS
WITH [all_coincidences]
AS (
	SELECT [books].[b_id]
		,[authors].[a_id]
		,[books].[b_name]
		,[authors].[a_name]
	FROM [books]
	JOIN [deleted] ON [books].[b_name] = [deleted].[b_name]
	JOIN [authors] ON [deleted].[a_name] = [authors].[a_name]
	)
	,[existing_links]
AS (
	SELECT ([m2m].[b_id]) AS [b_id]
		,([m2m].[a_id]) AS [a_id]
	FROM [all_coincidences] AS [all]
	JOIN [m2m_books_authors] AS [m2m] ON [all].[a_id] = [m2m].[a_id]
		AND [all].[b_id] = [m2m].[b_id]
	)
DELETE [m2m_books_authors]
FROM [m2m_books_authors]
JOIN [existing_links] ON [m2m_books_authors].[b_id] = [existing_links].[b_id]
	AND [m2m_books_authors].[a_id] = [existing_links].[a_id];
GO

/*
 ������� ��� ���������� ������ ����� ������������� �������� [m2m_books_authors]. �������� ��� ������, �������������� 
 ����� ������ ���� �������� (�������� �����, ��� ������). ��� �������� �������� �������� ��������� ������, ������� 
 �� ������� "��������" � �������� � ���� ������������ MS SQL Server 
 �� ���� � ���� �������� ����� ��������� ������� � ��������, ��� ��� � ���� ����, ��� � ������ ������ �� ��������� 
 ����������� ����������� ������ �� ������� [deleted] � ������� �� ������� [inserted] - ��� ���������� �����
 ������� ������, ������� ������ ���� ��������� � �������� �� ������, ������� ��������������

 ���� ����� �������� � ������������ ������, ��������������� �������: "������������ ������ � ����������� ��������� 
 ���������� �����", ������ ��� ��� �������� INSTEAD OF UPDATE �������� ������ ���� ����� �������� ���� �������
 [deleted] � [inserted], ���������� ���� ������������ ��� � ��������, ��� ����������� �� ������� [deleted], �����
 ������� ������ ���� ������� ����� ���� ��������: �����, � ������� �������� ���������, ������ ���������, �� �� 
 ����� � ���� �������� � ������� ������ id, � �������, � ������ ����� (b_id = n), ������������� ������ ������, ��� 
 � ������ �����, � ������� b_id = n+k > n - ����������, ����� �� ��� ������ ��������������� � ������ ������� �� 
 �������, �.�. �� id ������� 2-�� ������, �� ������ - 1-��.
 ������� ���������� ����� �������� ���:
	- ��������� ��� ������ ������� [deleted] �� �������� �� ��� ���������, ������� ����������� ��� �������� 
	��������
	- ����������� ��� ������ �� ������� [inserted] �� ���������, ������������ ��� �������� �������
*/

CREATE TRIGGER [books_and_authors_with_text_upd] ON [books_and_authors_with_text]
INSTEAD OF UPDATE
AS
WITH [all_coincidences]
AS (
	SELECT [books].[b_id]
		,[authors].[a_id]
		,[books].[b_name]
		,[authors].[a_name]
	FROM [books]
	JOIN [deleted] ON [books].[b_name] = [deleted].[b_name]
	JOIN [authors] ON [deleted].[a_name] = [authors].[a_name]
	)
	,[existing_links]
AS (
	SELECT ([m2m].[b_id]) AS [b_id]
		,([m2m].[a_id]) AS [a_id]
	FROM [all_coincidences] AS [all]
	JOIN [m2m_books_authors] AS [m2m] ON [all].[a_id] = [m2m].[a_id]
		AND [all].[b_id] = [m2m].[b_id]
	)
DELETE [m2m_books_authors]
FROM [m2m_books_authors]
JOIN [existing_links] ON [m2m_books_authors].[b_id] = [existing_links].[b_id]
	AND [m2m_books_authors].[a_id] = [existing_links].[a_id];

DECLARE @bad_records NVARCHAR(max);
DECLARE @msg NVARCHAR(max);

-- �������� ������� �������������� ��������
WITH [non_existent_names]
AS (
	SELECT [b_name]
		,[a_name]
	FROM [inserted]
	WHERE [b_name] IS NULL
		OR [a_name] IS NULL
		OR PATINDEX('%[^0-9]%', [a_name]) = 0
		AND PATINDEX('%[^0-9]%', [b_name]) > 0
		OR PATINDEX('%[^0-9]%', [a_name]) > 0
		-- AND PATINDEX('%[^0-9]%', [b_name]) > 0
		AND (
			[b_name] NOT IN (
				SELECT [b_name]
				FROM [books]
				)
			OR [a_name] NOT IN (
				SELECT [a_name]
				FROM [authors]
				)
			)
	)
	,[bad_info]
AS (
	SELECT STUFF((
				SELECT ', ([a_name]: ' + ISNULL([a_name], 'NULL') + '; [b_name]: ' + ISNULL([b_name], 'NULL') + ')'
				FROM [non_existent_names]
				FOR XML PATH('')
					,TYPE
				).value('.', 'nvarchar(max)'), 1, 2, '') AS [bad_text]
	)
SELECT @bad_records = [bad_text]
FROM [bad_info]

IF LEN(@bad_records) > 0
BEGIN
	SET @msg = CONCAT (
			'The following records are invalid: '
			,@bad_records
			);

	RAISERROR (
			@msg
			,16
			,1
			);

	ROLLBACK;
END;

-- ���������� �� ������ ������ � ����������� ��������, ������� ������������ ����� ������ (�������� �����, ��� ������)
WITH [inserted_names]
AS (
	SELECT [b_name]
		,[a_name]
	FROM [inserted]
	WHERE PATINDEX('%[^0-9]%', [a_name]) > 0
		AND [b_name] IN (
			SELECT [b_name]
			FROM [books]
			)
		AND [a_name] IN (
			SELECT [a_name]
			FROM [authors]
			)
	)
INSERT [m2m_books_authors] (
	[b_id]
	,[a_id]
	)
SELECT [b_min_id] AS [b_id]
	,[a_min_id] AS [a_id]
FROM (
	SELECT MIN([b_id]) AS [b_min_id]
		,[b_name]
	FROM [books]
	GROUP BY [b_name]
	) AS [books_min_id]
JOIN [inserted_names] ON [books_min_id].[b_name] = [inserted_names].[b_name]
JOIN (
	SELECT MIN([a_id]) AS [a_min_id]
		,[a_name]
	FROM [authors]
	GROUP BY [a_name]
	) AS [authors_min_id] ON [inserted_names].[a_name] = [authors_min_id].[a_name];
GO



-- 10.	�������������� ����� ���� ������ ����� �������, ����� ������� �authors� ���-���� ���������� ���������� � ���� ��������� ������ 
-- ����� ������ ��������.

ALTER TABLE [authors] ADD [a_last_sub] DATE NULL DEFAULT NULL;

UPDATE [authors]
SET [a_last_sub] = (
		SELECT MAX([sb_start]) AS [new_sub_date]
		FROM [subscriptions]
		JOIN [m2m_books_authors] AS [m2m] ON [sb_book] = [b_id]
		--JOIN [authors]	
		--	ON [m2m].[a_id] = [authors].[a_id]
		WHERE [a_id] = [authors].[a_id]
		);

CREATE TRIGGER [athrs_last_sub_ins_upd_del] ON [subscriptions]
AFTER INSERT
	,UPDATE
	,DELETE
AS
UPDATE [authors]
SET [a_last_sub] = [last_sub_date]
FROM (
	SELECT MAX([sb_start]) AS [last_sub_date]
		,[a_id]
	FROM [subscriptions]
	JOIN [m2m_books_authors] ON [sb_book] = [b_id]
	GROUP BY [a_id]
	) AS [temp]
WHERE [authors].[a_id] = [temp].[a_id]
GO



-- 12.	�������������� ����� ���� ������ ����� �������, ����� ������� �subscribers� ������� ���������� � ���, ������� ��� �������� 
--���� � ���������� ����� (���� ������� ������ ������������������ ������ ���, ����� �������� ������� �����; ���������� �������� 
--����� �������� �� �������������).

ALTER TABLE [subscribers] ADD [sbs_counter] INT NOT NULL DEFAULT 0;

UPDATE [subscribers]
SET [sbs_counter] = [counter]
FROM [subscribers]
JOIN (
	SELECT [sb_subscriber]
		,COUNT([sb_id]) AS [counter]
	FROM [subscriptions]
	GROUP BY [sb_subscriber]
	) AS [sbscr_inf] ON [s_id] = [sb_subscriber];

CREATE TRIGGER [new_sbs_counter_on_subscriptions_ins] ON [subscriptions]
AFTER INSERT
AS
UPDATE [subscribers]
SET [sbs_counter] = [sbs_counter] + [new_sbs_num]
FROM [subscribers]
JOIN (
	SELECT [sb_subscriber]
		,COUNT([sb_id]) AS [new_sbs_num]
	FROM [inserted]
	GROUP BY [sb_subscriber]
	) AS [sbscr_inf] ON [s_id] = [sb_subscriber]
GO



-- 13.	������� �������, �� ����������� �������� � ���� ������ ���������� � ������ �����, ���� ����������� ���� �� ���� �� �������:
-- �	���� ������ ��� �������� ���������� �� �����������;
-- �	�������� ���� �� ��������� ������� ����� 100 ����;
-- �	���������� ������� ����� ������ ������ � �������� ����� ��� ����.

DROP TRIGGER [subscriptions_control_ins]
GO

CREATE TRIGGER [subscriptions_control_ins] ON [subscriptions]
AFTER INSERT
	,UPDATE
AS
DECLARE @bad_records NVARCHAR(max);
DECLARE @msg NVARCHAR(max);

SELECT @bad_records = STUFF((
			SELECT ', ' + '[sb_id]: ' + CAST([sb_id] AS NVARCHAR) + ' (' + CASE 
					WHEN DATENAME(WEEKDAY, [sb_start]) = 'Sunday'
						AND DATENAME(WEEKDAY, [sb_finish]) = 'Sunday'
						THEN '[sb_start]: ' + CAST([sb_start] AS NVARCHAR) + '; [sb_finish]: ' + CAST([sb_finish] AS NVARCHAR)
					WHEN DATENAME(WEEKDAY, [sb_start]) = 'Sunday'
						THEN '[sb_start]: ' + CAST([sb_start] AS NVARCHAR)
					ELSE '[sb_finish]: ' + CAST([sb_finish] AS NVARCHAR)
					END + ')'
			FROM [inserted]
			WHERE DATENAME(WEEKDAY, [sb_start]) = 'Sunday'
				OR DATENAME(WEEKDAY, [sb_finish]) = 'Sunday'
			ORDER BY [sb_id]
			FOR XML PATH('')
				,TYPE
			).value('.', 'nvarchar(max)'), 1, 2, '');

IF LEN(@bad_records) > 0
BEGIN
	SET @msg = CONCAT (
			'The following subscriptions'' start or finish dates are fall on Sunday (forbidden): '
			,@bad_records
			);

	RAISERROR (
			@msg
			,16
			,1
			);

	ROLLBACK TRANSACTION;

	RETURN;
END;

SELECT @bad_records = STUFF((
			SELECT ', ' + CAST([sb_id] AS NVARCHAR) + ' ( user id: ' + CAST([sb_subscriber] AS NVARCHAR) + ')'
			FROM [inserted] AS [ins]
			WHERE (
					SELECT COUNT([sb_id])
					FROM [subscriptions]
					WHERE [subscriptions].[sb_subscriber] = [ins].[sb_subscriber]
						AND [sb_start] >= DATEADD(MONTH, - 6, [ins].[sb_start])
						AND [sb_start] <= [ins].[sb_start]
					) > 100
			ORDER BY [sb_id]
			FOR XML PATH('')
				,TYPE
			).value('.', 'nvarchar(max)'), 1, 2, '');

IF LEN(@bad_records) > 0
BEGIN
	SET @msg = CONCAT (
			'The following subscriptions'' are incorrect bacause user got more than 100 books in last 6 month (forbidden): '
			,@bad_records
			);

	RAISERROR (
			@msg
			,16
			,1
			);

	ROLLBACK TRANSACTION;

	RETURN;
END;

SELECT @bad_records = STUFF((
			SELECT ', ' + CAST([sb_id] AS NVARCHAR) + ' ( start date: ' + CAST([sb_start] AS NVARCHAR) + ' ; finish date: ' + CAST([sb_finish] AS NVARCHAR) + ')'
			FROM [inserted]
			WHERE DATEADD(day, 3, [sb_start]) > [sb_finish]
			ORDER BY [sb_id]
			FOR XML PATH('')
				,TYPE
			).value('.', 'nvarchar(max)'), 1, 2, '');

IF LEN(@bad_records) > 0
BEGIN
	SET @msg = CONCAT (
			'The following subscriptions'' are incorrect bacause interval between finish and start dates less than 3 days (forbidden): '
			,@bad_records
			);

	RAISERROR (
			@msg
			,16
			,1
			);

	ROLLBACK TRANSACTION;

	RETURN;
END;
GO



-- 14.	������� �������, �� ����������� ������ ����� ��������, � �������� �� ����� ����-����� ���� � ����� ����, 
-- ��� �������, ��� ��������� �����, ���������� �� ������-�� ���� �������� ��� ����, ���������� ����� ������ ������.

DROP TRIGGER [sbs_cntrl_5_time_less_month_ins]
GO

CREATE TRIGGER [sbs_cntrl_5_time_less_month_ins] ON [subscriptions]
INSTEAD OF INSERT
AS
DECLARE @bad_records NVARCHAR(max);
DECLARE @msg NVARCHAR(max);

SELECT @bad_records = STUFF((
			SELECT ', ' + [data]
			FROM (
				SELECT CONCAT (
						'(id='
						,[s_id]
						,', '
						,[s_name]
						,', books='
						,COUNT([sb_book])
						,')'
						) AS [data]
				FROM [subscribers]
				JOIN [inserted] AS [ins] ON [s_id] = [sb_subscriber]
				WHERE [s_id] IN (
						SELECT [sb_subscriber] AS [s_id]
						FROM (
							SELECT [sb_subscriber]
								,COUNT(sb_id) AS [sb_num]
								,SUM(DATEDIFF(DAY, GETDATE(), [sb_finish])) AS [remaining_days]
							FROM (
								SELECT *
								FROM [subscriptions]
								
								UNION ALL
								
								SELECT *
								FROM [inserted]
								) AS [all_sbs]
							WHERE [sb_is_active] = 'Y'
							GROUP BY [sb_subscriber]
							) AS [active_sbs]
						WHERE [sb_num] >= 5
							AND [remaining_days] < 30
						)
				GROUP BY [s_id]
					,[s_name]
				) AS [prepared_data]
			FOR XML PATH('')
				,TYPE
			).value('.', 'nvarchar(max)'), 1, 2, '');

IF LEN(@bad_records) > 0
BEGIN
	SET @msg = CONCAT (
			'The following readers have more books than allowed (5 allowed and the total time remaining before the return of all books is less than one month.): '
			,@bad_records
			);

	RAISERROR (
			@msg
			,16
			,1
			);

	ROLLBACK TRANSACTION;

	RETURN;
END

SET IDENTITY_INSERT [subscriptions] ON;

INSERT INTO [subscriptions] (
	[sb_id]
	,[sb_subscriber]
	,[sb_book]
	,[sb_start]
	,[sb_finish]
	,[sb_is_active]
	)
SELECT (
		CASE 
			WHEN [sb_id] IS NULL
				OR [sb_id] = 0
				THEN IDENT_CURRENT('subscriptions') + IDENT_INCR('subscriptions') + ROW_NUMBER() OVER (
						ORDER BY (
								SELECT 1
								)
						) - 1
			ELSE [sb_id]
			END
		) AS [sb_id]
	,[sb_subscriber]
	,[sb_book]
	,[sb_start]
	,[sb_finish]
	,[sb_is_active]
FROM [inserted];

SET IDENTITY_INSERT [subscriptions] OFF;
GO



 -- ��������� ��� INSTEAD OF DELETE �������� �� ������ �8
/*
 ����� ����������� �������� ���� �������, ���� ������� ������������� ���������� ��������� ��������� �� �������, 
 ����� ������� ��� DELETE �������� ������������� ������� "� ������ �������������� �������� ���� � ��� ������� 
 � ����� ������� ��������-���� ������ � ����������� ��������� ���������� �����" - ������ ��� ����� ���� �����,
 � ������� �������� ���������, ������ ���������, �� �� ����� � ���� �������� � ������� ������ id, � �������, �
 ������ ����� (b_id = n), ������������� ������ ������, ��� � ������ �����, � ������� b_id = n+k > n - ����������,
 ����� �� ��� ������ ��������������� � ������ ������� �� �������, �.�. �� id ������� 2-�� ������, �� ������ - 1-��

 � ����� � ������ �������������� ����� ��������� ���������� (��� ��������� ������� ������) ��������.
 ����� ����� ��������� �� �������:
 ��������, ���� � ������� � �������� ��� ������ � ��������� ���������� ������ (������ ��� �������, 
 ���� ����� ������ ��������� � ��� ����)
 '�.�. ������', � �������� a_id = 1
 '�.�. ������', � �������� a_id = 2
 ��������, � ����� ����� ������ ����, ��� ���������� � ������� ����� m2m_books_authors.

 �� � INSTEAD OF DELETE �������� ��� ����� ������������� books_and_authors_with_text �� ��������� 
 ��������� ���������� , ��������, ����� ������:
	DELETE
	FROM [books_and_authors_with_text]
	WHERE [a_name] = '�.�. ������'
		OR [a_name] = '�.�. ������'
		AND [b_name] = '�����_������_�������_�_id_=_2'
 
 ��� ������ ���������� �������� ������� �������:
	��� ��� ���� ������� [a_name] = '�.�. ������' - ���� ������� ��� ������, � ������� ��� ������ - 
	'�.�. ������', �� ������������� ������ ����������� (� ��� ������� ����������� id = 1).
	� ����� ����� ������� ������, ��������������� �������: 
		[a_name] = '�.�. ������' AND [b_name] = '�����_������_�������_�_id_=_2'
		�� ���� ������� ������ ���� �����, ��� ��������� ������, ��� ����� ��� �� ����������� ����� 
		���� ���� ������� � ������ '�.�. ������' - ��� ���� ������ � ������ � id = 2.

 ��� ����������:
	�������� � ���, ��� ���������� �� �������� �������� ������ ����� ������� [deleted]. � ���� � �������
	DELETE ��� ���� ������� [a_name] = '�.�. ������', �� � ������� [delete] � �������� �� "������"
	��������� ��� ������, � ������� ������ ����� '�.�. ������'. ������� ������� �� ��������� �������
	����������, ��� ������-�� ���� ��� ������� ����� '�����_������_�������_�_id_=_2' - �� ������� [delete]
	������ ���� ������� ��� ������ � ����� �������.

	��������� �������:
		- ������� ��� ������ � ����� �������.
		�����:
			�������� �������, ������ � ������ '�����_������_�������_�_id_=_2' � ����� ������ ��������.
		������:
			�� ������������� ������� ������� "������������ ������ � ����������� ��������� ���������� �����",
			������ ��� ���� � ������ � id=2 ���� � ������ �����, �� ��� ���� ��������, ���� ��� 
			�� ��������������.
		- ������� ������ � ���������� id
		�����:
			� �����-�� ������� ���� ������ ������������� ������� ������� ������������ ������ "������������ 
			������ � ����������� ��������� ���������� �����".
		������:
			������ � ������ '�����_������_�������_�_id_=_2' �� �������� (����� �� � ������� [deleted]
			��� ���������� ���������). �� ����� �������� ���� ������, � ������� id ������ ����������� (��
			���� id = 1) � �� ��������� ����� �� ��������. �� ���� ������ ���������� �� ���������.

 ��� ����� �����������:
	��������� ������, ���������������� ������� "������������ ������ � ����������� ��������� ���������� �����" 
	�� ����� �� ����� �������� �� ����� ���������. ��������� � INSERT �������� ��� ������� ���� ������ (�� 
	���� ��������� ��������, ��� ��� �����������, �������), �� ����� ������ ������, � ������� ����� ��������� 
	��� ������, � ������� ���� ����� ������������ ��������. � ��, ��� ����� ���� ���������� ������� ��������
	��� ������� ������ ������ �� ������� ����� ����������� ����

CREATE TRIGGER [books_and_authors_with_text_del] ON [books_and_authors_with_text]
INSTEAD OF DELETE
AS
WITH [deleted_id]
AS (
	SELECT [b_min_id] AS [b_id]
		,[a_min_id] AS [a_id]
	FROM (
		SELECT MIN([books].[b_id]) AS [b_min_id]
			,[b_name]
		FROM [books]
		JOIN [m2m_books_authors] ON [books].[b_id] = [m2m_books_authors].[b_id]
		GROUP BY [b_name]
		) AS [books_min_id]
	JOIN [deleted] ON [books_min_id].[b_name] = [deleted].[b_name]
	JOIN (
		SELECT MIN([authors].[a_id]) AS [a_min_id]
			,[a_name]
		FROM [authors]
		JOIN [m2m_books_authors] ON [authors].[a_id] = [m2m_books_authors].[a_id]
		GROUP BY [a_name]
		) AS [authors_min_id] ON [deleted].[a_name] = [authors_min_id].[a_name]
	)
DELETE [m2m_books_authors]
FROM [m2m_books_authors]
JOIN [deleted_id] ON [m2m_books_authors].[b_id] = [deleted_id].[b_id]
	AND [m2m_books_authors].[a_id] = [deleted_id].[a_id];
GO

CREATE TRIGGER [books_and_authors_with_text_del]
ON [books_and_authors_with_text]
INSTEAD OF DELETE
AS
	WITH 
	[all_coincidences]
	AS(
		SELECT [books].[b_id],
			[authors].[a_id],
			[books].[b_name],
			[authors].[a_name]
		FROM
		[books]
		JOIN
		[deleted]
			ON [books].[b_name] = [deleted].[b_name]
		JOIN 
		[authors]
			ON [deleted].[a_name] = [authors].[a_name]
	),
	[existing_links] AS
	(
		SELECT
			([m2m].[b_id]) AS [b_id],
			([m2m].[a_id]) AS [a_id]
		FROM [all_coincidences] AS [all]
		JOIN [m2m_books_authors] AS [m2m]
			ON [all].[a_id] = [m2m].[a_id]
			AND [all].[b_id] = [m2m].[b_id]
	)
	DELETE [m2m_books_authors]
		FROM [m2m_books_authors]
		JOIN [existing_links] ON [m2m_books_authors].[b_id] = [existing_links].[b_id]
			AND [m2m_books_authors].[a_id] = [existing_links].[a_id];
GO
 */
