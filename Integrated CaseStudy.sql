--TASK 1

Create Database Loans

--Banker Data
ALTER TABLE [dbo].[Banker_Data]
Alter column [dob] date
ALTER TABLE [dbo].[Banker_Data]
Alter column [date_joined] date
--Customer Data
Alter Table [dbo].[Customer_Data]
Alter Column [dob] date
Alter Table [dbo].[Customer_Data]
Alter Column [customer_since] date
--Home_Loan Data
Alter Table [dbo].[Home_Loan_Data]
ALTER COLUMN [property_value]  INT
Alter Table [dbo].[Home_Loan_Data]
ALTER COLUMN [loan_percent]  INT
Alter Table [dbo].[Home_Loan_Data]
ALTER COLUMN [loan_term]  INT
Alter Table [dbo].[Home_Loan_Data]
ALTER COLUMN [postal_code]  INT
--Loan Records Data
Alter Table [dbo].[Loan_Records_Data]
Alter Column [record_id] int
Alter Table [dbo].[Loan_Records_Data]
Alter Column [customer_id] int
UPDATE [dbo].[Loan_Records_Data]
SET [transaction_date] = NULL
WHERE ISDATE([transaction_date]) = 0
Alter Table [dbo].[Loan_Records_Data]
Alter Column [transaction_date] date

--Write a query to print all the databases available in the SQL Server.

SELECT name FROM sys.databases

--Write a query to print the names of the tables from the Loans database

SELECT table_name FROM information_schema.tables

--Write a query to print 5 records in each table

Select Top 5 * from [dbo].[Banker_Data] 
Select Top 5 * from [dbo].[Customer_Data]
Select Top 5 * from [dbo].[Home_Loan_Data]
Select Top 5 * from [dbo].[Loan_Records_Data]

--TASK 2

/*Q. Find the ID, first name, and last name of the top 2 bankers (and corresponding transaction count) 
involved in the highest number of distinct loan records.*/

SELECT top 2 b.banker_id, b.first_name, b.last_name, COUNT(DISTINCT l.record_id) as transaction_count
FROM Loan_Records_Data as l JOIN Banker_Data as b ON l.banker_id = b.banker_id
GROUP BY b.banker_id, b.first_name, b.last_name
ORDER BY transaction_count DESC

/*Q. Find the names of the top 3 cities (based on descending alphabetical order) and corresponding loan percent 
(in ascending order) with the lowest average loan percent.*/

Select top 3 [city] , AVG( [loan_percent]) as Avg_LoanPercent from [dbo].[Home_Loan_Data] 
Group by [city] Order by Avg_LoanPercent asc, [city] desc


/*Q. Find the customer ID, first name, last name, and email of customers whose email address
contains the term 'amazon'.*/

Select [customer_id], [first_name], [last_name], [email] from [dbo].[Customer_Data]
Where [email] like '%amazon%'

/*Q. Find the maximum property value (using appropriate alias) of each property type,
ordered by the maximum property value in descending order.*/

Select [property_type], MAX([property_value]) as Property_Value from [dbo].[Home_Loan_Data]
Group by [property_type]
Order by Property_Value desc

/*Q. Find the city name and the corresponding average property value (using appropriate alias) for cities 
where the average property value is greater than $3,000,000.*/

Select [city], AVG([property_value]) as Avg_PropertyValue from [dbo].[Home_Loan_Data]
Group by [city] having AVG([property_value]) > 3000000

/*Q. Find the average age of male bankers (years, rounded to 1 decimal place) based on the date they joined WBG */

Select Gender, Round(Avg(DATEDIFF(Year,[date_joined],GETDATE())),1) as Avg_Age from [dbo].[Banker_Data] 
where gender like 'Male'
Group by gender

/*Q. Find the total number of different cities for which home loans have been issued.*/

Select Count(distinct [city]) as Total_Cities from [dbo].[Home_Loan_Data]

/*Q.Find the average age (at the point of loan transaction, in years and nearest integer) of female customers 
who took a non-joint loan for townhomes.*/

Select ROUND(AVG(DATEDIFF(YEAR, c.[dob], l.[transaction_date])), 0) as Avg_Age From [dbo].[Customer_Data] as c
Join [dbo].[Loan_Records_Data] as l on c.customer_id = l.customer_id
Join [dbo].[Home_Loan_Data] as h ON l.loan_id = h.loan_id
WHERE c.gender = 'Female' and h.joint_loan = 'No' and h.property_type = 'Townhome'
 
/*Q.Find the number of home loans issued in San Francisco.*/

Select [city], Count(distinct [loan_id]) as No_of_HomeLoans from [dbo].[Home_Loan_Data]
Where [city] like 'San Francisco'
Group by [city]

/*Q. Find the average loan term for loans not for semi-detached and townhome property types, 
and are in the following list of cities: Sparks, Biloxi, Waco, Las Vegas, and Lansing.*/

Select City ,Avg([loan_term])as Avg_LoanTerm from [dbo].[Home_Loan_Data] 
where [property_type] not in ('semi-detached','townhome') and [city] in ('Sparks', 'Biloxi', 'Waco', 'Las Vegas', 'Lansing')
group by city

--Task 3

/*Q. Find the top 3 transaction dates (and corresponding loan amount sum) 
for which the sum of loan amount issued on that date is the highest.*/ 

Select top 3 l.[transaction_date], SUM(h.property_value * h.loan_percent / 100) as Loan_Amount from [dbo].[Loan_Records_Data] as l join
[dbo].[Home_Loan_Data] as h on l.loan_id=h.loan_id where l.transaction_date is not null
Group by l.transaction_date
Order by Loan_Amount desc

