/*
 *
 *   Copyright (c) 2003 Analog Devices Inc., 
 *
 */

%{

#include <stdlib.h>
#include <string.h>
#include "bfin-defs.h"
#include "bfin-parse.tab.h"
#include "as.h"

#ifdef TEST
int main()
{

  printf ("Result is %d\n",yylex());
}
struct {
  long regno;
  long value;
  struct {
    char *name;
  } *symbol;
} yylval;
#endif  /*  TEST  */


static long parse_int (char **end);


%}
A                  [Aa]
B                  [Bb]
C                  [Cc]
D                  [Dd]
E                  [Ee]
F                  [Ff]
G                  [Gg]
H                  [Hh]
I                  [Ii]
J                  [Jj]
K                  [Kk]
L                  [Ll]
M                  [Mm]
N                  [Nn]
O                  [Oo]
P                  [Pp]
Q                  [Qq]
R                  [Rr]
S                  [Ss]
T                  [Tt]
U                  [Uu]
V                  [Vv]
W                  [Ww]
X                  [Xx]
Y                  [Yy]
Z                  [Zz]
%%
sftreset                                yylval.regno = REG_sftreset;return REG;
omode                                   yylval.regno = REG_omode;return REG;
idle_req                                yylval.regno = REG_idle_req;return REG;
hwerrcause                              yylval.regno = REG_hwerrcause;return REG;
excause                                 yylval.regno = REG_excause;return REG;
emucause                                yylval.regno = REG_emucause;return REG;
{Z}                                     return Z;
{X}                                     return X;
{W}32                                   return W32; /* ************* */
{W}                                     return W;
{V}{I}{T}_{M}{A}{X}                     return VIT_MAX;
{V}                                     return V;
{U}{S}{P}                               yylval.regno = REG_USP;return REG;
{U}{N}{L}{I}{N}{K}                      return UNLINK;
{T}{L}                                  return TL;
{T}{H}                                  return TH;
{T}{F}{U}                               return TFU;
{T}{E}{S}{T}{S}{E}{T}                   return TESTSET;
{T}                                     return T;
{S}					return S;
{S}{Y}{S}{C}{F}{G}                      yylval.regno = REG_SYSCFG;return REG;
{S}{T}{I}                               return STI;
{S}{S}{Y}{N}{C}                         return SSYNC;
{S}{P}"."{L}                            yylval.regno = REG_SP;return LOW_REG;
{S}{P}"."{H}                            yylval.regno = REG_SP;return HIGH_REG;
{S}{P}                                  yylval.regno = REG_SP;return REG;
{S}{I}{G}{N}{B}{I}{T}{S}                return SIGNBITS;/*  add SIGN here */
{S}{I}{G}{N}                            return SIGN; /* ************* */
{S}{E}{Q}{S}{T}{A}{T}                   yylval.regno = REG_SEQSTAT;return REG;
{S}{E}{A}{R}{C}{H}                      return SEARCH;
{S}{H}{I}{F}{T}				return SHIFT;
{S}{C}{O}                               return SCO;

