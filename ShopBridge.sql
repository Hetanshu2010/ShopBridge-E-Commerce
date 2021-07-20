USE [ShopBridge]
GO
/****** Object:  Table [dbo].[AL_AuditLog]    Script Date: 25-05-2021 08:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AL_AuditLog](
	[AuditLogId] [bigint] NOT NULL,
	[RefId] [bigint] NOT NULL,
	[RefType] [uniqueidentifier] NOT NULL,
	[ActionDesc] [varchar](50) NULL,
	[Comments] [nvarchar](500) NULL,
	[CreatedBy] [varchar](200) NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_AL_AuditLog] PRIMARY KEY CLUSTERED 
(
	[AuditLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CAT_Category]    Script Date: 25-05-2021 08:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CAT_Category](
	[CategoryId] [int] NOT NULL,
	[CategoryName] [varchar](250) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_CAT_Category] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IM_ItemMaster]    Script Date: 25-05-2021 08:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IM_ItemMaster](
	[ItemId] [bigint] NOT NULL,
	[ItemCode] [varchar](50) NULL,
	[ItemName] [varchar](200) NULL,
	[ItemDesc] [varchar](2000) NULL,
	[ItemTypeId] [int] NULL,
	[CategoryId] [int] NULL,
	[HasImage] [bit] NOT NULL,
	[ImageFile] [varchar](500) NULL,
	[Remarks] [nvarchar](1000) NULL,
	[ItemStatus] [int] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedOn] [datetime] NULL,
	[DeletedBy] [varchar](50) NULL,
	[DeletedOn] [datetime] NULL,
 CONSTRAINT [PK_IM_ItemMaster] PRIMARY KEY CLUSTERED 
(
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IT_ItemType]    Script Date: 25-05-2021 08:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IT_ItemType](
	[ItemTypeId] [int] NOT NULL,
	[ItemTypeDesc] [varchar](50) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_IT_ItemType] PRIMARY KEY CLUSTERED 
(
	[ItemTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SM_StockMaster]    Script Date: 25-05-2021 08:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SM_StockMaster](
	[StockId] [bigint] NOT NULL,
	[ItemId] [bigint] NULL,
	[Manufacturer] [varchar](200) NULL,
	[ModelNo] [varchar](100) NULL,
	[InitialQty] [int] NULL,
	[AvailableQty] [int] NULL,
	[ThresholdLevel] [int] NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[StockStatus] [int] NULL,
	[CreatedBy] [varchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [varchar](200) NULL,
	[ModifiedOn] [datetime] NULL,
	[VendorName] [varchar](200) NULL,
	[PONumber] [varchar](50) NULL,
	[PODate] [datetime] NULL,
	[POValue] [decimal](18, 2) NULL,
	[InvoiceNumber] [varchar](50) NULL,
	[InvoiceDate] [datetime] NULL,
	[InvoiceValue] [decimal](18, 2) NULL,
 CONSTRAINT [PK_SM_StockMaster] PRIMARY KEY CLUSTERED 
(
	[StockId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[IM_ItemMaster]  WITH CHECK ADD  CONSTRAINT [FK_IM_ItemMaster_CAT_Category] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[CAT_Category] ([CategoryId])
GO
ALTER TABLE [dbo].[IM_ItemMaster] CHECK CONSTRAINT [FK_IM_ItemMaster_CAT_Category]
GO
/****** Object:  StoredProcedure [dbo].[AuditLog_Create]    Script Date: 25-05-2021 08:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AuditLog_Create]
(
	@refId BIGINT,
	@refType UNIQUEIDENTIFIER,
	@actionDesc VARCHAR(50) = NULL,
	@comments NVARCHAR(500) = NULL,
	@createdBy VARCHAR(200) = NULL
)
AS
BEGIN
	/*
	EXECUTE RequestAuditLog_Create @refId=,@refType=,@actionDesc=,@comments=,@createdBy=
	*/
	
	SET NOCOUNT ON

	DECLARE @maxAuditLogId AS BIGINT

	SELECT @maxAuditLogId=ISNULL(MAX(AuditLogId) , 0) + 1 FROM AL_AuditLog
		
	INSERT  INTO dbo.[AL_AuditLog] (AuditLogId,RefId,RefType,ActionDesc,Comments,CreatedBy,CreatedOn)
	VALUES  (@maxAuditLogId,@refId,@refType,@actionDesc,@comments,@createdBy,GETUTCDATE())
	
	RETURN 0
