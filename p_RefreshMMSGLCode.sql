USE FinanceBatches
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		RK
-- Create date: 10/13/2016
-- Description:	Refresh MMSGLCode table from FinanceBatches DB to FirstDataExtract DB
-- =============================================
CREATE PROCEDURE p_RefreshMMSGLCode 

AS
BEGIN

SET NOCOUNT ON;
TRUNCATE TABLE [dbo].[MMSGLCode]


SELECT * INTO dbo.[MMSGLCode]
		 FROM FirstDataExtract.dbo.[MMSGLCode]

END
GO
