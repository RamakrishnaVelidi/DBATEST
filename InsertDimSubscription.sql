	select Subscription_Customer_Number = custid, 
					Number_of_Copies =copies,
					Subscription_Product_Code = isnull(nqp.Description,rtrim(isnull(PRODCD,'?'))),
					Subscription_Product_Name = substring(isnull(pub.PUB_FULL,'?'), 1, 50),
					Includes_Online_Flag = isnull(nqw.Description,'Yes'),
					Includes_Online_Description = case nqw.Description
													when 'No' then 'Not Eligible for Web Access'
													else 'Eligible for Web Access'
												  end,
					Includes_Print_Flag = 'Yes',
					Includes_Print_Description = 'Includes print',
					Complimentary_Flag = case when PYT = 'C' then 'Yes' else 'No' end,
					Complimentary_Description = case 
													when PYT = 'C' then 'Complimentary' 
													else 'Paid' 
												end,
					Subscription_Expire_Date = CEXPIREDATE,
					Lifetime_Subscription_Flag = case 
													when PYT = 'L' then 'Yes' 
													else 'No' 
												 end,
					Lifetime_Subscription_Description = case 
															when PYT = 'L' then 'Lifetime' 
															else 'Non-Lifetime' 
														end,
					MMS_Subscription_Flag = case 
												when PYTDESC = 'MASSMED' then 'Yes' 
												else 'No' 
											end,
					MMS_Subscription_Description = case 
													when PYTDESC = 'MASSMED' then 'MMS Member' 
													else 'Non-member' 
												   end,
					Class_Code = case PYTDESC
									when 'MASSMED' then case substring(nqs.Description,1,1)
															when 'M' then dbo.fn_BIG_CleanField(nqs.Description)
															else 'M' + dbo.fn_BIG_CleanField(nqs.Description)
														end
									else dbo.fn_BIG_CleanField(nqs.Description)
								 end,
					Class_Description = dbo.fn_BIG_CleanField(sbt.SBT_DSC),
					Specialty_Code = dbo.fn_BIG_CleanField(SPEC),
					Physician_Resident_Group = case 
													when dbo.fn_BIG_CleanField(cl) in ('P','R') then 'Physician/Resident'  
													else 'Non-Physician/Resident' 
											   end,
					Individual_or_Institution = case 
													when dbo.fn_BIG_CleanField(cl) in ('L', 'I') then 'Institution'  
													else 'Individual' 
												end,
					Class_Total= dbo.fn_BIG_CleanField(clt.Description),
					Subscription_Name_First = substring(dbo.fn_BIG_CleanField(FNAME), 1, 20),
					Subscription_Name_Last= substring(dbo.fn_BIG_CleanField(LNAME), 1, 30),
					Subscription_Address1 = substring(dbo.fn_BIG_CleanField(ADDR1), 1, 40),
					Subscription_Address2 = substring(dbo.fn_BIG_CleanField(ADDR2), 1, 40),
					Subscription_Address3 = substring(dbo.fn_BIG_CleanField(ADDR3), 1, 40),
					Subscription_Postal_Code = substring(dbo.fn_BIG_CleanField(zip), 1, 9),
					Subscription_Country_Code = case 
													when len(custid) = 5 then 'JPN'
													when substring(custid, 1, 1) = 'Q' then 'KOR'
													else '?'
												end,
					Subscription_Country_Description = case 
															when len(custid) = 5 then 'JAPAN'
															when substring(custid, 1, 1) = 'Q' then 'KOREA (SOUTH)'
															else '?'
													   end,
			--        Subscription_Standard_Country_Group_Name = case 
			--										            when len(custid) = 5 then 'JAPAN'
			--										            when substring(custid, 1, 1) = 'Q' then 'KOREA (SOUTH)'
			--										            else '?'
			--										           end,
					Destination_Country_Code = case 
													when len(custid) = 5 then 'JPN'
													when substring(custid, 1, 1) = 'Q' then 'KOR'
													else '?'
												end,
					Destination_Country_Description = case 
															when len(custid) = 5 then 'JAPAN'
															when substring(custid, 1, 1) = 'Q' then 'KOREA (SOUTH)'
															else '?'
													   end,
					Row_Effective_Start_Date = min(IssueDate),
					Row_Effective_End_Date = null,
					Row_Current_Flag = 'Yes',
					Edition_Code = case 
									when len(custid) = 5 then 'J'
									when substring(custid, 1, 1) = 'Q' then 'I'
									else '?'
								   end,
					Edition_Description = dbo.fn_BIG_CleanField(edc.Description),
					Product_Key = prd.Product_Key,

					-- DEFAULT VALUES --
					Subscription_Reference	= '?',
					Donor_Customer_Number =	'?',
					Payment_with_Order_Flag = case PYT
												when 'C' then '?'
												else 'Yes'
											  end,
					Payment_with_Order_Description	= case PYT
														when 'C' then '?'
														else 'Cash with order'
													  end,
					Bulk_Flag	= 'No',
					Bulk_Description = 'Non-Bulk',
					Agency_Subscription_Flag = 'Yes',
					Agency_Subscription_Description = 'Agency Subscription',
					Sponsor_Flag = 'No',
					Sponsor_Description	= 'Non-sponsored',
					Sponsor_Program_Key	= 1,
					Paid_Status_Code = case PYT
											when 'C' then 'C'
											else 'P'
										end,
					Paid_Status_Description	= bil.FLD_DSC,
					Circ_Status_Code = case PYT
										when 'C' then 'P'
										else 'R'
									   end,
					Circ_Status_Description	= crc.FLD_DSC,
					Rate_Code = case PYT
								   when 'C' then 'COMP'
								   else '?'
								end,
					Rate_Code_Description = dbo.fn_BIG_CleanField(rat.RTE_DSC),
					Site_License_Price_Tier	= '?',
					Rate = -1,
					Currency = (case 
									when PYT = 'C' then '?'
									when len(custid) = 5 then 'JPY'
									when substring(custid, 1, 1) = 'Q' then 'KRW'
									else '?'
								end),
					US_Dollar_Rate = -1,
					Payment_Type_Code = '?',
					Payment_Type_Description =	'?',
					Do_Not_Renew_Flag = '?',
					Do_Not_Renew_Description = '?',
					Complimentary_Reason_Code = '?',
					Complimentary_Reason_Description = '?',
					Advance_Access_Type_Code = '?',
					Advance_Access_Type_Description	= '?',
					Advance_Access_Flag	= 'No',
					Advance_Access_Description	= 'Standard',
					Delivery_Code = '?',
					Delivery_Description = '?',
					Promotion_Key	= 1,
					Promotion_Code	= case PYT
										when 'C' then '?'
										else 'AGENCY'
									  end,
					Term	= 0,
					Term_Number	= 0,
					BPA_Qualified_Flag	= 'No',
					BPA_Qualified_Description	= 'Not BPA Qualified',
					Subscription_Name_Prefix	= '?',
					Subscription_Name_Middle_Initial	= '?',
					Subscription_Name_Suffix	= '?',
					Subscription_Company_Name	= '?',
					Subscription_Umbrella_Organization	= '?',
					Subscription_Organization	= '?',
					Subscription_City	= '?',
					Subscription_State_or_Province_Code	= '?',
					Subscription_State_or_Province_Description	= '?',
					Chief_Medical_Resident_Flag	= 'No',
					Chief_Medical_Resident_Description	= '?',
					Chief_Medical_Resident_Class_Year =	'?',
					Record_Status = 'Insert',
					Subscription_Order_Number = '?'
			from            NANKODO_KOREAN_ARCHIEVE                                    -- MMS-generated table of N/Q subs
			left outer join Util_Codes nqs on (dbo.fn_BIG_CleanField(cl) = nqs.Code
											   and nqs.Code_Type = 'NQ_Sub_Type_Code')                            -- Lookup table for Nankodo Subtype
			left outer join Util_Codes nqp on (SourceCode = nqp.Code
											   and nqp.Code_Type = 'NQ_Subscription_Product_Code')
			left outer join Util_Codes nqw on (SourceCode = nqw.Code
											   and nqw.Code_Type = 'NQ_Web_Eligibility_Flag')
			left outer join Util_Codes edc on ((case 
												   when len(custid) = 5 then 'J'
												   when substring(custid, 1, 1) = 'Q' then 'I'
												end) = edc.Code
												and edc.Code_Type = 'Edition_Code')
			left outer join CIRPUB_T pub on (isnull(nqp.Description,rtrim(isnull(PRODCD,'?')))COLLATE DATABASE_DEFAULT = pub.PUB_CDE COLLATE DATABASE_DEFAULT)    -- Publication code descriptions
			left outer join CIRSBT_T sbt on (case PYTDESC
												when 'MASSMED' then case substring(nqs.Description,1,1)
																		when 'M' then dbo.fn_BIG_CleanField(nqs.Description)
																		else 'M' + dbo.fn_BIG_CleanField(nqs.Description)
																	end
												else dbo.fn_BIG_CleanField(nqs.Description)
											 end = sbt.SUB_TYP)
			join TBCTBL_T bil on (bil.VLD_VAL = (case PYT
													when 'C' then 'C'
													else 'P'
												 end)
								  and bil.FLD_NME = 'BIL-STS')   -- Billing status code descriptions
			join TBCTBL_T crc on (crc.VLD_VAL = (case PYT
													when 'C' then 'P'
													else 'R'
												 end)
								  AND crc.FLD_NME = 'CRC-STS')        -- Circulation status code descriptions

			join Util_Codes clt	on (clt.Code_Type = 'Class_Total') 
			left outer join CIRRAT_T rat on ((case PYT
												when 'C' then 'COMP'
												else '?'
											  end)= substring(rat.PRIC_CDE, 1, 4)
											 AND isnull(nqp.Description,rtrim(isnull(PRODCD,'?')))COLLATE DATABASE_DEFAULT  = rat.PUB_cde COLLATE DATABASE_DEFAULT 
											 AND dbo.fn_BIG_CleanField(nqs.Description) = rat.SUB_TYP) 
			left outer join CIRRAT_T newrat on ((case
													when len(custid) = 5 then 'JPY'
													when substring(custid, 1, 1) = 'Q' then 'KRW'
													else '?'
												  end) = newrat.BIL_CUR) -- Rate code descriptions
			inner join BigDw..Dim_Product prd on (ProdCd = prd.Product_Code 
												  and Includes_Online_Flag = 'Yes'
												  and Includes_Print_Flag = isnull(nqw.Description,'Yes'))	                                                                  -- Lookup table for Class_Total
			                
			where dbo.fn_BIG_CleanField(nqs.Description) = clt.Code 
			group by custid, 
					 copies,
					 nqp.Description,
					 PRODCD,
					 pub.PUB_FULL,
					 nqw.Description,
					 PYT,
					 CEXPIREDATE,
					 PYTDESC,
					 nqs.Description,
					 sbt.SBT_DSC,
					 SPEC,
					 cl,
					 clt.Description,
					 FNAME, 
					 LNAME, 
					 ADDR1, 
					 ADDR2, 
					 ADDR3, 
					 zip,
					 edc.Description,
					 prd.Product_Key,
					 bil.FLD_DSC,
					 crc.FLD_DSC,
					 rat.RTE_DSC