/*Q.Create a stored procedure called `city_and_above_loan_amt` that takes in two parameters (city_name, loan_amt_cutoff)
that returns the full details of customers with loans for properties in the input city and with 
loan amount greater than or equal to the input loan amount cutoff.*/  
  
Create Procedure city_and_above_loan_amt
@city_name VARCHAR(255), @loan_amt_cutoff DECIMAL(10, 2)
As
Begin
Select c.*, h.*, l.* From  [dbo].[Customer_Data] as c
Join [dbo].[Loan_Records_Data] as l on c.customer_id = l.customer_id
Join [dbo].[Home_Loan_Data] as h ON l.loan_id = h.loan_id
Where  h.city = @city_name And (h.loan_percent * h.property_value/100) >= @loan_amt_cutoff
End

--Call the stored procedure `city_and_above_loan_amt` you created above, based on the city San Francisco and loan amount cutoff of $1.5 million

Execute city_and_above_loan_amt 'San Francisco', 1500000

/*Q. Find the ID, first name and last name of customers with properties of value between $1.5 and $1.9 million, 
along with a new column 'tenure' that categorizes how long the customer has been with WBG. 
The 'tenure' column is based on the following logic:
Long: Joined before 1 Jan 2015
Mid: Joined on or after 1 Jan 2015, but before 1 Jan 2019
Short: Joined on or after 1 Jan 2019*/

Select c.customer_id, c.first_name, c.last_name,
Case
When c.customer_since < '2015-01-01' then 'Long'
When c.customer_since >= '2015-01-01' AND c.customer_since < '2019-01-01' then  'Mid'
When c.customer_since >= '2019-01-01' then  'Short'
Else 'Unknown'
End as tenure From [dbo].[Customer_Data] as c
Join [dbo].[Loan_Records_Data] as l on c.customer_id = l.customer_id 
join [dbo].[Home_Loan_Data] as h on l.loan_id=h.loan_id
Where h.property_value Between 1500000 and 1900000

/*Q. Find the sum of the loan amounts ((i.e., property value x loan percent / 100) for each banker ID,
excluding properties based in the cities of Dallas and Waco. 
The sum values should be rounded to nearest integer.*/

SELECT b.banker_id, ROUND(SUM(h.property_value * h.loan_percent / 100), 0) AS sum_loan_amount
FROM [dbo].[Home_Loan_Data] as h  join [dbo].[Loan_Records_Data] as l on h.loan_id=l.loan_id
join [dbo].[Banker_Data] as b on b.banker_id=l.banker_id
WHERE h.city NOT IN ('Dallas', 'Waco')
GROUP BY b.banker_id

/*Q. Find the ID and full name (first name concatenated with last name) of customers 
who were served by bankers aged below 30 (as of 1 Aug 2022).*/

Select c.customer_id, CONCAT(c.first_name, ' ', c.last_name) as full_name
from [dbo].[Customer_Data] as c
Join [dbo].[Loan_Records_Data] as l ON c.customer_id = l.customer_id
Join [dbo].[Banker_Data] as b ON l.banker_id = b.banker_id
Where DATEDIFF(Year,b.dob, '2022-08-01')  < 30

--Q. Find the number of bankers involved in loans where the loan amount is greater than the average loan amount. 

Select COUNT(distinct  b.[banker_id]) as No_of_Bankers from [dbo].[Banker_Data] as b
Join [dbo].[Loan_Records_Data] as l on l.banker_id=b.banker_id 
Join [dbo].[Home_Loan_Data] as h on h.loan_id=l.loan_id
where (h.property_value * h.loan_percent / 100) > (Select AVG(property_value * loan_percent / 100)
from [dbo].[Home_Loan_Data])

/*Q. Create a stored procedure called `recent_joiners` that returns the ID, concatenated full name,
date of birth, and join date of bankers who joined within the recent 2 years (as of 1 Sep 2022) */

Create Procedure recent_joiners
As
Begin
Select  banker_id , CONCAT(first_name, ' ', last_name) AS full_name, dob , date_joined From [dbo].[Banker_Data]
Where date_joined >= DATEADD(YEAR, -2, '2022-09-01')
END
--Call the stored procedure `recent_joiners` you created above 

Execute recent_joiners

--Q. Find the number of Chinese customers with joint loans with property values less than $2.1 million, and served by female bankers.

Select COUNT(distinct c.[customer_id]) as No_of_ChineseCustomers from [dbo].[Customer_Data] as c
join [dbo].[Loan_Records_Data] as l on l.customer_id=c.customer_id 
join [dbo].[Home_Loan_Data] as h on h.loan_id=l.loan_id 
join [dbo].[Banker_Data] as b on b.banker_id=l.banker_id
where h.joint_loan like 'Yes' and h.property_value < 2100000 and b.gender like 'Female' and c.nationality like 'China'

/*Q. Create a view called `dallas_townhomes_gte_1m` which returns all the details of loans involving properties
of townhome type, located in Dallas, and have loan amount of >$1 million.*/

Create View dallas_townhomes_gte_1m 
as
Select c.customer_id, c.first_name, c.last_name, c.nationality, c.dob, c.gender, c.email, c.phone, c.customer_since,
h.loan_id, h.property_type, h.country, h.city, h.property_value, h.loan_percent, h.loan_term, h.postal_code, h.joint_loan,
h.loan_percent*h.property_value/100 as Loan_amount, l.record_id,l.transaction_date
from [dbo].[Customer_Data] as c 
Join [dbo].[Loan_Records_Data] as l on c.customer_id=l.customer_id
Join [dbo].[Home_Loan_Data] as h on h.loan_id=l.loan_id
Where h.property_type like 'Townhome' and h.city like 'Dallas' and h.loan_percent*h.property_value/100 > 1000000

Select * from dallas_townhomes_gte_1m 


