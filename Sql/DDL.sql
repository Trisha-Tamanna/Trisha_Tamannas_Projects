-----------------------------------------------------DATABASE CREATE-------------------------------------------------------------------------------
drop database BankDB
create database BankDB
on
(
name='BankDB_data',
filename='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\BankDB_data.mdf',
size=25mb,
filegrowth=10%,
maxsize=100mb
)
log on 
(
name='BankDB_log',
filename='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\BankDB_data.ldf',
size=10mb,
filegrowth=1%,
maxsize=1mb
)
exec sp_helpdb 'BankDB'
use BankDB
------------------------------------------------------CREATE TABLE-----------------------------------------------------------------------------------------

-------------------------CREATE CUSTOMERINFO TABLE--------------------------------------
create table CustomerINfo
(
CustomerID int primary key,
CustomerName varchar(50),
CustomerAddress varchar(50),
ZIP int
);
-------------------------CREATE BANKACCOUNT TABLE--------------------------------------
create table BankAccount
(
AccountNumber int primary key,
AccountType varchar(50),
AccountName varchar(50)
);
-------------------------CREATE BRANCH TABLE--------------------------------------
create table Branch
(
BranchID int primary key,
BranchName varchar(50)
);
use BankDB
-------------------------CREATE BANKTRANSACTION TABLE--------------------------------------
create table BankTransaction
(
CustomerID int references CustomerINfo(CustomerID),
AccountNumber int references BankAccount(AccountNumber),
BranchID int references Branch(BranchID),
Lasttransactiondate varchar(50),
CurrentAccountBalance money
)
go
--------------------------------------------------------------------CLUSTERED INDEX--------------------------------------------------------------------------------------------
create clustered index BankTransaction_INDEX
ON dbo.BankTransaction(CustomerID);
GO
--------------------------nonCLUSTERED INDEX------------------------------------------------
create nonclustered index Branch_INDEX
ON dbo.BankTransaction(CustomerID);
GO
------------------------------------------------------------------------Alter table---------------------------------------------------------------------------------------------
----------------------------Add a COLUMN-------------------------------------------------
ALTER TABLE CustomerINfo
ADD CustomerPhone varchar (50);
GO
---------------------------------------------------------------------DROP COLUMN------------------------------------------------------------------------------------------
ALTER TABLE CustomerINfo 
DROP COLUMN CustomerPhone;
GO
------------------------------------------------------------------------CREATE VIEW---------------------------------------------------------------------------------------------------------
create view vw_CustomerName 
as 
select CustomerName,CustomerAddress,ZIP,BankAccount.AccountNumber,AccountType,BranchName,Lasttransactiondate,CurrentAccountBalance 
from BankTransaction 
join CustomerINfo on BankTransaction.CustomerID=CustomerINfo.CustomerID
join BankAccount on BankTransaction.AccountNumber=BankAccount.AccountNumber
join Branch on BankTransaction.BranchID=Branch.BranchID
group by CustomerName,CustomerAddress,ZIP,BankAccount.AccountNumber,AccountType,BranchName,Lasttransactiondate,CurrentAccountBalance
having ZIP in(select ZIP from CustomerINfo
where ZIP='1214');
drop view vw_CustomerName
select * from vw_CustomerName
go
-----------------------------create view with only encryption-------------------------
go
Create view vw_ency_Branch
With encryption
AS
Select BranchID From Branch;
Go
select * from vw_ency_Branch
-----------------------------create view with only Schemabinding------------------------
go
Create view vw_scema_Branch
with schemabinding 
as
select BranchID 
from dbo.Branch;
go
select * from vw_scema_Branch
GO
----------------------Create view with Encryption and schemabinding togather-------------------
Create view vw_togather 
with encryption,schemabinding 
AS
SELECT BranchID FROM dbo.Branch
GO
 ------------------------------------Table valued Functions---------------------------------
Create function fn_BankAccount()
returns table
return
(
select * from BankAccount
)
go
select * from dbo.fn_BankAccount()
GO
-----------------------------------Scalar valued function----------------------------
Create function fn_sca_BankAccount()
returns INT
begin 
declare @A INT
select @A=count(*) from BankAccount
return @A
end
go
select dbo.fn_sca_BankAccount()
GO
------------------------------------Multi state functions-----------------------------
Create function fn_BankTransaction()
returns @OutTable 
table(CustomerID INT,Lasttransactiondate varchar,TotalAccountBalance money)
begin
insert into @OutTable(CustomerID ,Lasttransactiondate ,TotalAccountBalance)
select CustomerID,Lasttransactiondate,CurrentAccountBalance+1100
from BankTransaction
return
end
go
select * from dbo.fn_BankTransaction()
--------------------------------------------------------------------STORED PROCEDURE---------------------------------------------------------------------------------------
-------------------------------------------STORED PROCEDURE WITHOUT PARAMETER-----------------------------------------------------
create proc sp_BankTransactionwithoutParameters
as
select CustomerID FROM BankTransaction
go
-------------------------------------------STORED PROCEDURE WITH PARAMETER-----------------------------------------------------
Create proc sp_BankTransactionwithParameters
  @outputParam int output,
  @optionalParam date = null,
  @defaultParam varchar(40) = 'N/A '
  as
  set @outputParam = 1;
  if @optionalParam is null
       begin
       set @optionalParam = GETDATE();
       end;
  exec sp_BankTransactionwithoutParameters
----------------------------------------------------------------------DROP TABLE---------------------------------------------------------------------------------------
drop table CustomerINfo;
drop table  BankAccount;
drop table  Branch;
drop table BankTransaction;