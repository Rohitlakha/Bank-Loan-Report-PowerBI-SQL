-- ?? View all records from the loan dataset
SELECT * FROM bank_loan_data;

-- ?? Total number of loan applications
SELECT COUNT(id) AS Total_Loan_Applications FROM bank_loan_data;

-- ?? MTD (Month-To-Date) loan applications for December 2021
SELECT COUNT(id) AS MTD_Total_Loan_Applications 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- ?? PMTD (Previous Month-To-Date) loan applications for November 2021
SELECT COUNT(id) AS PMTD_Total_Loan_Applications 
FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- ?? Total loan amount funded
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM bank_loan_data;

-- ?? MTD funded loan amount for December 2021
SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- ?? PMTD funded loan amount for November 2021
SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount 
FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- ?? Total payment amount received on loans
SELECT SUM(total_payment) AS Total_Amount_Received FROM bank_loan_data;

-- ?? MTD amount received for December 2021
SELECT SUM(total_payment) AS MTD_Total_Amount_Received 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- ?? PMTD amount received for November 2021
SELECT SUM(total_payment) AS PMTD_Total_Amount_Received 
FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- ?? Average interest rate across all loans (as percentage)
SELECT ROUND(AVG(int_rate), 4)*100 AS Avg_Interest_Rate FROM bank_loan_data;

-- ?? MTD average interest rate for December 2021
SELECT AVG(int_rate)*100 AS MTD_Avg_Interest_Rate 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- ?? PMTD average interest rate for November 2021
SELECT AVG(int_rate)*100 AS PMTD_Avg_Interest_Rate 
FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- ?? Average DTI (Debt-To-Income ratio)
SELECT AVG(dti)*100 AS Avg_DTI FROM bank_loan_data;

-- ?? MTD average DTI for December 2021
SELECT AVG(dti)*100 AS MTD_Avg_DTI 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- ?? PMTD average DTI for November 2021
SELECT AVG(dti)*100 AS PMTD_Avg_DTI 
FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- ? Good Loan %: Loans that are either Fully Paid or Current
SELECT
    (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100.0) / 
    COUNT(id) AS Good_Loan_Percentage
FROM bank_loan_data;

-- ? Number of Good Loan applications
SELECT COUNT(id) AS Good_Loan_Applications 
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- ? Total funded amount for Good Loans
SELECT SUM(loan_amount) AS Good_Loan_Funded_amount 
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- ? Total received amount for Good Loans
SELECT SUM(total_payment) AS Good_Loan_amount_received 
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- ? Bad Loan %: Loans that are Charged Off
SELECT
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / 
    COUNT(id) AS Bad_Loan_Percentage
FROM bank_loan_data;

-- ? Number of Bad Loan applications
SELECT COUNT(id) AS Bad_Loan_Applications 
FROM bank_loan_data
WHERE loan_status = 'Charged Off';

-- ? Total funded amount for Bad Loans
SELECT SUM(loan_amount) AS Bad_Loan_Funded_amount 
FROM bank_loan_data
WHERE loan_status = 'Charged Off';

-- ? Total received amount for Bad Loans
SELECT SUM(total_payment) AS Bad_Loan_amount_received 
FROM bank_loan_data
WHERE loan_status = 'Charged Off';

-- ?? Summary of key metrics grouped by Loan Status
SELECT
    loan_status,
    COUNT(id) AS Total_Loan_Application,
    SUM(total_payment) AS Total_Amount_Received,
    SUM(loan_amount) AS Total_Funded_Amount,
    AVG(int_rate * 100) AS Interest_Rate,
    AVG(dti * 100) AS DTI
FROM bank_loan_data
GROUP BY loan_status;

-- ?? MTD metrics grouped by Loan Status (for December)
SELECT 
    loan_status, 
    SUM(total_payment) AS MTD_Total_Amount_Received, 
    SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 
GROUP BY loan_status;

-- ?? Monthly trend of loan applications, funded and received amounts
SELECT 
    MONTH(issue_date) AS Month_Number, 
    DATENAME(MONTH, issue_date) AS Month_name, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY MONTH(issue_date);

-- ??? State-wise loan performance analysis
SELECT 
    address_state AS State, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY address_state
ORDER BY COUNT(id) DESC;

-- ?? Loan analysis by term (e.g., 36 months, 60 months)
SELECT 
    term AS Term, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY term
ORDER BY term;

-- ????? Loan analysis by employee length
SELECT 
    emp_length AS Employee_Length, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY emp_length
ORDER BY emp_length;

-- ?? Purpose-wise loan distribution
SELECT 
    purpose AS PURPOSE, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY purpose
ORDER BY COUNT(id) DESC;

-- ?? Home ownership-wise loan distribution
SELECT 
    home_ownership AS Home_Ownership, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY COUNT(id) DESC;

-- ??? Purpose-wise loan data filtered for Grade A loans
SELECT 
    purpose AS PURPOSE, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
WHERE grade = 'A'
GROUP BY purpose
ORDER BY purpose;

-- ?? Home ownership data for Grade A loans in California
SELECT 
    home_ownership AS Home_Ownership, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
WHERE grade = 'A' AND address_state = 'CA'
GROUP BY home_ownership
ORDER BY COUNT(id) DESC;
