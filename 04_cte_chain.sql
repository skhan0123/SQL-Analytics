-- Identify customers buying across multiple categories

WITH CustomerProducts AS (
    SELECT 
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        pc.Name AS CategoryName
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod
        ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Sales.Customer c
        ON soh.CustomerID = c.CustomerID
    JOIN Person.Person p
        ON c.PersonID = p.BusinessEntityID
    JOIN Production.Product pr
        ON sod.ProductID = pr.ProductID
    JOIN Production.ProductSubcategory psc
        ON pr.ProductSubcategoryID = psc.ProductSubcategoryID
    JOIN Production.ProductCategory pc
        ON psc.ProductCategoryID = pc.ProductCategoryID
),
CategoryCounts AS (
    SELECT 
        CustomerID,
        CustomerName,
        COUNT(DISTINCT CategoryName) AS CategoriesBought
    FROM CustomerProducts
    GROUP BY CustomerID, CustomerName
)
SELECT *
FROM CategoryCounts
WHERE CategoriesBought > 2
ORDER BY CategoriesBought DESC;
