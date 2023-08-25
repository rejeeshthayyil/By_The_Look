

DECLARE @LooksEventFeed [Report].[udtProductIdentification] 
begin 
--insert data into table variable
INSERT INTO @LooksEventFeed
VALUES
(

/*[LookId]					*/107,
/*[HeroSKU]					*/'sku25',
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
),
(
/*[LookId]					*/107,
/*[HeroSKU]					*/'sku25',
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

-- CREATE PROCEDURE [ETL].[SpProductIdentification]
--    @LooksEventFeed [Report].[udtProductIdentification] READONLY
--AS
--BEGIN
--    SET NOCOUNT ON;
	-- DECLARE variables
	DECLARE @LastUpdatedDateTimeStamp DATETIME =GETDATE();

	--DECLARE SOURCE VARIABLE
	DECLARE @SourceLookId int						;
	DECLARE @SourceHeroSKU varchar (50) 			;
	DECLARE @SourceHeroOptionId bigint  			;
	DECLARE @SourceHeroProductId bigint 			;
	DECLARE @SourceLocation varchar(50)			;
	DECLARE @SourceLastUpdatedBy varchar (50)   ;
	DECLARE @SourceLookCreatedDateTime DATETIME ;
	DECLARE @SourceEventDateTimeStamp DATETIME  ;
	DECLARE @SourceEventTypeId int				;
	DECLARE @SourceStylingSKU varchar (50) 			;
	DECLARE @SourceStylingOptionId bigint  			;
	DECLARE @SourceStylingProductId bigint 


	--Assigning Values to @Source Variable

	DECLARE @CurrentRecordIndex INT = 1;
DECLARE @TotalRecords INT = (SELECT COUNT(*) FROM @LooksEventFeed);

WHILE @CurrentRecordIndex <= @TotalRecords
BEGIN
    -- Assign values from the current record to variables
    SELECT @SourceLookId = LookId,
           @SourceEventTypeId = EventTypeId
    FROM @LooksEventFeed
    WHERE RowNumber = @CurrentRecordIndex; -- Adjust this based on your actual field names

--SELECT DISTINCT @SourceLookId=LookId,
--	@SourceEventTypeId= EventTypeId
--	FROM @LooksEventFeed;
--	Print @SourceLookId;

	-- DECLARE TARGET VARIABLE
	DECLARE @TargetLookId int					;
	DECLARE @TargetHeroSKU varchar (50) 			;
	DECLARE @TargetHeroOptionId bigint  			;
	DECLARE @TargetHeroProductId bigint 			;
	DECLARE @TargetLocation varchar(50)			;
	DECLARE @TargetLastUpdatedBy varchar (50)   ;
	DECLARE @TargetLookCreatedDateTime DATETIME ;
	DECLARE @TargetEventDateTimeStamp DATETIME  ;
	DECLARE @TargetEventTypeId int				;
	DECLARE @TargetStylingSKU varchar (50) 			;
	DECLARE @TargetStylingOptionId bigint  			;
	DECLARE @TargetStylingProductId bigint	;

	--- Assigning values to @Target Variables
	SELECT DISTINCT 
	@TargetLookId=ISNULL([LookId],'0')
	FROM Report.Looks
	WHERE LookId=@SourceLookId;

BEGIN TRY
		BEGIN TRANSACTION T1;

		-- Condition to check
		--1. if the lookid already exists in the Looks table and  eventTypeid =60 then delete and insert
		if @SourceLookId=ISNULL(@TargetLookId,'0')
		and @SourceEventTypeId=60


--DELETE FROM Report.StylingItems
--WHERE LookId=@SourceLookId

IF NOT EXISTS (select 1 from @LooksEventFeed 
where lookid=@SourceLookId)

--DELETE FROM Report.Looks
--WHERE LookId=@SourceLookId
BEGIN
INSERT INTO Report.Looks
(LookId,
SKU,
OptionId,
ProductId,
Location,
LastUpdatedBy,
LastUpdatedDateTime,
LookCreatedDateTime
)
select
S.LookId,
S.HeroSKU,
S.HeroOptionId,
S.HeroProductId,
S.Location,
S.LastUpdatedBy,
@LastUpdatedDateTimeStamp,
S.LookCreatedDateTime

FROM @LooksEventFeed S;

SET @CurrentRecordIndex = @CurrentRecordIndex + 1;
END

IF @SourceLookId = ISNULL(@TargetLookId,'0')
		and @SourceEventTypeId=60
---need to insert into styling table as well

begin

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

S.LookId,
S.StylingSKU,
S.StylingOptionId,
S.StylingProductId,
S.LastUsedDateTime,
S.LastUpdatedBy,
@LastUpdatedDateTimeStamp
FROM @LooksEventFeed S

END
---if the lookid doen't match with the @source lookid and the EventTypeid=60 then insert

ELSE IF @SourceLookId<>ISNULL(@TargetLookId,'0')
		and @SourceEventTypeId=60
BEGIN 


INSERT INTO Report.Looks
(LookId,
SKU,
OptionId,
ProductId,
Location,
LastUpdatedBy,
LastUpdatedDateTime,
LookCreatedDateTime
)
select
S.LookId,
S.HeroSKU,
S.HeroOptionId,
S.HeroProductId,
S.Location,
S.LastUpdatedBy,
@LastUpdatedDateTimeStamp,
S.LookCreatedDateTime

FROM @LooksEventFeed S;

--need to insert styling table as well

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
S.LookId,
S.StylingSKU,
S.StylingOptionId,
S.StylingProductId,
S.LastUsedDateTime,
S.LastUpdatedBy,
@LastUpdatedDateTimeStamp
FROM @LooksEventFeed S;

END

--=========================================================

---if the lookId already exist and the eventTypeId =61 then delete

ELSE IF @SourceLookId=ISNULL(@TargetLookId,'0')
and @SourceEventTypeId=61

BEGIN

DELETE FROM Report.StylingItems
WHERE LookId=@SourceLookId

DELETE FROM Report.Looks
where LookId=@SourceLookId


END; 

	COMMIT TRANSACTION T1
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION T1;

	THROW;
END CATCH;

SET NOCOUNT OFF;
END;
GO