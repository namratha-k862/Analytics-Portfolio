Select * from loandatacsv;

-- 1. Total Loan Amount Funded 

SELECT SUM(Funded_Amount) AS Total_Loan_Amount_Funded
FROM loandatacsv;

-- 2. Total Loans

SELECT COUNT(*) AS Total_Loans
FROM loandataCSV;

-- 3. Total Collection 

SELECT SUM(Total_Pymnt_Inv) AS Total_Collection
FROM loandatacsv;

-- 4. Average Interest

SELECT avg(Int_Rate*100) AS AVEREGE_INTEREST_PERCENTAGE
FROM loandataCSV;

-- 5. Branch-Wise Performance

SELECT Branch_Name, 
       SUM(Total_Rrec_int) AS Total_Interest,
       SUM(Total_Fees) AS Total_Fees,
       SUM(Total_Rec_Prncp) AS Total_Principal,
       SUM(Total_Rrec_int + Total_Fees + Total_Rec_Prncp) AS Total_Revenue
FROM loandatacsv
GROUP BY Branch_Name;

-- 6. State-Wise Loan
SELECT State_Name, COUNT(*), SUM(Funded_Amount) AS Total_Loans
FROM loandatacsv
WHERE State_Name IS NOT NULL  
GROUP BY State_Name;

-- 7. Religion-Wise Loan

SELECT Religion, COUNT(*), SUM(Funded_Amount) AS Total_Loans
FROM loandatacsv
WHERE Religion IS NOT NULL  
GROUP BY Religion;

-- 8. Product-Wise Loan Distribution 

SELECT Product_Code, COUNT(*), SUM(Funded_Amount) AS Total_Loans
FROM loandataCSV
GROUP BY Product_Code;

-- 9. Disbursment Trend

SELECT Disbursement_Date_Years, COUNT(*), SUM(Funded_Amount) AS Total_Loans
FROM loandataCSV
GROUP BY Disbursement_Date_Years;

-- 10. Grade-Wise Loan Distribution

SELECT Grade, COUNT(*), SUM(Funded_Amount) AS Total_Loans
FROM loandataCSV
WHERE Grade IS NOT NULL  
GROUP BY Grade;

-- 11. Total Default Loan 

SELECT Is_Default_Loan, COUNT(*), SUM(Funded_Amount) AS Total_Loans
FROM loandataCSV
WHERE Is_Default_Loan = "y";

-- 12. Total Deliquent Loan

SELECT Is_Delinquent_Loan, COUNT(*), SUM(Funded_Amount) AS Total_Loans
FROM loandataCSV
WHERE Is_Delinquent_Loan = "y";

-- 13. Default Loan Rate

SELECT (COUNT(CASE WHEN Is_Default_Loan = "y"  THEN 1 END) * 100.0 / COUNT(*)) AS Default_loan_rate
FROM loandataCSV;

-- 14. Deliquent Loan Rate

SELECT (COUNT(CASE WHEN Is_Delinquent_Loan = "N"  THEN 1 END) * 100.0 / COUNT(*)) AS Deliquent_loan_rate
FROM loandataCSV;

-- 15. Loan Status_Wise Loan Distribution

SELECT Loan_Status, COUNT(*), SUM(Funded_Amount) AS Total_Loans
FROM loandataCSV
WHERE Loan_Status IS NOT NULL  
GROUP BY Loan_Status;

-- 16. Age-Wise Loan Distribution

SELECT Age, COUNT(*), SUM(Funded_Amount) AS Total_Loans
FROM loandataCSV
WHERE Age IS NOT NULL  
GROUP BY Age;

-- 17. Verification Status

SELECT Verification_Status,COUNT(*), SUM(Funded_Amount) AS Total_Loans
FROM loandataCSV
WHERE Verification_Status IS NOT NULL  
GROUP BY Verification_Status;

-- 18. Loan Maturity 

SELECT Account_ID, Disbursement_Date, Maturity_Date,                               
DATEDIFF ( Maturity_Date , Disbursement_Date ) AS Loan_Maturity
FROM loandataCSV;


