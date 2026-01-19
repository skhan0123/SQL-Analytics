/* 
Objective:
Identify the top 3 revenue-generating products within each sales territory.

Why this matters:
This pattern is commonly used for leaderboards, regional performance analysis,
and sales optimization decisions.

Key SQL concepts demonstrated:
- Aggregation before windowing
- RANK() vs ROW_NUMBER()
- PARTITION BY for per-group analytics
*/

SELECT *
FROM (
    SELECT 
        st.Name AS Territory,          -- Business dimension: geography
        pr.Name AS ProductName,        -- Business dimension: product
        SUM(sod.LineTotal) AS ProductSales, 
            -- Aggregate revenue at product + territory grain

        RANK() OVER (
            PARTITION BY st.TerritoryID   -- Reset ranking per territory
            ORDER BY SUM(sod.LineTotal) DESC
        ) AS SalesRank
            -- Rank products within each territory by total sales

    FROM Sales.SalesOrderHeader soh
        -- Header table defines order-level attributes

    JOIN Sales.SalesOrderDetail sod
        ON soh.SalesOrderID = sod.SalesOrderID
        -- Join to line items to access revenue

    JOIN Production.Product pr
        ON sod.ProductID = pr.ProductID
        -- Join to product dimension

    JOIN Sales.SalesTerritory st
        ON soh.TerritoryID = st.TerritoryID
        -- Join to territory dimension

    GROUP BY 
        st.TerritoryID,
        st.Name,
        pr.Name
        -- Grouping is required before applying window functions
) ranked_products
WHERE SalesRank <= 3
    -- Filter AFTER window calculation
ORDER BY Territory, SalesRank;
