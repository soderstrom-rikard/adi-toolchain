/*
 *
 *   Copyright (c) 2003 Analog Devices Inc., 
 *
 *   04/2004 Martin Strubel <hackfin@section5.ch>
 *       Added macros for pre-classifying registers for improved
 *       parsing through bfin-parse.y.
 *       Also changed all token matches to lowercase for better readability,
 *       sacrificing the previous total upper/lowercase freedom.
 *   09/2004 Pradip Shah <pcs@rrap-software.com>
 *       prefetch, unlink and other such keywords were not usable as
 *       parameters to call. Added a start state KEYWORD which will be
 *       the default start state, achieved by calling set_start_state()
 *       before every line is parsed. When call is processed, we set
 *       the state back to INITIAL, so keywords will not be matched.
 *       Will only work for keywords that are the "command" type keywords
 *       Only PREFETCH, LINK and UNLINK currently added
 *       Only CALL & JUMP resets the state.
 *
 */

%{

#include <stdlib.h>
#include <string.h>
#include "bfin-defs.h"
#include "bfin-parse.tab.h"
#include "as.h"

static long parse_int (char **end);
static int parse_halfreg(Register *r, int cl, char *hr);
static int parse_reg(Register *r, int type, char *rt);

// <strubi> some useful macros:
// see bfin-defs.h
// types: T_REG_R, T_REG_P, T_REG_A, T_REG_I, T_REG_B, T_REG_M

#define _REG yylval.reg


%}

/* Define Start States ... Actually we will use exclusion.
   If no start state is specified it should match any state
   and <INITIAL> would match some keyword rules only with
   initial
*/
%s KEYWORD

%%
sftreset|SFTRESET                       _REG.regno = REG_sftreset;  return REG;
omode|OMODE                             _REG.regno = REG_omode;     return REG;
idle_req|IDLE_REQ                       _REG.regno = REG_idle_req;  return REG;
hwerrcause|HWERRCAUSE                   _REG.regno = REG_hwerrcause;return REG;
excause|EXCAUSE                         _REG.regno = REG_excause;   return REG;
emucause|EMUCAUSE                       _REG.regno = REG_emucause;  return REG;
z|Z                                     return Z;
x|X                                     return X;
w32|W32                                 yylval.value = M_W32; return MMOD;
w|W                                     return W;
vit_max|VIT_MAX                         return VIT_MAX;
v|V                return V; /* special: V is a statflag and a modifier */
usp|USP            _REG.regno = REG_USP; return REG;
tl|TL                                   return TL;
th|TH                                   return TH;
tfu|TFU                                 yylval.value = M_TFU; return MMOD;
testset|TESTSET                         return TESTSET;
t|T                                     yylval.value = M_T; return MMOD;
s|S					                    return S;
syscfg|SYSCFG      _REG.regno = REG_SYSCFG; return REG;
sti|STI                                 return STI;
ssync|SSYNC                             return SSYNC;
sp"."l|SP"."L                           _REG.regno = REG_SP; return HALF_REG;
sp"."h|SP"."H                           _REG.regno = REG_SP | F_REG_HIGH; return HALF_REG;
sp|SP                                   _REG.regno = REG_SP; return REG;
signbits|SIGNBITS                       return SIGNBITS;
sign|SIGN                               return SIGN;
seqstat|SEQSTAT     _REG.regno = REG_SEQSTAT; return REG;
search|SEARCH                           return SEARCH;
shift|SHIFT                             return SHIFT;
sco|SCO                                 return SCO;

saa|SAA                                 return SAA;
s2rnd|S2RND                             yylval.value = M_S2RND; return MMOD;
rtx|RTX                                 return RTX;
rts|RTS                                 return RTS;
rtn|RTN                                 return RTN;
rti|RTI                                 return RTI;
rte|RTE                                 return RTE;
rot|ROT                                 return ROT;
rnd20|RND20                             return RND20;
rnd12|RND12                             return RND12;
rndl|RNDL                               return RNDL;
rndh|RNDH                               return RNDH;
rnd|RND                                 return RND;