{S}{A}{A}                               return SAA;
{S}2{R}{N}{D}                           return S2RND;
{S}                                     return S;
{R}{T}{X}                               return RTX;
{R}{T}{S}                               return RTS;
{R}{T}{N}                               return RTN;
{R}{T}{I}                               return RTI;
{R}{T}{E}                               return RTE;
{R}{O}{T}                               return ROT;
{R}{N}{D}20                             return RND20;
{R}{N}{D}12                             return RND12;
{R}{N}{D}{L}                            return RNDL;
{R}{N}{D}{H}                            return RNDH;
{R}{N}{D}                               return RND;
{R}7"."{L}                              yylval.regno = REG_R7;return LOW_REG;  /*  printf ("REG_R7 = %d \n", yylval.regno); return LOW_REG; */
{R}6"."{L}                              yylval.regno = REG_R6;return LOW_REG;  /*  printf ("REG_R6 = %d \n", yylval.regno); return LOW_REG;*/
{R}5"."{L}                              yylval.regno = REG_R5;return LOW_REG;  /*  printf ("REG_R5 = %d \n", yylval.regno); return LOW_REG; */ 
{R}4"."{L}                              yylval.regno = REG_R4;return LOW_REG;
{R}3"."{L}                              yylval.regno = REG_R3;return LOW_REG;
{R}2"."{L}                              yylval.regno = REG_R2;return LOW_REG;
{R}1"."{L}                              yylval.regno = REG_R1;return LOW_REG;
{R}0"."{L}                              yylval.regno = REG_R0;return LOW_REG;
{R}7"."{H}                              yylval.regno = REG_R7;return HIGH_REG;
{R}6"."{H}                              yylval.regno = REG_R6;return HIGH_REG;  /*   printf ("REG_R6 = %d \n", yylval.regno); return HIGH_REG;  */
{R}5"."{H}                              yylval.regno = REG_R5;return HIGH_REG;
{R}4"."{H}                              yylval.regno = REG_R4;return HIGH_REG;
{R}3"."{H}                              yylval.regno = REG_R3;return HIGH_REG;
{R}2"."{H}                              yylval.regno = REG_R2;return HIGH_REG;
{R}1"."{H}                              yylval.regno = REG_R1;return HIGH_REG;
{R}0"."{H}                              yylval.regno = REG_R0;return HIGH_REG;
{R}7"."{B}                              yylval.regno = REG_R7;return BYTE_REG;
{R}6"."{B}                              yylval.regno = REG_R6;return BYTE_REG;
{R}5"."{B}                              yylval.regno = REG_R5;return BYTE_REG;
{R}4"."{B}                              yylval.regno = REG_R4;return BYTE_REG;
{R}3"."{B}                              yylval.regno = REG_R3;return BYTE_REG;
{R}2"."{B}                              yylval.regno = REG_R2;return BYTE_REG;
{R}1"."{B}                              yylval.regno = REG_R1;return BYTE_REG;
{R}0"."{B}                              yylval.regno = REG_R0;return BYTE_REG;
{R}{E}{T}{X}                            yylval.regno = REG_RETX;return REG;
{R}{E}{T}{S}                            yylval.regno = REG_RETS;return REG;
{R}{E}{T}{N}                            yylval.regno = REG_RETN;return REG;
{R}{E}{T}{I}                            yylval.regno = REG_RETI;return REG;
{R}{E}{T}{E}                            yylval.regno = REG_RETE;return REG;
{R}{A}{I}{S}{E}                         return RAISE;
{R}7                                    yylval.regno = REG_R7;return REG;   /*  printf ("REG_R7 = %d \n", yylval.regno);return REG;  */
{R}6                                    yylval.regno = REG_R6;return REG;
{R}5                                    yylval.regno = REG_R5;return REG;
{R}4                                    yylval.regno = REG_R4;return REG;
{R}3                                    yylval.regno = REG_R3;return REG;
{R}2                                    yylval.regno = REG_R2;return REG;
{R}1                                    yylval.regno = REG_R1;return REG;
{R}0                                    yylval.regno = REG_R0;return REG;
{R}                                     return R;
{P}{R}{N}{T}                            return PRNT; /* ************* */
{P}{R}{E}{F}{E}{T}{C}{H}                return PREFETCH;
{P}{C}                                  return PC; /* *************** */
{P}{A}{C}{K}                            return PACK;
{P}5"."{L}                              yylval.regno = REG_P5;return LOW_REG;
{P}4"."{L}                              yylval.regno = REG_P4;return LOW_REG;
{P}3"."{L}                              yylval.regno = REG_P3;return LOW_REG;
{P}2"."{L}                              yylval.regno = REG_P2;return LOW_REG;
{P}1"."{L}                              yylval.regno = REG_P1;return LOW_REG;
{P}0"."{L}                              yylval.regno = REG_P0;return LOW_REG;
{P}5"."{H}                              yylval.regno = REG_P5;return HIGH_REG;
{P}4"."{H}                              yylval.regno = REG_P4;return HIGH_REG;
{P}3"."{H}                              yylval.regno = REG_P3;return HIGH_REG;
{P}2"."{H}                              yylval.regno = REG_P2;return HIGH_REG;
{P}1"."{H}                              yylval.regno = REG_P1;return HIGH_REG;
{P}0"."{H}                              yylval.regno = REG_P0;return HIGH_REG;
{P}5                                    yylval.regno = REG_P5;return REG;
{P}4                                    yylval.regno = REG_P4;return REG;
{P}3                                    yylval.regno = REG_P3;return REG;
{P}2                                    yylval.regno = REG_P2;return REG;
{P}1                                    yylval.regno = REG_P1;return REG;
{P}0                                    yylval.regno = REG_P0;return REG;
{O}{U}{T}{C}                            return OUTC; /* ************* */
{O}{N}{E}{S}                            return ONES;

