(*

输入参数 FAIL (BOOL) 故障输入信号
输入参数 STA (SINT) PHASE状态
输入参数 STT (BOOL) 启动允许
输入参数 MV_SET (REAL) 
输入参数 WT (REAL) 滴加缸称重
输入参数 WT_SET (REAL) 滴加总量设定
输入参数 WT_HZ_X (REAL) 
输入参数 FT (REAL) 瞬时流量

输出参数 FLAG_O (SINT) 状态转换标志，反馈给接口模块 
输出参数 WT_S (REAL) 理论投料终点
输出参数 WT_F1 (REAL) 实际投料量
输出参数 TS (BOOL) 
输出参数 TS1 (BOOL) 启动条件不满足
输出参数 OUT1 (BOOL) - AO_M 打料泵自动开
输出参数 OUT2 (BOOL) - AO_V1 罐出口阀自动开
输出参数 OUT3 (BOOL) - AO_V3 物料进料阀自动开
输出参数 OUT5 (BOOL) - MV1 打料泵变频手动给定值

内置参数 STA_O (SINT) 上周期PHASE状态记录，用于抓取状态跳转
内置参数 FLAG_T (SINT) 状态转换标志临时变量

监控参数 STEP_RN (UINT) RUNNING状态运行步序
监控参数 STEP_PA (UINT) PAUSING状态运行步序
监控参数 STEP_RE (UINT) RESUMING状态运行步序
监控参数 STEP_SP (UINT) STOPPING状态运行步序
监控参数 STEP_HD (UINT) HOLDING状态运行步序
监控参数 COUNT (UINT) 状态内计数器，不做计时功能
监控参数 COUNT1 (UINT) 计数器
监控参数 COUNT3 (UINT) 计数器
监控参数 WT_O (REAL) 记录投料初始量
监控参数 WT_W (REAL) 临时称重变量
监控参数 ADD_N (INT)  1是一段式打料 2是二段式打料
监控参数 WT_SET_1 (REAL)  一段式打料中与WT_SET相同 

别名变量 PDQQ (BOOL) 排队请求
别名变量 FAIL_I (BOOL) 故障忽视按钮
别名变量 PDYX (BOOL) 排队允许
别名变量 AM_M (BOOL) 打料泵手自动
别名变量 AO_M (BOOL) 打料泵自动开
别名变量 AO_V1 (BOOL) 罐出口阀自动开
别名变量 AM_V1 (BOOL) 罐出口阀手自动
别名变量 AM_V3 (BOOL) 物料进料阀手自动
别名变量 AM_MV1 (BOOL) 打料泵变频回路手自动
别名变量 STA_V3 (INT) 物料进料阀状态
别名变量 STA_M (INT) 打料泵电机状态
别名变量 WT_AH1 (REAL) 打料程序结束提前量
别名变量 AO_V3 (BOOL) 物料进料阀自动开
别名变量 MV1 (REAL) 打料泵变频手动给定值

 *)

(* 单罐单泵无出口阀，有打料变频，无进料总阀 *)

(* 当PHASE状态转换时¸复位瞬态运行完成标志 *)
(*如果 STA（当前状态）与 STA_O（上一个周期状态）不同，则复位各个步骤计数器和状态转换标志。这表明检测到状态转换时，需要进行一些初始化操作。 *)

(*内置参数 STA_O (SINT) `上周期`PHASE状态记录，用于抓取状态跳转*)
(*输入参数 STA (SINT) PHASE状态*)
IF STA_O <> STA THEN
    (* 内置参数 FLAG_T (SINT) 状态转换标志临时变量 *)
    FLAG_T := 0;
    (* 监控参数 STEP_PA (UINT) PAUSING状态运行步序 *)
    STEP_PA := 0;
    (* 监控参数 STEP_RE (UINT) RESUMING状态运行步序 *)
    STEP_RE := 0;
    (* 监控参数 STEP_SP (UINT) STOPPING状态运行步序 *)
    STEP_SP := 0;
    (* 监控参数 STEP_HD (UINT) HOLDING状态运行步序*)
    STEP_HD := 0;
END_IF;