[rR][0-7]"."[lLhHbB]  return parse_halfreg(&yylval.reg, T_REG_R, yytext);

rets|RETS   _REG.regno = REG_RETS; return REG;
reti|RETI   _REG.regno = REG_RETI; return REG;
retx|RETX   _REG.regno = REG_RETX; return REG;
retn|RETN   _REG.regno = REG_RETN; return REG;
rete|RETE   _REG.regno = REG_RETE; return REG;
raise|RAISE  return RAISE;

[rR][0-7]           return parse_reg(&yylval.reg, T_REG_R, yytext);

r|R       return R;
prnt|PRNT                               return PRNT;
pc|PC                                   return PC;
pack|PACK                               return PACK;

[pP][0-5]"."[lLhH]  return parse_halfreg(&yylval.reg, T_REG_P, yytext);
[pP][0-5]           return parse_reg(&yylval.reg, T_REG_P, yytext);

outc|OUTC                               return OUTC;
ones|ONES                               return ONES;

not|NOT                                 return NOT;
nop|NOP                                 return NOP;
mnop|MNOP                               return MNOP;
ns|NS                                   return NS;

min|MIN                                 return MIN;
max|MAX                                 return MAX;

[mM][0-3]"."[lLhH]  return parse_halfreg(&yylval.reg, T_REG_M, yytext);
[mM][0-3]           return parse_reg(&yylval.reg, T_REG_M, yytext);

m|M                                     return M;
lt|LT                                   return LT;
lshift|LSHIFT                           return LSHIFT;
lsetup|LSETUP                           return LSETUP;

le|LE                                   return LE;
lc0|LC0   _REG.regno = REG_LC0; return REG;
lt0|LT0   _REG.regno = REG_LT0; return REG;
lb0|LB0   _REG.regno = REG_LB0; return REG;
lc1|LC1   _REG.regno = REG_LC1; return REG;
lt1|LT1   _REG.regno = REG_LT1; return REG;
lb1|LB1   _REG.regno = REG_LB1; return REG;

[lL][0-3]"."[lLhH]  return parse_halfreg(&yylval.reg, T_REG_L, yytext);
[lL][0-3]           return parse_reg(&yylval.reg, T_REG_L, yytext);
lo|LO                                   return LO;
jump"."s|JUMP"."S                       { BEGIN 0; return JUMP_DOT_S;}
jump"."l|JUMP"."L                       { BEGIN 0; return JUMP_DOT_L;}
jump|JUMP                               { BEGIN 0; return JUMP;}
jump"."[xX]|JUMP"."[xX]                 { BEGIN 0; return JUMP_DOT_L; /* TODO: fix */}
iu|IU                                   yylval.value = M_IU;   return MMOD;
iss2|ISS2                               yylval.value = M_ISS2; return MMOD;
is|IS                                   yylval.value = M_IS;   return MMOD;
ih|IH                                   yylval.value = M_IH;   return MMOD;
if|IF                                   return IF;
[iI][0-3]"."[lLhH]  return parse_halfreg(&yylval.reg, T_REG_I, yytext);
[iI][0-3]           return parse_reg(&yylval.reg, T_REG_I, yytext);
hlt|HLT                                 return HLT;
hi|HI                                   return HI;
gt|GT                                   return GT;
ge|GE                                   return GE;
fu|FU                                   yylval.value = M_FU; return MMOD;
fp|FP            _REG.regno = REG_FP; return REG;
fp"."l|FP"."L    _REG.regno = REG_FP; return HALF_REG;
fp"."h|FP"."H    _REG.regno = REG_FP | F_REG_HIGH; return HALF_REG;