END




GO
/****** Object:  StoredProcedure [dbo].[Category_GetAll]    Script Date: 25-05-2021 08:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Category_GetAll]
	
AS
BEGIN
	
	SELECT	CAT.CategoryId, CAT.CategoryName
	FROM	CAT_Category CAT
	WHERE	CAT.IsActive = 1	

	RETURN 0
END


GO
/****** Object:  StoredProcedure [dbo].[Item_ById]    Script Date: 25-05-2021 08:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Item_ById]
	@itemId BIGINT
AS
BEGIN
	/*
	EXECUTE Item_ById 21
	*/

	SELECT	IM.ItemId,IM.ItemCode,IM.ItemName,IM.ItemDesc,IM.ItemTypeId,IT.ItemTypeDesc,IM.CategoryId,CAT.CategoryName,IM.HasImage,IM.ImageFile,IM.ItemStatus,IM.CreatedBy,IM.CreatedOn,IM.ModifiedBy,IM.ModifiedOn
	FROM	IM_ItemMaster IM
			LEFT OUTER JOIN IT_ItemType IT ON IT.ItemTypeId = IM.ItemTypeId
			LEFT OUTER JOIN CAT_Category CAT ON CAT.CategoryId = IM.CategoryId
	WHERE	IM.ItemId = @itemId

END


GO
/****** Object:  StoredProcedure [dbo].[Item_Create]    Script Date: 25-05-2021 08:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Item_Create]
(
	@itemName VARCHAR(200),
	@itemDesc VARCHAR(2000),
	@itemTypeId INT,
	@categoryId INT,
	@unitPrice DECIMAL(18,2) = NULL,
	@manufacturer VARCHAR(200) = NULL,
	@modelNo VARCHAR(100) = NULL,
	@hasImage BIT,
	@imageFile VARCHAR(500) = NULL,
	@remarks VARCHAR(1000) = NULL,
	@createdBy VARCHAR(200) = NULL
)
AS
BEGIN
	/*
	EXECUTE ItemRequest_Create @itemName='Thinkpad',@itemDesc='Thinkpad',@storeId=1,@isStockItem=1,@hasAttachment=0,@attachmentFile=NULL,@createdBy=99998,@createdOn='2018-04-24 20:24:06.180'
	*/
	
	SET NOCOUNT ON
	BEGIN TRANSACTION

	DECLARE @maxItemId AS BIGINT
	DECLARE @itemCode AS VARCHAR(50)
	DECLARE @startDate DATETIME
	DECLARE @endDate DATETIME

	SELECT @maxItemId=ISNULL(MAX(ItemId) , 0) + 1 FROM IM_ItemMaster
	SELECT @itemCode = ('SB' + RIGHT('0000000' + CONVERT(VARCHAR(10),RIGHT(@maxItemId,8)),8))
	SET @startDate = GETUTCDATE()
	SET @endDate = DATEADD(YEAR,1,GETUTCDATE())

	INSERT  INTO dbo.[IM_ItemMaster] (ItemId,ItemCode,ItemName,ItemDesc,ItemTypeId,CategoryId,HasImage,ImageFile,Remarks,ItemStatus,CreatedBy,CreatedOn)
	VALUES  (@maxItemId,@itemCode,@itemName,@itemDesc,@itemTypeId,@categoryId,@hasImage,@imageFile,@remarks,1,@createdBy,@startDate)

	-- Initiating Stock
	EXECUTE StockMaster_Create @itemId=@maxItemId,@manufacturer=@manufacturer,@modelNo=@modelNo,@initialQty=0,@availableQty=0,@thresholdLevel=0,
			@unitPrice=@unitPrice,@startDate=@startDate,@endDate=@endDate,@StockStatus=0,@createdBy=@createdBy

	-- Inserting Audit-Log
	EXECUTE AuditLog_Create @refId=@maxItemId,@refType='22C8B7D2-C080-4126-90D5-47691139F091',@actionDesc='Initiated by Admin',@comments='Draft',
			@createdBy=@createdBy
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 1
	END

	COMMIT TRANSACTION		
	RETURN 0