(* 以下编辑业务代码 *)
(* 输入参数 STA (SINT) PHASE状态 *)
CASE STA OF
    0: (* IDLE 闲置的 *)(* 编写IDLE状态业务代码 *);
        
        (* 在 IDLE 状态下，所有状态转换标志和步骤计数器都被复位。排队请求 PDQQ 被关闭，计数器 COUNT, COUNT1, COUNT3 也被复位。 *)
        (* 内置参数 FLAG_T (SINT) 状态转换标志临时变量 *)
        FLAG_T := 0;
        (* 监控参数 STEP_RN (UINT) RUNNING状态运行步序 *)
        STEP_RN := 0;
        (* 监控参数 STEP_PA (UINT) PAUSING状态运行步序 *)
        STEP_PA := 0;
        (* 监控参数 STEP_RE (UINT) RESUMING状态运行步序 *)
        STEP_RE := 0;
        (* 监控参数 STEP_SP (UINT) STOPPING状态运行步序 *)
        STEP_SP := 0;
        (* 监控参数 STEP_HD (UINT) HOLDING状态运行步序 *)
        STEP_HD := 0;
        (* 别名变量 PDQQ (BOOL) 排队请求 *)
        PDQQ := OFF;
        COUNT := 0;
        COUNT1 := 0;
        COUNT3 := 0;
        
    1: (* RUNNING *)
        (* 编写RUNNING状态业务代码，步序变量为STEP_RN，结束步必须包含语句FLAG_T = 1 *);
        (* 内置参数 FLAG_T (SINT) 状态转换标志临时变量 *)
        CASE STEP_RN OF
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 0 时 *)
            0:
                PDQQ := ON ;
                (* 别名变量 PDYX (BOOL) 排队允许 *)
                (* 输入参数 STT (BOOL) 启动允许 *)
                IF PDYX = ON AND STT = ON THEN
                    STEP_RN := 1 ;
                ELSEIF STT = OFF THEN
                    (* 输出参数 TS1 (BOOL) 启动条件不满足 *)
                    TS1 := ON; (* TS1为ON表示启动条件不满足 *)
                    STEP_RN := 21;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 1 时 *)
            1: (* 阀门电机切换成自动，调节阀切换成手动 *)
                TS := OFF; 
                TS1 := OFF; (* TS1为OFF表示启动条件满足了 *)
                (*别名变量 AM_M (BOOL) 打料泵手自动 ON自动 OFF手动 *)
                (*打料泵切成自动 *)
                AM_M := ON;
                (*别名变量 AM_V1 (BOOL) 罐出口阀手自动   ON自动 OFF手动*)
                (*罐出口阀切成自动 *)
                AM_V1 := ON;
                (*别名变量 AM_V3 (BOOL) 物料进料阀手自动   ON自动 OFF手动*)
                (*物料进料阀切成自动 *)
                AM_V3 := ON;
                (* AM_V4 :=ON; *)
                STEP_RN := 2 ;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 2 时 *)
            2: (* 判断投料量与提前量 *)
                (*监控参数 WT_O (REAL) 记录投料初始量 *)
                WT_O := WT ; (* 称一下重记录投料初始量 *)
                (*输出参数 WT_S (REAL) 理论投料终点 *)
                (*输入参数 WT_SET (REAL) 滴加总量设定 *)
                WT_S := WT_O + WT_SET ;
                (*别名变量 WT_AH1 (REAL) 打料程序结束提前量 *)
                IF WT_SET > WT_AH1 * 2.5 THEN
                    ADD_N := 1; (* 1为一段式 2为两段式打料 *)
                    STEP_RN := 3 ;
                ELSE
                    ADD_N := 1;
                    STEP_RN := 3 ;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 3 时 *)
            3: (* 开启电磁阀打料泵，开启放料阀调节阀开100 *)
                IF ADD_N = 2 THEN
                    WT_SET_1 := WT_SET / 2.0;
                    STEP_RN := 4 ;
                    (*一段式打料走以下程序 *)
                ELSEIF ADD_N = 1 THEN
                    WT_SET_1 := WT_SET;
                    STEP_RN := 4 ;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 4 时 *)
            4: (* 开启电磁阀打料泵，开启放料阀调节阀开100 *)
                (*别名变量 AO_V1 (BOOL) 罐出口阀自动开 *)
                AO_V1 := ON;
                (*别名变量 AO_M (BOOL) 打料泵自动开 *)
                AO_M := ON;
                (*别名变量 AM_MV1 (BOOL) 打料泵变频回路手自动 *)
                AM_MV1 := OFF;
                (*别名变量 MV1 (REAL) 打料泵变频手动给定值 *)
                MV1 := 100.0;
                COUNT := 0;
                (*别名变量 STA_M (INT) 打料泵电机状态 *)
                IF STA_M = 1 THEN (* 判断泵前开关阀机及调节阀电磁阀状态 *)
                    STEP_RN := 5;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 5 时 *)
            5:
                (*别名变量 MV1 (REAL) 打料泵变频手动给定值 *)
                MV1 := 100.0;
                (* IF COUNT > 2 THEN
                    STEP_RN :=6 ;
                ELSE
                    COUNT := COUNT + 1;
                END_IF; *)

                STEP_RN := 6 ;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 6 时 *)
            6:
                (*别名变量 MV1 (REAL) 打料泵变频手动给定值 *)
                MV1 := 100.0;
                (*别名变量 AO_V3 (BOOL) 物料进料阀自动开 *)
                AO_V3 := ON ; (* 开进料阀 *)
                (* AO_V4 := ON ; *)
                (*别名变量 STA_V3 (INT) 物料进料阀状态 *)
                IF STA_V3 = 1 THEN
                    STEP_RN := 7;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 7 时 *)
            7: (* 当投料达到调频设定值,调节阀调节变频设定值 *)
                COUNT := 0;
                IF WT - WT_O >= WT_SET_1 - WT_HZ_X THEN
                    STEP_RN := 8 ;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 8 时 *)
            8: (* 当重量到达提前量关闭打料泵 *)
                (*别名变量 MV1 (REAL) 打料泵变频手动给定值 *)
                MV1 := MV_SET ;
                COUNT := 0;
                (*WT滴加缸称重 *)
                (*(*别名变量 WT_AH1 (REAL) 打料程序结束提前量 *) *)
                IF WT - WT_O >= WT_SET_1 - WT_AH1 THEN
                    STEP_RN := 9 ;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 9 时 *)
            9:
                AO_V3 := OFF ; (* 关进料阀 *)
                MV1 := 0.0; (* 关变频 *)
                IF AO_V3 = OFF THEN
                    COUNT := 0;
                    STEP_RN := 10;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 10 时 *)
            10:
                IF COUNT > 10 THEN (* 延时5秒关进料总阀 *)
                    STEP_RN := 11 ;
                ELSE
                    COUNT := COUNT + 1;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 11 时 *)
            11:
                (* MV1 := 0.0; 关变频 *)
                (* AO_V4 := OFF ; 关进料总阀 *)
                AO_M := OFF; (* 关泵 *)
                AO_V1 := OFF;
                COUNT := 0;
                IF STA_M = 0 THEN
                    STEP_RN := 12;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 12 时 *)
            12:
                (* 提前量修正 *)
                IF ADD_N = 2 THEN
                    WT_AH1 := WT_AH1 + WT_F1 - WT_SET_1 ;
                    STEP_RN := 13;
                ELSEIF ADD_N = 1 THEN
                    (* WT_AH1 := WT_AH1 + WT_F1 - WT_SET_1 ; *)
                    STEP_RN := 22; (* 跳到结束步 *)
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 13 时 *)
            13:
                AO_V1 := ON;
                AO_M := ON;
                MV1 := 100.0;
                COUNT := 0;
                IF STA_M = 1 THEN (* 判断泵前开关阀机及调节阀电磁阀状态 *)
                    STEP_RN := 14;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 14 时 *)
            14:
                IF COUNT > 6 THEN
                    STEP_RN := 15 ;
                ELSE
                    COUNT := COUNT + 1;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 15 时 *)
            15:
                AO_V3 := ON ;
                IF STA_V3 = 1 THEN
                    STEP_RN := 16;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 16 时 *)
            16: (* 当投料达到调频设定值,调节阀调节变频设定值 *)
                COUNT := 0;
                IF WT - WT_O >= WT_SET - WT_HZ_X THEN
                    STEP_RN := 17 ;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 17 时 *)
            17: (* 当重量到达提前量关闭打料泵 *)
                MV1 := MV_SET ;
                COUNT := 0;
                IF WT - WT_O >= WT_SET - WT_AH1 THEN
                    STEP_RN := 18 ;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 18 时 *)
            18:
                AO_V3 := OFF ; (* 关进料阀 *)
                MV1 := 0.0;
                IF STA_V3 = 0 THEN
                    STEP_RN := 19;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 19 时 *)
            19:
                IF COUNT > 10 THEN (* 延时5秒关进料总阀 *)
                    (* AO_V4 := OFF ; *)
                    STEP_RN := 20 ;
                ELSE
                    COUNT := COUNT + 1;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 20 时 *)
            20:
                (* MV1 := 0.0; *)

                AO_M := OFF;
                AO_V1 := OFF;
                COUNT := 0;
                IF STA_M = 0 THEN
                    STEP_RN := 21;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 21 时 *)
            21:
                (* 提前量修正 *)
                (* WT_AH1 := WT_AH1 + WT_F1 - WT_SET ; *)
                STEP_RN := 22;
                (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 22 时 *)
            22:
                (* 别名变量 AM_M (BOOL) 打料泵手自动 *)
                AM_M := OFF;
                (* 别名变量 AM_V1 (BOOL) 罐出口阀手自动 *)
                AM_V1 := OFF;
                (* 别名变量 AM_V3 (BOOL) 物料进料阀手自动 *)
                AM_V3 := OFF;
                (* AM_V4 :=OFF; *)
                (* 别名变量 AM_MV1 (BOOL) 打料泵变频回路手自动 *)
                AM_MV1 := OFF;
                IF COUNT > 2 THEN

                    TS := OFF;
                    TS1 := OFF;
                    STEP_RN := 23 ;
                ELSE
                    COUNT := COUNT + 1;
                END_IF;
            (*STA PAHSE状态为1（RUNNING）时 STEP_RN RUNING运行步序为 23 时 *)
            23:
                (* 内置参数 FLAG_T (SINT) 状态转换标志临时变量 *)
                FLAG_T := 1; (* FLAG_T为1表示PAHSE状态机的 `RUNNING` 到 `COMPLETE`，运行正常结束 *)
        END_CASE;

        IF STEP_RN > 2 AND STEP_RN < 23 THEN (* 原­>2 <22 *)
            (*输出参数 WT_F1 (REAL) 实际投料量 *)
            (*输入参数 WT (REAL) 滴加缸称重 *)
            (*监控参数 WT_O (REAL) 记录投料初始量 *)
            WT_F1 := WT - WT_O ;
        END_IF;

        (* AO_M是打料泵自动开 *)
        OUT1 := AO_M ;
        (* AO_V1是罐出口阀自动开 *)
        OUT2 := AO_V1 ;
        (* AO_V3是物料进料阀自动开 *)
        OUT3 := AO_V3 ;
        (* OUT4 := AO_V4 ; *)
        (* MV1是打料泵变频手动给定值 *)
        OUT5 := MV1 ;

        (*别名变量 WT_AH1 (REAL) 打料程序结束提前量 *)
        IF WT_AH1 >= 100.0 THEN
            WT_AH1 := 100.0;
        END_IF;
        IF WT_AH1 <= 0.0 THEN
            WT_AH1 := 0.0;
        END_IF;

        IF STEP_RN > 3 AND STEP_RN < 18 THEN 
                (* 瞬时流量低于5000公斤每小时，持续20秒停车 *)
                (* 输入参数 FT (REAL) 瞬时流量 *)
                IF FT < 5000.0 THEN
                    IF COUNT3 >= 120 THEN
                        COUNT3 := 0;
                        TS := ON;
                        STEP_RN := 20 ;
                    ELSE 
                        COUNT3 := COUNT3 + 1;
                    END_IF;
                ELSE 
                    COUNT3 := 0;
                END_IF;
        END_IF;


    2: (* PAUSING, *)
      (* 编写PAUSING状态业务代码,步序变量为STEP_PA，结束步必须包含语句FLAG_T = 2 *);
       FLAG_T := 2;

    4: (* STOPPING *)
        (* 编写STOPPING状态业务代码,步序变量为STEP_SP，结束步必须包含语句FLAG_T = 4 *);
        CASE STEP_SP OF
        0:
            COUNT1 := 0;
            COUNT := 0;
            STEP_SP := 1;
        1:
            (* AO_V3是物料进料阀自动开，OFF是关 *)
            AO_V3 := OFF ;
            (* AO_V4 := OFF ; *)
            (*别名变量 STA_V3 (INT) 物料进料阀状态 *)
            IF STA_V3 = 0 THEN
                STEP_SP := 2;
            END_IF;
        2:
            IF COUNT > 2 THEN
                STEP_SP := 3;
            ELSE
                COUNT := COUNT + 1;
            END_IF;
        3:
            (*别名变量 MV1 (REAL) 打料泵变频手动给定值 *)
            MV1 := 0.0 ;
            (* AO_M是打料泵自动开 *)
            AO_M := OFF;
            (* AO_V1是罐出口阀自动开 *)
            AO_V1 := OFF;
            (*别名变量 STA_M (INT) 打料泵电机状态 0是关 *)
            IF STA_M = 0 THEN
                STEP_SP := 4;
            END_IF;
        4:
            (* 别名变量 AM_M (BOOL) 打料泵手自动 *)
            AM_M := OFF;
            (* 别名变量 AM_V1 (BOOL) 罐出口阀手自动 *)
            AM_V1 := OFF;
            (* AM_V4 :=OFF; *)
            (* 别名变量 AM_V3 (BOOL) 物料进料阀手自动 *)
            AM_V3 := OFF;
            (* 别名变量 AM_MV1 (BOOL) 打料泵变频回路手自动  *)
            AM_MV1 := OFF;
            STEP_SP := 5;
        5:
            FLAG_T := 4;
            END_CASE;



    11: (* HOLDING暂停 *) (* 编写HOLDING状态业务代码，步序变量为STEP_HD，结束步必须包含语句FLAG_T = 5 *);

        CASE STEP_HD OF
            0:
                COUNT1 := 0;
                COUNT := 0;
                STEP_HD := 1;
            1:
                (* AO_V3是物料进料阀自动开，OFF是关 *)
                AO_V3 := OFF ;
                (* AO_V4 := OFF ; *)
                (*别名变量 STA_V3 (INT) 物料进料阀状态 *)
                IF STA_V3 = 0 THEN
                    STEP_HD := 2;
                END_IF;
            2:
                IF COUNT > 4 THEN
                    STEP_HD := 3;
                ELSE
                    COUNT := COUNT + 1;
                END_IF;
            3:
                (*别名变量 MV1 (REAL) 打料泵变频手动给定值 *)
                MV1 := 0.0 ;
                COUNT := 0;
                (* AO_M是打料泵自动开 *)
                AO_M := OFF;
                (* AO_V1是罐出口阀自动开 *)
                AO_V1 := OFF;
                (*别名变量 STA_M (INT) 打料泵电机状态 0是关 *)
                IF STA_M = 0 THEN
                    STEP_HD := 4;
                END_IF;
            4:
                FLAG_T := 5;
                END_CASE;

    13: (* RESTARTING恢复 *)
      (* 编写RESTARTING状态业务代码,步序变量为STEP_RE，结束步必须包含语句FLAG_T = 3 *);

        CASE STEP_RE OF
            0:
                COUNT1 := 0;
                COUNT := 0;
                (* 别名变量 AM_M (BOOL) 打料泵手自动 ON自动 *)
                AM_M := ON;
                (* 别名变量 AM_V1 (BOOL) 罐出口阀手自动 ON自动 *)
                AM_V1 := ON;
                (* AM_V4 :=ON; *)
                (* 别名变量 AM_V3 (BOOL) 物料进料阀手自动 ON自动 *)
                AM_V3 := ON;
                (* 别名变量 AM_MV1 (BOOL) 打料泵变频回路手自动 OFF手动  *)
                AM_MV1 := OFF;
                STEP_RE := 1 ;
            1:
                (* AO_M是打料泵自动开 *)
                AO_M := OUT1;
                (* AO_V1是罐出口阀自动开 *)
                AO_V1 := OUT2;
                (* AO_V3是物料进料阀自动开，OFF是关 *)
                AO_V3 := OUT3;
                (* AO_V4 := OUT4; *)
                (*别名变量 MV1 (REAL) 打料泵变频手动给定值 *)
                MV1 := OUT5;
                IF COUNT > 3 THEN
                    STEP_RE := 2;
                ELSE
                    COUNT := COUNT + 1;
                END_IF;
            2:
                COUNT := 0;
                FLAG_T := 3;
        END_CASE;

    9: (* ABORTING *) (* 编写ABOUTING状态业务代码,步序变量为STEP_AB，结束步必须包含语句FLAG_T = 6 *);
        FLAG_T := 6;


