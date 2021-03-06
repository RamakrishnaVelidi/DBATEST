USE [Sponsors]
GO
/****** Object:  StoredProcedure [dbo].[p_SPONSORS_SSIS_GetSponsorsData]    Script Date: 08/02/2016 16:28:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Created by Roger Tenorio on 10/21/2011
	*	Gets the data from the SponsorInputFileNumbers on ACS to be process on 
		the ACSUpload database (WEBSQL)

Modified by Roger Tenorio on 3/24/2014
	* Modified to accomodate changes on ACS version 13r1
	
*/

--ALTER procedure [dbo].[p_SPONSORS_SSIS_GetSponsorsData]

as

begin
	begin try

		set nocount on
		
	 
		SELECT
		PUB_CDE = CASE
					  WHEN PUB_CDE IS NULL THEN SPACE(16)
					  ELSE CAST(PUB_CDE AS CHAR(16))
				  END,
		CTM_NBR = CASE
					  WHEN CTM_NBR IS NULL THEN SPACE(12)
					  ELSE CAST(CTM_NBR AS CHAR(12))
				  END,
		SUB_REF = SPACE(12),
		ADR_CDE = CASE
					  WHEN ADR_CDE IS NULL THEN SPACE(8)
					  ELSE CAST(ADR_CDE  AS CHAR(8))
				  END,
		AGN_REF = SPACE(30),
		PRIC_CDE = CAST(RTE_CDE AS CHAR(8)),
		BIL_CUR = CAST(BIL_CUR AS CHAR(4)),
		RATE = CAST(REPLACE(CAST(REPLACE(STR(isnull(RATE,0), 25, 6), SPACE(1), '0') AS varchar(25)),'.','') as char(24)),
		TERM = CAST(REPLACE(STR(TERM, 3), SPACE(1), ' ') AS CHAR(3)),
		FREE_ISS = '00',
		KEY_CDE = CAST(KEY_CDE AS CHAR(8)),
		BIL_CDE = CAST(BIL_CDE AS CHAR(1)),
		CRX_NBR = SPACE(20),	
		CHK_NBR6 = SPACE(6),
		DNR_NBR = CAST(DNR_NBR AS CHAR(12)),
		
		DNR_ADR = CAST(DNR_ADR AS CHAR(8)),
		DNR_TYP = CAST(DNR_TYP AS CHAR(1)),
		SUB_TYP = CASE
					  WHEN SUB_TYP IS NULL THEN SPACE(6)
					  ELSE CAST(SUB_TYP AS CHAR(6))
				  END,
		REF_CTM = SPACE(12),
		OPR_CDE = CAST(OPR_CDE AS CHAR(3)),
		STRT_DTE = CAST(STRT_DTE AS CHAR(8)),
		COPIES = CAST(COPIES AS CHAR(5)),
		DLV_CDE = CAST(DLV_CDE AS CHAR(2)),	
		BUS_IND = CAST(BUS_IND AS CHAR(2)),
		
		BUS_TTL = CASE
					  WHEN BUS_TTL IS NULL THEN SPACE(3)
					  ELSE CAST(BUS_TTL AS CHAR(3))
				  END,
		ADR_TYP = CAST(ADR_TYP AS CHAR(1)),
		QUAL_SRC = CAST(QUAL_SRC AS CHAR(2)),
		DTE_SGN = convert(char(8),getdate(),112),
		BPA_QUAL = CAST(BPA_QUAL AS CHAR(1)),
		APPY_TO = SPACE(8),
		CAN_CDE = SPACE(1),
		AMT_PD = CAST(REPLACE(CAST(REPLACE(str(isnull(AMT_PD,0), 25, 6), space(1), '0') AS varchar(25)),'.','') as char(24)),
		ARS_REF = SPACE(39),
		MEM_NBR = SPACE(8),
		TRM_DMO = CAST(TRM_DMO AS CHAR(16)),
		SPC_COD = SPACE(3),
		ORD_NBR = SPACE(8),
		
		SUB_DMO =  CAST(SUB_DMO AS CHAR(32)),
		SUB_CLS = CAST(SUB_CLS AS CHAR(1)),
		RN_FLG = CAST(RN_FLG AS CHAR(1)),
		SUB_DM2 = CAST(SUB_DM2 AS CHAR(32)),
		STS_UPD = CAST(STS_UPD AS CHAR(8)),
		SUB_DKT = SPACE(12),
		DOC_PTH = SPACE(128),
		MBR_ORG = SPACE(2),	
		PO_NBR = SPACE(20),	
		SLM_NBR = SPACE(8),	
		CAN_REA = SPACE(8),	
		ISU_GRP = CAST(ISU_GRP AS CHAR(2)),
		
		SND_BKI = SPACE(1),	
		PMO_CHC = SPACE(6),	
		WEB_IND = SPACE(1),	
		AUTH_CDE = SPACE(14),
		AUTH_DTE = SPACE(8),
		PRE_ATRN = SPACE(30),	
		SHP_THRU = SPACE(12),
		GRO_RATE = SPACE(24),
		SUB_EMAL = SPACE(50),
		EDN_NBR = SPACE(6),
		EDN_TYP = SPACE(6),	
		RSK_FREE = SPACE(2),	
		PAK_NBR = SPACE(16), 
		PAK_ID = SPACE(8),	
		CARD_TO = SPACE(1),	
		GFT_MSG = SPACE(4000),		
		DFR_DTE = SPACE(8),
		PGE_NBR = SPACE(8),
		INB_CDE = SPACE(3), 
		BRCH_NME = SPACE(40), 
		BRCH_ST1 = SPACE(80), 
		BRCH_ST2 = SPACE(80), 
		BRCH_ST3 = SPACE(80), 
		BRCH_CTY = SPACE(80), 
		BRCH_STE = SPACE(3), 
		BRCH_CUN = SPACE(3), 
		BRCH_ZIP = SPACE(9), 
		BANK_IDN = SPACE(12), 
		ACCT_NBR = SPACE(34), 
		ACT_HLDR = SPACE(40), 
		CHK_SAV = SPACE(1), 
		STR_INF = SPACE(8), 
		OPT_OUT = SPACE(1), 
		PMO_ADRS = SPACE(1), 
		PMO_PHNS = SPACE(1), 
		PMO_FAXS = SPACE(1), 
		PMO_EMLS = SPACE(1), 
		PMO_SMSS = SPACE(1), --3/6/2014
		AUTH_VAL = SPACE(50), 
		PASS_WD = SPACE(50), 
		PW_HINT = SPACE(60), 
		QST_CDE = SPACE(12), 
		PW_ANS = SPACE(60), 
		AUTH_GRP = SPACE(12), 
		AUTH_TYP = SPACE(1), 
		ARP_USR = SPACE(6), 
		BIL_ORG = SPACE(4), 
		SUS_SUB = SPACE(8), 
		RSM_SUB = SPACE(8), 
		LNB_CDE = SPACE(4), 
		COUP_CDE = SPACE(8), 
		AGN_PRX = SPACE(24), 
		ALD_IND = SPACE(1), 
		ALD_VNR = SPACE(3), 
		CRX_CMT = SPACE(30), 
		PMT_DTE = SPACE(8), 
		CSC_PSNC = SPACE(1), 
		EPI_IDN = SPACE(12), 
		ORDR_SRC = SPACE(8), 
		ARN_CID = SPACE(10), 
		ARC_SEQ = SPACE(4), 
		SHCT_LST = SPACE(50), --3/6/2014
		SERV_BKI = SPACE(3), --3/6/2014
		ALL_PKG = SPACE(1), --3/6/2014
		ATN_1ST = SPACE(20),
		ATN_MID = SPACE(1),
		ATN_END = SPACE(30),
		CMP_NME =  SPACE(80),
		DPT_NME = SPACE(80), 
		STR_1ST = SPACE(80), 
		STR_2ND = SPACE(80), 
		STR_3RD = SPACE(80),
		CTM_CTY = SPACE(80), 
		CTM_STE = SPACE(3),
		CUN_TYP = CAST(CUN_TYP AS CHAR(3)),
		ZIP_CDE = SPACE(9),
		CTM_CNTY = SPACE(20),
		CRRT_CDE = SPACE(4),
		DPBC_2 = SPACE(2),
		LOT_NBR = SPACE(4),
		LOT_ORD = SPACE(1),
		AUS_DPID = SPACE(8), 
		MDA_PST = SPACE(5), 
		ROU_DIS = SPACE(4), 
		HVIA_CDE = SPACE(8), --3/6/2014
		HCLE_CDE = SPACE(10), --3/6/2014
		STR_NBR = SPACE(4), --3/6/2014
		BT_IND = SPACE(1), --3/6/2014
		STR_TKN = SPACE(32), --3/6/2014
		STR_TYP = SPACE(12), --3/6/2014
		FSTR_NME = SPACE(32), --3/6/2014
		PHO_NBR =  SPACE(25),
		PHO_NBR2 = SPACE(25), 
		PHO_NBR3 = SPACE(25), 
		FAX_NBR =  SPACE(25), 
		ADR_EMAL = SPACE(50),
		EMAL_VLD = SPACE(1),
		EML_DVCE = SPACE(12), 
		ADR_FIL1 = SPACE(1),
		COMM_PRF = SPACE(1),
		CTM_TTL = SPACE(15),
		CTM_POS = SPACE(8),
		CTM_SFX = CASE
					  WHEN CTM_SFX IS NULL THEN SPACE(8)
					  ELSE CAST(CTM_SFX  AS CHAR(8))
				  END,
		JOB_TTL = SPACE(60),
		CTM_SAL = SPACE(30),
		ADR_VLD = CAST(ADR_VLD AS CHAR(1)),
		STZ_EXM = CAST(STZ_EXM AS CHAR(1)),
		CMP_EXM = SPACE(1), 
		DUP_EXM = CAST(DUP_EXM AS CHAR(1)),
		PMO_ADR = CAST(PMO_ADR AS CHAR(1)),
		PMO_PHN = CAST(PMO_PHN AS CHAR(1)),
		PMO_FAX = CAST(PMO_FAX AS CHAR(1)),
		PMO_SMS = SPACE(1), --3/6/2014
		PMO_EML = CAST(PMO_EML AS CHAR(1)),
		DKT_NBR = SPACE(12),
		OK_INDX = SPACE(1),
		STR_NME = SPACE(30), 
		HSE_NBR = SPACE(4), 
		BLK_NBR = SPACE(1), 
		FLR_NBR = SPACE(2), 
		SIDE_NBR = SPACE(4), 
		APT_NBR = SPACE(6), 
		CIR_EMAL = SPACE(1),
		BIR_DTE = SPACE(8), 
		EXM_FLG = SPACE(1), 
		EXM_RSN = SPACE(6), 
		EXM_IDN = SPACE(25),
		CUN_NAME = SPACE(20),
		CTM_TYP = SPACE(8),
		SIC_CDE = SPACE(8),
		SEX_CDE = SPACE(1),
		UPD_DTE = SPACE(8),
		UPD_USR = SPACE(6),
		PROMO = SPACE(1),
		LIST_CDE = SPACE(8),
		DMO_DTA = SPACE(32),
		DMO_DTA2 = SPACE(32),
		DMO_DTA3 =  SPACE(32),
		DMO_DAT1 = SPACE(50), 
		DMO_DAT2 = SPACE(50), 
		LANG_CDE = SPACE(5),
		LST_STS = SPACE(1),
		QNR_NME = SPACE(8),
		QNR_TYP = SPACE(1),
		/*800 */
		QNR_SEGF1 = SPACE(800)	,	 -- a block for extended demo data		
		FLSH_CDE = SPACE(2),
		DTE_FLSH = SPACE(8),
		NVSL_CDE = SPACE(2),
		NVSL_DTE = SPACE(8),
		PJCT_ID = SPACE(10),
		LSTM_PMO = SPACE(8),
		LSTP_PMO = SPACE(8),
		INP_CDTE = SPACE(8), --CAST(CONVERT(CHAR(8), GETDATE(), 112) AS CHAR(8)), --YYYYMMDD,
		INP_CID = SPACE(6), /*CAST(RIGHT(DATEPART(YY,GETDATE()),1)					   		 + 
					   		REPLICATE('0',3-LEN(CAST(DATEPART(DY,GETDATE()) AS VARCHAR(3)))) + CAST(DATEPART(dy,GETDATE()) AS VARCHAR(3)) + --day of the year, 3 characters long
					   		'S'
					  AS CHAR(6)), */
		DEP_ID= SPACE(10),
		DEP_DTE = SPACE(8),
		CTM_RLP = SPACE(8),
		TO_CTM = SPACE(12),
		TO_ADR = SPACE(8),
		PQNR_NME = SPACE(8),
		QNR_SGF2 = SPACE(800)	
		FROM SponsorInputFileNumbers s
		ORDER BY CTM_NBR



END TRY

	BEGIN CATCH
				--raise error to front end
			DECLARE @errProc NVARCHAR(126),
			@errLine INT,
			@errMsg  NVARCHAR(MAX)
			SELECT  @errProc = ERROR_PROCEDURE(),
			@errLine = ERROR_LINE(),
			@errMsg  = ERROR_MESSAGE()
			RAISERROR('Proc: %s - Line: %d - Error: %s', 12 ,1 ,@errProc, @errLine, @errMsg)
			RETURN(-1)
	END CATCH
END
