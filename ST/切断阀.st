(* 6个联锁关投切，1个联锁开投切，仿真切除关阀模式 *)

(*

EMCL1、EMCL2 联锁关条件
监控参数 TMP_CMD (BOOL) 驱动临时中间变量 OFF
监控参数 TEMP (BOOL) 脉冲位号 仿真结束阀门关掉的动作只执行一次

操作参数 SWAM (BOOL) 阀门手自动控制选择 OFF手动 ON自动
操作参数 MCMD (BOOL) 手动控制开关 OFF

输入引脚 STT (BOOL) 启动允许
输出引脚 ZSV (BOOL) 阀门驱动DO ON开 OFF关

监控参数 OPN_PT (BOOL) 开驱动临时变量
监控参数 CLS_PT (BOOL) 关驱动临时变量
监控参数 OPN_T (BOOL) 开到位临时变量
监控参数 CLS_T (BOOL) 关到位临时变量
监控参数 TMP_S (INT) 阀门状态临时中间变量
监控参数 STA (INT) 阀门状态（0全关；1全开；4故障）

监控参数 FLAG (UDINT) 质量码 0为手自动 1为开到位


 *)


IF MOS = 9 THEN


	// --------------------------------------------------
	// region start 判断联锁开和联锁关

	(* 1--输出命令 *)
	IF (EMCL1 AND BYP1) OR (EMCL2 AND BYP2) OR (EMCL3 AND BYP3) THEN 	(* 3个联锁关 *)
		(* 监控参数 TMP_CMD 驱动临时中间变量 OFF *)
		TMP_CMD := OFF;
	ELSEIF (EMCL4 AND BYP4) OR (EMCL5 AND BYP5)OR (EMCL6 AND BYP6) THEN 	(* 3个联锁关 *)
		TMP_CMD := OFF;
	ELSEIF (EMOPN = ON) AND BYPK THEN (* 联锁开 *)
		(* 监控参数 TMP_CMD 驱动临时中间变量 打开驱动 *)
		TMP_CMD := ON;
	ELSE
	(* 没接联锁的情况 SWAM 阀门手自动控制选择*)
		IF (SWAM = ON) THEN
			TMP_CMD := PCMD;	(* 自动开关 *)
		ELSE
			TMP_CMD := MCMD;	(* 手动开关 *)
		END_IF;
	END_IF;

	// endregion end 判断联锁开和联锁关
	// --------------------------------------------------



	IF NOT STT AND NOT ZSV THEN	(* 判断不允许启动 *)
		TMP_CMD := OFF;
	END_IF;


	// region 仿真判断 仿真结束阀门关掉
	IF NOT SIM THEN (* 仿真结束阀门关掉 *)
		IF TEMP THEN
			TMP_CMD := OFF;
			TEMP := OFF;
		END_IF;
	ELSE
		TEMP := ON;
	END_IF;
	// endregion

	(* 0关 1开 *)
	IF NOT SIM THEN
		ZSV := TMP_CMD;
	ELSE
		ZSV := OFF;
	END_IF;

	MCMD := TMP_CMD;
	PCMD := TMP_CMD;

	(* 2--分析阀门当前状态 *)

	// --------------------------------------------------
	IF (SIM = ON) THEN	(* 仿真调试 *)
		IF 	(TMP_CMD = ON) THEN	(* 状态由DO确定 *)
			TMP_S := 1; (* 阀开 *)
			STA := 1; (* 阀开 *)
		ELSE
			TMP_S := 0; (* 阀关 *)
			STA := 0; (* 阀关 *)
		END_IF;
	ELSE
		IF (ZSO = ON OR (ENSK AND SIMK)) AND (ZSC = OFF) AND NOT (ENSG AND SIMG) AND (ZSV = ON) THEN
			TMP_S := 1; (* 阀开 *)
		ELSEIF (ZSO = OFF) AND NOT (ENSK AND SIMK) AND (ZSC = ON OR (ENSG AND SIMG)) AND (ZSV = OFF) THEN
			TMP_S := 0; (* 阀关 *)
		ELSE
			TMP_S := 4; (* 阀故障 *)
		END_IF;
	END_IF;
	// --------------------------------------------------


		(* 延迟判断阀门状态 *)
	IF (TMP_S = STA) THEN
		COUNT := 0;	(* 状态无变化时，计数器清零 *)
	ELSE
		COUNT := COUNT + 1;
		IF (TMP_S = 0) THEN
			STA := TMP_S;

		ELSEIF (TMP_S = 1) THEN
			STA := TMP_S;

		ELSEIF (COUNT >= 1000 / TIME_R * TIME_DL) THEN (* 延迟判断故障 *)
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

	 (* 联锁投切指示 *)
	IF BYP1 OR BYP2 OR BYP3 OR BYP4 OR BYP5 OR BYP6 OR BYPK THEN
	 BYPALL := ON;
    ELSE
       BYPALL := OFF;
    END_IF;

    (* 联锁条件指示 *)
    IF EMCL1 OR EMCL2 OR EMCL3 OR EMCL4 OR EMCL5 OR EMCL6 OR EMOPN THEN
	 EMCALL := ON;
    ELSE
       EMCALL := OFF;
    END_IF;

	(* 状态解析 *)
	FLAG := SBIT_UDINT(FLAG, 0, SWAM); (* 0 为手自动 *)
	FLAG := SBIT_UDINT(FLAG, 1, OPN_T); (* 1 为开到位 *)
	FLAG := SBIT_UDINT(FLAG, 2, CLS_T); (* 2 为关到位 *)
	FLAG := SBIT_UDINT(FLAG, 3, OPN_PT); (* 3 为开驱动 *)
	FLAG := SBIT_UDINT(FLAG, 4, CLS_PT); (* 4 为关驱动 *)
	FLAG := SBIT_UDINT(FLAG, 5, ALM_T); (* 5 为故障报警 *)
	FLAG := SBIT_UDINT(FLAG, 6, SIM); (* 6 为仿真 *)
	FLAG := SBIT_UDINT(FLAG, 7, BYPALL); (* 7 为联锁投入 *)
	FLAG := SBIT_UDINT(FLAG, 8, EMCALL); (* 8 为联锁条件成立 *)
END_IF;