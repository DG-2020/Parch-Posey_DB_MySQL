CREATE TABLE sales_pro(
    Sales_Employee VARCHAR(50) NOT NULL,
    Fiscal_Year INT NOT NULL,
    Sale DECIMAL(14 , 2 ) NOT NULL,
    PRIMARY KEY (Sales_Employee , Fiscal_Year)
);

INSERT INTO sales_pro(Sales_Employee, Fiscal_Year, Sale)
VALUES ('Bob',2016,100),
      ('Bob',2017,150),
      ('Bob',2018,200),
      ('Alice',2016,150),
      ('Alice',2017,100),
      ('Alice',2018,200),
       ('John',2016,200),
      ('John',2017,150),
      ('John',2018,250);

SELECT 
    *
FROM
    sales_pro;

## Aggregate Functions ##
#1. SUM() function returns the total sales of all employees in the recorded years:
SELECT 
    SUM(Sale)
FROM
    sales_pro;

#2. GROUP BY() clause allows us to apply aggregate functions to a subset of rows.
# We may want to calculate the total sales by fiscal years:
SELECT 
    Fiscal_Year, SUM(Sale)
FROM
    sales_pro
GROUP BY Fiscal_Year;

# The following query returns the sales for each employee, along with total sales of the employees by fiscal year:
SELECT 
    Fiscal_Year, Sales_Employee, Sale, SUM(Sale) OVER (PARTITION BY Fiscal_Year) AS Total_Sales
FROM
    sales_pro;
