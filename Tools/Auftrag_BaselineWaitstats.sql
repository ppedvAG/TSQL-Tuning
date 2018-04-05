USE [master]
GO

/****** Object:  Database [baselinedata]    Script Date: 07.02.2013 09:09:03 ******/
CREATE DATABASE [baselinedata]
GO

use [Baselinedata]


IF NOT EXISTS ( SELECT  
                FROM    [sys].[tables]
                WHERE   [name] = N'WaitStats'
                        AND [type] = N'U' ) 
    CREATE TABLE [dbo].[WaitStats]
        (
          [RowNum] [BIGINT] IDENTITY(1, 1) ,
          [CaptureDate] [DATETIME] ,
          [WaitType] [NVARCHAR](120) ,
          [Wait_S] [DECIMAL](14, 2) ,
          [Resource_S] [DECIMAL](14, 2) ,
          [Signal_S] [DECIMAL](14, 2) ,
          [WaitCount] [BIGINT] ,
          [Percentage] [DECIMAL](4, 2) ,
          [AvgWait_S] [DECIMAL](14, 2) ,
          [AvgRes_S] [DECIMAL](14, 2) ,
          [AvgSig_S] [DECIMAL](14, 2)
        );
GO
-------------------------

USE [msdb]
GO

/****** Object:  Job [Waitstats]    Script Date: 07.02.2013 09:08:26 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 07.02.2013 09:08:26 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Waitstats', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Waitstats', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'EARTH\Administrator', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1]    Script Date: 07.02.2013 09:08:27 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE [Baselinedata];
GO

INSERT  INTO dbo.WaitStats
        ( [WaitType]
         )
VALUES  ( ''Wait Statistics for '' + CAST(GETDATE() AS NVARCHAR(19))
         );

INSERT  INTO dbo.WaitStats
        ( [CaptureDate] ,
          [WaitType] ,
          [Wait_S] ,
          [Resource_S] ,
          [Signal_S] ,
          [WaitCount] ,
          [Percentage] ,
          [AvgWait_S] ,
          [AvgRes_S] ,
          [AvgSig_S] 
         )
        EXEC
            ( ''
      WITH [Waits] AS
         (SELECT
            [wait_type],
            [wait_time_ms] / 1000.0 AS [WaitS],
            ([wait_time_ms] - [signal_wait_time_ms]) / 1000.0 AS [ResourceS],
            [signal_wait_time_ms] / 1000.0 AS [SignalS],
            [waiting_tasks_count] AS [WaitCount],
            100.0 * [wait_time_ms] / SUM ([wait_time_ms]) OVER() AS [Percentage],
            ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC) AS [RowNum]
         FROM sys.dm_os_wait_stats
         WHERE [wait_type] NOT IN (
            N''''CLR_SEMAPHORE'''',   N''''LAZYWRITER_SLEEP'''',
            N''''RESOURCE_QUEUE'''',  N''''SQLTRACE_BUFFER_FLUSH'''',
            N''''SLEEP_TASK'''',      N''''SLEEP_SYSTEMTASK'''',
            N''''WAITFOR'''',         N''''HADR_FILESTREAM_IOMGR_IOCOMPLETION'''',
            N''''CHECKPOINT_QUEUE'''', N''''REQUEST_FOR_DEADLOCK_SEARCH'''',
            N''''XE_TIMER_EVENT'''',   N''''XE_DISPATCHER_JOIN'''',
            N''''LOGMGR_QUEUE'''',     N''''FT_IFTS_SCHEDULER_IDLE_WAIT'''',
            N''''BROKER_TASK_STOP'''', N''''CLR_MANUAL_EVENT'''',
            N''''CLR_AUTO_EVENT'''',   N''''DISPATCHER_QUEUE_SEMAPHORE'''',
            N''''TRACEWRITE'''',       N''''XE_DISPATCHER_WAIT'''',
            N''''BROKER_TO_FLUSH'''',  N''''BROKER_EVENTHANDLER'''',
            N''''FT_IFTSHC_MUTEX'''',  N''''SQLTRACE_INCREMENTAL_FLUSH_SLEEP'''',
            N''''DIRTY_PAGE_POLL'''')
         )
      SELECT
         GETDATE(),
         [W1].[wait_type] AS [WaitType], 
         CAST ([W1].[WaitS] AS DECIMAL(14, 2)) AS [Wait_S],
         CAST ([W1].[ResourceS] AS DECIMAL(14, 2)) AS [Resource_S],
         CAST ([W1].[SignalS] AS DECIMAL(14, 2)) AS [Signal_S],
         [W1].[WaitCount] AS [WaitCount],
         CAST ([W1].[Percentage] AS DECIMAL(4, 2)) AS [Percentage],
         CAST (([W1].[WaitS] / [W1].[WaitCount]) AS DECIMAL (14, 4)) AS [AvgWait_S],
         CAST (([W1].[ResourceS] / [W1].[WaitCount]) AS DECIMAL (14, 4)) AS [AvgRes_S],
         CAST (([W1].[SignalS] / [W1].[WaitCount]) AS DECIMAL (14, 4)) AS [AvgSig_S]
      FROM [Waits] AS [W1]
      INNER JOIN [Waits] AS [W2]
         ON [W2].[RowNum] <= [W1].[RowNum]
      GROUP BY [W1].[RowNum], [W1].[wait_type], [W1].[WaitS], 
         [W1].[ResourceS], [W1].[SignalS], [W1].[WaitCount], [W1].[Percentage]
      HAVING SUM ([W2].[Percentage]) - [W1].[Percentage] < 95;''
            );
GO

', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'5 min', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=5, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20130207, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'68219913-3bc6-4163-9631-344310013a52'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


