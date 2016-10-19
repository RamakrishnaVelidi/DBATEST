USE FinanceBatches
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		RK
-- Create date: 10/13/2016
-- Description:	Refresh [NFGLMapping] table from FirstDataExtract DB to FinanceBatches DB
-- =============================================
CREATE PROCEDURE p_RefreshNFGLMapping 

AS
BEGIN

SET NOCOUNT ON;
TRUNCATE TABLE [dbo].[NFGLMapping]

INSERT INTO [dbo].[NFGLMapping]
SELECT * FROM FIRSTDATAEXTRACT.dbo.[NFGLMapping]

END
GO
