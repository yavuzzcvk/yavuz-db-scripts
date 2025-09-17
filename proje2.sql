-- Bu �al��ma microsoft'un  ContosoRetaildDW adl� veri taban� kullan�larak yap�lm��t�r 
-- CTE-Windowfunctions ve SUM fonksiyonu kullan�lm��t�r 
-- Amac� = Her bir kategorinin en �ok ciro yapan �r�nlerini azalan �ekilde s�ralamak 

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
		-- Ana sorgunun amac� sadece tablo ba�l�klar�n� vermek ve rownumber ile verilen numaralar�  filtrelemek
	FROM
		Categorys 
	WHERE
	  RowNum <= 5
	   
	




