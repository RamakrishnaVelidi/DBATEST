USE [AUDIT_CE]
GO

			DECLARE @vDateNow as [datetime] 
			DECLARE @newid UNIQUEIDENTIFIER	
				
			SET @vDateNow =GETDATE()
			SELECT @newid = NEWID()
 
			 SELECT 
				'AMBDRR_M' AS SOURCE
				,LIAB.SNP_ID
				,LIAB.SNP_DTE
				,LIAB.SRV_ID
				,sts.AGR_ID
				,apt.SRV_TYP
				,sts.AGR_TRM
				,ver.AGR_VER
				,bctm.CTM_NBR 		
				,LIAB.BIL_CUR
				,LIAB.LCL_CUR 
				,REMAINING_LIABILITY --,CONVERT(varchar, CAST(sum(REMAINING_LIABILITY) AS money), 1) AS REMAINING_LIABILITY 
				,REMAINING_LIABILITY_LOCALCURRRENCY --,CONVERT(varchar, CAST(sum(REMAINING_LIABILITY_LOCALCURRRENCY) AS money), 1) AS REMAINING_LIABILITY_LOCALCURRRENCY 
				,bctm.CTM_NBR  as [BILLING CUSTOMER NUMBER]  
				--, VER.ORD_NBR
				,apt.UNIT_PRC
				--RATE PER COPY
				,agr.ORG_STRT
				,CASE WHEN STS.AEXP_DTE IS NULL THEN ' ' ELSE CONVERT(CHAR(8), CAST(STS.AEXP_DTE AS DATETIME), 112) END AS [EXPIRE_DATE] 
				,CASE WHEN STS.AFIN_EXP IS NULL THEN ' ' ELSE CONVERT(CHAR(8), CAST(STS.AFIN_EXP AS DATETIME), 112) END AS [FINAL_EXPIRE] 
				,sts.AGR_STS --BIL_STS
				,CASE WHEN STS.AEXP_DTE IS NULL THEN ' ' ELSE 
						CASE WHEN DATEDIFF(day,getdate(),STS.AEXP_DTE)>=0 THEN DATEDIFF(day,getdate(),STS.AEXP_DTE) ELSE '-1' END
					END AS [DAYS TO GO]-- [ISSUES TO GO]
				,oadr.ATN_1ST as FIRST_NAME
				,oadr.ATN_MID as MIDDLE_NAME
				,oadr.ATN_END as LAST_NAME
				,oadr.STR_1ST
				,oadr.STR_2ND
				,oadr.CTM_CTY
				,oadr.CTM_STE
				,oadr.ZIP_CDE
				,oadr.CUN_TYP
				,COUO.[CUN_NME]
				,badr.ATN_1ST as BILLTO_FIRST_NAME
				,badr.ATN_MID as BILLTO_MIDDLE_NAME
				,badr.ATN_END as BILLTO_LAST_NAME
				,badr.STR_1ST AS BILLTO_STR_1ST
				,badr.STR_2ND AS BILLTO_STR_2ND
				,badr.CTM_CTY AS BILLTO_CTM_CTY
				,badr.CTM_STE AS BILLTO_CTM_STE
				,badr.ZIP_CDE AS BILLTO_ZIP_CDE
				,badr.CUN_TYP AS BILLTO_CUN_TYP
				,COUB.[CUN_NME] AS BILLTO_CUN_NME
				,@newid	AS UniqueKey
				,@vDateNow AS DATE_INSERTED	
				,ver.AGR_DAY AS [TOTAL_AGREEMENT_DAYS]
				,ver.VER_STRT AS [VERSION_START_DATE]
				,ver.ORD_NBR AS [ORDER_NUM]
			 FROM AdvDBMMSProd.[dbo].AMBAGR_M AS agr 
				INNER JOIN AdvDBMMSProd.[dbo].AMBTRM_M AS trm ON agr.AGR_ID = trm.AGR_ID 
				INNER JOIN AdvDBMMSProd.[dbo].AMBVER_M AS ver ON agr.AGR_ID = ver.AGR_ID 
							  AND trm.AGR_TRM = ver.AGR_TRM AND trm.RLS_VER = ver.AGR_VER 
				INNER JOIN AdvDBMMSProd.[dbo].AMBSTS_N AS sts ON agr.AGR_ID = sts.AGR_ID 
							  AND trm.AGR_TRM = sts.AGR_TRM 
							  AND ver.AGR_VER = sts.AGR_VER 
							  AND sts.AGR_STS <> 'X' 
							  AND ver.AGR_TYP <> 'P' 
				INNER JOIN AdvDBMMSProd.[dbo].AMBAPT_M AS apt ON agr.AGR_ID = apt.AGR_ID 
							  AND trm.AGR_TRM = apt.AGR_TRM 
							  AND ver.AGR_VER = apt.AGR_VER 
							  AND apt.DEL_FLG = 'N' 
				INNER JOIN AdvDBMMSProd.[dbo].AMBTYP_T AS typ ON apt.SRV_TYP = typ.SRV_TYP 
				INNER JOIN AdvDBMMSProd.[dbo].CDSCTM_M AS octm ON ver.ORD_CTM = octm.CTM_NBR 
				INNER JOIN AdvDBMMSProd.[dbo].CDSADR_M AS oadr ON octm.CTM_NBR = oadr.CTM_NBR 
							  AND ver.ORD_ADR = oadr.ADR_CDE 
							  AND oadr.ADR_FLG = '0' 
				LEFT OUTER JOIN AdvDBMMSProd.[dbo].CDSEML_M AS oeml ON oadr.EMAL_ID = oeml.EMAL_ID 
				INNER JOIN AdvDBMMSProd.[dbo].CDSCTM_M AS bctm ON ver.BIL_CTM = bctm.CTM_NBR 
				INNER JOIN AdvDBMMSProd.[dbo].CDSADR_M AS badr ON bctm.CTM_NBR = badr.CTM_NBR 
							  AND ver.BIL_ADR = badr.ADR_CDE 
							  AND badr.ADR_FLG = '0' 
				LEFT OUTER JOIN AdvDBMMSProd.[dbo].CDSEML_M AS beml ON badr.EMAL_ID = beml.EMAL_ID 
				LEFT OUTER JOIN AdvDBMMSProd.[dbo].CPNPMO_M AS PMO ON PMO.PMO_CDE = ver.PMO_CDE 
				LEFT OUTER JOIN AdvDBMMSProd.[dbo].CDSCOU_T AS COUO ON COUO.CUN_CDE = oadr.CUN_TYP 
				LEFT OUTER JOIN AdvDBMMSProd.[dbo].CDSCOU_T AS COUB ON COUB.CUN_CDE = badr.CUN_TYP 
				LEFT OUTER JOIN AdvDBMMSProd.[dbo].CDSSTE_T AS STEO ON STEO.STE_CDE = oadr.CTM_STE 
				LEFT OUTER JOIN AdvDBMMSProd.[dbo].CDSSTE_T AS STEB ON STEB.STE_CDE = badr.CTM_STE 
				LEFT OUTER JOIN AdvDBMMSProd.[dbo].TBCTBL_T AS TBLB ON TBLB.VLD_VAL = sts.ABIL_STS AND TBLB.FLD_NME = 'BIL-STS' 
				LEFT OUTER JOIN AdvDBMMSProd.[dbo].TBCTBL_T AS TBLC ON TBLC.VLD_VAL = sts.AGR_STS AND TBLC.FLD_NME = 'AGR-STS'
				LEFT OUTER JOIN
							(SELECT drr.SNP_ID,drr.SNP_DTE, drr.SRV_ID, drr.CTM_NBR, drr.AGR_ID, drr.SRV_TYP, drr.AGR_TRM, drr.AGR_VER ,drr.BIL_CUR, drr.LCL_CUR 
								,sum(REM_LIAB)  AS REMAINING_LIABILITY 
								, sum(CUR_LIAB)  AS REMAINING_LIABILITY_LOCALCURRRENCY 
							from AdvDBMMSProd.[dbo].AMBDRR_M drr 
							INNER JOIN AdvDBMMSProd.[dbo].AMBTYP_T typ
								ON drr.SRV_TYP = typ.SRV_TYP 
							WHERE drr.SNP_ID in (select max(SNP_ID) from AdvDBMMSProd.[dbo].AMBDRR_M where SRV_TYP = typ.SRV_TYP) 
							GROUP BY drr.SNP_ID,drr.SNP_DTE, drr.SRV_ID,drr.CTM_NBR, drr.AGR_ID, drr.SRV_TYP , drr.AGR_TRM, drr.AGR_VER, drr.BIL_CUR, drr.LCL_CUR) LIAB
					ON LIAB.CTM_NBR =bctm.CTM_NBR    
					 AND LIAB.SRV_TYP =apt.SRV_TYP
					AND  LIAB.AGR_ID =sts.AGR_ID
					AND LIAB.AGR_TRM = sts.AGR_TRM
					AND LIAB.AGR_VER = ver.AGR_VER 

				--WHERE  (IsNull((SELECT max(IsNull(SNP_ID,0)) FROM AUDIT_AMB2 
				--WHERE SRV_TYP = apt.SRV_TYP collate SQL_Latin1_General_CP1_CI_AS ),0) 
				--<  IsNull(LIAB.SNP_ID collate SQL_Latin1_General_CP1_CI_AS ,0)) 
				--This where clause is only to insert new snap_id records from table AdvDBMMSProd.[dbo].AMBDRR_M to AUDIT_AMB tale