{N}{O}{T}                               return NOT;
{N}{O}{P}                               return NOP;
{N}{S}                                  return NS;

{M}{I}{N}                               return MIN;
{M}{A}{X}                               return MAX;
{M}3"."{H}                              yylval.regno = REG_M3;return HIGH_REG;
{M}2"."{H}                              yylval.regno = REG_M2;return HIGH_REG;
{M}1"."{H}                              yylval.regno = REG_M1;return HIGH_REG;
{M}0"."{H}                              yylval.regno = REG_M0;return HIGH_REG;
{M}3"."{L}                              yylval.regno = REG_M3;return LOW_REG;
{M}2"."{L}                              yylval.regno = REG_M2;return LOW_REG;
{M}1"."{L}                              yylval.regno = REG_M1;return LOW_REG;
{M}0"."{L}                              yylval.regno = REG_M0;return LOW_REG;
{M}3                                    yylval.regno = REG_M3;return REG;
{M}2                                    yylval.regno = REG_M2;return REG;
{M}1                                    yylval.regno = REG_M1;return REG;
{M}0                                    yylval.regno = REG_M0;return REG;
{M}                                     return M;
{L}{T}1                                 yylval.regno = REG_LT1;return REG;
{L}{T}0                                 yylval.regno = REG_LT0;return REG;
{L}{T}                                  return LT;
{L}{S}{H}{I}{F}{T}                      return LSHIFT;
{L}{S}{E}{T}{U}{P}                      return LSETUP;

{L}{I}{N}{K}                            return LINK;
{L}{E}                                  return LE;
{L}{C}1                                 yylval.regno = REG_LC1;return REG;
{L}{C}0                                 yylval.regno = REG_LC0;return REG;
{L}{B}1                                 yylval.regno = REG_LB1;return REG;
{L}{B}0                                 yylval.regno = REG_LB0;return REG;
{L}{A}{S}{T}{R}{E}{G}                   yylval.regno = REG_LASTREG;return REG;
{L}3"."{H}                              yylval.regno = REG_L3;return HIGH_REG;
{L}2"."{H}                              yylval.regno = REG_L2;return HIGH_REG;
{L}1"."{H}                              yylval.regno = REG_L1;return HIGH_REG;
{L}0"."{H}                              yylval.regno = REG_L0;return HIGH_REG;
{L}3"."{L}                              yylval.regno = REG_L3;return LOW_REG;
{L}2"."{L}                              yylval.regno = REG_L2;return LOW_REG;
{L}1"."{L}                              yylval.regno = REG_L1;return LOW_REG;
{L}0"."{L}                              yylval.regno = REG_L0;return LOW_REG;
{L}3                                    yylval.regno = REG_L3;return REG;
{L}2                                    yylval.regno = REG_L2;return REG;
{L}1                                    yylval.regno = REG_L1;return REG;
{L}0                                    yylval.regno = REG_L0;return REG;
{L}{O}                                  return LO;
{J}{U}{M}{P}"."{S}                      return JUMP_DOT_S;
{J}{U}{M}{P}"."{L}                      return JUMP_DOT_L;
{J}{U}{M}{P}"."{X}                      return JUMP_DOT_X;
{J}{U}{M}{P}                            return JUMP;
{I}{U}                                  return IU;
{I}{S}{S}2                              return ISS2;
{I}{S}                                  return IS;
{I}{H}                                  return IH;
{I}{F}{L}{U}{S}{H}                      return IFLUSH;
{I}{F}                                  return IF;
{I}{D}{L}{E}                            return IDLE;
{I}3"."{H}                              yylval.regno = REG_I3;return HIGH_REG;
{I}2"."{H}                              yylval.regno = REG_I2;return HIGH_REG;
{I}1"."{H}                              yylval.regno = REG_I1;return HIGH_REG;
{I}0"."{H}                              yylval.regno = REG_I0;return HIGH_REG;
{I}3"."{L}                              yylval.regno = REG_I3;return LOW_REG;
{I}2"."{L}                              yylval.regno = REG_I2;return LOW_REG;
{I}1"."{L}                              yylval.regno = REG_I1;return LOW_REG;
{I}0"."{L}                              yylval.regno = REG_I0;return LOW_REG;
{I}3                                    yylval.regno = REG_I3;return REG;
{I}2                                    yylval.regno = REG_I2;return REG;
{I}1                                    yylval.regno = REG_I1;return REG;
{I}0                                    yylval.regno = REG_I0;return REG;
{H}{L}{T}                               return HLT; /* ************** */
{H}{I}                                  return HI;
{G}{T}                                  return GT;
{G}{P}                                  yylval.regno = REG_GP;return REG;
{G}{E}                                  return GE;
{F}{U}                                  return FU;
{F}{P}                                  yylval.regno = REG_FP;return REG;
{F}{P}"."{L}                            yylval.regno = REG_FP;return LOW_REG;
{F}{P}"."{H}                            yylval.regno = REG_FP;return HIGH_REG;
{F}{L}{U}{S}{H}{I}{N}{V}                return FLUSHINV;
{F}{L}{U}{S}{H}                         return FLUSH;

