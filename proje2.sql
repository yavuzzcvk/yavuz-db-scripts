-- Bu çalýþma microsoft'un  ContosoRetaildDW adlý veri tabaný kullanýlarak yapýlmýþtýr 
-- CTE-Windowfunctions ve SUM fonksiyonu kullanýlmýþtýr 
-- Amacý = Her bir kategorinin en çok ciro yapan ürünlerini azalan þekilde sýralamak 

WITH Categorys as ( 
	SELECT
		dpc.ProductCategoryName,
		dp.ProductName,
		SUM(fc.SalesAmount) AS TotalSales,
		ROW_NUMBER() OVER ( PARTITION BY  dpc.ProductCategoryName ORDER BY SUM(fc.SalesAmount)  desc ) as RowNum
	FROM 
		DimProductCategory dpc
	JOIN
		DimProductSubcategory as dps ON dps.ProductCategoryKey = dpc.ProductCategoryKey
	JOIN
		DimProduct as dp ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
	JOIN 
		FactSales as fc ON fc.ProductKey = dp.ProductKey

	GROUP BY 
		dpc.ProductCategoryName,
		dp.ProductName
		)
	
	SELECT
		ProductCategoryName,
		ProductName,
		TotalSales,
		RowNum
		-- Ana sorgunun amacý sadece tablo baþlýklarýný vermek ve rownumber ile verilen numaralarý  filtrelemek
	FROM
		Categorys 
	WHERE
	  RowNum <= 5
	   
	




