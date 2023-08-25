USE [Onlinestore]
GO

/****** Object:  UserDefinedTableType [Report].[udtProductIdentification]    Script Date: 25/08/2023 12:45:43 ******/
CREATE TYPE [Report].[udtProductIdentification] AS TABLE(
	[LookId] [int] NOT NULL,
	[HeroSKU] [varchar](50) NOT NULL,
	[HeroOptionId] [bigint] NOT NULL,
	[HeroProductId] [bigint] NOT NULL,
	[Location] [varchar](50) NOT NULL,
	[EventDateTimeStamp] [datetime] NOT NULL,
	[EventTypeId] [int] NOT NULL,
	[LastUsedDateTime] [datetime] NOT NULL,
	[LastUpdatedBy] [varchar](50) NOT NULL,
	[LookCreatedDateTime] [datetime] NOT NULL,
	[StylingSKU] [varchar](50) NOT NULL,
	[StylingOptionId] [bigint] NOT NULL,
	[StylingProductId] [bigint] NOT NULL
)
GO


