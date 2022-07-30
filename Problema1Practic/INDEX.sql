USE P32022;

---- INDEX

GO
SELECT pret, nume_b FROM Biscuiti WHERE pret > 7 ORDER BY pret desc
CREATE NONCLUSTERED INDEX IX_Biscuti_pret ON Biscuiti(pret asc) include (nume_b)
DROP INDEX Biscuiti.IX_Biscuti_pret

