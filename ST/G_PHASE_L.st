(*
输入参数 FLAG_T (SINT) 状态自动跳转标志(来自下游业务代码模块) 初值为0 ,

输出参数 STA (SINT) PHASE状态 初值为0 ,

操作参数，CMD_A (SINT) 自动命令（PHASE软件控制）初值为0，
操作参数，CMD_M (SINT) 手动命令（面板控制）初值为0, 
操作参数，AM (BOOL) PHASE手自动

内置参数，AM_I (BOOL) 锁存手自动状态
内置参数，TMP_CMD (SINT) 内部指令
 *)

(* 配合VxBatch，下位机PHASE统一模板 *)

(* 运行时禁止切换手自动 *)
(* 在该段代码中，系统初始状态下（STA = 0），如果收到自动的启动命令（CMD_A = 1），则切换至自动模式（AM = ON）。并将当前手自动状态锁存（AM_I := AM）。一旦系统进入运行状态，则手自动状态保持不变。 *)
IF STA = 0 THEN
    IF CMD_A = 1 THEN
        AM := ON;
    END_IF;
    AM_I := AM;
ELSE
    AM := AM_I;
END_IF;



(* 自动时（AM_I为1）由`CMD_A`控制,手动时（AM_I为0）由`CMD_M`控制 *)
IF AM_I THEN (* 自动时CMD完全由BATCH控制，下位机不参与CMD置值 *)
    TMP_CMD := LIM_SINT(11, CMD_A, 0); (* 通过限制函数LIM_SINT确保命令在0到11之间，防止命令越界。 *)
    CMD_M := 0; (* BATCH控制时，CMD_M恒为0，防止切换扰动 *)

ELSE (* 手动时，下位机仿照BATCH软件逻辑有条件地对CMD进行置值 *)
    IF STA = 8 OR STA = 10 THEN (* 当处于COMPLETE或STOPPED，BATCH写RESET命令，手动模拟此功能 当处于COMPLETE或STOPPED状态时（STA = 8或10），手动模式下模拟发出复位命令（CMD_M := 6）。 *)
        CMD_M := 6; (* RESET命令 *)
    END_IF;
    TMP_CMD := LIM_SINT(11, CMD_M, 0); (* 通过限制函数LIM_SINT确保命令在0到11之间，防止命令越界。 *)
    CMD_M := 0;
    CMD_A := 0; (* 手动时CMD_A恒为0，防止Batch误触发导致切换扰动 *)
END_IF;

(* ------------以上代码的意思是由 CMD_M手动命令（面板控制） 或 CMD_A自动命令（PHASE软件控制） 获得TMP_CMD的值 ------------ *)




(* TMP_CMD 为11时，重新回到初始状态0 *)
IF TMP_CMD = 11 THEN
    TMP_CMD := 0;
END_IF;




(* 状态机处理 控制命令处理，满足上位机状态基切换
根据临时命令（TMP_CMD）的值，状态机（STA）在不同状态之间进行切换。例如：
 *)
CASE TMP_CMD OF
    1: (* 启动， 从空闲状态（STA = 0）进入运行状态（STA = 1）。 *)
        IF STA = 0 THEN
            STA := 1;
        END_IF;
	2: (* 停止， 从运行、暂停等状态（STA = 1, 2, 5等）进入停止状态（STA = 4）。 *)
        IF STA = 1 OR STA = 2 OR STA = 5 OR STA = 11 OR STA = 12 OR STA = 13 THEN
            STA := 4;
        END_IF;
	3: (* 暂停， 从运行状态（STA = 1）进入暂停状态（STA = 2）。 *)
        IF STA = 1 THEN
            STA := 2;
        END_IF;
	4: (* ABORT *)
        IF STA = 1 OR STA = 2 OR STA = 4 OR STA = 5 OR STA = 11 OR STA = 12 OR STA = 13 THEN
            STA := 9;
        END_IF;
	5: (* RESUME *)
        IF STA = 5 THEN
            STA := 1;
        END_IF;
	6: (* RESET， 从ABORTED,强制放弃状态（STA = 6）, COMPLETE状态（STA = 8）, STOPPED,已停止状态（STA = 10）回到空闲状态（STA = 0）。 *)
        IF STA = 6 OR STA = 8 OR STA = 10 THEN
            STA := 0;
        END_IF;
	8: (* RESTART , STA从HELD 到 RESTARTING*)
        IF STA = 12 THEN 
            STA := 13;
        END_IF;
	9: (* FORCE_RESET, 跳出状态机新增处理跳步指令，收到该指令无论处于何状态强制复位，保证下次可启动。 
            强制复位（CMD = 9）时，无论当前状态如何，强制进入空闲状态（STA = 0）。
      *)
        IF STA <> 0 THEN
            STA := 0;
        END_IF;
    10: (* HOLD *)
        IF STA = 1 OR STA = 2 OR STA = 5 OR STA = 13 THEN
            STA := 11;(*HOLDING,保持中*)
        END_IF;

END_CASE;
(* *************************以上内容除程序参数外，均为`固定格式`，不可更改***************************** *)




