{E}{X}{T}{R}{A}{C}{T}                   return EXTRACT;
{E}{X}{P}{A}{D}{J}                      return EXPADJ;
{E}{X}{C}{P}{T}                         return EXCPT;
{E}{M}{U}{E}{X}{C}{P}{T}                return EMUEXCPT;
{D}{I}{V}{S}                            return DIVS;
{D}{I}{V}{Q}                            return DIVQ;
{D}{I}{S}{A}{L}{G}{N}{E}{X}{C}{P}{T}    return DISALGNEXCPT;
{D}{E}{P}{O}{S}{I}{T}                   return DEPOSIT;
{D}{B}{G}{H}{A}{L}{T}                   return DBGHALT; /* ********** */
{D}{B}{G}{C}{M}{P}{L}{X}                return DBGCMPLX; /* ********* */
{D}{B}{G}{A}{L}                         return DBGAL; /* ************ */
{D}{B}{G}{A}{H}                         return DBGAH; /* ************ */
{D}{B}{G}{A}                            return DBGA; /* ************* */
{D}{B}{G}                               return DBG; /* ************** */
{C}{Y}{C}{L}{E}{S}2                     yylval.regno = REG_CYCLES2;return REG;
{C}{Y}{C}{L}{E}{S}                      yylval.regno = REG_CYCLES;return REG;
{C}{S}{Y}{N}{C}                         return CSYNC;
{C}{O}                                  return CO;
{C}{L}{I}                               return CLI;

{C}{C}                                  yylval.regno = REG_CC;return REG;
{C}{A}{L}{L}"."{X}                      return CALL_DOT_X;
{C}{A}{L}{L}                            return CALL;
{B}{Y}{T}{E}{U}{N}{P}{A}{C}{K}          return BYTEUNPACK;
{B}{Y}{T}{E}{P}{A}{C}{K}                return BYTEPACK;
{B}{Y}{T}{E}{O}{P}16{M}                 return BYTEOP16M;
{B}{Y}{T}{E}{O}{P}16{P}                 return BYTEOP16P;
{B}{Y}{T}{E}{O}{P}3{P}                  return BYTEOP3P;
{B}{Y}{T}{E}{O}{P}2{M}                  return BYTEOP2M;
{B}{Y}{T}{E}{O}{P}2{P}                  return BYTEOP2P;
{B}{Y}{T}{E}{O}{P}1{P}                  return BYTEOP1P;
{B}{Y}                                  return BY;
{B}{X}{O}{R}{S}{H}{I}{F}{T}             return BXORSHIFT;
{B}{X}{O}{R}                            return BXOR;


