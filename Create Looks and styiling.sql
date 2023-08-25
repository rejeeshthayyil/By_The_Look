create table Report.Looks
(LookId int primary key not null,
SKU varchar (50) not null,
OptionId bigint not null,
ProductId bigint not null,
Location varchar(50)not null,
LastUpdatedBy varchar (50) not null,
LastUpdatedDateTime DATETIME not null,
LookCreatedDateTime DATETIME not null,
)


create table Report.StylingItems
(LookId int  foreign key references Report.Looks(LookId) not null,
SKU varchar (50) not null,
OptionId bigint not null,
ProductId bigint not null,
LastUsedDateTime DATETIME not null,
LastUpdatedBy varchar (50),
LastUpdatedDateTime DATETIME,
primary key (LookId,SKU));


create type Report.udtProductIdentification AS TABLE 
(LookId int not null,
HeroSKU varchar (50) not null,
HeroOptionId bigint not null,
HeroProductId bigint not null,
Location varchar(50)not null,
EventDateTimeStamp DATETIME not null,
EventTypeId int not null,
LastUsedDateTime DATETIME not null,
LastUpdatedBy varchar (50) not null,
LookCreatedDateTime DATETIME not null,
StylingSKU varchar (50) not null,
StylingOptionId bigint not null,
StylingProductId bigint not null

)