(* FLAG_T *)
(* 值为1，RUNNING ➡️ COMPLETE，运行正常结束 *)
(* 值为2，PAUSING ➡️ PAUSED，暂停中到已暂停 *)
(* 值为3，RESTARTING ➡️ RUNNING，暂停状态恢复到运行状态中 *)
(* 值为4，STOPPING ➡️ STOPPED，停止到完成 *)
(* 值为5，HOLDING ➡️ HELD，保持中到已保持 *)
(* 值为6，ABORTING ➡️ ABORTED，放弃中到已放弃 *)
(* 值为7，RUNNING/RESTARTING/PAUSING/PAUSED ➡️ HOLDING,运行中、重启中、暂停中、已暂停 至 保持中，故障信号响应 *)

(* 非RUNNING状态下，运行计数器保持初始化 *)
IF STA <> 1 THEN
    CD_F := 0;
END_IF;
(* 每秒系统周期数计算 *)
TL := 1000 / TR;
(* 各状态逻辑运行 *)
CASE STA OF
    0: (* IDLE 在空闲状态（STA = 0），所有计数器和时间显示变量重置为0。 *)
      CD_RN := 0;
      CD_PA := 0;
      CD_F := 0;
      S_RN := 0;
      S_PA := 0;
      M_RN := 0;
      M_PA := 0;
      H_RN := 0;
      H_PA := 0;
    1: (* RUNNING 在运行状态（STA = 1），内部运行计数器（CD_RN）和RUNNING状态计数器（CD_F）增加。如果运行时间超过10秒且正常结束（FLAG_T = 1），状态切换至完成状态（STA = 8）；如果出现故障（FLAG_T = 7），状态切换至保持状态（STA = 11）。 *)
      CD_RN := CD_RN + 1;
      (* RUNNING状态计数器（CD_F） 运行计数，用于保持运行状态维持时间超过10s，确保上位机正确抓取状态 *)
      CD_F := CD_F + 1;
      IF FLAG_T = 1 AND CD_F >= 10 * UDINT_TO_UINT(TL) THEN
         STA := 8;
      END_IF;
      (* FAIL Monitor,故障记录 *)
      IF FLAG_T = 7 THEN
         STA := 11;
      END_IF;

    2: (* PAUSING, 在暂停状态（STA = 2），内部暂停计数器（CD_PA）增加。如果正常暂停（FLAG_T = 2），状态切换至已暂停状态（STA = 5）；如果出现故障（FLAG_T = 7），状态切换至保持状态（STA = 11）。 *)
      CD_PA := CD_PA + 1;
      IF FLAG_T = 2 THEN
         STA := 5;
      END_IF;
      (* FAIL Monitor,故障记录 *)
      IF FLAG_T = 7 THEN
         STA := 11;
      END_IF;

    4: (* STOPPING *)
      CD_RN := CD_RN + 1;
      IF FLAG_T = 4 THEN
         STA := 10;
      END_IF;

    5: (* PAUSED *)
      CD_PA := CD_PA + 1;
      (* FAIL Monitor,故障记录 *)
      IF FLAG_T = 7 THEN
         STA := 11;
      END_IF;

    6: (* ABORTED,强制放弃，需要人为进行复位操作 *)
      (* NULL *);

    8: (* COMPLETE,可由RUNNING进入 *)
      (* NULL *);

    9: (* ABORTING,放弃中 *)
      CD_RN := CD_RN + 1;
      IF FLAG_T = 6 THEN
         STA := 6;
      END_IF;

   10: (* STOPPED,已停止，可由STOPPING进入 *)
      (* NULL *);

   11: (* HOLDING,保持中 *)
      CD_PA := CD_PA + 1;
      IF FLAG_T = 5 THEN
         STA := 12;
      END_IF;

   12: (* HELD,已保持 *)
      CD_PA := CD_PA + 1;

   13: (* RESTARTING,重启中 *)
      CD_RN := CD_RN + 1;
      IF FLAG_T = 3 THEN
         STA := 1;
      END_IF;
      (* FAIL Monitor,故障记录 *)
      IF FLAG_T = 7 THEN
         STA := 11;
      END_IF;

END_CASE;

(* 显示时间计算 该部分代码根据计数器值和系统周期数，计算并显示运行时间（H_RN, M_RN, S_RN）和暂停时间（H_PA, M_PA, S_PA）。 *)
H_RN := UDINT_TO_UINT(CD_RN / TL / 3600);
M_RN := UDINT_TO_UINT(CD_RN / TL MOD 3600 / 60);
S_RN := UDINT_TO_UINT(CD_RN / TL MOD 60);
H_PA := UDINT_TO_UINT(CD_PA / TL / 3600);
M_PA := UDINT_TO_UINT(CD_PA / TL MOD 3600 / 60);
S_PA := UDINT_TO_UINT(CD_PA / TL MOD 60);

(* RESET 当复位标志（RESET）被触发时，系统将所有变量重置为初始状态，确保系统可以重新启动。 *)
IF RESET THEN
   RESET := OFF;
   STA := 0;
   CMD_A := 0;
   CMD_M := 0;
   S_RN := 0;
   S_PA := 0;
   M_RN := 0;
   M_PA := 0;
   H_RN := 0;
   H_PA := 0;
   CD_RN := 0;
   CD_PA := 0;
   CD_F := 0;
END_IF;