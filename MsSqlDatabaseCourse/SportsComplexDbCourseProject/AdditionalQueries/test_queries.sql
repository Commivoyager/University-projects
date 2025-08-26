
--SELECT * FROM [calendar];

DECLARE @curr_date DATE = GETDATE(),
	@next_date DATE;
SET @next_date = DATEADD(MONTH, 2, @curr_date);

EXECUTE dbo.GENERATE_SCHEDULES_FOR_ALL_PATTERNS
	@start_date = @curr_date,
	@end_date = @next_date;


SELECT * FROM [schedule_item]
--SELECT * FROM [schedule_view]

INSERT INTO [client_discount](
	[cdisc_procent],
	[cdisc_date_start],
	[cdisc_date_end],
	[cdisc_client]
)
VALUES 
(
	15.5,
	'2025-06-01',
	'2024-05-01',
	1
)

