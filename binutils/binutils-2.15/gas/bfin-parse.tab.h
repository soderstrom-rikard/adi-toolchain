/* A Bison parser, made by GNU Bison 1.875.  */

/* Skeleton parser for Yacc-like parsing with Bison,
   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002 Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

/* As a special exception, when this file is copied by Bison into a
   Bison output file, you may use that output file without restriction.
   This special exception was added by the Free Software Foundation
   in version 1.24 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     BYTEOP16P = 258,
     BYTEOP16M = 259,
     BYTEOP1P = 260,
     BYTEOP2P = 261,
     BYTEOP2M = 262,
     BYTEOP3P = 263,
     BYTEUNPACK = 264,
     BYTEPACK = 265,
     PACK = 266,
     SAA = 267,
     ALIGN8 = 268,
     ALIGN16 = 269,
     ALIGN24 = 270,
     VIT_MAX = 271,
     EXTRACT = 272,
     DEPOSIT = 273,
     EXPADJ = 274,
     SEARCH = 275,
     ONES = 276,
     SIGN = 277,
     SIGNBITS = 278,
     LINK = 279,
     UNLINK = 280,
     REG = 281,
     PC = 282,
     CCREG = 283,
     BYTE_REG = 284,
     REG_A00 = 285,
     REG_A11 = 286,
     A_ZERO_DOT_L = 287,
     A_ZERO_DOT_H = 288,
     A_ONE_DOT_L = 289,
     A_ONE_DOT_H = 290,
     HALF_REG = 291,
     NOP = 292,
     RTI = 293,
     RTS = 294,
     RTX = 295,
     RTN = 296,
     RTE = 297,
     HLT = 298,
     IDLE = 299,
     STI = 300,
     CLI = 301,
     CSYNC = 302,
     SSYNC = 303,
     EMUEXCPT = 304,
     RAISE = 305,
     EXCPT = 306,
     LSETUP = 307,
     DISALGNEXCPT = 308,
     JUMP = 309,
     JUMP_DOT_S = 310,
     JUMP_DOT_L = 311,
     CALL = 312,
     ABORT = 313,
     NOT = 314,
     TILDA = 315,
     BANG = 316,
     AMPERSAND = 317,
     BAR = 318,
     PERCENT = 319,
     CARET = 320,
     BXOR = 321,
     MINUS = 322,
     PLUS = 323,
     STAR = 324,
     SLASH = 325,
     NEG = 326,
     MIN = 327,
     MAX = 328,
     ABS = 329,
     DOUBLE_BAR = 330,
     _PLUS_BAR_PLUS = 331,
     _PLUS_BAR_MINUS = 332,
     _MINUS_BAR_PLUS = 333,
     _MINUS_BAR_MINUS = 334,
     _MINUS_MINUS = 335,
     _PLUS_PLUS = 336,
     SHIFT = 337,
     LSHIFT = 338,
     ASHIFT = 339,
     BXORSHIFT = 340,
     _GREATER_GREATER_GREATER_THAN_ASSIGN = 341,
     ROT = 342,
     LESS_LESS = 343,
     GREATER_GREATER = 344,
     _GREATER_GREATER_GREATER = 345,
     _LESS_LESS_ASSIGN = 346,
     _GREATER_GREATER_ASSIGN = 347,
     DIVS = 348,
     DIVQ = 349,
     ASSIGN = 350,
     _STAR_ASSIGN = 351,
     _BAR_ASSIGN = 352,
     _CARET_ASSIGN = 353,
     _AMPERSAND_ASSIGN = 354,
     _MINUS_ASSIGN = 355,
     _PLUS_ASSIGN = 356,
     _ASSIGN_BANG = 357,
     _LESS_THAN_ASSIGN = 358,
     _ASSIGN_ASSIGN = 359,
     GE = 360,
     LT = 361,
     LE = 362,
     GT = 363,
     LESS_THAN = 364,
     FLUSHINV = 365,
     FLUSH = 366,
     IFLUSH = 367,
     PREFETCH = 368,
     PRNT = 369,
     OUTC = 370,
     WHATREG = 371,
     TESTSET = 372,
     ASL = 373,
     ASR = 374,
     B = 375,
     W = 376,
     NS = 377,
     S = 378,
     CO = 379,
     SCO = 380,
     TH = 381,
     TL = 382,
     BP = 383,
     BREV = 384,
     X = 385,
     Z = 386,
     M = 387,
     MMOD = 388,
     R = 389,
     RND = 390,
     RNDL = 391,
     RNDH = 392,
     RND12 = 393,
     RND20 = 394,
     V = 395,
     LO = 396,
     HI = 397,
     BITTGL = 398,
     BITCLR = 399,
     BITSET = 400,
     BITTST = 401,
     BITMUX = 402,
     DBGAL = 403,
     DBGAH = 404,
     DBGHALT = 405,
     DBG = 406,
     DBGA = 407,
     DBGCMPLX = 408,
     IF = 409,
     COMMA = 410,
     BY = 411,
     COLON = 412,
     SEMICOLON = 413,
     RPAREN = 414,
     LPAREN = 415,
     LBRACK = 416,
     RBRACK = 417,
     MODIFIED_STATUS_REG = 418,
     MNOP = 419,
     SYMBOL = 420,
     NUMBER = 421
   };
#endif
#define BYTEOP16P 258
#define BYTEOP16M 259
#define BYTEOP1P 260
#define BYTEOP2P 261
#define BYTEOP2M 262
#define BYTEOP3P 263
#define BYTEUNPACK 264
#define BYTEPACK 265
#define PACK 266
#define SAA 267
#define ALIGN8 268
#define ALIGN16 269
#define ALIGN24 270
#define VIT_MAX 271
#define EXTRACT 272
#define DEPOSIT 273
#define EXPADJ 274
#define SEARCH 275
#define ONES 276
#define SIGN 277
#define SIGNBITS 278
#define LINK 279
#define UNLINK 280
#define REG 281
#define PC 282
#define CCREG 283
#define BYTE_REG 284
#define REG_A00 285
#define REG_A11 286
#define A_ZERO_DOT_L 287
#define A_ZERO_DOT_H 288
#define A_ONE_DOT_L 289
#define A_ONE_DOT_H 290
#define HALF_REG 291
#define NOP 292
#define RTI 293
#define RTS 294
#define RTX 295
#define RTN 296
#define RTE 297
#define HLT 298
#define IDLE 299
#define STI 300
#define CLI 301
#define CSYNC 302
#define SSYNC 303
#define EMUEXCPT 304
#define RAISE 305
#define EXCPT 306
#define LSETUP 307
#define DISALGNEXCPT 308
#define JUMP 309
#define JUMP_DOT_S 310
#define JUMP_DOT_L 311
#define CALL 312
#define ABORT 313
#define NOT 314
#define TILDA 315
#define BANG 316
#define AMPERSAND 317
#define BAR 318
#define PERCENT 319
#define CARET 320
#define BXOR 321
#define MINUS 322
#define PLUS 323
#define STAR 324
#define SLASH 325
#define NEG 326
#define MIN 327
#define MAX 328
#define ABS 329
#define DOUBLE_BAR 330
#define _PLUS_BAR_PLUS 331
#define _PLUS_BAR_MINUS 332
#define _MINUS_BAR_PLUS 333
#define _MINUS_BAR_MINUS 334
#define _MINUS_MINUS 335
#define _PLUS_PLUS 336
#define SHIFT 337
#define LSHIFT 338
#define ASHIFT 339
#define BXORSHIFT 340
#define _GREATER_GREATER_GREATER_THAN_ASSIGN 341
#define ROT 342
#define LESS_LESS 343
#define GREATER_GREATER 344
#define _GREATER_GREATER_GREATER 345
#define _LESS_LESS_ASSIGN 346
#define _GREATER_GREATER_ASSIGN 347
#define DIVS 348
#define DIVQ 349
#define ASSIGN 350
#define _STAR_ASSIGN 351
#define _BAR_ASSIGN 352
#define _CARET_ASSIGN 353
#define _AMPERSAND_ASSIGN 354
#define _MINUS_ASSIGN 355
#define _PLUS_ASSIGN 356
#define _ASSIGN_BANG 357
#define _LESS_THAN_ASSIGN 358
#define _ASSIGN_ASSIGN 359
#define GE 360
#define LT 361
#define LE 362
#define GT 363
#define LESS_THAN 364
#define FLUSHINV 365
#define FLUSH 366
#define IFLUSH 367
#define PREFETCH 368
#define PRNT 369
#define OUTC 370
#define WHATREG 371
#define TESTSET 372
#define ASL 373
#define ASR 374
#define B 375
#define W 376
#define NS 377
#define S 378
#define CO 379
#define SCO 380
#define TH 381
#define TL 382
#define BP 383
#define BREV 384
#define X 385
#define Z 386
#define M 387
#define MMOD 388
#define R 389
#define RND 390
#define RNDL 391
#define RNDH 392
#define RND12 393
#define RND20 394
#define V 395
#define LO 396
#define HI 397
#define BITTGL 398
#define BITCLR 399
#define BITSET 400
#define BITTST 401
#define BITMUX 402
#define DBGAL 403
#define DBGAH 404
#define DBGHALT 405
#define DBG 406
#define DBGA 407
#define DBGCMPLX 408
#define IF 409
#define COMMA 410
#define BY 411
#define COLON 412
#define SEMICOLON 413
#define RPAREN 414
#define LPAREN 415
#define LBRACK 416
#define RBRACK 417
#define MODIFIED_STATUS_REG 418
#define MNOP 419
#define SYMBOL 420
#define NUMBER 421




#if ! defined (YYSTYPE) && ! defined (YYSTYPE_IS_DECLARED)
#line 387 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
typedef union YYSTYPE {
    INSTR_T instr;
    ExprNode *expr;
    SYMBOL_T symbol;
    long value;
	// new encoding of registers
	Register reg;

    Macfunc macfunc;
    struct { int r0; int s0; int x0; } modcodes;
    struct { int r0; } r0;
    Opt_mode mod;
} YYSTYPE;
/* Line 1249 of yacc.c.  */
#line 382 "y.tab.h"
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;



