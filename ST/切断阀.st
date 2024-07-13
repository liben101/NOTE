(*6个联锁关投切，1个联锁开投切，仿真切除关阀模式*)

IF MOS = 9 THEN
	(*1--Êä³öÃüÁî*)
		IF (EMCL1 AND BYP1) OR (EMCL2 AND BYP2) OR (EMCL3 AND BYP3) THEN 	(*3¸öÁªËø¹Ø*)
			TMP_CMD := OFF ;	
		ELSEIF (EMCL4 AND BYP4) OR (EMCL5 AND BYP5)OR  (EMCL6 AND BYP6) THEN 	(*ÁíÍâ3¸öÁªËø¹Ø*)
			TMP_CMD := OFF ;
	    ELSEIF (EMOPN = ON) AND BYPK THEN  (*ÁªËø¿ª*)
			TMP_CMD := ON ;		
		ELSE
			IF (SWAM = ON) THEN	
				TMP_CMD := PCMD ;	(*×Ô¶¯¿ª¹Ø*)
			ELSE
				TMP_CMD := MCMD ;	(*ÊÖ¶¯¿ª¹Ø*)
			END_IF;
		END_IF;
		          
		IF NOT STT AND NOT ZSV THEN	(*Æô¶¯ÔÊÐí*)
			TMP_CMD := OFF; 
		END_IF;
		
		IF NOT SIM THEN             (*·ÂÕæ½áÊø·§ÃÅ¹Øµô*)
		   IF TEMP THEN 
		      TMP_CMD:=OFF;
		      TEMP := OFF;
		   END_IF;
		ELSE 
		    TEMP:=ON;
	    END_IF; 
		(*£º0-¹Ø;1-¿ª*)
		
		IF NOT SIM THEN
		  ZSV := TMP_CMD;
	    ELSE
	      ZSV := OFF;
	    END_IF;
	    
	    MCMD := TMP_CMD;
	    PCMD := TMP_CMD;
	    
	(*2--·ÖÎö·§ÃÅµ±Ç°×´Ì¬*)
		IF (SIM = ON) THEN	(*·ÂÕæµ÷ÊÔ*)
			IF 	(TMP_CMD = ON) THEN	(*×´Ì¬ÓÉDOÈ·¶¨*)
				TMP_S := 1;(*·§¿ª*)	
				STA := 1;(*·§¿ª*)
			ELSE
				TMP_S := 0;(*·§¹Ø*)	
				STA := 0;(*·§¹Ø*)								
			END_IF;		
		ELSE
			IF (ZSO = ON OR (ENSK AND SIMK)) AND (ZSC = OFF) AND NOT (ENSG AND SIMG) AND (ZSV = ON) THEN
				TMP_S := 1;(*·§¿ª*)	
			ELSEIF (ZSO = OFF) AND NOT (ENSK AND SIMK) AND (ZSC = ON OR (ENSG AND SIMG)) AND (ZSV = OFF) THEN
				TMP_S := 0;(*·§¹Ø*)	
			ELSE
				TMP_S := 4;(*·§¹ÊÕÏ*)
			END_IF;				
		END_IF;
	
	
		(*ÑÓ³ÙÅÐ¶Ï·§ÃÅ×´Ì¬*)
		IF (TMP_S = STA) THEN
			COUNT := 0;	(*×´Ì¬ÎÞ±ä»¯Ê±£¬¼ÆÊýÆ÷ÇåÁã*)	
		ELSE
			COUNT := COUNT + 1;
			IF (TMP_S = 0) THEN
				STA := TMP_S;
	
			ELSEIF (TMP_S = 1) THEN
				STA := TMP_S;
				
			ELSEIF (COUNT >= 1000 / TIME_R * TIME_DL) THEN (*ÑÓ³ÙÅÐ¶Ï¹ÊÕÏ*)
				STA := TMP_S ;
			END_IF;			
		END_IF;
	
	IF ZSV THEN 
	    OPN_PT := ON;
	    CLS_PT := OFF;
	ELSE 
	    OPN_PT := OFF;
	    CLS_PT := ON;
	END_IF;
	
	CASE STA OF 
	    1: OPN_T := ON;
	       CLS_T := OFF;
	       ALM_T := OFF;
	    0: OPN_T := OFF;
	       CLS_T := ON;
	       ALM_T := OFF;
	    4: OPN_T := OFF;
	       CLS_T := OFF;
	       ALM_T := ON;
	END_CASE;
	
	 (*ÁªËøÍ¶ÇÐÖ¸Ê¾*)
	IF BYP1  OR BYP2  OR BYP3 OR BYP4  OR BYP5 OR BYP6 OR BYPK THEN 
	   BYPALL := ON;
    ELSE 
       BYPALL := OFF;
    END_IF;
    
    (*ÁªËøÌõ¼þÖ¸Ê¾*)
    IF EMCL1 OR EMCL2 OR EMCL3 OR EMCL4 OR EMCL5 OR EMCL6 OR EMOPN  THEN 
	   EMCALL := ON;
    ELSE 
       EMCALL := OFF;
    END_IF;
	
	(*×´Ì¬½âÎö*)
	FLAG:=SBIT_UDINT(FLAG,0,SWAM);(*0ÎªÊÖ×Ô¶¯*)
	FLAG:=SBIT_UDINT(FLAG,1,OPN_T);(*1Îª¿ªµ½Î»*)
	FLAG:=SBIT_UDINT(FLAG,2,CLS_T);(*2Îª¹Øµ½Î»*)
	FLAG:=SBIT_UDINT(FLAG,3,OPN_PT);(*3Îª¿ªÇý¶¯*)
	FLAG:=SBIT_UDINT(FLAG,4,CLS_PT);(*4Îª¹ØÇý¶¯*)
	FLAG:=SBIT_UDINT(FLAG,5,ALM_T);(*5Îª¹ÊÕÏ±¨¾¯*)
	FLAG:=SBIT_UDINT(FLAG,6,SIM);(*6Îª·ÂÕæ*)
	FLAG:=SBIT_UDINT(FLAG,7,BYPALL);(*7ÎªÁªËøÍ¶Èë*)
	FLAG:=SBIT_UDINT(FLAG,8,EMCALL);(*8ÎªÁªËøÌõ¼þ³ÉÁ¢*)     
END_IF;