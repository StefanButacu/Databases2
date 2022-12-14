USE [SGBD-Lab3]
GO
/****** Object:  StoredProcedure [dbo].[insert_full_rollback]    Script Date: 4/18/2022 9:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER   PROCEDURE [dbo].[insert_full_rollback]
@nume_medic varchar(20),
@vechime int, 
@specializare varchar(15),
@varsta int,
@nume_pacient varchar(20),
@cnp varchar(15),
@data_consult DATE,
@pret int
AS
BEGIN

	BEGIN TRAN
		declare @error_medic varchar(100);
		set @error_medic = dbo.Valideaza_medic(@nume_medic,@vechime,@specializare);
		if len(@error_medic) = 0 BEGIN 

			INSERT INTO Medici(nume, vechime,specializare) VALUES (@nume_medic, @vechime, @specializare)
		
			DECLARE @medic_id AS INT
			SET @medic_id = @@IDENTITY
			SELECT FORMATMESSAGE('AM INSERAT  Medicul(%i, %s, %i, %s',@medic_id, @nume_medic, @vechime, @specializare) AS ResultM;  

			declare @error_pacient varchar(100);
			set @error_pacient = dbo.Valideaza_pacient(@varsta, @nume_pacient, @cnp);

			if len(@error_pacient) = 0 BEGIN 
				INSERT INTO Pacienti(varsta, nume, cnp) VALUES (@varsta, @nume_pacient, @cnp)
				DECLARE @pacient_id AS INT
				SET @pacient_id = @@IDENTITY
				print @pacient_id
				SELECT FORMATMESSAGE('AM INSERAT  Pacientul(%i, %s, %s',@pacient_id, @nume_pacient, @cnp) AS ResultP;  

				declare @error_consultatie varchar(100);
				set @error_consultatie = dbo.Valideaza_consulatie(@medic_id, @pacient_id, @data_consult, @pret);
				if len(@error_consultatie) = 0 BEGIN 
					INSERT INTO Consultatii(medic_id, pacient_id, data_consult, pret) VALUES(@medic_id, @pacient_id, @data_consult, @pret)
					SELECT FORMATMESSAGE('AM INSERAT  Consulatatia(%i,%i, %s, %i', @medic_id, @pacient_id, CAST(@data_consult AS VARCHAR), @pret) AS ResultC;  
			
			/* PRINT 'AM INSERAT CONSULTATIA '+ CAST(@medic_id AS VARCHAR) + ' ' + CAST(@pacient_id as VARCHAR) +' '+  CAST(@data_consult AS VARCHAR)
			+' ' + CAST(@pret as varchar)
			*/
				COMMIT TRAN
				END 
				ELSE BEGIN
					SELECT FORMATMESSAGE('AM ESUAT SA INSEREZ CONSULTATIA(%i,%i,%s,%i) din cauza %s', @medic_id, @pacient_id, CAST(@data_consult as VARCHAR),  @pret, @error_consultatie) AS ResultC
					ROLLBACK TRAN
				END
			
			END
			ELSE BEGIN 
				SELECT FORMATMESSAGE('AM ESUAT SA INSEREZ Pacientul(%i, %s, %s',@pacient_id, @nume_pacient, @cnp) AS ResultP;  
				ROLLBACK TRAN
			END
		END 
		ELSE BEGIN 
			SELECT FORMATMESSAGE('AM ESUAT SA inserez  Medicul(%i, %s, %i, %s',@medic_id, @nume_medic, @vechime, @specializare) AS Result;  
			ROLLBACK TRAN
		END

END