END



GO
/****** Object:  StoredProcedure [dbo].[Item_Delete]    Script Date: 25-05-2021 08:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Item_Delete]
(
	@itemId BIGINT,
	@remarks NVARCHAR(1000),
	@deletedBy VARCHAR(50) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRANSACTION

	IF NOT EXISTS(SELECT 1 FROM IM_ItemMaster WHERE ItemId=@ItemId AND ItemStatus=4)
	BEGIN
		UPDATE	dbo.[IM_ItemMaster] 
		SET		ItemStatus=4,
				Remarks=(CASE WHEN (LEN(@remarks)=0) THEN Remarks WHEN (LEN(@remarks)>0 AND LEN(Remarks)>0) THEN (Remarks+'|'+@remarks) ELSE @remarks END),
				DeletedBy=@deletedBy,
				DeletedOn=GETUTCDATE() 
		WHERE	ItemId=@itemId

		UPDATE	SM_StockMaster
		SET		StockStatus = 0
		WHERE	ItemId = @ItemId

		-- Inserting Audit-Log
		EXECUTE AuditLog_Create @refId=@itemId,@refType='22C8B7D2-C080-4126-90D5-47691139F091',@actionDesc='Deleted by Admin',@comments='Deleted',
				@createdBy=@deletedBy

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 1
		END
	END

	COMMIT TRANSACTION		
	RETURN 0

END


GO
/****** Object:  StoredProcedure [dbo].[Item_GetAll_Paged]    Script Date: 25-05-2021 08:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Item_GetAll_Paged]
	@xmlItemTypes XML = NULL,
	@xmlCategories XML = NULL,
	@itemStatus INT = NULL,	
	@strSearchExpression VARCHAR(50) = NULL,

	/*Paging Parameters*/
	@nPageSize int,
	@nCurrentPage int,	
	@strSortExpression nvarchar(50),
	@strSortDirection varchar(4)
