-- ��������
EXEC msdb.dbo.sp_delete_job @job_name = N'Monthly_Maintain_Schedule';

-- 1. �������� �������
EXEC msdb.dbo.sp_add_job
    @job_name = N'Monthly_Maintain_Schedule';

-- 2. ���������� ����
EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Monthly_Maintain_Schedule',
    @step_name = N'RunProcedure',
    @subsystem = N'TSQL',
    @database_name = N'sport_complex_db',
    @command = N'EXEC dbo.MAINTAIN_AND_REGENERATE_SCHEDULE;';

-- 3. �������� ���������� (��� � �����, ������ 1 �����)
EXEC msdb.dbo.sp_add_schedule
    @schedule_name = N'MonthlySchedule',
    @freq_type = 16,                -- Monthly
    @freq_interval = 1,            -- 1st day of the month
    @freq_recurrence_factor = 1,   -- Every 1 month
    @active_start_time = 020000;   -- 02:00 AM

-- 4. �������� ���������� � �������
EXEC msdb.dbo.sp_attach_schedule
    @job_name = N'Monthly_Maintain_Schedule',
    @schedule_name = N'MonthlySchedule';

-- 5. �������� ������� � �������
EXEC msdb.dbo.sp_add_jobserver
    @job_name = N'Monthly_Maintain_Schedule';
