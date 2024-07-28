drop database BankDB
--------------------------------------------------------------------------DATA INSERT--------------------------------------------------------------------------------------------------
------------------------------------INSERT INTO CUSTOMERINFO----------------------------------
insert into CustomerINfo(CustomerID,CustomerName,CustomerAddress,ZIP) values(1,'Lucky','NorthMugdapara',1214),
(2,'IronMan','SouthMugdapara',1214),
(3,'BlackWindow','NorthBasaboo',1204),(4,'Nun','SouthBasaboo',1204),
(5,'Hulk','Goran',1824),(6,'Superman','EastGoran',1821),(7,'Thor','NorthTaltola',1219),
(8,'SuperHero','SouthKamalapur',1217),(9,'IronMan','Khilgoan',1226),(10,'SpiderMan','Rampura',4224)
------------------------------------INSERT INTO BankAccount----------------------------------
insert into BankAccount(AccountNumber,AccountName,AccountType)
values(90471234,'savings','SAV'),(91232313,'savings','SAV'),(91323410,'Checking','CHECK'),
(91323412,'Goal Saver','GOAL'),(90401234,'Checking','CHECK'),
(95462134,'Checking','CHECK'),(90213241,'Checking','CHECK'),(95356795,'Retriment','IRA'),
(96325874,'Retriment','IRA')
------------------------------------INSERT INTO Branch----------------------------------
insert into Branch(BranchID,BranchName) values(1,'Motijheel'),(2,'Khilgoan'),(3,'Basaboo'),
(4,'Iskaton'),(5,'Mogbajar'),(6,'Malibag'),(7,'BanglaMotor'),(8,'Panthapath')
------------------------------------INSERT INTO BankTransaction----------------------------------
insert into BankTransaction(CustomerID,AccountNumber,BranchID,Lasttransactiondate,CurrentAccountBalance) values(1,90471234,1,'01-12-2021',500),
(2,91232313,2,'12-05-2022',500),(3,91323410,3,'11-11-2022',3000),(4,91323412,4,'12-05-2023',5400),(5,90401234,5,'14-6-2022',2300),
(6,95462134,6,'15-03-2023',2600),(7,90213241,7,'01-02-2023',4000),(8,95356795,8,'01-02-2023',9800)

select * from CustomerINfo
select * from BankAccount
select * from Branch
select * from BankTransaction

-------------------------------------------------------------DISTINCT--------------------------------------------------------------------------
select distinct AccountNumber,AccountName from BankAccount
GO
-------------------------------------------------------------order by--------------------------------------------------------------------------
select CustomerID,AccountNumber,BranchID,Lasttransactiondate,CurrentAccountBalance from BankTransaction
order by CustomerID 
GO
---------------------------------------------------------------LOGICAL OPERATOR(AND/OR/NOT/)-----------------------------------------------------------------
--------------------------AND--------------------------------------------------
select CustomerID,AccountNumber,BranchID,Lasttransactiondate,CurrentAccountBalance from BankTransaction
where CurrentAccountBalance>500 and Lasttransactiondate='01-02-2023'
go
-------------------------OR---------------------------------------------------
select CustomerID,AccountNumber,BranchID,Lasttransactiondate,CurrentAccountBalance from BankTransaction
where CurrentAccountBalance>500 or Lasttransactiondate='01-02-2023'
go
-------------------------NOT--------------------------------------------------
select CustomerID,AccountNumber,BranchID,Lasttransactiondate,CurrentAccountBalance from BankTransaction
where CurrentAccountBalance>=500 or not Lasttransactiondate<='01-02-2023'
go
-------------------------------------------------------------JOIN-------------------------------------------------------------------------------
select CustomerName,CustomerAddress,ZIP,BankAccount.AccountNumber,AccountType,BranchName,Lasttransactiondate,CurrentAccountBalance 
from BankTransaction 
join CustomerINfo on BankTransaction.CustomerID=CustomerINfo.CustomerID
join BankAccount on BankTransaction.AccountNumber=BankAccount.AccountNumber
join Branch on BankTransaction.BranchID=Branch.BranchID
group by CustomerName,CustomerAddress,ZIP,BankAccount.AccountNumber,AccountType,BranchName,Lasttransactiondate,CurrentAccountBalance
GO
-------------------------------------------------------------CASE---------------------------------------------------------------------------------
select AccountNumber,AccountName,AccountType,
case 
when AccountName='savings' then 'S/A'
when AccountName='Checking' then 'C/A'
when AccountName='Retriment' then 'R/A'
when AccountName='Goal Saver' then 'G/S'
else 'OTHERS'
end as AccountTYpe from BankAccount 
GO
---------------------------CHOOSE,iif--------------------------------
select AccountNumber,AccountName,AccountType,
CHOOSE(AccountNumber,'Checking','others') as NewAccountName_1,
iif(AccountName='savings','savings','others') as NewAccountName_2 from BankAccount;
insert into BankAccount(AccountNumber,AccountName,AccountType) values(90471235,null,'SAV'),(91232319,'savings',null),(91323411,'Checking',null),
(91323419,'Goal Saver',null),(90401239,'Checking',null),
(95462136,'Checking',null),(90213242,'Checking',null);
select AccountNumber,AccountName,AccountType,
isnull(AccountType,'No Name Yet') as NameOfAcType ,
coalesce(AccountType,'No Name Yet') as NameOfAcType from BankAccount;
go
-------------------------------------------------------------------------RANK--------------------------------------------------------------------------------------
select AccountNumber,AccountName,AccountType,
ROW_NUMBER()over (partition by AccountName order by AccountNumber) as ROW_AccName ,
Rank() over (partition by AccountName order by AccountNumber) as Rank_AccName ,
DENSE_RANK() over (partition by AccountName order by AccountNumber) as DENSE_Rank_AccName ,
NTILE(8) over (partition by AccountName order by AccountNumber) as NTILE_Rank_AccName from BankAccount;
go
-------------------------------------------------------------------------ANALYTIC FUNCTION--------------------------------------------------------------------------------------
select AccountNumber,AccountName,AccountType,
FIRST_VALUE(AccountNumber)over (partition by AccountName order by AccountNumber) as FIRST_VALUE_AccName ,
LAST_VALUE(AccountNumber)over (partition by AccountName order by AccountNumber) as LAST_VALUE_AccName ,
LEAD(AccountNumber) over (partition by AccountName order by AccountNumber) as LEAD_AccName ,
LAG(AccountNumber) over (partition by AccountName order by AccountNumber) as LAG_AccName ,
PERCENT_RANK () over (partition by AccountName order by AccountNumber) as PERCENT_RANK_AccName,
CUME_DIST() over (partition by AccountName order by AccountNumber) as CUME_DIST_AccName,
PERCENTILE_CONT(0.5) within group (order by AccountNumber) over (partition by AccountName) as PERCENTILE_CONT_AccName,
PERCENTILE_DISC(0.5) within group (order by AccountNumber) over (partition by AccountName) as PERCENTILE_DISC_AccName from BankAccount;
go