AS
BEGIN
	/*	
	EXECUTE Item_GetAll_Paged @xmlItemTypes='<Items><Item value="2" /></Items>',@xmlCategories='<Items><Item value="2" /></Items>', @strSearchExpression=NULL,@nPageSize=10,@nCurrentPage=1,@strSortExpression='Name',@strSortDirection='DESC'
	*/

	Declare @nUpperBand int, @nLowerBand int
	SET @nLowerBand  = (@nCurrentPage - 1) * @nPageSize
	SET @nUpperBand  = (@nCurrentPage * @nPageSize) + 1

	DECLARE @tblItemTypes TABLE(ItemTypeId INT)
	INSERT INTO @tblItemTypes(ItemTypeId)
	SELECT DISTINCT ref.value( './@value', 'INT' ) AS id FROM @xmlItemTypes.nodes('/Items/Item') AS T (ref)

	DECLARE @tblCategories TABLE(CategoryId INT)
	INSERT INTO @tblCategories(CategoryId)
	SELECT DISTINCT ref.value( './@value', 'INT' ) AS id FROM @xmlCategories.nodes('/Items/Item') AS T (ref)

	;WITH Paged1 AS
	(
		SELECT	IM.ItemId,IM.ItemCode,IM.ItemName,IM.ItemDesc,IM.ItemTypeId,IT.ItemTypeDesc,IM.CategoryId,CAT.CategoryName,IM.HasImage,IM.ImageFile,IM.ItemStatus,IM.CreatedBy,IM.CreatedOn,IM.ModifiedBy,IM.ModifiedOn,
				ROW_NUMBER() OVER 
				(
					ORDER BY 
					CASE @strSortDirection
						WHEN 'DESC' THEN  
							CASE @strSortExpression 
								WHEN 'Name' THEN IM.ItemName					
								WHEN 'CreatedOn' THEN CONVERT(VARCHAR, IM.CreatedOn, 120)
							END 
					END DESC,
					CASE @strSortDirection 
						WHEN 'ASC' THEN  
							CASE @strSortExpression 
								WHEN 'Name' THEN IM.ItemName					
								WHEN 'CreatedOn' THEN CONVERT(VARCHAR, IM.CreatedOn, 120)
							END 
					END
				) AS RowNumber
		FROM	IM_ItemMaster IM
				LEFT OUTER JOIN IT_ItemType IT ON IT.ItemTypeId = IM.ItemTypeId
				LEFT OUTER JOIN CAT_Category CAT ON CAT.CategoryId = IM.CategoryId
		WHERE	((@xmlItemTypes IS NULL) OR ((@xmlItemTypes IS NOT NULL) AND EXISTS (SELECT ItemTypeId FROM @tblItemTypes WHERE ItemTypeId = IM.ItemTypeId)))
				AND ((@xmlCategories IS NULL) OR ((@xmlCategories IS NOT NULL) AND EXISTS (SELECT CategoryId FROM @tblCategories WHERE CategoryId = IM.CategoryId)))
				AND ((@itemStatus IS NULL AND (IM.ItemStatus<>3 OR IM.ItemStatus<>4)) OR (@itemStatus IS NOT NULL AND IM.ItemStatus=@itemStatus))
				AND (@strSearchExpression IS NULL OR ((@strSearchExpression IS NOT NULL) AND (  IM.ItemId LIKE @strSearchExpression
																								OR IM.ItemCode LIKE @strSearchExpression
																								OR IM.ItemName LIKE @strSearchExpression
																								OR IM.ItemDesc LIKE @strSearchExpression
																								OR IT.ItemTypeDesc LIKE @strSearchExpression
																								OR CAT.CategoryName LIKE @strSearchExpression))
					)
	)
	, Paged2 AS
	(
		SELECT COUNT(1) TotalRowCount FROM Paged1
	)

	SELECT	ItemId,ItemCode,ItemName,ItemDesc,ItemTypeId,ItemTypeDesc,CategoryId,CategoryName,HasImage,ImageFile,ItemStatus,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn,TotalRowCount
	FROM	Paged1 P1, Paged2 P2
	WHERE	RowNumber > @nLowerBand AND RowNumber < @nUpperBand
	ORDER BY 
			CASE @strSortDirection
				WHEN 'DESC' THEN  
					CASE @strSortExpression 
						WHEN 'Name' THEN ItemName					
						WHEN 'CreatedOn' THEN CONVERT(NVARCHAR, CreatedOn, 120)
					END 
			END DESC,
			CASE @strSortDirection 
				WHEN 'ASC' THEN  
					CASE @strSortExpression 
						WHEN 'Name' THEN ItemName					
						WHEN 'CreatedOn' THEN CONVERT(NVARCHAR, CreatedOn, 120)
					END 
			END

	RETURN 0
END



