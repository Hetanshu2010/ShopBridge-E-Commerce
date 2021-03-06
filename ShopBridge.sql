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
/****** Object:  Table [dbo].[IM_ItemMaster]    Script Date: 25-05-2021 08:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Inventory](
	[ItemId] [bigint] NOT NULL,
	[ItemCode] [varchar](50) NULL,
	[ItemName] [varchar](200) NULL,
	[ItemDesc] [varchar](2000) NULL,	
	[Remarks] [nvarchar](1000) NULL,
	[ItemStatus] [int] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedOn] [datetime] NULL,
	[DeletedBy] [varchar](50) NULL,
	[DeletedOn] [datetime] NULL,
 CONSTRAINT [PK_Inventory] PRIMARY KEY CLUSTERED 
(
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


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
/****** Object:  StoredProcedure [dbo].[Item_ById]    Script Date: 25-05-2021 08:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Item_ById]
	@itemId BIGINT
AS
BEGIN

	SELECT	IM.ItemId,IM.ItemCode,IM.ItemName,IM.ItemDesc,IM.ItemTypeId,IT.ItemTypeDesc,IM.CategoryId,CAT.CategoryName,IM.HasImage,IM.ImageFile,IM.ItemStatus,IM.CreatedBy,IM.CreatedOn,IM.ModifiedBy,IM.ModifiedOn
	FROM	IM_ItemMaster IM		
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

	SELECT @maxItemId=ISNULL(MAX(ItemId) , 0) + 1 FROM Inventory
	SELECT @itemCode = ('SB' + RIGHT('0000000' + CONVERT(VARCHAR(10),RIGHT(@maxItemId,8)),8))
	SET @startDate = GETUTCDATE()
	SET @endDate = DATEADD(YEAR,1,GETUTCDATE())

	INSERT  INTO dbo.[Inventory] (ItemId,ItemCode,ItemName,ItemDesc,Remarks,CreatedBy,CreatedOn)
	VALUES  (@maxItemId,@itemCode,@itemName,@itemDesc,@remarks,@createdBy,@startDate)

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

	IF NOT EXISTS(SELECT 1 FROM Inventory WHERE ItemId=@ItemId)
	BEGIN
		UPDATE	dbo.[Inventory] 
		SET		DeletedBy=@deletedBy,
				Remarks=(CASE WHEN (LEN(@remarks)=0) THEN Remarks WHEN (LEN(@remarks)>0 AND LEN(Remarks)>0) THEN (Remarks+'|'+@remarks) ELSE @remarks END),
				DeletedOn=GETUTCDATE() 
		WHERE	ItemId=@itemId

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
	@remarks VARCHAR(1000) = NULL,
	@modifiedBy VARCHAR(20) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRANSACTION

	IF NOT EXISTS(SELECT 1 FROM Inventory WHERE ItemId=@itemId)
	BEGIN
		UPDATE	dbo.Inventory 
		SET		ItemName=@itemName,
				ItemDesc=@itemDesc,			
				Remarks=(CASE WHEN (LEN(@remarks)=0) THEN Remarks WHEN (LEN(@remarks)>0 AND LEN(Remarks)>0) THEN (Remarks+'|'+@remarks) ELSE @remarks END),
				ModifiedBy=@modifiedBy,
				ModifiedOn=GETUTCDATE() 
		WHERE	ItemId=@itemId

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
/****** Object:  StoredProcedure [dbo].[Item_Getall]    Script Date: 20-07-2021 21:29:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Item_Getall]

AS
BEGIN
	/*
	EXECUTE Item_ById 21
	*/

	SELECT	ItemId,ItemCode,ItemName,Remarks,ItemDesc,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn
	FROM	Inventory 			


END
