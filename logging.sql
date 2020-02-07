/*
	Create table for the application log
*/
if not(exists(
	select * from information_schema.tables 
	where table_schema = 'dbo' and table_name = 'AuditApplog'
	)
)
begin
    create table dbo.AuditApplog (
		[LogID] int identity(1,1) NOT NULL,
		[LogDate] datetime2 NOT NULL,
		[Context] varchar(100) NULL, 
		[Message] varchar(max) NULL,
		constraint PK_AuditApplog_LogID primary key clustered ([LogID])
	);
end;
go


/*
	Create proc to insert into application log
*/
if object_id('dbo.usp_LogItem') is null
	exec ('create procedure dbo.usp_LogItem as return 0;')
go

alter procedure dbo.usp_LogItem (
	@Message	varchar(max),
	@Context	varchar(128) = null
)
as
begin
	/*
		This script inserts a LogItem into the log table.

		Parameter explanations:
		@Message	The message to be logged
		@Context	The context of the message, such as the name of the calling stored procedure

		Changes:
		2017-05-29	jsl		Initial version

	*/

	-- Don't return row-count information, save network overhead
	set nocount on;

	insert into dbo.AuditApplog ([LogDate], [Context], [Message])
	select sysdatetime(), @Context, @Message;

	declare @env char(3) --= dbo.fn_GetEnvironmentDetail('environment', default)

	-- only print when environment != PRD
	if not(@env = 'PRD')
		print convert(varchar(50), sysdatetime()) + ' - ' + isnull(@Context, '') + ' - ' + isnull(@Message, '');

end;
