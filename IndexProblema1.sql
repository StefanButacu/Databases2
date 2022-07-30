use Problema1
go

-- 2)
begin tran
update Cofetarii set nume_cofetarie='Cofetarie noua' where cod_cofetarie=1
waitfor delay '00:00:03'
rollback tran

--set transaction isolation level read uncommitted
set transaction isolation level read committed
begin tran
select * from Cofetarii
waitfor delay '00:00:03'
select * from Cofetarii
commit tran

-- 3)
drop index Briose.idx_pret
create NONCLUSTERED index idx_pret on Briose (pret asc) include (nume_briosa)
select nume_briosa, pret from Briose order by pret asc
select nume_briosa, pret from Briose WHERE pret > 15

select * from Briose