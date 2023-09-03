USE [Onlinestore]
GO

/****** Object:  View [Report].[LooksDetails]    Script Date: 03/09/2023 10:07:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [Report].[LooksDetails]
AS
SELECT ROW_NUMBER() over (ORDER BY L.[lookId]) as [Row Number],
l.LOokId, 
l.SKU,
l.ProductId,
l.OptionId,
convert (date,l.[LookCreatedDateTime]) as lookcreateDate,
l.Location,
count(s.sku) as TotalStyiling
from Report.Looks l
left join report.Stylingitems s
on l.lookid=s.lookid
group by 
l.LOokId, 
l.SKU,
l.ProductId,
l.OptionId,
convert (date,l.LookCreatedDateTime),
l.location
GO


