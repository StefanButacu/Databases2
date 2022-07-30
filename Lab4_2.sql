USE PartajareAbonamente

SELECT @@TRANCOUNT AS TR
/*Dirty read */

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRAN;
SELECT * FROM Pacienti;
COMMIT TRAN;

/* se afiseaza varsta 100, chiar daca prima T a facut rollback
 SELECT * FROM Pacienti; */

/* Dirty read evitare */


SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRAN;
SELECT * FROM Pacienti;
COMMIT TRAN;


/* Non-repeateable reads EVITARE */
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRAN;
SELECT * FROM Pacienti;
COMMIT TRAN;


/* Non-repeateable reads */
BEGIN TRAN;
WAITFOR DELAY '00:00:02';
UPDATE Pacienti set nume='john12345' where pacient_id = 6;  /* modifica numele */
COMMIT TRAN;

/* phantom reads */ 
BEGIN TRAN;
WAITFOR DELAY '00:00:03';
INSERT INTO Pacienti(varsta, nume, cnp) VALUES 
(99, 'Stef','000000');
COMMIT TRAN;


/* deadlock */ 

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRAN;
print 'Prepare to update Medici table'
UPDATE Medici SET vechime=5 WHERE 
specializare='kineto';
print 'update Medici finish'
WAITFOR DELAY '00:00:05';
print 'Prepare to update Pacienti table'
UPDATE Pacienti SET nume='lock_name' WHERE cnp='12345';
print 'update Pacienti finish'
COMMIT TRAN


/* deadlock evitare */
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRAN;
print 'Prepare to update Pacienti table'

UPDATE Pacienti SET nume='lock_name1' WHERE cnp='12345';
WAITFOR DELAY '00:00:05';

print 'update Pacienti finish'

print 'Prepare to update Medici table'

UPDATE Medici SET vechime=50 WHERE 
specializare='kineto';

print 'update Medici finish'

COMMIT TRAN


BEGIN TRY
	
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	BEGIN TRAN;
	print 'Prepare to update Medici table'
	UPDATE Medici SET vechime=5 WHERE 
	specializare='kineto';
	print 'update Medici finish'

	WAITFOR DELAY '00:00:05';
	print 'Prepare to update Pacienti table'
	UPDATE Pacienti SET nume='lock_name' WHERE cnp='12345';
	print 'update Pacienti finish'
END TRY 
BEGIN CATCH  
	ROLLBACK TRAN
	if( ERROR_NUMBER() = 1205) 
		BEGIN
			print 'Deadlock T2 found... retry'
			BEGIN TRAN;
			print 'Prepare to update Medici table'
			UPDATE Medici SET vechime=5 WHERE 
			specializare='kineto';
			print 'update Medici finish'

			WAITFOR DELAY '00:00:05';
			print 'Prepare to update Pacienti table'
			UPDATE Pacienti SET nume='lock_name' WHERE cnp='12345';
			print 'update Pacienti finish'

			COMMIT TRAN
	END 
END CATCH 

ROLLBACK TRAN
SELECT @@TRANCOUNT
EXEC deadlock_second