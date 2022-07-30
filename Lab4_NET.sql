USE PartajareAbonamente

GO
CREATE OR ALTER PROCEDURE deadlock_first AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	BEGIN TRAN
	UPDATE Pacienti SET nume='dead_name' WHERE cnp='12345';
	WAITFOR DELAY '00:00:05';
	UPDATE Medici SET vechime=21 WHERE 
	specializare='kineto';
	COMMIT TRAN

END

GO
CREATE OR ALTER PROCEDURE deadlock_second AS 
BEGIN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	BEGIN TRAN;
	UPDATE Medici SET vechime=5 WHERE 
	specializare='kineto';
	WAITFOR DELAY '00:00:05';
	UPDATE Pacienti SET nume='lock_name' WHERE cnp='12345';
	COMMIT TRAN
END 

EXEC deadlock_first;
