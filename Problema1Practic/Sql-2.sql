USE P32022;

SELECT * FROM Clienti
UPDATE Clienti set nume_c='client1' where cod_c = 1;  /* modifica numele */

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
/* un-repeateable reads */
BEGIN TRAN;
WAITFOR DELAY '00:00:02';
UPDATE Clienti set nume_c='adi' where cod_c = 1;  /* modifica numele */
COMMIT TRAN;


/* un-repeateable reads EVITARE */
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRAN;
UPDATE Clienti set nume_c='adi' where cod_c = 1;  /* modifica numele */
COMMIT TRAN;

