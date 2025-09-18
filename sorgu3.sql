-- Bu çalýþma Microsoftun ContosoRetailDW veritabaný kullanýlarak hazýrlanmýþtýr 
-- FactOnlineSales, DimCustomer, DimDate tablolarý kullanýldý 
-- Çalýþmanýn amacý : Her bir müþterinin ilk ve son sipariþ tarihlerini listeleyip herhangi bir müþterinin ne zamandýr bizimle olduðunu görebiliyoruz 
                     --   Ve her müþteriyi total harcamasýna göre  'bronz, gümüþ,altýn,elmas' class  larýnda sýnýflandýrýyoruz 
-- Bu sorgu CTE  kullanýlmadanda yazýlabilir fakat okunabilirlik ve hata ayýklama kolaylýðý için bu yolu tercih ettim 

WITH CustomerSales as  (
	
	SELECT
		dc.CustomerKey,
		dc.FirstName + ' ' + dc.LastName AS CustomerName,
		SUM(fos.SalesAmount) as TotalSales,
		COUNT(DISTINCT SalesOrderNumber) as TotalOrders,
		MIN(dd.DateKey) as  FirstDate,
		MAX(dd.DateKey) as  LastDate
	FROM 
		FactOnlineSales fos
	JOIN
		DimCustomer as dc ON dc.CustomerKey = fos.CustomerKey
	JOIN 
		DimDate as dd ON dd.DateKey = fos.DateKey
	GROUP BY 
		dc.CustomerKey,dc.FirstName,dc.LastName
		)
	
	SELECT 
		CustomerKey,
		CustomerName,
		TotalSales,
		TotalOrders,
		DATEDIFF(DAY,FirstDate,LastDate) as  LifeTimeDays,    -- Ýlk ve son sipariþ tarihi arasýndaki farký bulan fonksiyon 
		CASE 
			WHEN TotalSales BETWEEN 0 AND 20000 THEN 'Bronz'
			WHEN TotalSales BETWEEN 20000 AND  50000 THEN 'Gümüþ'
			WHEN TotalSales BETWEEN 50000 AND  70000 THEN  'Altýn'
			ELSE 'Elmas'
			end as CustomerSegment
	FROM 
		CustomerSales
	ORDER BY
		TotalSales asc   
		
		

	



