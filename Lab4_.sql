USE PartajareAbonamente


/* Dirty reads */ 
GO 
SELECT * FROM Pacienti;
UPDATE Pacienti SET varsta = 20, nume = 'ion' WHERE pacient_id = 3

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRAN;
UPDATE Pacienti SET varsta=100 WHERE nume='ion';
WAITFOR DELAY '00:00:07';
ROLLBACK TRAN

SELECT * FROM Pacienti;

/* evitare dirty read */
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

/* non-repeatable reads */
BEGIN TRAN;
SELECT * FROM Pacienti;
WAITFOR DELAY '00:00:07';
SELECT * FROM Pacienti;
COMMIT TRAN;

/* non - repeatable reads - evitare */
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRAN;
SELECT * FROM Pacienti;
WAITFOR DELAY '00:00:10';
SELECT * FROM Pacienti;
COMMIT TRAN;

/*phantom reads EVITARE */ 
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 

/*phantom reads */ 
BEGIN TRAN;
SELECT * FROM Pacienti WHERE pacient_id BETWEEN 1 AND 10000;
WAITFOR DELAY '00:00:06';
SELECT * FROM Pacienti WHERE pacient_id BETWEEN 1 AND 10000;
COMMIT TRAN;

/* deadlock */

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRAN;
print 'Prepare to update Pacienti table ' 

UPDATE Pacienti SET nume='dead_name' WHERE cnp='12345';
print 'update pacienti finish'
WAITFOR DELAY '00:00:05';
print  'Prepare to update Medici table'
UPDATE Medici SET vechime=21 WHERE 
specializare='kineto';
print 'update medici finish'
COMMIT TRAN
/*  */
SELECT * FROM Pacienti

SELECT * FROM Medici

EXEC deadlock_second;



begin try 
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRAN;
	print 'Prepare to update Pacienti table ' 
	UPDATE Pacienti SET nume='dead_name' WHERE cnp='12345';
	print 'update Pacienti finish'

	WAITFOR DELAY '00:00:05';
	print  'Prepare to update Medici table'
	UPDATE Medici SET vechime=21 WHERE 
	specializare='kineto';
	print 'update Medici finish'
COMMIT TRAN
END TRY

BEGIN CATCH  
	ROLLBACK TRAN
	if( ERROR_NUMBER() = 1205) 
	BEGIN
		print 'Deadlock T1 found... retry'
		BEGIN TRAN;
		UPDATE Pacienti SET nume='dead_name' WHERE cnp='12345';
		WAITFOR DELAY '00:00:05';
		UPDATE Medici SET vechime=21 WHERE 
		specializare='kineto';
		COMMIT TRAN
    END 
END CATCH 

ROLLBACK TRAN
select @@TRANCOUNT
EXEC deadlock_first