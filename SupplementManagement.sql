CREATE DATABASE SupplementManagement

CREATE TABLE SupCategory
(
	SCategoryID nvarchar(6) NOT NULL PRIMARY KEY,
	SCategoryName NVARCHAR(100) NOT NULL,
)

CREATE TABLE SupProduct
(
	ProID nvarchar(6) NOT NULL PRIMARY KEY,
	ProName NVARCHAR(100) NOT NULL,
	SCategoryID nvarchar(6) NOT NULL,
	Price int NOT NULL DEFAULT 0
)

CREATE TABLE Stock 
(
	StockID nvarchar(6) NOT NULL PRIMARY KEY,
	DateGet date NOT NULL DEFAULT GETDATE(),
)

CREATE TABLE StockInfo
(
	StockID nvarchar(6) NOT NULL,
	ProID nvarchar(6) NOT NULL,
	Amount INT,
	primary key(StockID,ProID)
)


CREATE TABLE Agency
(	
	AgencyID NVARCHAR(6) NOT NULL Primary Key,
	AgencyName NVARCHAR(100) NOT NULL,
	AgencyPNumber NVARCHAR(50) NOT NULL,
)



CREATE TABLE Bill
(
	BillID nvarchar(6) NOT NULL PRIMARY KEY,
	DateBuy DATE NOT NULL DEFAULT GETDATE(),
	AgencyID NVARCHAR(6) NOT NULL,
	StatusPay nvarchar(30) DEFAULT(N'No'),
)

CREATE TABLE BillInfo
(
	BillID nvarchar(6) NOT NULL,
	ProID nvarchar(6) NOT NULL,
	Amount INT,
	StatusDeli nvarchar(30) DEFAULT(N'NoTransfer'),
	primary key(BillID,ProID)
)

CREATE TABLE Report
(
	ReportID nvarchar(6) PRIMARY KEY NOT NULL,
	Thang Date NOT NULL,
	ProID nvarchar(6) NOT NULL,
	AmountGet smallint NOT NULL,
	AmountSell smallint NOT NULL
)



Alter table SupProduct
Add constraint fk_sp_sc foreign key (SCategoryID) references SupCategory(SCategoryID)
Alter table Stock
Add constraint fk_s_sp foreign key (ProID) references SupProduct(ProID)
Alter table StockInfo
Add constraint fk_si_b foreign key (StockID) references Stock (StockID)
Alter table StockInfo
Add constraint fk_si_f foreign key (ProID) references SupProduct (ProID)
Alter table Bill
Add constraint fk_b_a foreign key (AgencyID) references Agency(AgencyID)
Alter table BillInfo
Add constraint fk_bi_b foreign key (BillID) references Bill (BillID)
Alter table BillInfo
Add constraint fk_bi_f foreign key (ProID) references SupProduct (ProID)
ALTER TABLE Report
ADD CONSTRAINT FK_R_SP FOREIGN KEY (ProID) REFERENCES SupProduct(ProID)


INSERT INTO SupCategory Values ('SC01','Whey')
INSERT INTO SupCategory Values ('SC02','Vitamins')
INSERT INTO SupCategory Values ('SC03','Minerals')
INSERT INTO SupCategory Values ('SC04','Food')
INSERT INTO SupCategory Values ('SC05','Drink')
INSERT INTO SupCategory Values ('SC06','Energy')
INSERT INTO SupCategory Values ('SC07','Others')

INSERT INTO SupProduct Values ('P101','Gold Whey','SC01','40000')
INSERT INTO SupProduct Values ('P102','Iso Whey','SC01','45000')
INSERT INTO SupProduct Values ('P103','Mutant Whey','SC01','45000')
INSERT INTO SupProduct Values ('P104','Rule1 Whey','SC01','50000')
INSERT INTO SupProduct Values ('P105','MyProtein Whey','SC01','45000')

INSERT INTO SupProduct Values ('P201','Vitamin E','SC02','55000')
INSERT INTO SupProduct Values ('P202','Vitamin B','SC02','55000')
INSERT INTO SupProduct Values ('P203','Vitamin C','SC02','55000')
INSERT INTO SupProduct Values ('P204','Vitamin A','SC02','55000')
INSERT INTO SupProduct Values ('P205','Vitamin K2','SC02','55000')
INSERT INTO SupProduct Values ('P206','Vitamin D3','SC02','40000')

INSERT INTO SupProduct Values ('P301','IRON','SC03','45000')
INSERT INTO SupProduct Values ('P302','Magnesium','SC03','40000')
INSERT INTO SupProduct Values ('P303','Fish Oil','SC03','40000')
INSERT INTO SupProduct Values ('P304','Glucosamine','SC03','40000')

INSERT INTO SupProduct Values ('P401','Chicken','SC04','45000')
INSERT INTO SupProduct Values ('P402','Fish','SC04','55000')
INSERT INTO SupProduct Values ('P403','Beef','SC04','55000')
INSERT INTO SupProduct Values ('P404','Pork','SC04','55000')

INSERT INTO SupProduct Values ('P501','Esspresso','SC05','45000')
INSERT INTO SupProduct Values ('P502','Esspresso (Ice)','SC05','45000')
INSERT INTO SupProduct Values ('P503','Cappuchino','SC05','45000')
INSERT INTO SupProduct Values ('P504','Cappuchino (Ice)','SC05','45000')
INSERT INTO SupProduct Values ('P505','Latte','SC05','55000')

INSERT INTO SupProduct Values ('P601','PRE Mutant','SC06','35000')
INSERT INTO SupProduct Values ('P602','PRE Pump','SC06','35000')
INSERT INTO SupProduct Values ('P603','PRE Curse','SC06','35000')
INSERT INTO SupProduct Values ('P604','PRE C4','SC06','35000')
INSERT INTO SupProduct Values ('P605','PRE ABE','SC06','35000')

INSERT INTO SupProduct Values ('P701','Bottle1000ML','SC07','60000')
INSERT INTO SupProduct Values ('P702','HandProtect','SC07','60000')

/*INSERT INTO Bill Values ('B01',GETDATE(),'A01','No')
INSERT INTO BillInfo Values ('B01','P701',10,'NoTransfer')
INSERT INTO BillInfo Values ('B01','P702',10,'NoTransfer')
INSERT INTO BillInfo Values ('B01','P601',10,'NoTransfer')

Select ProName, bi.Amount, s.Price*bi.Amount as 'Total'
From SupProduct s inner join BillInfo bi on s.ProID = bi.ProID inner join Bill b on b.BillID = bi.BillID
Where b.BillID = 'B01'*/


Go
create proc Income
as
begin
select b.BillID, DateBuy,Sum(Price*bi.Amount) as 'Total'
from SupProduct s inner join BillInfo bi on s.ProID = bi.ProID
	inner join Bill b on b.BillID = bi.BillID
group by b.BillID, DateBuy
end