/*
USE DestinationSystem
SELECT * FROM dimProduct
WHERE dimProduct.ProductCategory LIKE 'Accessories'
SELECT TOP 20 * FROM factSalesActual
SELECT * FROM dimStore
SELECT * from StageTargetProduct
SELECT * FROM factProductSalesTarget
*/

-- ====================================
-- Sales by year and product name
-- ====================================
SELECT dDate.CalendarYear, Product.ProductName, Product.ProductCategory, Product.ProductType, SUM(Sales.SaleAmount) AS 'Yearly Sales'
	, SUM(Sales.SaleExtendedCost) AS 'Yearly Cost', SUM(Sales.SaleTotalProfit) AS 'Yearly Profit'
	, CAST(SUM(Sales.SaleTotalProfit)/SUM(Sales.SaleAmount)*100 AS numeric(5,2)) AS 'Profit Margin'
	, SUM(Sales.SaleQuantity) AS 'Quantity Sold'
FROM factSalesActual AS Sales
LEFT JOIN dimProduct AS Product ON Sales.dimProductKey = Product.dimProductKey
LEFT JOIN DimDate AS dDate ON Sales.dimSaleDateKey = dDate.DimDateKey
WHERE Product.ProductCategory LIKE 'Womens Apparel'
	OR Product.ProductCategory LIKE 'Accessories'
GROUP BY dDate.CalendarYear, Product.ProductName, Product.ProductCategory, Product.ProductType
ORDER BY Product.ProductName, dDate.CalendarYear

-- ====================================
-- Sales by month and product name
-- ====================================
SELECT dDate.MonthNumberOfYear, dDate.[MonthName], dDate.CalendarYear, Product.ProductName, SUM(Sales.SaleAmount) AS 'Monthly Sales'
FROM factSalesActual AS Sales
LEFT JOIN dimProduct AS Product ON Sales.dimProductKey = Product.dimProductKey
LEFT JOIN DimDate AS dDate ON Sales.dimSaleDateKey = dDate.DimDateKey
WHERE Product.ProductCategory LIKE 'Womens Apparel'
	OR Product.ProductCategory LIKE 'Accessories'
GROUP BY dDate.CalendarYear, dDate.MonthNumberOfYear, Product.ProductName, dDate.[MonthName]
ORDER BY Product.ProductName, dDate.CalendarYear, dDate.MonthNumberOfYear

-- ====================================
-- Sales by day of the week and product name
-- ====================================
SELECT dDate.DayNumberOfWeek, dDate.DayNameOfWeek, dDate.CalendarYear, Product.ProductName, SUM(Sales.SaleAmount) AS 'Daily Sales'
FROM factSalesActual AS Sales
LEFT JOIN dimProduct AS Product ON Sales.dimProductKey = Product.dimProductKey
LEFT JOIN DimDate AS dDate ON Sales.dimSaleDateKey = dDate.DimDateKey
WHERE Product.ProductCategory LIKE 'Womens Apparel'
	OR Product.ProductCategory LIKE 'Accessories'
GROUP BY dDate.CalendarYear, dDate.DayNumberOfWeek, Product.ProductName, dDate.DayNameOfWeek
ORDER BY Product.ProductName, dDate.CalendarYear, dDate.DayNumberOfWeek

-- ====================================
-- Targets by year and product name
-- ====================================
SELECT dDate.CalendarYear, Product.ProductName, SUM(SalesTarget.ProductTargetSalesQuantity) AS 'Yearly Target'
FROM factProductSalesTarget AS SalesTarget
LEFT JOIN dimProduct AS Product ON SalesTarget.dimProductKey = Product.dimProductKey
LEFT JOIN DimDate AS dDate ON SalesTarget.dimTargetDateKey = dDate.DimDateKey
WHERE Product.ProductCategory LIKE 'Womens Apparel'
	OR Product.ProductCategory LIKE 'Accessories'
GROUP BY Product.ProductName, dDate.CalendarYear
ORDER BY Product.ProductName, dDate.CalendarYear

-- ====================================
-- Sales and Targets by year and product name
-- ====================================
SELECT dDate.CalendarYear, Product.ProductName, Product.ProductCategory, Product.ProductType, SUM(Sales.SaleAmount) AS 'Yearly Sales'
	, SUM(Sales.SaleExtendedCost) AS 'Yearly Cost', SUM(Sales.SaleTotalProfit) AS 'Yearly Profit'
	, CAST(SUM(Sales.SaleTotalProfit)/SUM(Sales.SaleAmount)*100 AS numeric(5,2)) AS 'Profit Margin'
	, SUM(Sales.SaleQuantity) AS 'Quantity Sold'
	, subq1.[Yearly Target]
FROM factSalesActual AS Sales
LEFT JOIN dimProduct AS Product ON Sales.dimProductKey = Product.dimProductKey
LEFT JOIN DimDate AS dDate ON Sales.dimSaleDateKey = dDate.DimDateKey
LEFT JOIN (
	SELECT dDate.CalendarYear, Product.ProductName, SUM(SalesTarget.ProductTargetSalesQuantity) AS 'Yearly Target'
	FROM factProductSalesTarget AS SalesTarget
	LEFT JOIN dimProduct AS Product ON SalesTarget.dimProductKey = Product.dimProductKey
	LEFT JOIN DimDate AS dDate ON SalesTarget.dimTargetDateKey = dDate.DimDateKey
	WHERE Product.ProductCategory LIKE 'Womens Apparel'
		OR Product.ProductCategory LIKE 'Accessories'
	GROUP BY Product.ProductName, dDate.CalendarYear
	) AS subq1 ON Product.ProductName = subq1.ProductName
WHERE Product.ProductCategory LIKE 'Womens Apparel'
	OR Product.ProductCategory LIKE 'Accessories'
GROUP BY dDate.CalendarYear, Product.ProductName, Product.ProductCategory, Product.ProductType, subq1.ProductName, subq1.[Yearly Target]
ORDER BY Product.ProductName, dDate.CalendarYear