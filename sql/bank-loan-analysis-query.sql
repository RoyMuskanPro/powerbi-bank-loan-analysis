use [db-bank-loan]
select * from tbl_bank_loan 

--Total Loan Application
SELECT COUNT(id) AS Total_Loan_Application FROM tbl_bank_loan;

--Month to date (MTD) Total Loan Application
SELECT COUNT(id) AS MTD_Total_Loan_Application FROM tbl_bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021 

--Previous Month to date (MTD) Total Loan Application
SELECT COUNT(id) AS PMTD_Total_Loan_Application FROM tbl_bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021 

--Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM tbl_bank_loan

-- Total Funded Amount MTD
SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount FROM tbl_bank_loan
WHERE Month(issue_date) = 12 AND YEAR(issue_date) = 2021 

-- Total Funded Amount Previous MTD
SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount FROM tbl_bank_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021 

--Correct MTD
SELECT ((
SELECT SUM(loan_amount) FROM tbl_bank_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021)
-
(SELECT SUM(loan_amount) FROM tbl_bank_loan
Where Month(issue_date) = 11 And YEAR(issue_date) = 2021))
/
(SELECT SUM(loan_amount) FROM tbl_bank_loan
Where MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021)

AS MTD_Total_Funded_Amount;



--- Month to date (MTD) Loan Application
create view vw_loan_appn_dec_2021 as  select * from tbl_bank_loan Where Month(issue_date) = 12 And YEAR(issue_date) = 2021 

--- use view
select * from [dbo].[vw_loan_appn_dec_2021]

Select COUNT(id) as December_Total_Loan_Application from [dbo].[vw_loan_appn_dec_2021]

drop view [dbo].[vw_loan_appn_dec_2021]

--Total Amount Received
Select SUM(total_payment) As Total_Amount_Received 
from tbl_bank_loan

--Total Amount Received MTD
Select SUM(total_payment) As Total_Amount_Received_MTD 
from tbl_bank_loan
Where MONTH(issue_date) = 12 And YEAR(issue_date) = 2021

--Average Interest Rate
Select Round(AVG(int_rate), 4) * 100 As Average_Interest_Rate from tbl_bank_loan

--MTD Avg Interest Rate
Select Round(AVG(int_rate), 4) * 100 As MTD_Average_Interest_Rate 
from tbl_bank_loan
Where MONTH(issue_date) = 12 ANd YEAR(issue_date) = 2021

--Debt to Income Ratio (DTI)
Select Round(AVG(dti),4) * 100 As Avg_DTI
from tbl_bank_loan

--Good Loan Percentage
Select
(Count(Case When loan_status = 'Current' OR loan_status = 'Fully Paid' Then id End) * 100)
/
Count(id) As Good_Loan_Percentage
from tbl_bank_loan;

--Good loan Application
Select Count(id) As Good_Loan_Application from tbl_bank_loan
Where loan_status = 'Current' Or loan_status = 'Fully Paid'; 

--Good Loan Funded Amount
Select SUM(loan_amount) As Good_Loan_Funded_Amount from tbl_bank_loan
Where loan_status = 'Current' Or loan_status = 'Fully Paid'; 

--Good Loan Total Received Amount
Select SUM(total_payment) As Total_Received_Amount
from tbl_bank_loan
Where loan_status In('Current', 'Fully Paid')


--Bad Loan Percentage
Select
(Count(Case When loan_status = 'Charged Off' Then id End) * 100)
/
COUNT(id) As Bad_Loan_Percentage
from tbl_bank_loan;

--Bad Loan Application
Select
Count(id) As Bad_Loan_Application from tbl_bank_loan
Where loan_status = 'Charged Off';

--Bad Loan Funded Amount
Select SUM(loan_amount) As Bad_Loan_Funded_Amount from tbl_bank_loan
Where loan_status = 'Charged Off';

--Bad Loan Total Received Amount
Select SUM(total_payment) As Total_Received_Amount
from tbl_bank_loan
Where loan_status = 'Charged Off';

--Loan Status Grid View
Select loan_status,
Count(id) As Total_Applications,
SUM(loan_amount) As Total_Funded_Amount,
SUM(total_payment) As Total_Amount_Received,
Round(AVG(int_rate * 100), 2) As Average_Interest_Rate,
Round(AVG(dti * 100), 2) As Average_DTI
from tbl_bank_loan
Group By loan_status;

--Loan Status Grid View
Select loan_status,
Sum(loan_amount) As MTD_Total_Funded_Amount,
SUM(total_payment) As MTD_Total_Amount_Received
from tbl_bank_loan
Where MONTH(issue_date) = 12 And YEAR(issue_date) = 2021
Group By loan_status;

--Monthly Trend by issue date
Select 
Month(issue_date) AS Month_No,
DATENAME(Month, issue_date) As Month_Name,
Count(id) As Total_Applications,
SUM(loan_amount) As Total_Funded_Amount,
SUM(total_payment) As Total_Amount_Received
from tbl_bank_loan
Group By Month(issue_date), DATENAME(Month, issue_date)
Order By Month(issue_date);

--Regional Analysis By State
Select 
address_state,
Count(id) As Total_Applications,
SUM(loan_amount) As Total_Funded_Amount,
SUM(total_payment) As Total_Amount_Received
from tbl_bank_loan
Group By address_state
Order By SUM(loan_amount) Desc;

--Loan Term Analysis
Select 
term,
Count(id) As Total_Applications,
SUM(loan_amount) As Total_Funded_Amount,
SUM(total_payment) As Total_Amount_Received
from tbl_bank_loan
Group By term;

--Emmployee Length Analysis
Select
home_ownership,
Count(id) As Total_Applications,
SUM(loan_amount) As Total_Funded_Amount,
SUM(total_payment) As Total_Amount_Received
from tbl_bank_loan
Group By home_ownership
Order By COUNT(id) Desc;
