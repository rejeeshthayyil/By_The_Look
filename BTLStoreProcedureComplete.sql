DECLARE @LooksEventFeed [Report].[udtProductIdentification] 
begin 
--insert data into table variable
INSERT INTO @LooksEventFeed
VALUES
(

/*[LookId]					*/112,
/*[HeroSKU]					*/'sku26',
/*[HeroOptionId]			*/10000,
/*[HeroProductId]			*/15000,
/*[Location]				*/'GLH',
/*[EventDateTimeStamp]		*/GETDATE(),
/*[EventTypeId]				*/60,
/*[LastUsedDateTime]		*/GETDATE(),
/*[LastUpdatedBy]			*/'Rejeesh',
/*[LookCreatedDateTime]		*/GETDATE(),
/*[StylingSKU]				*/'SSku31',
/*[StylingOptionId]			*/20000,
/*[StylingProductId]		*/25000
)
,
(
/*[LookId]					*/112,
/*[HeroSKU]					*/'sku26',
/*[HeroOptionId]			*/10000,
/*[HeroProductId]			*/15000,
/*[Location]				*/'GLH',
/*[EventDateTimeStamp]		*/GETDATE(),
/*[EventTypeId]				*/60,
/*[LastUsedDateTime]		*/GETDATE(),
/*[LastUpdatedBy]			*/'Rejeesh',
/*[LookCreatedDateTime]		*/GETDATE(),
/*[StylingSKU]				*/'SSku33',
/*[StylingOptionId]			*/20000,
/*[StylingProductId]		*/25000

)
--create proc ETL.usproductIdentification @looksEventFeed [Report].[udtProductIdentification]
--AS
--BEGIN
--Assiging Values to @Source Variables
	
DECLARE @SourceLookId varchar (50) ;
DECLARE @SourceHeroProductSKU varchar (50);
DECLARE @SourceEventTypeId int;
--Declareing target variables

DECLARE @TargetLookId varchar (50);
DECLARE @TargetHereoProductSKU varchar(50);

--Assiging values to @source variables
SELECT DISTINCT @SourceLookId=LookId,
				@SourceEventTypeId=EventTypeId
				from @LooksEventFeed;
	
	--Assigning values to @target variables
SELECT DISTINCT @TargetLookId=ISNULL(LookId,0),
				@TargetHereoProductSKU=ISNULL(SKU,0)
				from Report.Looks
				WHERE LookId=@SourceLookId;
				IF OBJECT_ID('tempdb..#LooksEvent') IS NOT NULL
    DROP TABLE #LooksEvent;
--inseret data from the udt to the temp table

SELECT LookId,
       HeroSKU,
       HeroOptionId,
       HeroProductId,
       Location,
       LastUsedDateTime,
       LastUpdatedBy,
       LookCreatedDateTime,
       EventDateTimeStamp,
       StylingSKU,
       StylingOptionId,
       StylingProductId
INTO #LooksEvent
FROM @LooksEventFeed;



IF @SourceEventTypeId = 60
BEGIN
--delete existing record with the same lookid
    DELETE FROM Report.Looks
    WHERE LookId IN (SELECT LookId FROM #LooksEvent);
	
	--insert the last record from temp table into the report.looks table
	
	INSERT INTO Report.Looks
        (LookId,
         SKU,
         OptionId,
         ProductId,
         Location,
         LastUpdatedBy,
         LastUpdatedDateTime,
         LookCreatedDateTime,
		 lastUsedDateTime
        )
    SELECT TOP 1
        LookId,
        HeroSKU,
        HeroOptionId,
        HeroProductId,
        Location,
        LastUpdatedBy,
        GETDATE(),
        LookCreatedDateTime,
		LastUsedDateTime
    FROM #LooksEvent
    ORDER BY LookCreatedDateTime DESC;

	-- insert all record from styling table with the incoming lookid

	 INSERT INTO Report.StylingItems
        (LookId,
         SKU,
         OptionId,
         ProductId,
         LastUsedDateTime,
         LastUpdatedBy,
		 LastUpdatedDateTime
        )
    SELECT 
        LookId,
        StylingSKU,
        StylingOptionId,
        StylingProductId,
        LastUsedDateTime,
        LastUpdatedBy,
		GETDATE()
    FROM #LooksEvent;
END

ELSE IF @SourceEventTypeId = 61
BEGIN
    DELETE FROM Report.StylingItems
    WHERE LookId IN (SELECT LookId FROM #LooksEvent);

    DELETE FROM Report.Looks
    WHERE LookId IN (SELECT LookId FROM #LooksEvent);
	
	DELETE FROM Report.Looks
	WHERE LookId=@SourceLookId;

END;
END;


----drop temp table
--DROP TABLE #LooksEvent;
--END
GO







