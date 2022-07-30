
USE [SGBD-Lab3]
GO


SET IMPLICIT_TRANSACTIONS OFF 
GO

CREATE OR ALTER PROCEDURE insert_partial_rollback
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
		SAVE TRANSACTION enter

		declare @error_medic varchar(100);
		set @error_medic = dbo.Valideaza_medic(@nume_medic,@vechime,@specializare);
		if len(@error_medic) = 0 BEGIN 

			INSERT INTO Medici(nume, vechime,specializare) VALUES (@nume_medic, @vechime, @specializare)
		
			DECLARE @medic_id AS INT
			SET @medic_id = @@IDENTITY
			SELECT FORMATMESSAGE('AM INSERAT  Medicul(%i, %s, %i, %s',@medic_id, @nume_medic, @vechime, @specializare) AS ResultM;  
			SAVE TRANSACTION medic_inserat


			declare @error_pacient varchar(100);
			set @error_pacient = dbo.Valideaza_pacient(@varsta, @nume_pacient, @cnp);

			if len(@error_pacient) = 0 BEGIN 
				INSERT INTO Pacienti(varsta, nume, cnp) VALUES (@varsta, @nume_pacient, @cnp)
				DECLARE @pacient_id AS INT
				SET @pacient_id = @@IDENTITY
				SELECT FORMATMESSAGE('AM INSERAT  Pacientul(%i, %s, %s',@pacient_id, @nume_pacient, @cnp) AS ResultP;  
				SAVE TRANSACTION pacient_inserat


				declare @error_consultatie varchar(100);
				set @error_consultatie = dbo.Valideaza_consulatie(@medic_id, @pacient_id, @data_consult, @pret);
				if len(@error_consultatie) = 0 BEGIN 
					INSERT INTO Consultatii(medic_id, pacient_id, data_consult, pret) VALUES(@medic_id, @pacient_id, @data_consult, @pret)
					SELECT FORMATMESSAGE('AM INSERAT  Consulatatia(%i,%i, %s, %i', @medic_id, @pacient_id, CAST(@data_consult AS VARCHAR), @pret) AS ResultC;  
			
					SAVE TRANSACTION consultatie_inserata
			/* PRINT 'AM INSERAT CONSULTATIA '+ CAST(@medic_id AS VARCHAR) + ' ' + CAST(@pacient_id as VARCHAR) +' '+  CAST(@data_consult AS VARCHAR)
			+' ' + CAST(@pret as varchar)
			*/
				END 
				ELSE BEGIN
					SELECT FORMATMESSAGE('AM ESUAT SA INSEREZ CONSULTATIA(%i,%i,%s,%i) din cauza %s', @medic_id, @pacient_id, CAST(@data_consult as VARCHAR),  @pret, @error_consultatie) AS ResultC
				
					ROLLBACK TRAN pacient_inserat
				END
			
			END
			ELSE BEGIN 
				SELECT FORMATMESSAGE('AM ESUAT SA INSEREZ Pacientul(%i, %s, %s) din cauza %s ',@pacient_id, @nume_pacient, @cnp, @error_pacient) AS ResultP;  
				ROLLBACK TRAN medic_inserat 
			END
		END 
		ELSE BEGIN 
			SELECT FORMATMESSAGE('AM ESUAT SA inserez  Medicul(%i, %s, %i, %s, din cauza %s',@medic_id, @nume_medic, @vechime, @specializare, @error_medic) AS Result;  
			ROLLBACK TRAN enter
		END
		COMMIT TRAN

END

SELECT * FROM Medici;
SELECT * FROM Pacienti;
SELECT * FROM Consultatii;
DELETE FROM Medici;
DELETE FROM Pacienti;
DELETE FROM Consultatii;
/*  INSEREAZA FARA PROBLEME */
EXEC insert_partial_rollback @nume_medic='medic',@vechime=10,@specializare='dermato',@varsta=45,@nume_pacient='pacient',
@cnp = '6901803156891', @data_consult ='2020/10/10' , @pret=50

/* EROARE LA VALIDARE MEDIC */
EXEC insert_partial_rollback  @nume_medic='medic',@vechime=1,@specializare='dermato',@varsta=45,@nume_pacient='pacient',
@cnp = '6901803156891', @data_consult ='2020/10/10' , @pret=10


/* EROARE LA VALIDARE PACIENT - se pastreaza medicul inserat */

EXEC insert_partial_rollback @nume_medic='medic', @vechime=10, @specializare='kineto',
@varsta=4, @nume_pacient='p', @cnp ='6901803156891', @data_consult ='2021-1-1', @pret =50


/* EROARE LA INSERARE CONSULTATIE - se pastreaza medic si pacient */
EXEC insert_partial_rollback @nume_medic='medic', @vechime=10, @specializare='kineto',
@varsta=45, @nume_pacient='p', @cnp ='6901803156891', @data_consult ='2021-1-1', @pret =-10