extract|EXTRACT                         return EXTRACT;
expadj|EXPADJ                           return EXPADJ;
excpt|EXCPT                             return EXCPT;
emuexcpt|EMUEXCPT                       return EMUEXCPT;
divs|DIVS                               return DIVS;
divq|DIVQ                               return DIVQ;
disalgnexcpt|DISALGNEXCPT               return DISALGNEXCPT;
deposit|DEPOSIT                         return DEPOSIT;
dbghalt|DBGHALT                         return DBGHALT;
dbgcmplx|DBGCOMPLX                      return DBGCMPLX;
dbgal|DBGAL                             return DBGAL;
dbgah|DBGAH                             return DBGAH;
dbga|DBGA                               return DBGA;
dbg|DBG                                 return DBG;
cycles2|CYCLES2   { _REG.regno = REG_CYCLES2; return REG; }
cycles|CYCLES     { _REG.regno = REG_CYCLES; return REG; }
csync|CSYNC                             return CSYNC;
co|CO                                   return CO;
cli|CLI                                 return CLI;

cc|CC        _REG.regno = REG_CC; return CCREG;
[call|CALL]"."[xX]                      { BEGIN 0; return CALL;}
call|CALL                               { BEGIN 0; return CALL;}
byteunpack|BYTEUNPACK                   return BYTEUNPACK;
bytepack|BYTEPACK                       return BYTEPACK;
byteop16m|BYTEOP16M                     return BYTEOP16M;
byteop16p|BYTEOP16P                     return BYTEOP16P;
byteop3p|BYTEOP3P                       return BYTEOP3P;
byteop2m|BYTEOP2M                       return BYTEOP2M;
byteop2p|BYTEOP2P                       return BYTEOP2P;
byteop1p|BYTEOP1P                       return BYTEOP1P;
by|BY                                   return BY;
bxorshift|BXORSHIFT                     return BXORSHIFT;
bxor|BXOR                               return BXOR;

brev|BREV                               return BREV;
bp|BP                                   return BP;
bittst|BITTST                           return BITTST;
bittgl|BITTGL                           return BITTGL;
bitset|BITSET                           return BITSET;
bitmux|BITMUX                           return BITMUX;
bitclr|BITCLR                           return BITCLR;
[bB][0-3]"."[lLhH]  return parse_halfreg(&yylval.reg, T_REG_B, yytext);
[bB][0-3]           return parse_reg(&yylval.reg, T_REG_B, yytext);
b|B                                     return B;
az|AZ     _REG.regno = S_AZ;   return MODIFIED_STATUS_REG;
an|AN     _REG.regno = S_AN;   return MODIFIED_STATUS_REG;
aq|AQ     _REG.regno = S_AQ;   return MODIFIED_STATUS_REG;
ac0|AC0   _REG.regno = S_AC0;  return MODIFIED_STATUS_REG;
ac1|AC1   _REG.regno = S_AC1;  return MODIFIED_STATUS_REG;
av0|AV0   _REG.regno = S_AV0;  return MODIFIED_STATUS_REG;
av0s|AV0S _REG.regno = S_AV0S; return MODIFIED_STATUS_REG;
av1|AV1   _REG.regno = S_AV1;  return MODIFIED_STATUS_REG;
av1s|AV1S _REG.regno = S_AV1S; return MODIFIED_STATUS_REG;
vs|VS     _REG.regno = S_VS;   return MODIFIED_STATUS_REG;

astat|ASTAT    _REG.regno = REG_ASTAT; return REG;
ashift|ASHIFT                           return ASHIFT;
asl|ASL                                 return ASL;
asr|ASR                                 return ASR;
align8|ALIGN8                           return ALIGN8;
align16|ALIGN16                         return ALIGN16;
align24|ALIGN24                         return ALIGN24;
[aA]1"."[lL]    return A_ONE_DOT_L;
[aA]0"."[lL]    return A_ZERO_DOT_L;
[aA]1"."[hH]    return A_ONE_DOT_H;
[aA]0"."[hH]    return A_ZERO_DOT_H;
abs|ABS                                 return ABS;
abort                                   return ABORT;
[aA]1"."[xX]    _REG.regno = REG_A1x; return REG;
[aA]1"."[wW]    _REG.regno = REG_A1w; return REG;
[aA]1           _REG.regno = REG_A1;  return REG_A11;
[aA]0"."[xX]    _REG.regno = REG_A0x; return REG;
[aA]0"."[wW]    _REG.regno = REG_A0w; return REG;
[aA]0           _REG.regno = REG_A0;  return REG_A00;


