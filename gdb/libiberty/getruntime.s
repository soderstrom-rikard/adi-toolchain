// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "getruntime.i";
.text;
.align 2
.global _get_run_time;
.type _get_run_time, STT_FUNC;
_get_run_time:
	LINK 72;
	R0  =FP ;
	R1  = -72 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	R0  = 0 (X);
	call _getrusage;
	R1  =[FP +-72];
	R0  =[FP +-64];
	R0 =R1 +R0 ;
	R1  = 15625 (X); R1  <<= 6; // zeros
	R0  *=R1 ;
	R1  =[FP +-68];
	R0 =R0 +R1 ;
	R1  =[FP +-60];
	R0 =R0 +R1 ;
	UNLINK;
	rts;


