/*
jad76
USE DestinationSystem
SELECT * FROM dimProduct
WHERE dimProduct.ProductCategory LIKE 'Accessories'
SELECT TOP 20 * FROM factSalesActual
SELECT * FROM dimStore
SELECT * from StageTargetProduct
SELECT * FROM factProductSalesTarget
WHERE dimproductkey = 13
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
GO
-- ====================================
-- Sales by month and product name
-- ====================================
SELECT dDate.MonthNumberOfYear, dDate.[MonthName], dDate.CalendarYear, Product.ProductName, Product.ProductCategory, Product.ProductType
	, SUM(Sales.SaleAmount) AS 'Monthly Sales'
	, SUM(Sales.SaleExtendedCost) AS 'Monthly Cost', SUM(Sales.SaleTotalProfit) AS 'Monthly Profit'
	, CAST(SUM(Sales.SaleTotalProfit)/SUM(Sales.SaleAmount)*100 AS numeric(5,2)) AS 'Profit Margin'
	, SUM(Sales.SaleQuantity) AS 'Quantity Sold'
FROM factSalesActual AS Sales
LEFT JOIN dimProduct AS Product ON Sales.dimProductKey = Product.dimProductKey
LEFT JOIN DimDate AS dDate ON Sales.dimSaleDateKey = dDate.DimDateKey
WHERE Product.ProductCategory LIKE 'Womens Apparel'
	OR Product.ProductCategory LIKE 'Accessories'
GROUP BY dDate.CalendarYear, Product.ProductName, dDate.MonthNumberOfYear, dDate.[MonthName], Product.ProductCategory, Product.ProductType
ORDER BY Product.ProductName, dDate.CalendarYear, dDate.MonthNumberOfYear
GO
-- ====================================
-- Sales by day of the week and product name
-- ====================================
SELECT dDate.DayNumberOfWeek, dDate.DayNameOfWeek, dDate.CalendarYear, Product.ProductName, SUM(Sales.SaleAmount) AS 'Daily Sales'
	, SUM(Sales.SaleExtendedCost) AS 'Daily Cost', SUM(Sales.SaleTotalProfit) AS 'Daily Profit'
	, CAST(SUM(Sales.SaleTotalProfit)/SUM(Sales.SaleAmount)*100 AS numeric(5,2)) AS 'Profit Margin'
	, SUM(Sales.SaleQuantity) AS 'Quantity Sold'
FROM factSalesActual AS Sales
LEFT JOIN dimProduct AS Product ON Sales.dimProductKey = Product.dimProductKey
LEFT JOIN DimDate AS dDate ON Sales.dimSaleDateKey = dDate.DimDateKey
WHERE Product.ProductCategory LIKE 'Womens Apparel'
	OR Product.ProductCategory LIKE 'Accessories'
GROUP BY dDate.CalendarYear, dDate.DayNumberOfWeek, Product.ProductName, dDate.DayNameOfWeek
ORDER BY Product.ProductName, dDate.CalendarYear, dDate.DayNumberOfWeek
GO
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
GO
-- ====================================
-- Targets by month and product name
-- ====================================
SELECT dDate.CalendarYear, dDate.[MonthName], Product.ProductName, SUM(SalesTarget.ProductTargetSalesQuantity) AS 'Monthly Target'
FROM factProductSalesTarget AS SalesTarget
LEFT JOIN dimProduct AS Product ON SalesTarget.dimProductKey = Product.dimProductKey
LEFT JOIN DimDate AS dDate ON SalesTarget.dimTargetDateKey = dDate.DimDateKey
WHERE Product.ProductCategory LIKE 'Womens Apparel'
	OR Product.ProductCategory LIKE 'Accessories'
GROUP BY Product.ProductName, dDate.CalendarYear, dDate.MonthNumberOfYear, dDate.[MonthName]
ORDER BY Product.ProductName, dDate.CalendarYear, dDate.MonthNumberOfYear
GO
-- ====================================
-- Targets by day and product name
-- ====================================
SELECT dDate.CalendarYear, dDate.DayNameOfWeek, Product.ProductName, SUM(SalesTarget.ProductTargetSalesQuantity) AS 'Daily Target'
FROM factProductSalesTarget AS SalesTarget
LEFT JOIN dimProduct AS Product ON SalesTarget.dimProductKey = Product.dimProductKey
LEFT JOIN DimDate AS dDate ON SalesTarget.dimTargetDateKey = dDate.DimDateKey
WHERE Product.ProductCategory LIKE 'Womens Apparel'
	OR Product.ProductCategory LIKE 'Accessories'
GROUP BY Product.ProductName, dDate.CalendarYear, dDate.DayNumberOfWeek, dDate.DayNameOfWeek
ORDER BY dDate.CalendarYear, Product.ProductName, dDate.DayNumberOfWeek
GO
-- ====================================
-- Sales and Targets by year and product name - works!
-- ====================================
--CREATE VIEW [dbo].[viewYearlySalesAndTargets]
--AS
SELECT dDate.CalendarYear, Product.ProductName, Product.ProductCategory, Product.ProductType, SUM(Sales.SaleAmount) AS 'Yearly Sales'
	, SUM(Sales.SaleExtendedCost) AS 'Yearly Cost', SUM(Sales.SaleTotalProfit) AS 'Yearly Profit'
	, CAST(SUM(Sales.SaleTotalProfit)/SUM(Sales.SaleAmount)*100 AS numeric(5,2)) AS 'Profit Margin'
	, SUM(Sales.SaleQuantity) AS 'Quantity Sold'
	, subq1.[Yearly Target] AS 'Yearly Quantity Target'
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
		AND dDate.CalendarYear = subq1.CalendarYear
WHERE Product.ProductCategory LIKE 'Womens Apparel'
	OR Product.ProductCategory LIKE 'Accessories'
GROUP BY dDate.CalendarYear, Product.ProductName, Product.ProductCategory, Product.ProductType, subq1.ProductName, subq1.[Yearly Target]
ORDER BY Product.ProductName, dDate.CalendarYear
GO
-- ====================================
-- Sales and Targets by month and product name - works!
-- ====================================
--CREATE VIEW [dbo].[viewMonthlySalesAndTargets]
--AS
SELECT dDate.MonthNumberOfYear, dDate.[MonthName], dDate.CalendarYear, Product.ProductName, Product.ProductCategory, Product.ProductType
	, SUM(Sales.SaleAmount) AS 'Monthly Sales', SUM(Sales.SaleExtendedCost) AS 'Monthly Cost', SUM(Sales.SaleTotalProfit) AS 'Monthly Profit'
	, CAST(SUM(Sales.SaleTotalProfit)/SUM(Sales.SaleAmount)*100 AS numeric(5,2)) AS 'Profit Margin'
	, SUM(Sales.SaleQuantity) AS 'Quantity Sold', subq1.[Monthly Target]
FROM factSalesActual AS Sales
LEFT JOIN dimProduct AS Product ON Sales.dimProductKey = Product.dimProductKey
LEFT JOIN DimDate AS dDate ON Sales.dimSaleDateKey = dDate.DimDateKey
LEFT JOIN (
	SELECT dDate.CalendarYear, dDate.[MonthName], Product.ProductName, SUM(SalesTarget.ProductTargetSalesQuantity) AS 'Monthly Target'
	FROM factProductSalesTarget AS SalesTarget
	LEFT JOIN dimProduct AS Product ON SalesTarget.dimProductKey = Product.dimProductKey
	LEFT JOIN DimDate AS dDate ON SalesTarget.dimTargetDateKey = dDate.DimDateKey
	WHERE Product.ProductCategory LIKE 'Womens Apparel'
		OR Product.ProductCategory LIKE 'Accessories'
	GROUP BY Product.ProductName, dDate.CalendarYear, dDate.MonthNumberOfYear, dDate.[MonthName]
	) AS subq1 ON Product.ProductName = subq1.ProductName
		AND dDate.CalendarYear = subq1.CalendarYear
		AND dDate.[MonthName] = subq1.[MonthName]
WHERE Product.ProductCategory LIKE 'Womens Apparel'
	OR Product.ProductCategory LIKE 'Accessories'
GROUP BY dDate.CalendarYear, dDate.MonthNumberOfYear, Product.ProductName, dDate.[MonthName], Product.ProductCategory, Product.ProductType
	, subq1.[Monthly Target]
ORDER BY Product.ProductName, dDate.CalendarYear, dDate.MonthNumberOfYear
GO
-- ====================================
-- Sales and targets by day of the week and product name
-- ====================================
--CREATE VIEW [dbo].[viewDailySalesAndTargets]
--AS
SELECT dDate.DayNumberOfWeek, dDate.DayNameOfWeek, dDate.CalendarYear, Product.ProductName, SUM(Sales.SaleAmount) AS 'Daily Sales'
	, SUM(Sales.SaleExtendedCost) AS 'Daily Cost', SUM(Sales.SaleTotalProfit) AS 'Daily Profit'
	, CAST(SUM(Sales.SaleTotalProfit)/SUM(Sales.SaleAmount)*100 AS numeric(5,2)) AS 'Profit Margin'
	, SUM(Sales.SaleQuantity) AS 'Quantity Sold', subq1.[Daily Target]
FROM factSalesActual AS Sales
LEFT JOIN dimProduct AS Product ON Sales.dimProductKey = Product.dimProductKey
LEFT JOIN DimDate AS dDate ON Sales.dimSaleDateKey = dDate.DimDateKey
LEFT JOIN (
	SELECT dDate.CalendarYear, dDate.DayNameOfWeek, Product.ProductName, SUM(SalesTarget.ProductTargetSalesQuantity) AS 'Daily Target'
	FROM factProductSalesTarget AS SalesTarget
	LEFT JOIN dimProduct AS Product ON SalesTarget.dimProductKey = Product.dimProductKey
	LEFT JOIN DimDate AS dDate ON SalesTarget.dimTargetDateKey = dDate.DimDateKey
	WHERE Product.ProductCategory LIKE 'Womens Apparel'
		OR Product.ProductCategory LIKE 'Accessories'
	GROUP BY Product.ProductName, dDate.CalendarYear, dDate.DayNumberOfWeek, dDate.DayNameOfWeek
	) AS subq1 ON Product.ProductName = subq1.ProductName
		AND dDate.CalendarYear = subq1.CalendarYear
		AND dDate.DayNameOfWeek = subq1.DayNameOfWeek
WHERE Product.ProductCategory LIKE 'Womens Apparel'
	OR Product.ProductCategory LIKE 'Accessories'
GROUP BY dDate.CalendarYear, dDate.DayNumberOfWeek, Product.ProductName, dDate.DayNameOfWeek, subq1.[Daily Target]
ORDER BY Product.ProductName, dDate.CalendarYear, dDate.DayNumberOfWeek
GO