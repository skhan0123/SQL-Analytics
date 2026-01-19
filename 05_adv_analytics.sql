-- Compare customer spend against territory averages

WITH CustomerSales AS (
    SELECT 
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        st.Name AS Territory,
        SUM(sod.LineTotal) AS TotalSpent
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod
        ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Sales.Customer c
        ON soh.CustomerID = c.CustomerID
    JOIN Person.Person p
        ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesTerritory st
        ON soh.TerritoryID = st.TerritoryID
    GROUP BY c.CustomerID, p.FirstName, p.LastName, st.Name
),
TerritoryAvg AS (
    SELECT 
        Territory,
        AVG(TotalSpent) AS AvgTerritorySpent
    FROM CustomerSales
    GROUP BY Territory
)
SELECT 
    cs.CustomerID,
    cs.CustomerName,
    cs.Territory,
    cs.TotalSpent,
    ta.AvgTerritorySpent
FROM CustomerSales cs
JOIN TerritoryAvg ta
    ON cs.Territory = ta.Territory
WHERE cs.TotalSpent > ta.AvgTerritorySpent
ORDER BY cs.Territory, cs.TotalSpent DESC;
