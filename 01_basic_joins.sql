-- Customer orders with product and territory details

SELECT 
    c.CustomerID,
    p.FirstName + ' ' + p.LastName AS CustomerName,
    soh.SalesOrderID,
    soh.OrderDate,
    pr.Name AS ProductName,
    sod.OrderQty,
    sod.LineTotal,
    st.Name AS Territory
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod
    ON soh.SalesOrderID = sod.SalesOrderID
JOIN Sales.Customer c
    ON soh.CustomerID = c.CustomerID
JOIN Person.Person p
    ON c.PersonID = p.BusinessEntityID
JOIN Production.Product pr
    ON sod.ProductID = pr.ProductID
JOIN Sales.SalesTerritory st
    ON soh.TerritoryID = st.TerritoryID
WHERE soh.OrderDate >= '2025-01-01';
