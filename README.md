# SQL-Power-BI---WBG-Loans-Data
You are a data analyst working in the Loans Division of the Personal Financial Services department of a major US bank called West Banking Group (WBG). WBG has been issuing mortgages for home owners across more than 200 cities in the US.

The head of the loans division is keen to take stock of the set of loans issued over the most recent month (Aug 2022) before the upcoming meeting with the CEO. He has a set of questions he would like you to answer as part of the business intelligence reporting and trend analysis ahead of the meeting.

About the dataset:

•	Banker_Data.csv: Employee details of the bankers in the loans division

banker_id: ID of bank employee (banker) - text string 
first_name: First name of banker - text string 
last_name: Last name of banker - text string 
gender: Gender of banker - text string 
phone: Phone number of banker - text string 
dob: Date of Birth of banker - date 
date_joined: Date joined as employee - date 
•	Customer_Data.csv: Details of the home owners issued the home loan from WBG
           customer_id: ID of bank customer (loanee) - integer 
           first_name: First name of customer - text string 
           last_name: Last name of customer - text string 
           email: Email address of customer - text string 
           gender: Gender of customer - text string 
           phone: Phone number of customer - text string 
           dob: Date of Birth of customer - date
           customer_since: Date joined as bank customer - date
           nationality: Nationality of customer - text string

•	Home_Loan_Data.csv: Details of the property for which the home loan is issued
           loan_id: ID of home loan from bank-text string 
           property_type: Type of property (categorical)-text string 
           country: Country of property (default USA)-text string 
           city: City of property -text string 
           property_value: Value of property (US dollars)-integer 
           loan_percent: Percent of property value approved for loan-integer 
           loan_term: Loan term (number of years)-integer 
           postal_code: Postal code of property-integer 
           joint_loan: Whether loan is shared with another person - text_string

•	Loan_Records_Data.csv: Transaction records of the home loans (Aug 2022)
           record_id: ID of the home loan transaction record -integer 
           customer_id: ID of bank customer (loanee) -integer 
           loan_id: ID of home loan from bank -text string 
           banker_id: ID of bank employee (banker)-text string 
           transaction_date: Date of loan approval -date