"~"                     return TILDA;
"|="                    return _BAR_ASSIGN;
"|"                     return BAR;
"^="                    return _CARET_ASSIGN;
"^"                     return CARET;
"]"                     return RBRACK;
"["                     return LBRACK;
">>>="                  return _GREATER_GREATER_GREATER_THAN_ASSIGN;
">>="                   return _GREATER_GREATER_ASSIGN;
">>>"                   return _GREATER_GREATER_GREATER;
">>"                    return GREATER_GREATER;
"=="                    return _ASSIGN_ASSIGN;
"="                     return ASSIGN;
"<="                    return _LESS_THAN_ASSIGN;
"<<="                   return _LESS_LESS_ASSIGN;
"<<"                    return LESS_LESS;
"<"                     return LESS_THAN;
"("                     return LPAREN;
")"                     return RPAREN;
":"                     return COLON;
"/"                     return SLASH;
"-="                    return _MINUS_ASSIGN;
"+|+"					return _PLUS_BAR_PLUS;
"-|+"					return _MINUS_BAR_PLUS;
"+|-"					return _PLUS_BAR_MINUS;
"-|-"					return _MINUS_BAR_MINUS;
"--"                    return _MINUS_MINUS;
"-"                     return MINUS;
","                     return COMMA;
"+="                    return _PLUS_ASSIGN;
"++"                    return _PLUS_PLUS;
"+"                     return PLUS;
"*="                    return _STAR_ASSIGN;
"*"                     return STAR;
"&="                    return _AMPERSAND_ASSIGN;
"&"                     return AMPERSAND;
"%"                     return PERCENT;
"!"                     return BANG;
"=!"					return _ASSIGN_BANG;
"||"					return DOUBLE_BAR;
<KEYWORD>prefetch|PREFETCH                       return PREFETCH;
<KEYWORD>unlink|UNLINK                           return UNLINK;
<KEYWORD>link|LINK                               return LINK;
<KEYWORD>idle|IDLE                               return IDLE;
<KEYWORD>iflush|IFLUSH                           return IFLUSH;
<KEYWORD>flushinv|FLUSHINV                       return FLUSHINV;
<KEYWORD>flush|FLUSH                             return FLUSH;
([0-9]+)|(0[xX][0-9a-fA-F]+)|([bhfodBHOFD]#[0-9a-fA-F]+)|(0.[0-9]+)  {
         yylval.value = parse_int (&yytext);
         return NUMBER;
     }
[A-Za-z_$][A-Za-z0-9_$]*      { 
		yylval.symbol = symbol_find_or_make(yytext);
		symbol_mark_used(yylval.symbol);
		return SYMBOL; 
		}
[0-9][bfBF] {
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
  char fmt = '\0';
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

    case '0':  /* Accept different formated integers hex octal and binary. */
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


static int parse_reg(Register *r, int cl, char *rt)
{
	// compose regno:
	r->regno = cl | (rt[1] - '0');
	return REG;
}

// Xn.Y

static int parse_halfreg(Register *r, int cl, char *rt)
{
	r->regno = cl | (rt[1] - '0');

	switch (rt[3]) {
		case 'b':
		case 'B':
			return BYTE_REG;
		case 'l':
		case 'L':
			break;
		case 'h':
		case 'H':
			r->regno |= F_REG_HIGH;
			break;
	}

	return HALF_REG;
}

/* Our start state is KEYWORD as we have command keywords such as
   PREFETCH.
*/
void 
set_start_state(void)
{
	BEGIN KEYWORD;
}



#ifndef yywrap
int
yywrap ()
{ 
    return 1;
}
#endif