{B}{R}{E}{V}                            return BREV;
{B}{P}                                  return BP; /* *************** */
{B}{I}{T}{T}{S}{T}                      return BITTST;
{B}{I}{T}{T}{G}{L}                      return BITTGL;
{B}{I}{T}{S}{E}{T}                      return BITSET;
{B}{I}{T}{M}{U}{X}                      return BITMUX;
{B}{I}{T}{C}{L}{R}                      return BITCLR;
{B}3"."{H}                              yylval.regno = REG_B3;return HIGH_REG;
{B}2"."{H}                              yylval.regno = REG_B2;return HIGH_REG;
{B}1"."{H}                              yylval.regno = REG_B1;return HIGH_REG;
{B}0"."{H}                              yylval.regno = REG_B0;return HIGH_REG;
{B}3"."{L}                              yylval.regno = REG_B3;return LOW_REG;
{B}2"."{L}                              yylval.regno = REG_B2;return LOW_REG;
{B}1"."{L}                              yylval.regno = REG_B1;return LOW_REG;
{B}0"."{L}                              yylval.regno = REG_B0;return LOW_REG;
{B}3                                    yylval.regno = REG_B3;return REG;
{B}2                                    yylval.regno = REG_B2;return REG;
{B}1                                    yylval.regno = REG_B1;return REG;
{B}0                                    yylval.regno = REG_B0;return REG;
{B}                                     return B;
{A}{Z}                                  yylval.regno = REG_AZ;return MODIFIED_STATUS_REG;
{A}{V}1                                 yylval.regno = REG_AV1;return MODIFIED_STATUS_REG;
{A}{V}0                                 yylval.regno = REG_AV0;return MODIFIED_STATUS_REG;
{A}{S}{T}{A}{T}                         yylval.regno = REG_ASTAT;return REG;
{A}{S}{H}{I}{F}{T}                      return ASHIFT;
{A}{S}{L}                               return ASL;
{A}{S}{R}                               return ASR;
{A}{Q}                                  yylval.regno = REG_AQ;return MODIFIED_STATUS_REG;
{A}{N}                                  yylval.regno = REG_AN;return MODIFIED_STATUS_REG;
{A}{L}{I}{G}{N}8                        return ALIGN8;
{A}{L}{I}{G}{N}24                       return ALIGN24;
{A}{L}{I}{G}{N}16                       return ALIGN16;
{A}1"."{L}                              return A_ONE_DOT_L;
{A}0"."{L}                              return A_ZERO_DOT_L;
{A}1"."{H}                              return A_ONE_DOT_H;
{A}0"."{H}                              return A_ZERO_DOT_H;
{A}{C}                                  yylval.regno = REG_AC;return MODIFIED_STATUS_REG;
{A}{B}{S}                               return ABS;
{A}{B}{O}{R}{T}                         return ABORT; /* ************ */
{A}1"."{X}                              yylval.regno = REG_A1x;return REG;
{A}1"."{W}                              yylval.regno = REG_A1w;return REG;
{A}1                                    yylval.regno = REG_A1;return REG_A11;  /* printf ("REG_A11=%d\n", yylval.regno);return REG_A11; */
{A}0"."{X}                              yylval.regno = REG_A0x;return REG;
{A}0"."{W}                              yylval.regno = REG_A0w;return REG;
{A}0                                    yylval.regno = REG_A0;return REG_A00; /* printf ("REG_A00=%d\n", yylval.regno);return REG_A00; */
"~"                                     return TILDA;
"|="                                    return _BAR_ASSIGN;
"|"                                     return BAR;
"^="                                    return _KARAT_ASSIGN;
"^"                                     return CARET;
"]"                                     return RBRACK;
"["                                     return LBRACK;
">>>="                                  return _GREATER_GREATER_GREATER_THAN_ASSIGN;
">>="                                   return _GREATER_GREATER_ASSIGN;
">>>"                                   return _GREATER_GREATER_GREATER;
">>"                                    return GREATER_GREATER;
"=="                                    return _ASSIGN_ASSIGN;
"="                                     return ASSIGN;
"<="                                    return _LESS_THAN_ASSIGN;
"<<="                                   return _LESS_LESS_ASSIGN;
"<<"                                    return LESS_LESS;
"<"                                     return LESS_THAN;
"("                                     return LPAREN;    /*    printf ("%s \n", yytext);	return LPAREN;    */
")"                                     return RPAREN;
":"                                     return COLON;     /*   printf("%s\n", yytext);	return COLON;    */
"/"                                     return SLASH; /* ************ */
"-="                                    return _MINUS_ASSIGN;
"+|+"					return _PLUS_BAR_PLUS;
"-|+"					return _MINUS_BAR_PLUS;
"+|-"					return _PLUS_BAR_MINUS;
"-|-"					return _MINUS_BAR_MINUS;
"--"                                    return _MINUS_MINUS;
"-"                                     { return MINUS;}
","                                     return COMMA;
"+="                                    return _PLUS_ASSIGN;
"++"                                    return _PLUS_PLUS;
"+"                                     return PLUS;
"*="                                    return _STAR_ASSIGN;
"*"                                     return STAR;
"&="                                    return _AMPERSAND_ASSIGN;
"&"                                     return AMPERSAND;
"%"                                     return PERCENT; /* ********** */
"!"                                     return BANG;
"=!"					return _ASSIGN_BANG;
"||"					return DOUBLE_BAR;
([0-9]+)|(0[xX][0-9a-fA-F]+)|([bhfodBHOFD]#[0-9a-fA-F]+)|(0.[0-9]+)  {
         yylval.value = parse_int (&yytext);
         return NUMBER;
     }
