DROP PROC IF EXISTS [log].[InsertLogExecucaoDetalhe]
go

create proc [log].[InsertLogExecucaoDetalhe] (@id int output,@idlog int, @objeto varchar(200) = null,@descricao varchar(300) = null)
as
begin

	begin try

	if (@id is null) or (@id = 0)
	begin
		insert into log.LogExecucaoDetalhe 
		(
			idLog
			,NomeObjeto
			,Descricao
			,DataInicio
			,Usuario
		)
		values 
		(
			@idlog
			,@objeto
			,@descricao
			,getdate()
			,suser_name()
		)

		set @id = (select IDENT_CURRENT('log.LogExecucaoDetalhe'))

		return @id
	end
	else
	begin
		declare @final as datetime2 = getdate()

		update log.LogExecucaoDetalhe 
		set
			DataFim = @final
			, Tempo = convert(time,dateadd(ss,datediff(ss,DataInicio,@final),0))
		where
			id = @id

		return select @id = 0
	end

	end try
	
	begin catch
		  declare @errormessage nvarchar(4000);
		  declare @errorseverity int;
		  declare @errorstate int;

		  select @errormessage  = error_message(),
			     @errorseverity = error_severity(),
			     @errorstate    = error_state();

		  raiserror (@errormessage, @errorseverity, @errorstate);
	end catch

end

