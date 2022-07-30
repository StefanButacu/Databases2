CREATE DATABASE [Lab1222-1SGBD];
GO
USE [Lab1222-1SGBD];
CREATE TABLE Sali
(cod_s INT PRIMARY KEY IDENTITY,
denumire VARCHAR(20),
etaj INT,
capacitate INT,
tip VARCHAR(50)
);
INSERT INTO Sali (denumire, etaj, capacitate, tip) VALUES
('C308',3,30,'laborator'), ('C310',3,50,'seminar'), ('C510',5,44,'seminar'),
('L001',-1,30,'laborator');
SELECT * FROM Sali;