[A-Za-z_$][A-Za-z0-9_$]*                 { char *t =strdup (yytext);
                                           yylval.symbol = symbol_find_or_make(yytext);
					   symbol_mark_used(yylval.symbol);
					   return SYMBOL; }
[0-9][bfBF]				 {
	char *name;
	char *ref = strdup (yytext);
	if (ref[1] == 'b' || ref[1] == 'B')
	{
	   name = fb_label_name((int)(ref[0]-'0'),0);
	   yylval.symbol = symbol_find (name);

	   if ((yylval.symbol != NULL) && (S_IS_DEFINED (yylval.symbol)))
		/* local labels are never absolute. don't waste time
                   checking absoluteness. */
	       return SYMBOL;
	   as_bad ("backw. ref to unknown label \"%d:\", 0 assumed.",
                      (int)(ref[0]-'0')); 
	}
	else if (ref[1] == 'f' || ref[1] == 'F')
	{
          /*
           * forward reference. expect symbol to be undefined or
           * unknown. undefined: seen it before. unknown: never seen
           * it before.
           * construct a local label name, then an undefined symbol.
           * don't create a xseg frag for it: caller may do that.
           * just return it as never seen before.
           */
	   name = fb_label_name((int)(ref[0]-'0'),1);
	   yylval.symbol = symbol_find_or_make (name);
          /* we have no need to check symbol properties. */
	   return SYMBOL;
        }                                  
        }                                  
[ \t\n]                                    ;
"/*".*"*/"                                 ;
.                                          return yytext[0];
%%
static long parse_int (char **end)
{
  char fmt;
  int not_done = 1;
  int shiftvalue = 0;
  char * char_bag;
  long value = 0;
  char c;
  char *arg = *end;

  while (*arg && *arg == ' ') arg++;

  switch (*arg) {
    case '1':    case '2':    case '3':    case '4':
    case '5':    case '6':    case '7':    case '8':    case '9':
      fmt = 'd';
      break;

    case '0':  /* Accept diffrent formated integers hex octal and binary. */
      {
	c = *++arg; arg++;
	if (c == 'x' || c == 'X') /* hex input */
	  fmt = 'h';
	else if (c == 'b' || c == 'B')
	  fmt = 'b';
	else if (c == '.')
	  fmt = 'f';
	else {             /* octal */
	  arg--;
	  fmt = 'o';
	}
	break;
      }

    case 'd':    case 'D':    case 'h':    case 'H':
    case 'o':    case 'O':    case 'b':    case 'B':
    case 'f':    case 'F':
      {
	fmt = *arg++;
	if (*arg == '#')
	  arg++;
      }
  }

  switch (fmt) {
  case 'h':  case 'H':
    shiftvalue = 4;
    char_bag = "0123456789ABCDEFabcdef";
    break;

  case 'o':  case 'O':
    shiftvalue = 3;
    char_bag = "01234567";
    break;

  case 'b':  case 'B':
    shiftvalue = 1;
    char_bag = "01";
    break;

/*
The assembler allows for fractional constants to be created
by either the 0.xxxx or the f#xxxx format 

i.e.   0.5 would result in 0x4000

note .5 would result in the identifier .5.

The assembler converts to fractional format 1.15
by the simple rule.


value = (short)(finput*(1<<15))
*/
  case 'f':  case 'F':
  {
    float fval = 0.0;
    float pos = 10.0;
    while (1) {
      int c;
      c = *arg++;

      if (c >= '0' && c <= '9') {
        float digit = (c - '0') / pos;
        fval = fval + digit;
        pos = pos * 10.0;
      }
      else
      {
	*--arg = c;
        value = (short) (fval * (1 << 15));
        break;
      }
    }
    *end = arg+1;
    return value;
  }

  case 'd':  case 'D':
  default:
  {
    while (1) {
      int c;
      c = *arg++;
      if (c >= '0' && c <= '9')
        value = (value * 10) + (c - '0');
      else
      {
/* Constants that are suffixed with k|K are multiplied by 1024
   This suffix is only allowed on decimal constants. */
        if (c == 'k' || c == 'K')
          value *= 1024;
        else
          *--arg = c;
        break;
      }
    }
    *end = arg+1;
    return value;
  }
  }

  while (not_done) {
    char c;
    c = *arg++;
    if (c == 0 || !index (char_bag, c)) {
      not_done = 0;
      *--arg = c;
    }
    else
    {
      if (c >= 'a' && c <= 'z')
        c = c - ('a' - '9') + 1;
      else if (c >= 'A' && c <= 'Z')
        c = c - ('A' - '9') + 1;

      c -= '0';

      value = (value << shiftvalue) + c;
    }
  }
  *end = arg+1;
  return value;
}


