
-- Bu �al��mada  Microsoft'un  �cretsiz veri tabanlar�ndan  **ContosoRetailDW** kullan�ld� 
-- Y�l ve Ayl�k bazda  sat�� toplamlar�n� bir �nceki ay ile kar��la�t�rmak ve aralar�ndaki pozitif veya negatif b�y�me oran�n� hesaplamak amac� ile yap�ld� 


	WITH MonthlySales  as (
	 -- Ayl�k sat��lar�n tutuldu�u cte
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
		LAG(TotalSales,1,0) OVER ( ORDER BY SalesYear, SalesMonth ) as LastMonth,  -- Ge�en ay�n toplam sat�� verisi 
		(TotalSales - LAG(TotalSales,1,0) OVER ( ORDER BY SalesYear, SalesMonth ) ) / NULLIF(LAG(TotalSales,1,0) OVER ( ORDER BY SalesYear, SalesMonth ),0) as GrowthRate
		-- B�y�me oran� i�in (nullif) payda k�sm�  0 olursa bunu null olarak g�stermesini sa�layacak 
	FROM 
		MonthlySales
	ORDER BY
		SalesYear, SalesMonth

