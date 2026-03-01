USE msdb;
GO

-- Create a new schedule
EXEC sp_add_schedule
    @schedule_name = N'Weekly ETL Schedule',
    @enabled = 1,
    @freq_type = 8,          -- Weekly
    @freq_interval = 1,      -- Every Monday
    @active_start_time = 020000, -- 02:00 AM
    @freq_recurrence_factor = 1
GO