#ifndef yywrap
int
yywrap ()
{ 
    return 1;
}
#endif
/* the garbage deleted 
 * {U}{N}{R}{A}{I}{S}{E}                   return UNRAISE;
 * {T}{S}{T}                               return TST; 
 * {S}{S}{F}_{T}{R}{U}{N}{C}_{H}{I}        return SSF_TRUNC_HI;
 * {S}{S}{F}_{T}{R}{U}{N}{C}               return SSF_TRUNC;
 * {S}{S}{F}_{R}{N}{D}_{H}{I}              return SSF_RND_HI;
 * {S}{S}{F}_{R}{N}{D}                     return SSF_RND;
 * {S}{S}{F}                               return SSF;
 * {S}{S}                                  return SS;
 * {S}{L}{E}{E}{P}                         return SLEEP;
 * {S}{K}{P}{T}                            return SKPT;
 * {S}{K}{P}{F}                            return SKPF;
 * {S}{A}{A}3{L}                           return SAA3L;
 * {S}{A}{A}3{H}                           return SAA3H;
 * {S}{A}{A}2{L}                           return SAA2L;
 * {S}{A}{A}2{H}                           return SAA2H;
 * {S}{A}{A}1{L}                           return SAA1L;
 * {S}{A}{A}1{H}                           return SAA1H;
 * {R}{S}{D}{L}                            return RSDL; 
 * {R}{O}{T}_{R}_{A}{C}                    return ROT_R_AC;
 * {R}{O}{T}_{L}_{A}{C}                    return ROT_L_AC;
 * {I}{N}{T}{R}{P}                         return INTRP;
 * {G}{F}_{M}{P}{Y}4                       return GF_MPY4;
 * {G}{F}_{M}{P}{A}4                       return GF_MPA4;
 * {G}{F}2{A}{L}{U}{C}{O}{N}{F}{I}{G}      return GF2ALUCONFIG;
 * {G}{F}2{A}{L}{U}                        return GF2ALU;
 * {F}{E}{X}{T}{S}{X}                      return FEXTSX;
 * {D}{O}{Z}{E}                            return DOZE;
 * {C}{L}{I}{P}                            return CLIP;
 * {B}{Y}{T}{E}_{S}{P}{R}{D}               return BYTE_SPRD;
 * {B}{Y}{T}{E}{O}{P}1{N}{S}               return BYTEOP1NS;
 * {B}{I}{T}_{X}{O}{R}_{A}{C}              return BIT_XOR_AC;
 * {B}{I}{T}_{I}{N}{T}{L}{V}               return BIT_INTLV;
 * {B}{I}{T}_{F}{L}{I}{P}                  return BIT_FLIP;
 * {B}{I}{T}_{D}{E}{I}{N}{T}{L}{V}         return BIT_DEINTLV;


*/