GO
/****** Object:  StoredProcedure [dbo].[Item_Update]    Script Date: 25-05-2021 08:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[Item_Update]
(
	@itemId BIGINT,
	@itemName VARCHAR(200) = NULL,
	@itemDesc VARCHAR(2000) = NULL,
	@itemTypeId INT,
	@categoryId INT,
	@hasImage BIT,
	@imageFile VARCHAR(500) = NULL,
	@remarks VARCHAR(1000) = NULL,
	@modifiedBy VARCHAR(20) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRANSACTION

	IF NOT EXISTS(SELECT 1 FROM IM_ItemMaster WHERE ItemId=@itemId AND ItemStatus=4)
	BEGIN
		UPDATE	dbo.[IM_ItemMaster] 
		SET		ItemName=@itemName,
				ItemDesc=@itemDesc,
				CategoryId=@categoryId,
				ItemTypeId=@itemTypeId,
				Remarks=(CASE WHEN (LEN(@remarks)=0) THEN Remarks WHEN (LEN(@remarks)>0 AND LEN(Remarks)>0) THEN (Remarks+'|'+@remarks) ELSE @remarks END),
				ModifiedBy=@modifiedBy,
				ModifiedOn=GETUTCDATE() 
		WHERE	ItemId=@itemId
		
		-- Inserting Audit-Log
		EXECUTE AuditLog_Create @refId=@itemId,@refType='22C8B7D2-C080-4126-90D5-47691139F091',
				@actionDesc='Updated by Admin',@comments='Updated',@createdBy=@modifiedBy
	END

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 1
	END

	COMMIT TRANSACTION
END

GO
/****** Object:  StoredProcedure [dbo].[Item_UpdateStatus]    Script Date: 25-05-2021 08:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Item_UpdateStatus]
(
	@itemId BIGINT,
	@itemStatus INT,
	@remarks NVARCHAR(1000),
	@modifiedBy VARCHAR(200) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRANSACTION

	IF NOT EXISTS(SELECT 1 FROM IM_ItemMaster WHERE ItemId=@ItemId AND (ItemStatus=3 OR ItemStatus=4))
	BEGIN
		UPDATE	dbo.[IM_ItemMaster] 
		SET		ItemStatus=@itemStatus,
				Remarks=(CASE WHEN (LEN(@remarks)=0) THEN Remarks WHEN (LEN(@remarks)>0 AND LEN(Remarks)>0) THEN (Remarks+'|'+@remarks) ELSE @remarks END),
				ModifiedBy=@modifiedBy,
				ModifiedOn=GETUTCDATE() 
		WHERE ItemId=@ItemId

		IF (@itemStatus = 2)
		BEGIN
			UPDATE	SM_StockMaster
			SET		StockStatus = 1
			WHERE	ItemId = @ItemId
		END

		-- Inserting Audit-Log
		EXECUTE AuditLog_Create @refId=@ItemId,@refType='22C8B7D2-C080-4126-90D5-47691139F091',@actionDesc='Activated by Admin',@comments='Created',
				@createdBy=@modifiedBy
	END

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 1
	END

	COMMIT TRANSACTION		
	RETURN 0

END




GO
/****** Object:  StoredProcedure [dbo].[ItemType_GetAll]    Script Date: 25-05-2021 08:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ItemType_GetAll]
	
AS
BEGIN
	
	SELECT	IT.ItemTypeId, IT.ItemTypeDesc
	FROM	IT_ItemType IT
	WHERE	IT.IsActive = 1	

	RETURN 0
END


GO
/****** Object:  StoredProcedure [dbo].[StockMaster_Create]    Script Date: 25-05-2021 08:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[StockMaster_Create]
(
	@itemId BIGINT,
	@manufacturer VARCHAR(200) = NULL,
	@modelNo VARCHAR(100) = NULL,
	@initialQty INT,
	@availableQty INT,
	@thresholdLevel INT,
	@unitPrice DECIMAL(18,2),
	@startDate DATETIME = NULL,
	@endDate DATETIME = NULL,
	@StockStatus BIT,
	@createdBy VARCHAR(200) = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON

	DECLARE @maxStockId BIGINT
	SELECT @maxStockId=ISNULL(MAX(StockId) , 0) + 1 FROM SM_StockMaster
		
	INSERT INTO SM_StockMaster(StockId,ItemId,Manufacturer,ModelNo,InitialQty,AvailableQty,ThresholdLevel,UnitPrice,StartDate,EndDate,StockStatus,CreatedBy,CreatedOn)
	VALUES		(@maxStockId,@itemId,@manufacturer,@modelNo,@initialQty,@availableQty,@thresholdLevel,@unitPrice,@startDate,@endDate,@StockStatus,@createdBy, GETUTCDATE())
	
	RETURN 0
END


GO
