-- Bu �al��ma Microsoftun ContosoRetailDW veritaban� kullan�larak haz�rlanm��t�r 
-- FactOnlineSales, DimCustomer, DimDate tablolar� kullan�ld� 
-- �al��man�n amac� : Her bir m��terinin ilk ve son sipari� tarihlerini listeleyip herhangi bir m��terinin ne zamand�r bizimle oldu�unu g�rebiliyoruz 
                     --   Ve her m��teriyi total harcamas�na g�re  'bronz, g�m��,alt�n,elmas' class  lar�nda s�n�fland�r�yoruz 
-- Bu sorgu CTE  kullan�lmadanda yaz�labilir fakat okunabilirlik ve hata ay�klama kolayl��� i�in bu yolu tercih ettim 

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
		DATEDIFF(DAY,FirstDate,LastDate) as  LifeTimeDays,    -- �lk ve son sipari� tarihi aras�ndaki fark� bulan fonksiyon 
		CASE 
			WHEN TotalSales BETWEEN 0 AND 20000 THEN 'Bronz'
			WHEN TotalSales BETWEEN 20000 AND  50000 THEN 'G�m��'
			WHEN TotalSales BETWEEN 50000 AND  70000 THEN  'Alt�n'
			ELSE 'Elmas'
			end as CustomerSegment
	FROM 
		CustomerSales
	ORDER BY
		TotalSales asc   
		
		

	



