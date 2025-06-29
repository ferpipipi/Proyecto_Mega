-- ===============================================
-- JOB PARA FACTURACIÓN AUTOMÁTICA MENSUAL
-- ===============================================

USE msdb;
GO

-- Crear el job
EXEC dbo.sp_add_job
    @job_name = N'Facturación Automática Mensual';

-- Agregar paso del job
EXEC sp_add_jobstep
    @job_name = N'Facturación Automática Mensual',
    @step_name = N'Generar Facturas Automáticamente',
    @subsystem = N'TSQL',
    @database_name = N'PracticaMega',
    @command = N'EXEC sp_facturacion_automatica_completa;';

-- Programar para ejecutar el día 1 de cada mes a las 2:00 AM
EXEC dbo.sp_add_schedule
    @schedule_name = N'Mensual Día 1',
    @freq_type = 4, -- Mensual
    @freq_interval = 1, -- Día 1
    @freq_subday_type = 1,
    @active_start_time = 020000; -- 2:00 AM

-- Asociar schedule al job
EXEC sp_attach_schedule
    @job_name = N'Facturación Automática Mensual',
    @schedule_name = N'Mensual Día 1';

-- Agregar job al servidor
EXEC dbo.sp_add_jobserver
    @job_name = N'Facturación Automática Mensual';

PRINT '✅ Job de facturación automática creado - Se ejecutará el día 1 de cada mes a las 2:00 AM';