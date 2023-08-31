	
	create view vmStylingItemUsage
	as
	SELECT			
	S.[SKU]
	,count(s.[LookId]) as TotalLook		
	,S.[ProductId]
	,p.ProductTitle
	,s.[OptionId]	
	,max(s.lastuseddatetime) as datelastused			
	,l.Location
	FROM  [Report].[StylingItems] s
	join Report.Looks L
	on s.LookId=L.LookId
	left join report.DimProduct p
	on s.productId=p.productid
	group by s.SKU,
	s.ProductId,
	s.OptionId,
	L.Location,
	p.ProductTitle