END_CASE;


(* 输入参数 FAIL (BOOL) 故障输入信号 *)
(* 别名变量 FAIL_I (BOOL) 故障忽视按钮 *)
(* 故障信号为ON,且未忽略故障时，强制状态转化标志为故障自动暂停，处于运行中(STA = 1)、重启中(STA = 13)、暂停中(STA = 2)及已暂停(STA = 5)才响应故障信号 *)
IF FAIL AND NOT FAIL_I AND (STA = 1 OR STA = 2 OR STA = 5 OR STA = 13 ) THEN
    (*输出参数 FLAG_O (SINT) 状态转换标志，反馈给接口模块  *)
    FLAG_O := 7;
ELSE
    (*输出参数 FLAG_O (SINT) 状态转换标志，反馈给接口模块  *)
    FLAG_O := FLAG_T;
END_IF;

(* 故障消除时，自动复位故障忽视按钮 *)
IF NOT FAIL AND FAIL_O THEN
    (* 别名变量 FAIL_I (BOOL) 故障忽视按钮 *)
    FAIL_I := OFF;
END_IF;

(* 本周期结束前记录本周期参数状态 *)
(* STA_O (SINT) 上周期PHASE状态记录，用于抓取状态跳转 *)
STA_O := STA;
(* FAIL_O (BOOL) 上周期FAIL状态，用于抓取故障消除时刻 *)
FAIL_O := FAIL;
