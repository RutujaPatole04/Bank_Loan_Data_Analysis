use [Bank Loan DB]
select * from bank_loan_data;

/*1-- KPIs*/

/* 1-- Total loan applications*/
select count(id) as Total_Loan_Applications from bank_loan_data;

/* 1.1 MTD do calc on issue date-- latest data is dec 2021   */
select count(id) as MTD_Total_Loan_Applications from bank_loan_data
where MONTH(issue_date)=12 and year(issue_date)=2021;

/*1.1.1 MOM -- how your bank loan disbursements are done with respect to last month and current month find out the percentage increase or percentage decrease*/
select count(id) as PMTD_Total_Loan_Applications from bank_loan_data
where MONTH(issue_date)=11 and year(issue_date)=2021;
-- MOM = (MTD-PMTD)/PMTD

---2 Total Funded amount
select * from bank_loan_data;

select sum(loan_amount) as Total_funded_amount from bank_loan_data;
--- MTD means the current month 
select sum(loan_amount) as MTD_Total_funded_amount from bank_loan_data
where month(issue_date)=12 and year(issue_date)=2021;

---PMTD
select sum(loan_amount) as PMTD_Total_funded_amount from bank_loan_data
where month(issue_date)=11 and year(issue_date)=2021;

---3. total received amount
select sum(total_payment) as MTD_Total_Amount_Received  from bank_loan_data
where month(issue_date)=12 and year(issue_date)=2021
select sum(total_payment) as PMTD_Total_Amount_Received  from bank_loan_data
where month(issue_date)=11 and year(issue_date)=2021

--  4. Average Interest Rate

select round(avg(int_rate),4)*100 as PMTD_Avg_Interset_Rate from bank_loan_data
where MONTH(issue_date)=12 and year(issue_date)=2021
select cast(avg(int_rate) as decimal(10,2)) * 100 as Avg_Interset_Rate from bank_loan_data
where MONTH(issue_date)=11 and year(issue_date)=2021

----5. Average Debt-to-Income Ration(DTI) based on this value bankers decide whethere we should give loan to the customer or no
--Month to Date
select round(avg(dti),4)*100 as MTD_Avg_DTI from bank_loan_data
where month(issue_date)=12 and year(issue_date)=2021
----Previous Month to Date
select round(avg(dti),4)*100 as PMTD_Avg_DTI from bank_loan_data
where month(issue_date)=11 and year(issue_date)=2021
----DTI should not high neither too low, should be 30-35 or 20-25 depending on the banks

----Good loan KPIs -- current and fully paid
--- bad loan -- charged off
----good loan application percentage
select 
      (count(case when loan_status= 'Fully Paid' or loan_status='Current' then id end)*100)
        / count(id) as Good_loan_percentage
from bank_loan_data
---good loan applications
select count(id) from bank_loan_data
where loan_status='Fully Paid' or loan_status='Current'

---good loan funded amount ---funded amount is loan amount
select sum(loan_amount) as Good_Loan_Funded_Amount from bank_loan_data
where loan_status='Fully Paid' or loan_status='Current'

-----good loan Total reveived amount
select sum(total_payment) as Good_Loan_Amount_Received from bank_loan_data
where loan_status='Fully Paid' or loan_status='Current'

----Bad Loan
--------Bad Loan Application Percentage
select 
      (count(case when loan_status= 'Charged Off'  then id end)*100.0)
        / count(id) as Bad_loan_percentage
from bank_loan_data

-----bad loan applications
select count(id)  as bank_loan_applications from bank_loan_data
where loan_status='Charged Off'

----bad loan funded amount
select sum(loan_amount) as Bad_loan_funded_amount from bank_loan_data
where loan_status='Charged Off'

---bad loan amount received
select sum(total_payment) as Bad_loan_funded_amount from bank_loan_data
where loan_status='Charged Off'

-----loan status grid view
select 
loan_status,
count(id) as Total_Loan_Applications,
sum(total_payment) as Total_Amount_Received,
sum(loan_amount) as Total_Funded_Amount,
AVG(int_rate * 100) as Interest_Rate,
AVG(dti *100) as DTI
from bank_loan_data
Group By
loan_status

----month to date
select 
loan_status,
count(id) as MTD_Total_Loan_Applications,
sum(total_payment) as MTD_Total_Amount_Received,
sum(loan_amount) as MTD_Total_Funded_Amount
from bank_loan_data
where MONTH(issue_date)=12
Group By
loan_status
----PMTD
select 
loan_status,
count(id) as PMTD_Total_Loan_Applications,
sum(total_payment) as PMTD_Total_Amount_Received,
sum(loan_amount) as PMTD_Total_Funded_Amount
from bank_loan_data
where MONTH(issue_date)=11
Group By
loan_status


------Charts Dashboard
----Metrics to be shown -- Total Loan Applications, Total Funded Amount, Total Amount Received
-----1 Monthly Trends by Issue Date(Line Chart)
select * from bank_loan_data
select 
    Month(issue_date) as Month_Number,
	DATENAME(month,issue_date) as Month_Name,
	Count(id) as Total_Loan_Applications,
	SUM(loan_amount) as Total_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
from bank_loan_data
group by Month(issue_date),DATENAME(month,issue_date)
order by Month(issue_date)

------2 Regional Analysis by State(Filled Map)
select 
    address_state,
	Count(id) as Total_Loan_Applications,
	SUM(loan_amount) as Total_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
from bank_loan_data
group by address_state
order by count(id) desc
------3 Loan Term Analysis(Donut Chart)
select 
    term,
	Count(id) as Total_Loan_Applications,
	SUM(loan_amount) as Total_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
from bank_loan_data
group by term
order by term
------4 Employee Length Analysis (Bar Chart)
select 
    emp_length,
	Count(id) as Total_Loan_Applications,
	SUM(loan_amount) as Total_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
from bank_loan_data
group by emp_length
order by emp_length
-----5 Loan Purpose Breakdown (Bar Chart)
select 
    purpose,
	Count(id) as Total_Loan_Applications,
	SUM(loan_amount) as Total_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
from bank_loan_data
group by purpose
order by count(id) desc
-----6 Home Ownership Analysis(Tree Map)
select * from bank_loan_data
select 
    home_ownership,
	Count(id) as Total_Loan_Applications,
	SUM(loan_amount) as Total_Funded_Amount,
	SUM(total_payment) as Total_Received_Amount
from bank_loan_data
group by home_ownership
order by count(id) desc