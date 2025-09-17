
-- Bu çalýþmada  Microsoft'un  ücretsiz veri tabanlarýndan  **ContosoRetailDW** kullanýldý 
-- Yýl ve Aylýk bazda  satýþ toplamlarýný bir önceki ay ile karþýlaþtýrmak ve aralarýndaki pozitif veya negatif büyüme oranýný hesaplamak amacý ile yapýldý 


	WITH MonthlySales  as (
	 -- Aylýk satýþlarýn tutulduðu cte
	SELECT	
		YEAR(fs.DateKey) as SalesYear,
		MONTH(fs.DateKey) as SalesMonth,
		SUM(fs.SalesAmount) as TotalSales
	FROM 
		FactSales fs
	GROUP BY 
		YEAR(fs.DateKey),
		MONTH(fs.DateKey) 
	)

	SELECT
		SalesYear,SalesMonth,TotalSales,
		LAG(TotalSales,1,0) OVER ( ORDER BY SalesYear, SalesMonth ) as LastMonth,  -- Geçen ayýn toplam satýþ verisi 
		(TotalSales - LAG(TotalSales,1,0) OVER ( ORDER BY SalesYear, SalesMonth ) ) / NULLIF(LAG(TotalSales,1,0) OVER ( ORDER BY SalesYear, SalesMonth ),0) as GrowthRate
		-- Büyüme oraný için (nullif) payda kýsmý  0 olursa bunu null olarak göstermesini saðlayacak 
	FROM 
		MonthlySales
	ORDER BY
		SalesYear, SalesMonth

