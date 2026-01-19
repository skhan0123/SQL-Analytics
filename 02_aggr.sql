-- Total spend and order count per customer

SELECT 
    c.CustomerID,
    p.FirstName + ' ' + p.LastName AS CustomerName,
    SUM(sod.LineTotal) AS TotalSpent,
    COUNT(DISTINCT soh.SalesOrderID) AS OrdersPlaced
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod
    ON soh.SalesOrderID = sod.SalesOrderID
JOIN Sales.Customer c
    ON soh.CustomerID = c.CustomerID
JOIN Person.Person p
    ON c.PersonID = p.BusinessEntityID
GROUP BY c.CustomerID, p.FirstName, p.LastName
HAVING SUM(sod.LineTotal) > 1000
ORDER BY TotalSpent DESC;
