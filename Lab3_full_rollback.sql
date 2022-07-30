USE [SGBD-Lab3]


CREATE  TABLE Medici 
(medic_id INT PRIMARY KEY IDENTITY,
nume varchar(20),
vechime int,
specializare varchar(15), 
);

CREATE TABLE Pacienti(
pacient_id INT PRIMARY KEY IDENTITY,
varsta int,
nume varchar(20),
cnp varchar(15)
);

CREATE TABLE Consultatii(
medic_id INT FOREIGN KEY (medic_id) REFERENCES Medici(medic_id),
pacient_id INT FOREIGN KEY (pacient_id) REFERENCES Pacienti(pacient_id),
data_consult DATE,
pret int
)
GO


SET IMPLICIT_TRANSACTIONS OFF 
GO-

/*  INSEREAZA FARA PROBLEME */
EXEC insert_full_rollback @nume_medic='medic',@vechime=10,@specializare='dermato',@varsta=45,@nume_pacient='pacient',
@cnp = '6901803156891', @data_consult ='2020/10/10' , @pret=10

/* EROARE LA VALIDARE PACIENT - se face rollback pe medicul inserat */

EXEC insert_full_rollback @nume_medic='medic', @vechime=10, @specializare='kineto',
@varsta=4, @nume_pacient='p', @cnp ='6901803156891', @data_consult ='2021/01/01', @pret =50


/* EROARE LA INSERARE CONSULTATIE - se face rollback pe medic si pe pacient */
EXEC insert_full_rollback @nume_medic='medic', @vechime=10, @specializare='kineto',
@varsta=45, @nume_pacient='p', @cnp ='6901803156891', @data_consult ='2021/01/01', @pret =-10

SELECT * FROM Medici
SELECT * FROM Pacienti
SELECT * FROM Consultatii


CREATE TABLE Specializari(
	ID INT PRIMARY KEY IDENTITY,
	nume varchar(15)
);
INSERT INTO Specializari(nume) VALUES ('chirurgie')

GO 

CREATE OR ALTER FUNCTION Valideaza_medic(@nume varchar(50), @vechime int, @specializare varchar(15))
returns varchar(80) AS 
BEGIN
	declare @error varchar(100);
	set @error = ''
	if @nume LIKE '' set  @error = @error + ' Numele nu poate fi vid';
	if @vechime < 7 set  @error = @error + ' Vechimea este prea mica'
	if NOT EXISTS(SELECT * FROM Specializari WHERE nume = @specializare) 
		set @error = @error + 'Nu exsista specializare ' 

	return @error
END 

GO
CREATE OR ALTER FUNCTION Valideaza_pacient(@varsta int , @nume varchar(15), @cnp varchar(15))
returns varchar(80) AS 
BEGIN
	declare @error varchar(100);
	set @error = ''
	if @nume LIKE '' set  @error = @error + ' Numele nu poate fi vid';
	if @varsta < 18 set  @error = @error + ' Pacientul nu poate avea sub 18 ani'
	if len(@cnp) != 13 set @error = @error + 'Invalid cnp'
	return @error
END 


GO
CREATE OR ALTER FUNCTION Valideaza_consulatie(@medic_id int, @pacient_id int, @data_consult DATE,
@pret int)
returns varchar(80) AS 
BEGIN
	declare @error varchar(100);
	set @error = ''
	if NOT EXISTS(SELECT * FROM Medici WHERE medic_id = @medic_id)
		set @error = @error + 'Nu exista medicul'
	if NOT EXISTS(SELECT * FROM Pacienti WHERE pacient_id = @pacient_id)
		set @error = @error + 'Nu exista pacientul'
/*	if @data_consult between '2019/04/15' and '2025/04/15'
		set @error = @error + 'Nu se poate face programare atunci'
	*/
	if @pret < 0 
		set @error = @error + 'Pretul nu poate fi negativ'
	return @error
END 

