/*The database contains eight tables: 
Customers: Stores customer data including names, contact information, and possibly other details.
Employees: all employee information (names, job titles, contact information, and possibly employee IDs)
Offices: sales office information
Orders: customers' sales orders
OrderDetails: sales order line for each sales order
Payments: customers' payment records
Products: a list of scale model cars
ProductLines: a list of product line categories*/
SELECT 'Customers' AS TableName, 
       13 AS NumberOfAttributes,
       COUNT(*) AS NumberOfRows
  FROM Customers
UNION ALL
SELECT 'Employees', 
       8,
       COUNT(*)
  FROM Employees
UNION ALL
SELECT 'Offices', 
       9,
       COUNT(*)
  FROM Offices
UNION ALL
SELECT 'Orders', 
       7,
       COUNT(*)
  FROM Orders
UNION ALL
SELECT 'OrderDetails', 
       5,
       COUNT(*)
  FROM OrderDetails
UNION ALL
SELECT 'Payments', 
       4,
       COUNT(*)
  FROM Payments
UNION ALL
SELECT 'Products', 
       9,
       COUNT(*)
  FROM Products
UNION ALL
SELECT 'ProductLines', 
       4,
       COUNT(*)
  FROM ProductLines;
  
-- Question 1: Which Products to Order More of
 
--  top 10 low stock (product in demand) 
SELECT productCode,
       ROUND(
         (SELECT SUM(quantityOrdered) / quantityInStock
          FROM OrderDetails
          WHERE OrderDetails.productCode = Products.productCode
          GROUP BY productCode),
       2) AS LowStock
FROM Products
ORDER BY LowStock DESC
LIMIT 10;
 
-- top 10 product performance 
SELECT productCode,
       SUM(quantityOrdered * priceEach) AS ProductPerformance
FROM OrderDetails
GROUP BY productCode
ORDER BY ProductPerformance DESC
LIMIT 10;


-- Combine  low stock and product performance using CTE
WITH LowStockCTE AS (
    SELECT productCode,
           ROUND(
             (SELECT SUM(quantityOrdered) / quantityInStock
              FROM OrderDetails
              WHERE OrderDetails.productCode = Products.productCode
              GROUP BY productCode),
           2) AS LowStock
    FROM Products
),
ProductPerformanceCTE AS (
    SELECT productCode,
           SUM(quantityOrdered * priceEach) AS ProductPerformance
    FROM OrderDetails
    GROUP BY productCode
)
SELECT p.productCode, 
       ls.LowStock,
       pp.ProductPerformance
FROM Products p
JOIN LowStockCTE ls ON p.productCode = ls.productCode
JOIN ProductPerformanceCTE pp ON p.productCode = pp.productCode
WHERE p.productCode IN (
    SELECT productCode
    FROM LowStockCTE
    ORDER BY LowStock DESC
    LIMIT 10
)
ORDER BY (ls.LowStock + pp.ProductPerformance) DESC;

-- Question 2: Match Marketing and Communication Strategies to Customer Behavior

