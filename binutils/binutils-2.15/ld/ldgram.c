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

/* Written by Richard Stallman by simplifying the original so called
   ``semantic'' parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     INT = 258,
     NAME = 259,
     LNAME = 260,
     OREQ = 261,
     ANDEQ = 262,
     RSHIFTEQ = 263,
     LSHIFTEQ = 264,
     DIVEQ = 265,
     MULTEQ = 266,
     MINUSEQ = 267,
     PLUSEQ = 268,
     OROR = 269,
     ANDAND = 270,
     NE = 271,
     EQ = 272,
     GE = 273,
     LE = 274,
     RSHIFT = 275,
     LSHIFT = 276,
     UNARY = 277,
     END = 278,
     ALIGN_K = 279,
     BLOCK = 280,
     BIND = 281,
     QUAD = 282,
     SQUAD = 283,
     LONG = 284,
     SHORT = 285,
     BYTE = 286,
     SECTIONS = 287,
     PHDRS = 288,
     DATA_SEGMENT_ALIGN = 289,
     DATA_SEGMENT_RELRO_END = 290,
     DATA_SEGMENT_END = 291,
     SORT_BY_NAME = 292,
     SORT_BY_ALIGNMENT = 293,
     SIZEOF_HEADERS = 294,
     OUTPUT_FORMAT = 295,
     FORCE_COMMON_ALLOCATION = 296,
     OUTPUT_ARCH = 297,
     INHIBIT_COMMON_ALLOCATION = 298,
     SEGMENT_START = 299,
     INCLUDE = 300,
     MEMORY = 301,
     DEFSYMEND = 302,
     NOLOAD = 303,
     DSECT = 304,
     COPY = 305,
     INFO = 306,
     OVERLAY = 307,
     DEFINED = 308,
     TARGET_K = 309,
     SEARCH_DIR = 310,
     MAP = 311,
     ENTRY = 312,
     NEXT = 313,
     SIZEOF = 314,
     ADDR = 315,
     LOADADDR = 316,
     MAX_K = 317,
     MIN_K = 318,
     STARTUP = 319,
     HLL = 320,
     SYSLIB = 321,
     FLOAT = 322,
     NOFLOAT = 323,
     NOCROSSREFS = 324,
     ORIGIN = 325,
     FILL = 326,
     LENGTH = 327,
     CREATE_OBJECT_SYMBOLS = 328,
     INPUT = 329,
     GROUP = 330,
     OUTPUT = 331,
     CONSTRUCTORS = 332,
     ALIGNMOD = 333,
     AT = 334,
     SUBALIGN = 335,
     PROVIDE = 336,
     CHIP = 337,
     LIST = 338,
     SECT = 339,
     ABSOLUTE = 340,
     LOAD = 341,
     NEWLINE = 342,
     ENDWORD = 343,
     ORDER = 344,
     NAMEWORD = 345,
     ASSERT_K = 346,
     FORMAT = 347,
     PUBLIC = 348,
     BASE = 349,
     ALIAS = 350,
     TRUNCATE = 351,
     REL = 352,
     INPUT_SCRIPT = 353,
     INPUT_MRI_SCRIPT = 354,
     INPUT_DEFSYM = 355,
     CASE = 356,
     EXTERN = 357,
     START = 358,
     VERS_TAG = 359,
     VERS_IDENTIFIER = 360,
     GLOBAL = 361,
     LOCAL = 362,
     VERSIONK = 363,
     INPUT_VERSION_SCRIPT = 364,
     KEEP = 365,
     ONLY_IF_RO = 366,
     ONLY_IF_RW = 367,
     EXCLUDE_FILE = 368
   };
#endif
#define INT 258
#define NAME 259
#define LNAME 260
#define OREQ 261
#define ANDEQ 262
#define RSHIFTEQ 263
#define LSHIFTEQ 264
#define DIVEQ 265
#define MULTEQ 266
#define MINUSEQ 267
#define PLUSEQ 268
#define OROR 269
#define ANDAND 270
#define NE 271
#define EQ 272
#define GE 273
#define LE 274
#define RSHIFT 275
#define LSHIFT 276
#define UNARY 277
#define END 278
#define ALIGN_K 279
#define BLOCK 280
#define BIND 281
#define QUAD 282
#define SQUAD 283
#define LONG 284
#define SHORT 285
#define BYTE 286
#define SECTIONS 287
#define PHDRS 288
#define DATA_SEGMENT_ALIGN 289
#define DATA_SEGMENT_RELRO_END 290
#define DATA_SEGMENT_END 291
#define SORT_BY_NAME 292
#define SORT_BY_ALIGNMENT 293
#define SIZEOF_HEADERS 294
#define OUTPUT_FORMAT 295
#define FORCE_COMMON_ALLOCATION 296
#define OUTPUT_ARCH 297
#define INHIBIT_COMMON_ALLOCATION 298
#define SEGMENT_START 299
#define INCLUDE 300
#define MEMORY 301
#define DEFSYMEND 302
#define NOLOAD 303
#define DSECT 304
#define COPY 305
#define INFO 306
#define OVERLAY 307
#define DEFINED 308
#define TARGET_K 309
#define SEARCH_DIR 310
#define MAP 311
#define ENTRY 312
#define NEXT 313
#define SIZEOF 314
#define ADDR 315
#define LOADADDR 316
#define MAX_K 317
#define MIN_K 318
#define STARTUP 319
#define HLL 320
#define SYSLIB 321
#define FLOAT 322
#define NOFLOAT 323
#define NOCROSSREFS 324
#define ORIGIN 325
#define FILL 326
#define LENGTH 327
#define CREATE_OBJECT_SYMBOLS 328
#define INPUT 329
#define GROUP 330
#define OUTPUT 331
#define CONSTRUCTORS 332
#define ALIGNMOD 333
#define AT 334
#define SUBALIGN 335
#define PROVIDE 336
#define CHIP 337
#define LIST 338
#define SECT 339
#define ABSOLUTE 340
#define LOAD 341
#define NEWLINE 342
#define ENDWORD 343
#define ORDER 344
#define NAMEWORD 345
#define ASSERT_K 346
#define FORMAT 347
#define PUBLIC 348
#define BASE 349
#define ALIAS 350
#define TRUNCATE 351
#define REL 352
#define INPUT_SCRIPT 353
#define INPUT_MRI_SCRIPT 354
#define INPUT_DEFSYM 355
#define CASE 356
#define EXTERN 357
#define START 358
#define VERS_TAG 359
#define VERS_IDENTIFIER 360
#define GLOBAL 361
#define LOCAL 362
#define VERSIONK 363
#define INPUT_VERSION_SCRIPT 364
#define KEEP 365
#define ONLY_IF_RO 366
#define ONLY_IF_RW 367
#define EXCLUDE_FILE 368




/* Copy the first part of user declarations.  */
#line 22 "ldgram.y"

/*

 */

#define DONTDECLARE_MALLOC

#include "bfd.h"
#include "sysdep.h"
#include "bfdlink.h"
#include "ld.h"
#include "ldexp.h"
#include "ldver.h"
#include "ldlang.h"
#include "ldfile.h"
#include "ldemul.h"
#include "ldmisc.h"
#include "ldmain.h"
#include "mri.h"
#include "ldctor.h"
#include "ldlex.h"

#ifndef YYDEBUG
#define YYDEBUG 1
#endif

static enum section_type sectype;

lang_memory_region_type *region;

bfd_boolean ldgram_want_filename = TRUE;
FILE *saved_script_handle = NULL;
bfd_boolean force_make_executable = FALSE;

bfd_boolean ldgram_in_script = FALSE;
bfd_boolean ldgram_had_equals = FALSE;
bfd_boolean ldgram_had_keep = FALSE;
char *ldgram_vers_current_lang = NULL;

#define ERROR_NAME_MAX 20
static char *error_names[ERROR_NAME_MAX];
static int error_index;
#define PUSH_ERROR(x) if (error_index < ERROR_NAME_MAX) error_names[error_index] = x; error_index++;
#define POP_ERROR()   error_index--;


/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

#if ! defined (YYSTYPE) && ! defined (YYSTYPE_IS_DECLARED)
#line 67 "ldgram.y"
typedef union YYSTYPE {
  bfd_vma integer;
  struct big_int
    {
      bfd_vma integer;
      char *str;
    } bigint;
  fill_type *fill;
  char *name;
  const char *cname;
  struct wildcard_spec wildcard;
  struct wildcard_list *wildcard_list;
  struct name_list *name_list;
  int token;
  union etree_union *etree;
  struct phdr_info
    {
      bfd_boolean filehdr;
      bfd_boolean phdrs;
      union etree_union *at;
      union etree_union *flags;
    } phdr;
  struct lang_nocrossref *nocrossref;
  struct lang_output_section_phdr_list *section_phdr;
  struct bfd_elf_version_deps *deflist;
  struct bfd_elf_version_expr *versyms;
  struct bfd_elf_version_tree *versnode;
} YYSTYPE;
/* Line 191 of yacc.c.  */
#line 376 "y.tab.c"
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* Copy the second part of user declarations.  */


/* Line 214 of yacc.c.  */
#line 388 "y.tab.c"

#if ! defined (yyoverflow) || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# if YYSTACK_USE_ALLOCA
#  define YYSTACK_ALLOC alloca
# else
#  ifndef YYSTACK_USE_ALLOCA
#   if defined (alloca) || defined (_ALLOCA_H)
#    define YYSTACK_ALLOC alloca
#   else
#    ifdef __GNUC__
#     define YYSTACK_ALLOC __builtin_alloca
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning. */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
# else
#  if defined (__STDC__) || defined (__cplusplus)
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   define YYSIZE_T size_t
#  endif
#  define YYSTACK_ALLOC malloc
#  define YYSTACK_FREE free
# endif
#endif /* ! defined (yyoverflow) || YYERROR_VERBOSE */


#if (! defined (yyoverflow) \
     && (! defined (__cplusplus) \
	 || (YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  short yyss;
  YYSTYPE yyvs;
  };

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (short) + sizeof (YYSTYPE))				\
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  register YYSIZE_T yyi;		\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (0)
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack)					\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack, Stack, yysize);				\
	Stack = &yyptr->Stack;						\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (0)

#endif

#if defined (__STDC__) || defined (__cplusplus)
   typedef signed char yysigned_char;
#else
   typedef short yysigned_char;
#endif

/* YYFINAL -- State number of the termination state. */
#define YYFINAL  14
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1704

/* YYNTOKENS -- Number of terminals. */
#define YYNTOKENS  137
/* YYNNTS -- Number of nonterminals. */
#define YYNNTS  110
/* YYNRULES -- Number of rules. */
#define YYNRULES  315
/* YYNRULES -- Number of states. */
#define YYNSTATES  674

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   368

#define YYTRANSLATE(YYX) 						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const unsigned char yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,   135,     2,     2,     2,    34,    21,     2,
      37,   132,    32,    30,   130,    31,     2,    33,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    16,   131,
      24,     6,    25,    15,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,   133,     2,   134,    20,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    53,    19,    54,   136,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     7,     8,     9,    10,    11,    12,    13,    14,    17,
      18,    22,    23,    26,    27,    28,    29,    35,    36,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    55,    56,    57,    58,    59,    60,
      61,    62,    63,    64,    65,    66,    67,    68,    69,    70,
      71,    72,    73,    74,    75,    76,    77,    78,    79,    80,
      81,    82,    83,    84,    85,    86,    87,    88,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,   103,   104,   105,   106,   107,   108,   109,   110,
     111,   112,   113,   114,   115,   116,   117,   118,   119,   120,
     121,   122,   123,   124,   125,   126,   127,   128,   129
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const unsigned short yyprhs[] =
{
       0,     0,     3,     6,     9,    12,    15,    17,    18,    23,
      24,    27,    31,    32,    35,    40,    42,    44,    47,    49,
      54,    59,    63,    66,    71,    75,    80,    85,    90,    95,
     100,   103,   106,   109,   114,   119,   122,   125,   128,   131,
     132,   138,   141,   142,   146,   149,   150,   152,   156,   158,
     162,   163,   165,   169,   171,   174,   178,   179,   182,   185,
     186,   188,   190,   192,   194,   196,   198,   200,   202,   204,
     206,   211,   216,   221,   226,   235,   240,   242,   244,   249,
     250,   256,   261,   262,   268,   273,   278,   280,   284,   287,
     289,   293,   296,   301,   304,   307,   308,   313,   316,   317,
     325,   327,   329,   331,   333,   339,   344,   349,   357,   365,
     373,   381,   390,   393,   395,   399,   401,   403,   407,   412,
     414,   415,   421,   424,   426,   428,   430,   435,   437,   442,
     447,   450,   452,   453,   455,   457,   459,   461,   463,   465,
     467,   470,   471,   473,   475,   477,   479,   481,   483,   485,
     487,   489,   491,   495,   499,   506,   508,   509,   515,   518,
     522,   523,   524,   532,   536,   540,   541,   545,   547,   550,
     552,   555,   560,   565,   569,   573,   575,   580,   584,   585,
     587,   589,   590,   593,   597,   598,   601,   604,   608,   613,
     616,   619,   622,   626,   630,   634,   638,   642,   646,   650,
     654,   658,   662,   666,   670,   674,   678,   682,   686,   692,
     696,   700,   705,   707,   709,   714,   719,   724,   729,   734,
     741,   748,   755,   760,   767,   772,   774,   781,   788,   795,
     800,   805,   809,   810,   815,   816,   821,   822,   824,   826,
     827,   828,   829,   830,   831,   832,   851,   852,   853,   854,
     855,   856,   875,   876,   877,   885,   887,   889,   891,   893,
     895,   899,   900,   903,   907,   910,   917,   928,   931,   933,
     934,   936,   939,   940,   941,   945,   946,   947,   948,   949,
     961,   966,   967,   970,   971,   972,   979,   981,   982,   986,
     992,   993,   997,   998,  1001,  1002,  1008,  1010,  1013,  1018,
    1024,  1031,  1033,  1036,  1037,  1040,  1045,  1050,  1059,  1061,
    1065,  1066,  1076,  1077,  1085,  1086
};

/* YYRHS -- A `-1'-separated list of the rules' RHS. */
static const short yyrhs[] =
{
     138,     0,    -1,   114,   152,    -1,   115,   142,    -1,   125,
     235,    -1,   116,   140,    -1,     4,    -1,    -1,   141,     4,
       6,   198,    -1,    -1,   143,   144,    -1,   144,   145,   103,
      -1,    -1,    98,   198,    -1,    98,   198,   130,   198,    -1,
       4,    -1,    99,    -1,   105,   147,    -1,   104,    -1,   109,
       4,     6,   198,    -1,   109,     4,   130,   198,    -1,   109,
       4,   198,    -1,   108,     4,    -1,   100,     4,   130,   198,
      -1,   100,     4,   198,    -1,   100,     4,     6,   198,    -1,
      38,     4,     6,   198,    -1,    38,     4,   130,   198,    -1,
      94,     4,     6,   198,    -1,    94,     4,   130,   198,    -1,
     101,   149,    -1,   102,   148,    -1,   106,     4,    -1,   111,
       4,   130,     4,    -1,   111,     4,   130,     3,    -1,   110,
     198,    -1,   112,     3,    -1,   117,   150,    -1,   118,   151,
      -1,    -1,    61,   139,   146,   144,    36,    -1,   119,     4,
      -1,    -1,   147,   130,     4,    -1,   147,     4,    -1,    -1,
       4,    -1,   148,   130,     4,    -1,     4,    -1,   149,   130,
       4,    -1,    -1,     4,    -1,   150,   130,     4,    -1,     4,
      -1,   151,     4,    -1,   151,   130,     4,    -1,    -1,   153,
     154,    -1,   154,   155,    -1,    -1,   180,    -1,   159,    -1,
     227,    -1,   189,    -1,   190,    -1,   192,    -1,   194,    -1,
     161,    -1,   237,    -1,   131,    -1,    70,    37,     4,   132,
      -1,    71,    37,   139,   132,    -1,    92,    37,   139,   132,
      -1,    56,    37,     4,   132,    -1,    56,    37,     4,   130,
       4,   130,     4,   132,    -1,    58,    37,     4,   132,    -1,
      57,    -1,    59,    -1,    90,    37,   158,   132,    -1,    -1,
      91,   156,    37,   158,   132,    -1,    72,    37,   139,   132,
      -1,    -1,    61,   139,   157,   154,    36,    -1,    85,    37,
     195,   132,    -1,   118,    37,   151,   132,    -1,     4,    -1,
     158,   130,     4,    -1,   158,     4,    -1,     5,    -1,   158,
     130,     5,    -1,   158,     5,    -1,    46,    53,   160,    54,
      -1,   160,   203,    -1,   160,   161,    -1,    -1,    73,    37,
       4,   132,    -1,   178,   177,    -1,    -1,   107,   162,    37,
     198,   130,     4,   132,    -1,     4,    -1,    32,    -1,    15,
      -1,   163,    -1,   129,    37,   165,   132,   163,    -1,    51,
      37,   163,   132,    -1,    52,    37,   163,   132,    -1,    51,
      37,    52,    37,   163,   132,   132,    -1,    51,    37,    51,
      37,   163,   132,   132,    -1,    52,    37,    51,    37,   163,
     132,   132,    -1,    52,    37,    52,    37,   163,   132,   132,
      -1,    51,    37,   129,    37,   165,   132,   163,   132,    -1,
     165,   163,    -1,   163,    -1,   166,   179,   164,    -1,   164,
      -1,     4,    -1,   133,   166,   134,    -1,   164,    37,   166,
     132,    -1,   167,    -1,    -1,   126,    37,   169,   167,   132,
      -1,   178,   177,    -1,    89,    -1,   131,    -1,    93,    -1,
      51,    37,    93,   132,    -1,   168,    -1,   173,    37,   196,
     132,    -1,    87,    37,   174,   132,    -1,   171,   170,    -1,
     170,    -1,    -1,   171,    -1,    41,    -1,    42,    -1,    43,
      -1,    44,    -1,    45,    -1,   196,    -1,     6,   174,    -1,
      -1,    14,    -1,    13,    -1,    12,    -1,    11,    -1,    10,
      -1,     9,    -1,     8,    -1,     7,    -1,   131,    -1,   130,
      -1,     4,     6,   196,    -1,     4,   176,   196,    -1,    97,
      37,     4,     6,   196,   132,    -1,   130,    -1,    -1,    62,
      53,   182,   181,    54,    -1,   181,   182,    -1,   181,   130,
     182,    -1,    -1,    -1,     4,   183,   186,    16,   184,   179,
     185,    -1,    86,     6,   196,    -1,    88,     6,   196,    -1,
      -1,    37,   187,   132,    -1,   188,    -1,   187,   188,    -1,
       4,    -1,   135,     4,    -1,    80,    37,   139,   132,    -1,
      81,    37,   191,   132,    -1,    81,    37,   132,    -1,   191,
     179,   139,    -1,   139,    -1,    82,    37,   193,   132,    -1,
     193,   179,   139,    -1,    -1,    83,    -1,    84,    -1,    -1,
       4,   195,    -1,     4,   130,   195,    -1,    -1,   197,   198,
      -1,    31,   198,    -1,    37,   198,   132,    -1,    74,    37,
     198,   132,    -1,   135,   198,    -1,    30,   198,    -1,   136,
     198,    -1,   198,    32,   198,    -1,   198,    33,   198,    -1,
     198,    34,   198,    -1,   198,    30,   198,    -1,   198,    31,
     198,    -1,   198,    29,   198,    -1,   198,    28,   198,    -1,
     198,    23,   198,    -1,   198,    22,   198,    -1,   198,    27,
     198,    -1,   198,    26,   198,    -1,   198,    24,   198,    -1,
     198,    25,   198,    -1,   198,    21,   198,    -1,   198,    20,
     198,    -1,   198,    19,   198,    -1,   198,    15,   198,    16,
     198,    -1,   198,    18,   198,    -1,   198,    17,   198,    -1,
      69,    37,     4,   132,    -1,     3,    -1,    55,    -1,    75,
      37,     4,   132,    -1,    76,    37,     4,   132,    -1,    77,
      37,     4,   132,    -1,   101,    37,   198,   132,    -1,    38,
      37,   198,   132,    -1,    38,    37,   198,   130,   198,   132,
      -1,    48,    37,   198,   130,   198,   132,    -1,    49,    37,
     198,   130,   198,   132,    -1,    50,    37,   198,   132,    -1,
      60,    37,     4,   130,   198,   132,    -1,    39,    37,   198,
     132,    -1,     4,    -1,    78,    37,   198,   130,   198,   132,
      -1,    79,    37,   198,   130,   198,   132,    -1,   107,    37,
     198,   130,     4,   132,    -1,    86,    37,     4,   132,    -1,
      88,    37,     4,   132,    -1,    95,    25,     4,    -1,    -1,
      95,    37,   198,   132,    -1,    -1,    96,    37,   198,   132,
      -1,    -1,   127,    -1,   128,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,     4,   204,   218,   200,   201,   205,   202,    53,
     206,   172,    54,   207,   221,   199,   222,   175,   208,   179,
      -1,    -1,    -1,    -1,    -1,    -1,    68,   209,   219,   220,
     200,   201,   210,    53,   211,   223,    54,   212,   221,   199,
     222,   175,   213,   179,    -1,    -1,    -1,    91,   214,   218,
     215,    53,   160,    54,    -1,    64,    -1,    65,    -1,    66,
      -1,    67,    -1,    68,    -1,    37,   216,   132,    -1,    -1,
      37,   132,    -1,   198,   217,    16,    -1,   217,    16,    -1,
      40,    37,   198,   132,   217,    16,    -1,    40,    37,   198,
     132,    39,    37,   198,   132,   217,    16,    -1,   198,    16,
      -1,    16,    -1,    -1,    85,    -1,    25,     4,    -1,    -1,
      -1,   222,    16,     4,    -1,    -1,    -1,    -1,    -1,   223,
       4,   224,    53,   172,    54,   225,   222,   175,   226,   179,
      -1,    47,    53,   228,    54,    -1,    -1,   228,   229,    -1,
      -1,    -1,     4,   230,   232,   233,   231,   131,    -1,   198,
      -1,    -1,     4,   234,   233,    -1,    95,    37,   198,   132,
     233,    -1,    -1,    37,   198,   132,    -1,    -1,   236,   239,
      -1,    -1,   238,   124,    53,   239,    54,    -1,   240,    -1,
     239,   240,    -1,    53,   242,    54,   131,    -1,   120,    53,
     242,    54,   131,    -1,   120,    53,   242,    54,   241,   131,
      -1,   120,    -1,   241,   120,    -1,    -1,   243,   131,    -1,
     122,    16,   243,   131,    -1,   123,    16,   243,   131,    -1,
     122,    16,   243,   131,   123,    16,   243,   131,    -1,   121,
      -1,   243,   131,   121,    -1,    -1,   243,   131,   118,     4,
      53,   244,   243,   246,    54,    -1,    -1,   118,     4,    53,
     245,   243,   246,    54,    -1,    -1,   131,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const unsigned short yyrline[] =
{
       0,   164,   164,   165,   166,   167,   171,   175,   175,   185,
     185,   198,   199,   203,   204,   205,   208,   211,   212,   213,
     215,   217,   219,   221,   223,   225,   227,   229,   231,   233,
     235,   236,   237,   239,   241,   243,   245,   247,   248,   250,
     249,   253,   255,   259,   260,   261,   265,   267,   271,   273,
     278,   279,   280,   284,   286,   288,   293,   293,   304,   305,
     311,   312,   313,   314,   315,   316,   317,   318,   319,   320,
     321,   323,   325,   327,   330,   332,   334,   336,   338,   340,
     339,   343,   346,   345,   349,   353,   357,   360,   363,   366,
     369,   372,   378,   382,   383,   384,   388,   390,   391,   391,
     399,   403,   407,   414,   420,   426,   432,   438,   444,   450,
     456,   462,   471,   480,   491,   500,   511,   519,   523,   530,
     532,   531,   538,   539,   543,   544,   549,   554,   555,   560,
     567,   568,   571,   573,   577,   579,   581,   583,   585,   590,
     600,   602,   606,   608,   610,   612,   614,   616,   618,   620,
     625,   625,   630,   634,   642,   650,   650,   654,   658,   659,
     660,   665,   664,   672,   680,   690,   691,   695,   696,   700,
     702,   707,   712,   713,   718,   720,   726,   728,   730,   734,
     736,   742,   745,   754,   765,   765,   771,   773,   775,   777,
     779,   781,   784,   786,   788,   790,   792,   794,   796,   798,
     800,   802,   804,   806,   808,   810,   812,   814,   816,   818,
     820,   822,   824,   826,   829,   831,   833,   835,   837,   839,
     841,   843,   845,   847,   856,   858,   860,   862,   864,   866,
     868,   874,   875,   879,   880,   884,   885,   889,   890,   891,
     894,   897,   900,   906,   908,   894,   915,   917,   919,   924,
     926,   914,   936,   938,   936,   946,   947,   948,   949,   950,
     954,   955,   956,   960,   961,   966,   967,   972,   973,   978,
     979,   984,   986,   991,   994,  1007,  1011,  1016,  1018,  1009,
    1026,  1029,  1031,  1035,  1036,  1035,  1045,  1090,  1093,  1105,
    1114,  1117,  1126,  1126,  1140,  1140,  1150,  1151,  1155,  1159,
    1163,  1170,  1174,  1182,  1185,  1189,  1193,  1197,  1204,  1208,
    1213,  1212,  1223,  1222,  1234,  1236
};
#endif

#if YYDEBUG || YYERROR_VERBOSE
/* YYTNME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals. */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "INT", "NAME", "LNAME", "'='", "OREQ", 
  "ANDEQ", "RSHIFTEQ", "LSHIFTEQ", "DIVEQ", "MULTEQ", "MINUSEQ", "PLUSEQ", 
  "'?'", "':'", "OROR", "ANDAND", "'|'", "'^'", "'&'", "NE", "EQ", "'<'", 
  "'>'", "GE", "LE", "RSHIFT", "LSHIFT", "'+'", "'-'", "'*'", "'/'", 
  "'%'", "UNARY", "END", "'('", "ALIGN_K", "BLOCK", "BIND", "QUAD", 
  "SQUAD", "LONG", "SHORT", "BYTE", "SECTIONS", "PHDRS", 
  "DATA_SEGMENT_ALIGN", "DATA_SEGMENT_RELRO_END", "DATA_SEGMENT_END", 
  "SORT_BY_NAME", "SORT_BY_ALIGNMENT", "'{'", "'}'", "SIZEOF_HEADERS", 
  "OUTPUT_FORMAT", "FORCE_COMMON_ALLOCATION", "OUTPUT_ARCH", 
  "INHIBIT_COMMON_ALLOCATION", "SEGMENT_START", "INCLUDE", "MEMORY", 
  "DEFSYMEND", "NOLOAD", "DSECT", "COPY", "INFO", "OVERLAY", "DEFINED", 
  "TARGET_K", "SEARCH_DIR", "MAP", "ENTRY", "NEXT", "SIZEOF", "ADDR", 
  "LOADADDR", "MAX_K", "MIN_K", "STARTUP", "HLL", "SYSLIB", "FLOAT", 
  "NOFLOAT", "NOCROSSREFS", "ORIGIN", "FILL", "LENGTH", 
  "CREATE_OBJECT_SYMBOLS", "INPUT", "GROUP", "OUTPUT", "CONSTRUCTORS", 
  "ALIGNMOD", "AT", "SUBALIGN", "PROVIDE", "CHIP", "LIST", "SECT", 
  "ABSOLUTE", "LOAD", "NEWLINE", "ENDWORD", "ORDER", "NAMEWORD", 
  "ASSERT_K", "FORMAT", "PUBLIC", "BASE", "ALIAS", "TRUNCATE", "REL", 
  "INPUT_SCRIPT", "INPUT_MRI_SCRIPT", "INPUT_DEFSYM", "CASE", "EXTERN", 
  "START", "VERS_TAG", "VERS_IDENTIFIER", "GLOBAL", "LOCAL", "VERSIONK", 
  "INPUT_VERSION_SCRIPT", "KEEP", "ONLY_IF_RO", "ONLY_IF_RW", 
  "EXCLUDE_FILE", "','", "';'", "')'", "'['", "']'", "'!'", "'~'", 
  "$accept", "file", "filename", "defsym_expr", "@1", "mri_script_file", 
  "@2", "mri_script_lines", "mri_script_command", "@3", "ordernamelist", 
  "mri_load_name_list", "mri_abs_name_list", "casesymlist", 
  "extern_name_list", "script_file", "@4", "ifile_list", "ifile_p1", "@5", 
  "@6", "input_list", "sections", "sec_or_group_p1", "statement_anywhere", 
  "@7", "wildcard_name", "wildcard_spec", "exclude_name_list", 
  "file_NAME_list", "input_section_spec_no_keep", "input_section_spec", 
  "@8", "statement", "statement_list", "statement_list_opt", "length", 
  "fill_exp", "fill_opt", "assign_op", "end", "assignment", "opt_comma", 
  "memory", "memory_spec_list", "memory_spec", "@9", "origin_spec", 
  "length_spec", "attributes_opt", "attributes_list", "attributes_string", 
  "startup", "high_level_library", "high_level_library_NAME_list", 
  "low_level_library", "low_level_library_NAME_list", 
  "floating_point_support", "nocrossref_list", "mustbe_exp", "@10", "exp", 
  "memspec_at_opt", "opt_at", "opt_subalign", "sect_constraint", 
  "section", "@11", "@12", "@13", "@14", "@15", "@16", "@17", "@18", 
  "@19", "@20", "@21", "@22", "type", "atype", "opt_exp_with_type", 
  "opt_exp_without_type", "opt_nocrossrefs", "memspec_opt", "phdr_opt", 
  "overlay_section", "@23", "@24", "@25", "phdrs", "phdr_list", "phdr", 
  "@26", "@27", "phdr_type", "phdr_qualifiers", "phdr_val", 
  "version_script_file", "@28", "version", "@29", "vers_nodes", 
  "vers_node", "verdep", "vers_tag", "vers_defns", "@30", "@31", 
  "opt_semicolon", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const unsigned short yytoknum[] =
{
       0,   256,   257,   258,   259,   260,    61,   261,   262,   263,
     264,   265,   266,   267,   268,    63,    58,   269,   270,   124,
      94,    38,   271,   272,    60,    62,   273,   274,   275,   276,
      43,    45,    42,    47,    37,   277,   278,    40,   279,   280,
     281,   282,   283,   284,   285,   286,   287,   288,   289,   290,
     291,   292,   293,   123,   125,   294,   295,   296,   297,   298,
     299,   300,   301,   302,   303,   304,   305,   306,   307,   308,
     309,   310,   311,   312,   313,   314,   315,   316,   317,   318,
     319,   320,   321,   322,   323,   324,   325,   326,   327,   328,
     329,   330,   331,   332,   333,   334,   335,   336,   337,   338,
     339,   340,   341,   342,   343,   344,   345,   346,   347,   348,
     349,   350,   351,   352,   353,   354,   355,   356,   357,   358,
     359,   360,   361,   362,   363,   364,   365,   366,   367,   368,
      44,    59,    41,    91,    93,    33,   126
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const unsigned char yyr1[] =
{
       0,   137,   138,   138,   138,   138,   139,   141,   140,   143,
     142,   144,   144,   145,   145,   145,   145,   145,   145,   145,
     145,   145,   145,   145,   145,   145,   145,   145,   145,   145,
     145,   145,   145,   145,   145,   145,   145,   145,   145,   146,
     145,   145,   145,   147,   147,   147,   148,   148,   149,   149,
     150,   150,   150,   151,   151,   151,   153,   152,   154,   154,
     155,   155,   155,   155,   155,   155,   155,   155,   155,   155,
     155,   155,   155,   155,   155,   155,   155,   155,   155,   156,
     155,   155,   157,   155,   155,   155,   158,   158,   158,   158,
     158,   158,   159,   160,   160,   160,   161,   161,   162,   161,
     163,   163,   163,   164,   164,   164,   164,   164,   164,   164,
     164,   164,   165,   165,   166,   166,   167,   167,   167,   168,
     169,   168,   170,   170,   170,   170,   170,   170,   170,   170,
     171,   171,   172,   172,   173,   173,   173,   173,   173,   174,
     175,   175,   176,   176,   176,   176,   176,   176,   176,   176,
     177,   177,   178,   178,   178,   179,   179,   180,   181,   181,
     181,   183,   182,   184,   185,   186,   186,   187,   187,   188,
     188,   189,   190,   190,   191,   191,   192,   193,   193,   194,
     194,   195,   195,   195,   197,   196,   198,   198,   198,   198,
     198,   198,   198,   198,   198,   198,   198,   198,   198,   198,
     198,   198,   198,   198,   198,   198,   198,   198,   198,   198,
     198,   198,   198,   198,   198,   198,   198,   198,   198,   198,
     198,   198,   198,   198,   198,   198,   198,   198,   198,   198,
     198,   199,   199,   200,   200,   201,   201,   202,   202,   202,
     204,   205,   206,   207,   208,   203,   209,   210,   211,   212,
     213,   203,   214,   215,   203,   216,   216,   216,   216,   216,
     217,   217,   217,   218,   218,   218,   218,   219,   219,   220,
     220,   221,   221,   222,   222,   223,   224,   225,   226,   223,
     227,   228,   228,   230,   231,   229,   232,   233,   233,   233,
     234,   234,   236,   235,   238,   237,   239,   239,   240,   240,
     240,   241,   241,   242,   242,   242,   242,   242,   243,   243,
     244,   243,   245,   243,   246,   246
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const unsigned char yyr2[] =
{
       0,     2,     2,     2,     2,     2,     1,     0,     4,     0,
       2,     3,     0,     2,     4,     1,     1,     2,     1,     4,
       4,     3,     2,     4,     3,     4,     4,     4,     4,     4,
       2,     2,     2,     4,     4,     2,     2,     2,     2,     0,
       5,     2,     0,     3,     2,     0,     1,     3,     1,     3,
       0,     1,     3,     1,     2,     3,     0,     2,     2,     0,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       4,     4,     4,     4,     8,     4,     1,     1,     4,     0,
       5,     4,     0,     5,     4,     4,     1,     3,     2,     1,
       3,     2,     4,     2,     2,     0,     4,     2,     0,     7,
       1,     1,     1,     1,     5,     4,     4,     7,     7,     7,
       7,     8,     2,     1,     3,     1,     1,     3,     4,     1,
       0,     5,     2,     1,     1,     1,     4,     1,     4,     4,
       2,     1,     0,     1,     1,     1,     1,     1,     1,     1,
       2,     0,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     3,     3,     6,     1,     0,     5,     2,     3,
       0,     0,     7,     3,     3,     0,     3,     1,     2,     1,
       2,     4,     4,     3,     3,     1,     4,     3,     0,     1,
       1,     0,     2,     3,     0,     2,     2,     3,     4,     2,
       2,     2,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     5,     3,
       3,     4,     1,     1,     4,     4,     4,     4,     4,     6,
       6,     6,     4,     6,     4,     1,     6,     6,     6,     4,
       4,     3,     0,     4,     0,     4,     0,     1,     1,     0,
       0,     0,     0,     0,     0,    18,     0,     0,     0,     0,
       0,    18,     0,     0,     7,     1,     1,     1,     1,     1,
       3,     0,     2,     3,     2,     6,    10,     2,     1,     0,
       1,     2,     0,     0,     3,     0,     0,     0,     0,    11,
       4,     0,     2,     0,     0,     6,     1,     0,     3,     5,
       0,     3,     0,     2,     0,     5,     1,     2,     4,     5,
       6,     1,     2,     0,     2,     4,     4,     8,     1,     3,
       0,     9,     0,     7,     0,     1
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const unsigned short yydefact[] =
{
       0,    56,     9,     7,   292,     0,     2,    59,     3,    12,
       5,     0,     4,     0,     1,    57,    10,     0,   303,     0,
     293,   296,     0,     0,     0,     0,    76,     0,    77,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   179,   180,
       0,     0,    79,     0,     0,    98,     0,    69,    58,    61,
      67,     0,    60,    63,    64,    65,    66,    62,    68,     0,
      15,     0,     0,     0,     0,    16,     0,     0,     0,    18,
      45,     0,     0,     0,     0,     0,     0,    50,     0,     0,
       0,     0,     0,   308,     0,     0,     0,     0,   303,   297,
     184,   149,   148,   147,   146,   145,   144,   143,   142,   184,
      95,   281,     0,     0,     6,    82,     0,     0,     0,     0,
       0,     0,     0,   178,   181,     0,     0,     0,     0,     0,
       0,   151,   150,    97,     0,     0,    39,     0,   212,   225,
       0,     0,     0,     0,     0,     0,     0,     0,   213,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    13,     0,    48,    30,    46,    31,    17,
      32,    22,     0,    35,     0,    36,    51,    37,    53,    38,
      41,    11,     8,     0,     0,     0,     0,   304,     0,   152,
       0,   153,     0,     0,     0,     0,    59,   161,   160,     0,
       0,     0,     0,     0,   173,   175,   156,   156,   181,     0,
      86,    89,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    12,     0,     0,   190,   186,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   189,   191,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    24,     0,
       0,    44,     0,     0,     0,    21,     0,     0,    54,     0,
     312,     0,     0,   298,     0,   309,     0,   185,   240,    92,
     246,   252,    94,    93,   283,   280,   282,     0,    73,    75,
     294,   165,     0,    70,    71,    81,    96,   171,   155,   172,
       0,   176,     0,   181,   182,    84,    88,    91,     0,    78,
       0,    72,   184,     0,    85,     0,    26,    27,    42,    28,
      29,   187,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     210,   209,   207,   206,   205,   200,   199,   203,   204,   202,
     201,   198,   197,   195,   196,   192,   193,   194,    14,    25,
      23,    49,    47,    43,    19,    20,    34,    33,    52,    55,
       0,   305,   306,     0,   301,   299,     0,   261,     0,   261,
       0,     0,    83,     0,     0,   157,     0,   158,   174,   177,
     183,    87,    90,    80,     0,     0,   295,    40,     0,   218,
     224,     0,     0,   222,     0,   211,   188,   214,   215,   216,
       0,     0,   229,   230,   217,     0,     0,   314,     0,   310,
     302,   300,     0,     0,   261,     0,   234,   268,     0,   269,
     253,   286,   287,     0,   169,     0,     0,   167,     0,   159,
     154,     0,     0,     0,     0,     0,     0,     0,     0,   208,
     315,     0,     0,     0,   255,   256,   257,   258,   259,   262,
       0,     0,     0,     0,   264,     0,   236,   267,   270,   234,
       0,   290,     0,   284,     0,   170,   166,   168,     0,   156,
      99,   219,   220,   221,   223,   226,   227,   228,   313,     0,
     314,   260,     0,   263,     0,     0,   241,   236,    95,     0,
     287,     0,     0,    74,   184,     0,   307,     0,   261,     0,
       0,   239,   247,     0,     0,   288,     0,   285,   163,     0,
     162,   311,     0,     0,   233,     0,   237,   238,     0,     0,
     254,   291,   287,   184,     0,   265,   235,   242,   248,   289,
     164,     0,   132,   275,   261,   116,   102,   101,   134,   135,
     136,   137,   138,     0,     0,     0,   123,   125,     0,     0,
     124,     0,   103,     0,   119,   127,   131,   133,     0,     0,
       0,     0,     0,     0,     0,   184,   120,     0,   100,     0,
     115,   156,     0,   130,   243,   184,   122,   276,   249,   266,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   139,
       0,   113,     0,     0,   117,     0,   156,   272,     0,     0,
     272,     0,     0,   126,     0,   105,     0,     0,   106,   129,
     100,     0,     0,   112,   114,   118,     0,   232,   128,   132,
     232,     0,     0,     0,     0,     0,   121,   104,   271,     0,
     273,     0,   273,     0,     0,     0,     0,     0,     0,   141,
     277,   141,   108,   107,     0,   109,   110,   231,   184,     0,
     244,   273,   250,   111,   140,   274,   156,   141,   156,   245,
     278,   251,   156,   279
};

/* YYDEFGOTO[NTERM-NUM]. */
static const short yydefgoto[] =
{
      -1,     5,   105,    10,    11,     8,     9,    16,    80,   211,
     159,   158,   156,   167,   169,     6,     7,    15,    48,   116,
     186,   202,    49,   182,    50,   119,   562,   563,   602,   581,
     564,   565,   600,   566,   567,   568,   569,   598,   660,    99,
     123,    51,   605,    52,   292,   188,   291,   479,   520,   384,
     436,   437,    53,    54,   196,    55,   197,    56,   199,   599,
     180,   216,   640,   466,   496,   528,   283,   377,   511,   542,
     607,   666,   378,   529,   543,   610,   668,   379,   470,   460,
     425,   426,   429,   469,   627,   649,   571,   609,   661,   672,
      57,   183,   286,   380,   502,   432,   473,   500,    12,    13,
      58,    59,    20,    21,   376,    86,    87,   453,   370,   451
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -594
static const short yypact[] =
{
     101,  -594,  -594,  -594,  -594,    45,  -594,  -594,  -594,  -594,
    -594,    58,  -594,    -9,  -594,   691,  1293,   169,   149,    28,
      -9,  -594,   609,    53,   148,   168,  -594,   182,  -594,   219,
     183,   211,   214,   221,   226,   231,   249,   264,  -594,  -594,
     265,   270,  -594,   276,   278,  -594,   279,  -594,  -594,  -594,
    -594,    -6,  -594,  -594,  -594,  -594,  -594,  -594,  -594,   197,
    -594,   289,   219,   318,   604,  -594,   319,   324,   326,  -594,
    -594,   332,   339,   341,   604,   342,   345,   353,   354,   357,
     259,   604,   370,  -594,   348,   359,   322,   250,   149,  -594,
    -594,  -594,  -594,  -594,  -594,  -594,  -594,  -594,  -594,  -594,
    -594,  -594,   376,   378,  -594,  -594,   379,   381,   219,   219,
     382,   219,    15,  -594,   383,   166,   351,   219,   391,   362,
     354,  -594,  -594,  -594,   343,    25,  -594,    36,  -594,  -594,
     604,   604,   604,   363,   365,   372,   373,   374,  -594,   375,
     390,   392,   394,   395,   396,   398,   401,   403,   405,   407,
     408,   604,   604,  1420,   329,  -594,   267,  -594,   283,    18,
    -594,  -594,   448,  1648,   286,  -594,  -594,   298,  -594,    32,
    -594,  -594,  1648,   393,   103,   103,   316,   107,   399,  -594,
     604,  -594,   256,    26,  -105,   323,  -594,  -594,  -594,   325,
     328,   330,   331,   334,  -594,  -594,   -34,   115,    37,   335,
    -594,  -594,    24,   166,   336,   442,   604,    68,    -9,   604,
     604,  -594,   604,   604,  -594,  -594,   890,   604,   604,   604,
     604,   604,   452,   454,   604,   457,   465,   466,   604,   604,
     468,   471,   604,   604,  -594,  -594,   604,   604,   604,   604,
     604,   604,   604,   604,   604,   604,   604,   604,   604,   604,
     604,   604,   604,   604,   604,   604,   604,   604,  1648,   472,
     476,  -594,   477,   604,   604,  1648,   228,   478,  -594,   479,
    -594,   358,   361,  -594,   480,  -594,   -17,  1648,   609,  -594,
    -594,  -594,  -594,  -594,  -594,  -594,  -594,   484,  -594,  -594,
     755,   453,    12,  -594,  -594,  -594,  -594,  -594,  -594,  -594,
     219,  -594,   219,   383,  -594,  -594,  -594,  -594,   292,  -594,
      33,  -594,  -594,  1440,  -594,   -21,  1648,  1648,  1315,  1648,
    1648,  -594,   870,   910,  1460,  1480,   930,   364,   367,   950,
     368,   369,   377,  1500,  1534,   380,   384,   986,  1554,  1616,
    1314,  1082,   965,   702,  1195,   513,   513,   100,   100,   100,
     100,   360,   360,   177,   177,  -594,  -594,  -594,  1648,  1648,
    1648,  -594,  -594,  -594,  1648,  1648,  -594,  -594,  -594,  -594,
     103,     0,   107,   438,  -594,  -594,   -12,   526,   204,   526,
     604,   385,  -594,     4,   486,  -594,   379,  -594,  -594,  -594,
    -594,  -594,  -594,  -594,   386,   489,  -594,  -594,   604,  -594,
    -594,   604,   604,  -594,   604,  -594,  -594,  -594,  -594,  -594,
     604,   604,  -594,  -594,  -594,   500,   604,   388,   490,  -594,
    -594,  -594,     9,   470,  1574,   494,   410,  -594,  1670,   426,
    -594,  1648,    20,   509,  -594,   510,     3,  -594,   434,  -594,
    -594,   389,  1006,  1026,  1046,  1066,  1102,  1122,   400,  1648,
     107,   474,   103,   103,  -594,  -594,  -594,  -594,  -594,  -594,
     416,   604,   305,   515,  -594,   496,   439,  -594,  -594,   410,
     497,   514,   516,  -594,   420,  -594,  -594,  -594,   548,   428,
    -594,  -594,  -594,  -594,  -594,  -594,  -594,  -594,  -594,   429,
     388,  -594,  1142,  -594,   604,   522,  -594,   439,  -594,   604,
      20,   604,   430,  -594,  -594,   481,   107,   508,   200,  1162,
     604,   171,  -594,   258,  1182,  -594,  1218,  -594,  -594,   561,
    -594,  -594,   531,   554,  -594,  1238,  -594,  -594,   518,   519,
    -594,  -594,    20,  -594,   604,  -594,  -594,  -594,  -594,  -594,
    -594,  1258,   625,  -594,   536,   412,  -594,  -594,  -594,  -594,
    -594,  -594,  -594,   540,   542,   543,  -594,  -594,   545,   550,
    -594,   223,  -594,   551,  -594,  -594,  -594,   625,   535,   553,
      -6,    59,   569,   198,    75,  -594,  -594,    50,  -594,   555,
    -594,   -29,   223,  -594,  -594,  -594,  -594,  -594,  -594,  -594,
     556,   557,   459,   559,   467,   560,   572,   492,   493,  -594,
      85,  -594,    11,   225,  -594,   223,   155,   573,   498,   558,
     573,    50,    50,  -594,    50,  -594,    50,    50,  -594,  -594,
     499,   504,    50,  -594,  -594,  -594,   602,   533,  -594,   625,
     533,   505,   506,    19,   507,   512,  -594,  -594,  -594,   585,
    -594,   578,  -594,   517,   523,    50,   524,   528,   622,    44,
    -594,    44,  -594,  -594,   539,  -594,  -594,  -594,  -594,   641,
    -594,  -594,  -594,  -594,  -594,  -594,   428,    44,   428,  -594,
    -594,  -594,   428,  -594
};

/* YYPGOTO[NTERM-NUM].  */
static const short yypgoto[] =
{
    -594,  -594,   -56,  -594,  -594,  -594,  -594,   402,  -594,  -594,
    -594,  -594,  -594,  -594,   527,  -594,  -594,   460,  -594,  -594,
    -594,   445,  -594,   152,  -179,  -594,  -308,  -349,    49,    69,
      65,  -594,  -594,    91,  -594,    43,  -594,    16,  -558,  -594,
     105,  -368,  -195,  -594,  -594,  -274,  -594,  -594,  -594,  -594,
    -594,   248,  -594,  -594,  -594,  -594,  -594,  -594,  -181,   -90,
    -594,   -60,    55,   217,   190,  -594,  -594,  -594,  -594,  -594,
    -594,  -594,  -594,  -594,  -594,  -594,  -594,  -594,  -594,  -594,
    -404,   309,  -594,  -594,    79,  -593,  -594,  -594,  -594,  -594,
    -594,  -594,  -594,  -594,  -594,  -594,  -465,  -594,  -594,  -594,
    -594,  -594,   483,   -15,  -594,   605,  -164,  -594,  -594,   206
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -295
static const short yytable[] =
{
     179,   300,   302,   282,   153,    89,   126,   434,   434,   181,
     271,   272,   128,   129,   163,   578,   187,   304,   387,   104,
     463,   172,   261,   578,   471,   287,   546,   288,   306,   307,
     284,   209,    18,   396,   546,   515,   268,   306,   307,   130,
     131,   198,   212,   547,    18,    14,   132,   133,   134,   651,
     658,   547,   190,   191,   578,   193,   195,   135,   136,   137,
     659,   204,    17,   587,   138,   546,   385,   539,   667,   139,
     214,   215,   268,   454,   455,   456,   457,   458,   140,   578,
     285,    88,   547,   141,   142,   143,   144,   145,   146,   620,
     546,   234,   235,   662,   258,   147,   298,   148,   299,    19,
     546,   298,   265,   374,   523,   604,   100,   547,   420,   670,
     149,    19,   439,   588,   375,   472,   150,   547,   274,   421,
     277,   275,   390,   418,   121,   122,   595,   596,   248,   249,
     250,   251,   252,   253,   254,   476,   579,   554,   435,   435,
     572,   459,   386,   622,   151,   152,   313,   194,   262,   316,
     317,   645,   319,   320,   308,   210,   309,   322,   323,   324,
     325,   326,   269,   308,   329,   393,   213,   303,   333,   334,
     200,   201,   337,   338,   570,    81,   339,   340,   341,   342,
     343,   344,   345,   346,   347,   348,   349,   350,   351,   352,
     353,   354,   355,   356,   357,   358,   359,   360,   269,   570,
     314,   101,   578,   364,   365,   102,   417,   128,   129,   252,
     253,   254,   580,   546,   559,     1,     2,     3,   561,   103,
     427,    82,   394,   104,    83,   274,     4,   578,   275,   578,
     547,   366,   367,   580,   130,   131,   106,   462,   546,   522,
     546,   132,   133,   134,   388,   298,   389,   301,   107,   590,
     591,   108,   135,   136,   137,   547,   624,   547,   109,   138,
     278,   570,   278,   110,   139,   594,   597,    82,   111,   601,
      83,    84,    85,   140,   579,   554,   590,   591,   141,   142,
     143,   144,   145,   146,   505,   298,   112,   625,   489,   490,
     147,   592,   148,   125,   623,   594,   391,   392,   526,   527,
      89,   113,   114,   631,   632,   149,   601,   115,   634,   635,
     279,   150,   530,   117,   637,   118,   120,   424,   428,   424,
     431,   124,   127,   154,   280,   623,   280,   593,   155,    34,
     157,    34,   128,   129,   282,   256,   160,   654,   442,   151,
     152,   443,   444,   161,   445,   162,   164,   281,   165,   281,
     446,   447,   559,    44,   593,    44,   449,   166,   168,   130,
     131,   170,   171,    45,   174,    45,   132,   133,   134,   454,
     455,   456,   457,   458,   173,   175,   176,   135,   136,   137,
     184,   177,   185,   187,   138,   189,   192,   198,   203,   139,
     250,   251,   252,   253,   254,   205,   208,   259,   140,   206,
     217,   492,   218,   141,   142,   143,   144,   145,   146,   219,
     220,   221,   222,   260,   518,   147,   266,   148,    90,    91,
      92,    93,    94,    95,    96,    97,    98,   223,   267,   224,
     149,   225,   226,   227,   509,   228,   150,   459,   229,   514,
     230,   516,   231,   540,   232,   233,   270,   273,   312,  -100,
     525,   128,   129,   276,   263,   289,   327,   293,   328,   257,
     294,   330,   295,   296,   151,   152,   297,   305,   311,   331,
     332,   669,   335,   671,   541,   336,   361,   673,   130,   131,
     362,   363,   368,   369,   373,   132,   133,   134,   381,   371,
     383,   419,   372,   441,   404,   608,   135,   136,   137,   405,
     407,   408,   438,   138,   448,   465,   452,   461,   139,   409,
     464,   468,   412,   474,   475,   433,   413,   140,   440,   450,
     478,   480,   141,   142,   143,   144,   145,   146,   488,   128,
     129,   493,   487,   494,   147,   495,   148,   244,   245,   246,
     247,   248,   249,   250,   251,   252,   253,   254,   491,   149,
     498,   499,   503,   501,   504,   150,   130,   131,   298,   510,
     506,   517,   521,   422,   133,   134,   423,   533,   534,   519,
     535,   537,   538,   462,   135,   136,   137,   573,   264,   574,
     575,   138,   576,   151,   152,   589,   139,   577,   582,   584,
     585,   613,   603,   611,   612,   140,   614,   616,   626,   615,
     141,   142,   143,   144,   145,   146,   638,   128,   129,   617,
     648,   629,   147,   318,   148,    90,    91,    92,    93,    94,
      95,    96,    97,    98,   618,   619,   657,   149,   639,   545,
     628,  -116,   650,   150,   130,   131,   636,   643,   644,   646,
     546,   132,   133,   134,   647,   665,   290,   207,   310,   652,
     513,   606,   135,   136,   137,   653,   655,   547,   583,   138,
     656,   151,   152,   633,   139,   621,   548,   549,   550,   551,
     552,   663,   641,   140,   664,   586,   553,   554,   141,   142,
     143,   144,   145,   146,   477,   642,   497,   512,   430,   630,
     147,   315,   148,   178,     0,    22,   507,     0,     0,     0,
       0,     0,     0,     0,     0,   149,     0,     0,     0,     0,
       0,   150,   555,     0,   556,     0,     0,     0,   557,     0,
       0,     0,    44,   241,   242,   243,   244,   245,   246,   247,
     248,   249,   250,   251,   252,   253,   254,    23,    24,   151,
     152,     0,     0,     0,     0,     0,     0,    25,    26,    27,
      28,   558,    29,    30,   559,     0,   560,     0,   561,    22,
       0,    31,    32,    33,    34,     0,     0,     0,     0,     0,
       0,    35,    36,    37,    38,    39,    40,     0,     0,     0,
       0,    41,    42,    43,     0,     0,     0,     0,    44,     0,
       0,   382,     0,     0,     0,     0,     0,     0,    45,     0,
       0,    23,    24,     0,     0,     0,     0,     0,     0,    46,
       0,    25,    26,    27,    28,  -294,    29,    30,     0,     0,
       0,     0,    47,     0,     0,    31,    32,    33,    34,     0,
       0,     0,     0,     0,     0,    35,    36,    37,    38,    39,
      40,     0,     0,     0,     0,    41,    42,    43,     0,     0,
       0,     0,    44,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    45,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    46,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   236,    47,   237,   238,   239,
     240,   241,   242,   243,   244,   245,   246,   247,   248,   249,
     250,   251,   252,   253,   254,   236,     0,   237,   238,   239,
     240,   241,   242,   243,   244,   245,   246,   247,   248,   249,
     250,   251,   252,   253,   254,   236,     0,   237,   238,   239,
     240,   241,   242,   243,   244,   245,   246,   247,   248,   249,
     250,   251,   252,   253,   254,   236,     0,   237,   238,   239,
     240,   241,   242,   243,   244,   245,   246,   247,   248,   249,
     250,   251,   252,   253,   254,   236,     0,   237,   238,   239,
     240,   241,   242,   243,   244,   245,   246,   247,   248,   249,
     250,   251,   252,   253,   254,   240,   241,   242,   243,   244,
     245,   246,   247,   248,   249,   250,   251,   252,   253,   254,
     398,   236,   399,   237,   238,   239,   240,   241,   242,   243,
     244,   245,   246,   247,   248,   249,   250,   251,   252,   253,
     254,   236,   321,   237,   238,   239,   240,   241,   242,   243,
     244,   245,   246,   247,   248,   249,   250,   251,   252,   253,
     254,   236,   400,   237,   238,   239,   240,   241,   242,   243,
     244,   245,   246,   247,   248,   249,   250,   251,   252,   253,
     254,   236,   403,   237,   238,   239,   240,   241,   242,   243,
     244,   245,   246,   247,   248,   249,   250,   251,   252,   253,
     254,   236,   406,   237,   238,   239,   240,   241,   242,   243,
     244,   245,   246,   247,   248,   249,   250,   251,   252,   253,
     254,   239,   240,   241,   242,   243,   244,   245,   246,   247,
     248,   249,   250,   251,   252,   253,   254,   236,   414,   237,
     238,   239,   240,   241,   242,   243,   244,   245,   246,   247,
     248,   249,   250,   251,   252,   253,   254,   236,   481,   237,
     238,   239,   240,   241,   242,   243,   244,   245,   246,   247,
     248,   249,   250,   251,   252,   253,   254,   236,   482,   237,
     238,   239,   240,   241,   242,   243,   244,   245,   246,   247,
     248,   249,   250,   251,   252,   253,   254,   236,   483,   237,
     238,   239,   240,   241,   242,   243,   244,   245,   246,   247,
     248,   249,   250,   251,   252,   253,   254,   236,   484,   237,
     238,   239,   240,   241,   242,   243,   244,   245,   246,   247,
     248,   249,   250,   251,   252,   253,   254,   242,   243,   244,
     245,   246,   247,   248,   249,   250,   251,   252,   253,   254,
       0,     0,     0,   236,   485,   237,   238,   239,   240,   241,
     242,   243,   244,   245,   246,   247,   248,   249,   250,   251,
     252,   253,   254,   236,   486,   237,   238,   239,   240,   241,
     242,   243,   244,   245,   246,   247,   248,   249,   250,   251,
     252,   253,   254,   236,   508,   237,   238,   239,   240,   241,
     242,   243,   244,   245,   246,   247,   248,   249,   250,   251,
     252,   253,   254,     0,   524,     0,     0,    60,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   531,     0,     0,     0,     0,    60,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    61,   238,   239,   240,   241,   242,   243,   244,   245,
     246,   247,   248,   249,   250,   251,   252,   253,   254,     0,
     532,   397,     0,    61,    62,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     536,     0,     0,     0,     0,     0,    62,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    63,     0,     0,
     544,    64,    65,    66,    67,    68,   -42,    69,    70,    71,
       0,    72,    73,    74,    75,    76,     0,     0,     0,    63,
      77,    78,    79,    64,    65,    66,    67,    68,     0,    69,
      70,    71,     0,    72,    73,    74,    75,    76,     0,     0,
       0,     0,    77,    78,    79,   236,     0,   237,   238,   239,
     240,   241,   242,   243,   244,   245,   246,   247,   248,   249,
     250,   251,   252,   253,   254,   236,     0,   237,   238,   239,
     240,   241,   242,   243,   244,   245,   246,   247,   248,   249,
     250,   251,   252,   253,   254,   236,     0,   237,   238,   239,
     240,   241,   242,   243,   244,   245,   246,   247,   248,   249,
     250,   251,   252,   253,   254,   236,     0,   237,   238,   239,
     240,   241,   242,   243,   244,   245,   246,   247,   248,   249,
     250,   251,   252,   253,   254,   236,     0,   237,   238,   239,
     240,   241,   242,   243,   244,   245,   246,   247,   248,   249,
     250,   251,   252,   253,   254,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   236,
     255,   237,   238,   239,   240,   241,   242,   243,   244,   245,
     246,   247,   248,   249,   250,   251,   252,   253,   254,   236,
     395,   237,   238,   239,   240,   241,   242,   243,   244,   245,
     246,   247,   248,   249,   250,   251,   252,   253,   254,   236,
     401,   237,   238,   239,   240,   241,   242,   243,   244,   245,
     246,   247,   248,   249,   250,   251,   252,   253,   254,     0,
     402,   462,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     410,   236,   416,   237,   238,   239,   240,   241,   242,   243,
     244,   245,   246,   247,   248,   249,   250,   251,   252,   253,
     254,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   236,   411,   237,   238,   239,   240,   241,
     242,   243,   244,   245,   246,   247,   248,   249,   250,   251,
     252,   253,   254,     0,   415,   236,   467,   237,   238,   239,
     240,   241,   242,   243,   244,   245,   246,   247,   248,   249,
     250,   251,   252,   253,   254
};

static const short yycheck[] =
{
      90,   196,   197,   182,    64,    20,    62,     4,     4,    99,
     174,   175,     3,     4,    74,     4,     4,   198,   292,     4,
     424,    81,     4,     4,     4,   130,    15,   132,     4,     5,
       4,     6,    53,    54,    15,   500,     4,     4,     5,    30,
      31,     4,     6,    32,    53,     0,    37,    38,    39,   642,
       6,    32,   108,   109,     4,   111,   112,    48,    49,    50,
      16,   117,     4,     4,    55,    15,    54,   532,   661,    60,
     130,   131,     4,    64,    65,    66,    67,    68,    69,     4,
      54,    53,    32,    74,    75,    76,    77,    78,    79,     4,
      15,   151,   152,   651,   154,    86,   130,    88,   132,   120,
      15,   130,   162,   120,   508,   134,    53,    32,   120,   667,
     101,   120,   386,    54,   131,    95,   107,    32,   118,   131,
     180,   121,   303,   123,   130,   131,    51,    52,    28,    29,
      30,    31,    32,    33,    34,   132,    51,    52,   135,   135,
     544,   132,   130,   132,   135,   136,   206,   132,   130,   209,
     210,   132,   212,   213,   130,   130,   132,   217,   218,   219,
     220,   221,   130,   130,   224,   132,   130,   130,   228,   229,
       4,     5,   232,   233,   542,     6,   236,   237,   238,   239,
     240,   241,   242,   243,   244,   245,   246,   247,   248,   249,
     250,   251,   252,   253,   254,   255,   256,   257,   130,   567,
     132,    53,     4,   263,   264,    37,   370,     3,     4,    32,
      33,    34,   561,    15,   129,   114,   115,   116,   133,    37,
      16,   118,   312,     4,   121,   118,   125,     4,   121,     4,
      32,     3,     4,   582,    30,    31,    53,    37,    15,    39,
      15,    37,    38,    39,   300,   130,   302,   132,    37,    51,
      52,    37,    48,    49,    50,    32,   605,    32,    37,    55,
       4,   629,     4,    37,    60,   573,   574,   118,    37,   577,
     121,   122,   123,    69,    51,    52,    51,    52,    74,    75,
      76,    77,    78,    79,   479,   130,    37,   132,   452,   453,
      86,    93,    88,     4,   602,   603,     4,     5,   127,   128,
     315,    37,    37,   611,   612,   101,   614,    37,   616,   617,
      54,   107,    54,    37,   622,    37,    37,   377,   378,   379,
     380,   124,     4,     4,    68,   633,    68,   129,     4,    73,
       4,    73,     3,     4,   513,     6,     4,   645,   398,   135,
     136,   401,   402,     4,   404,     4,     4,    91,     3,    91,
     410,   411,   129,    97,   129,    97,   416,     4,     4,    30,
      31,     4,   103,   107,    16,   107,    37,    38,    39,    64,
      65,    66,    67,    68,     4,    16,    54,    48,    49,    50,
       4,   131,     4,     4,    55,     4,     4,     4,    37,    60,
      30,    31,    32,    33,    34,     4,    53,   130,    69,    37,
      37,   461,    37,    74,    75,    76,    77,    78,    79,    37,
      37,    37,    37,   130,   504,    86,   130,    88,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    37,   130,    37,
     101,    37,    37,    37,   494,    37,   107,   132,    37,   499,
      37,   501,    37,   533,    37,    37,    53,   131,     6,    37,
     510,     3,     4,    54,     6,   132,     4,   132,     4,   130,
     132,     4,   132,   132,   135,   136,   132,   132,   132,     4,
       4,   666,     4,   668,   534,     4,     4,   672,    30,    31,
       4,     4,     4,     4,     4,    37,    38,    39,     4,   131,
      37,    53,   131,     4,   130,   585,    48,    49,    50,   132,
     132,   132,    16,    55,     4,    95,    16,    37,    60,   132,
      16,    85,   132,     4,     4,   130,   132,    69,   132,   131,
      86,   132,    74,    75,    76,    77,    78,    79,    54,     3,
       4,    16,   132,    37,    86,    96,    88,    24,    25,    26,
      27,    28,    29,    30,    31,    32,    33,    34,   132,   101,
      53,    37,   132,    37,     6,   107,    30,    31,   130,    37,
     131,   131,    54,    37,    38,    39,    40,     6,    37,    88,
      16,    53,    53,    37,    48,    49,    50,    37,   130,    37,
      37,    55,    37,   135,   136,    16,    60,    37,    37,    54,
      37,   132,    37,    37,    37,    69,    37,    37,    25,   132,
      74,    75,    76,    77,    78,    79,     4,     3,     4,    37,
      25,    53,    86,   211,    88,     6,     7,     8,     9,    10,
      11,    12,    13,    14,   132,   132,     4,   101,    95,     4,
     132,   132,    54,   107,    30,    31,   132,   132,   132,   132,
      15,    37,    38,    39,   132,     4,   186,   120,   203,   132,
     498,   582,    48,    49,    50,   132,   132,    32,   567,    55,
     132,   135,   136,   614,    60,   600,    41,    42,    43,    44,
      45,   132,   629,    69,   658,   570,    51,    52,    74,    75,
      76,    77,    78,    79,   436,   630,   469,   497,   379,   610,
      86,   208,    88,    88,    -1,     4,   490,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   101,    -1,    -1,    -1,    -1,
      -1,   107,    87,    -1,    89,    -1,    -1,    -1,    93,    -1,
      -1,    -1,    97,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    46,    47,   135,
     136,    -1,    -1,    -1,    -1,    -1,    -1,    56,    57,    58,
      59,   126,    61,    62,   129,    -1,   131,    -1,   133,     4,
      -1,    70,    71,    72,    73,    -1,    -1,    -1,    -1,    -1,
      -1,    80,    81,    82,    83,    84,    85,    -1,    -1,    -1,
      -1,    90,    91,    92,    -1,    -1,    -1,    -1,    97,    -1,
      -1,    36,    -1,    -1,    -1,    -1,    -1,    -1,   107,    -1,
      -1,    46,    47,    -1,    -1,    -1,    -1,    -1,    -1,   118,
      -1,    56,    57,    58,    59,   124,    61,    62,    -1,    -1,
      -1,    -1,   131,    -1,    -1,    70,    71,    72,    73,    -1,
      -1,    -1,    -1,    -1,    -1,    80,    81,    82,    83,    84,
      85,    -1,    -1,    -1,    -1,    90,    91,    92,    -1,    -1,
      -1,    -1,    97,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   107,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   118,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    15,   131,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    15,    -1,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    15,    -1,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    15,    -1,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    15,    -1,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
     130,    15,   132,    17,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    31,    32,    33,
      34,    15,   132,    17,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    31,    32,    33,
      34,    15,   132,    17,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    31,    32,    33,
      34,    15,   132,    17,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    31,    32,    33,
      34,    15,   132,    17,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    31,    32,    33,
      34,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    15,   132,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    15,   132,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    15,   132,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    15,   132,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    15,   132,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      -1,    -1,    -1,    15,   132,    17,    18,    19,    20,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30,    31,
      32,    33,    34,    15,   132,    17,    18,    19,    20,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30,    31,
      32,    33,    34,    15,   132,    17,    18,    19,    20,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30,    31,
      32,    33,    34,    -1,   132,    -1,    -1,     4,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   132,    -1,    -1,    -1,    -1,     4,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    38,    18,    19,    20,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    -1,
     132,    36,    -1,    38,    61,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     132,    -1,    -1,    -1,    -1,    -1,    61,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    94,    -1,    -1,
     132,    98,    99,   100,   101,   102,   103,   104,   105,   106,
      -1,   108,   109,   110,   111,   112,    -1,    -1,    -1,    94,
     117,   118,   119,    98,    99,   100,   101,   102,    -1,   104,
     105,   106,    -1,   108,   109,   110,   111,   112,    -1,    -1,
      -1,    -1,   117,   118,   119,    15,    -1,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    15,    -1,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    15,    -1,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    15,    -1,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    15,    -1,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    15,
     130,    17,    18,    19,    20,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    15,
     130,    17,    18,    19,    20,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    15,
     130,    17,    18,    19,    20,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    -1,
     130,    37,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     130,    15,    16,    17,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    31,    32,    33,
      34,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    15,   130,    17,    18,    19,    20,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30,    31,
      32,    33,    34,    -1,   130,    15,    16,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const unsigned char yystos[] =
{
       0,   114,   115,   116,   125,   138,   152,   153,   142,   143,
     140,   141,   235,   236,     0,   154,   144,     4,    53,   120,
     239,   240,     4,    46,    47,    56,    57,    58,    59,    61,
      62,    70,    71,    72,    73,    80,    81,    82,    83,    84,
      85,    90,    91,    92,    97,   107,   118,   131,   155,   159,
     161,   178,   180,   189,   190,   192,   194,   227,   237,   238,
       4,    38,    61,    94,    98,    99,   100,   101,   102,   104,
     105,   106,   108,   109,   110,   111,   112,   117,   118,   119,
     145,     6,   118,   121,   122,   123,   242,   243,    53,   240,
       6,     7,     8,     9,    10,    11,    12,    13,    14,   176,
      53,    53,    37,    37,     4,   139,    53,    37,    37,    37,
      37,    37,    37,    37,    37,    37,   156,    37,    37,   162,
      37,   130,   131,   177,   124,     4,   139,     4,     3,     4,
      30,    31,    37,    38,    39,    48,    49,    50,    55,    60,
      69,    74,    75,    76,    77,    78,    79,    86,    88,   101,
     107,   135,   136,   198,     4,     4,   149,     4,   148,   147,
       4,     4,     4,   198,     4,     3,     4,   150,     4,   151,
       4,   103,   198,     4,    16,    16,    54,   131,   242,   196,
     197,   196,   160,   228,     4,     4,   157,     4,   182,     4,
     139,   139,     4,   139,   132,   139,   191,   193,     4,   195,
       4,     5,   158,    37,   139,     4,    37,   151,    53,     6,
     130,   146,     6,   130,   198,   198,   198,    37,    37,    37,
      37,    37,    37,    37,    37,    37,    37,    37,    37,    37,
      37,    37,    37,    37,   198,   198,    15,    17,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,   130,     6,   130,   198,   130,
     130,     4,   130,     6,   130,   198,   130,   130,     4,   130,
      53,   243,   243,   131,   118,   121,    54,   198,     4,    54,
      68,    91,   161,   203,     4,    54,   229,   130,   132,   132,
     154,   183,   181,   132,   132,   132,   132,   132,   130,   132,
     179,   132,   179,   130,   195,   132,     4,     5,   130,   132,
     158,   132,     6,   198,   132,   239,   198,   198,   144,   198,
     198,   132,   198,   198,   198,   198,   198,     4,     4,   198,
       4,     4,     4,   198,   198,     4,     4,   198,   198,   198,
     198,   198,   198,   198,   198,   198,   198,   198,   198,   198,
     198,   198,   198,   198,   198,   198,   198,   198,   198,   198,
     198,     4,     4,     4,   198,   198,     3,     4,     4,     4,
     245,   131,   131,     4,   120,   131,   241,   204,   209,   214,
     230,     4,    36,    37,   186,    54,   130,   182,   139,   139,
     195,     4,     5,   132,   196,   130,    54,    36,   130,   132,
     132,   130,   130,   132,   130,   132,   132,   132,   132,   132,
     130,   130,   132,   132,   132,   130,    16,   243,   123,    53,
     120,   131,    37,    40,   198,   217,   218,    16,   198,   219,
     218,   198,   232,   130,     4,   135,   187,   188,    16,   182,
     132,     4,   198,   198,   198,   198,   198,   198,     4,   198,
     131,   246,    16,   244,    64,    65,    66,    67,    68,   132,
     216,    37,    37,   217,    16,    95,   200,    16,    85,   220,
     215,     4,    95,   233,     4,     4,   132,   188,    86,   184,
     132,   132,   132,   132,   132,   132,   132,   132,    54,   243,
     243,   132,   198,    16,    37,    96,   201,   200,    53,    37,
     234,    37,   231,   132,     6,   179,   131,   246,   132,   198,
      37,   205,   201,   160,   198,   233,   198,   131,   196,    88,
     185,    54,    39,   217,   132,   198,   127,   128,   202,   210,
      54,   132,   132,     6,    37,    16,   132,    53,    53,   233,
     196,   198,   206,   211,   132,     4,    15,    32,    41,    42,
      43,    44,    45,    51,    52,    87,    89,    93,   126,   129,
     131,   133,   163,   164,   167,   168,   170,   171,   172,   173,
     178,   223,   217,    37,    37,    37,    37,    37,     4,    51,
     164,   166,    37,   170,    54,    37,   177,     4,    54,    16,
      51,    52,    93,   129,   163,    51,    52,   163,   174,   196,
     169,   163,   165,    37,   134,   179,   166,   207,   196,   224,
     212,    37,    37,   132,    37,   132,    37,    37,   132,   132,
       4,   167,   132,   163,   164,   132,    25,   221,   132,    53,
     221,   163,   163,   165,   163,   163,   132,   163,     4,    95,
     199,   172,   199,   132,   132,   132,   132,   132,    25,   222,
      54,   222,   132,   132,   163,   132,   132,     4,     6,    16,
     175,   225,   175,   132,   174,     4,   208,   222,   213,   179,
     175,   179,   226,   179
};

#if ! defined (YYSIZE_T) && defined (__SIZE_TYPE__)
# define YYSIZE_T __SIZE_TYPE__
#endif
#if ! defined (YYSIZE_T) && defined (size_t)
# define YYSIZE_T size_t
#endif
#if ! defined (YYSIZE_T)
# if defined (__STDC__) || defined (__cplusplus)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# endif
#endif
#if ! defined (YYSIZE_T)
# define YYSIZE_T unsigned int
#endif

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrlab1

/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK;						\
      goto yybackup;						\
    }								\
  else								\
    { 								\
      yyerror ("syntax error: cannot back up");\
      YYERROR;							\
    }								\
while (0)

#define YYTERROR	1
#define YYERRCODE	256

/* YYLLOC_DEFAULT -- Compute the default location (before the actions
   are run).  */

#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)         \
  Current.first_line   = Rhs[1].first_line;      \
  Current.first_column = Rhs[1].first_column;    \
  Current.last_line    = Rhs[N].last_line;       \
  Current.last_column  = Rhs[N].last_column;
#endif

/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (0)

# define YYDSYMPRINT(Args)			\
do {						\
  if (yydebug)					\
    yysymprint Args;				\
} while (0)

# define YYDSYMPRINTF(Title, Token, Value, Location)		\
do {								\
  if (yydebug)							\
    {								\
      YYFPRINTF (stderr, "%s ", Title);				\
      yysymprint (stderr, 					\
                  Token, Value);	\
      YYFPRINTF (stderr, "\n");					\
    }								\
} while (0)

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (cinluded).                                                   |
`------------------------------------------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yy_stack_print (short *bottom, short *top)
#else
static void
yy_stack_print (bottom, top)
    short *bottom;
    short *top;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (/* Nothing. */; bottom <= top; ++bottom)
    YYFPRINTF (stderr, " %d", *bottom);
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yy_reduce_print (int yyrule)
#else
static void
yy_reduce_print (yyrule)
    int yyrule;
#endif
{
  int yyi;
  unsigned int yylineno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %u), ",
             yyrule - 1, yylineno);
  /* Print the symbols being reduced, and their result.  */
  for (yyi = yyprhs[yyrule]; 0 <= yyrhs[yyi]; yyi++)
    YYFPRINTF (stderr, "%s ", yytname [yyrhs[yyi]]);
  YYFPRINTF (stderr, "-> %s\n", yytname [yyr1[yyrule]]);
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (Rule);		\
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YYDSYMPRINT(Args)
# define YYDSYMPRINTF(Title, Token, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   SIZE_MAX < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#if YYMAXDEPTH == 0
# undef YYMAXDEPTH
#endif

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined (__GLIBC__) && defined (_STRING_H)
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
#   if defined (__STDC__) || defined (__cplusplus)
yystrlen (const char *yystr)
#   else
yystrlen (yystr)
     const char *yystr;
#   endif
{
  register const char *yys = yystr;

  while (*yys++ != '\0')
    continue;

  return yys - yystr - 1;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined (__GLIBC__) && defined (_STRING_H) && defined (_GNU_SOURCE)
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
#   if defined (__STDC__) || defined (__cplusplus)
yystpcpy (char *yydest, const char *yysrc)
#   else
yystpcpy (yydest, yysrc)
     char *yydest;
     const char *yysrc;
#   endif
{
  register char *yyd = yydest;
  register const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

#endif /* !YYERROR_VERBOSE */



#if YYDEBUG
/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yysymprint (FILE *yyoutput, int yytype, YYSTYPE *yyvaluep)
#else
static void
yysymprint (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  /* Pacify ``unused variable'' warnings.  */
  (void) yyvaluep;

  if (yytype < YYNTOKENS)
    {
      YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
# ifdef YYPRINT
      YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
    }
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  switch (yytype)
    {
      default:
        break;
    }
  YYFPRINTF (yyoutput, ")");
}

#endif /* ! YYDEBUG */
/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yydestruct (int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yytype, yyvaluep)
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  /* Pacify ``unused variable'' warnings.  */
  (void) yyvaluep;

  switch (yytype)
    {

      default:
        break;
    }
}


/* Prevent warnings from -Wmissing-prototypes.  */

#ifdef YYPARSE_PARAM
# if defined (__STDC__) || defined (__cplusplus)
int yyparse (void *YYPARSE_PARAM);
# else
int yyparse ();
# endif
#else /* ! YYPARSE_PARAM */
#if defined (__STDC__) || defined (__cplusplus)
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */



/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
# if defined (__STDC__) || defined (__cplusplus)
int yyparse (void *YYPARSE_PARAM)
# else
int yyparse (YYPARSE_PARAM)
  void *YYPARSE_PARAM;
# endif
#else /* ! YYPARSE_PARAM */
#if defined (__STDC__) || defined (__cplusplus)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
  
  register int yystate;
  register int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;

  /* Three stacks and their tools:
     `yyss': related to states,
     `yyvs': related to semantic values,
     `yyls': related to locations.

     Refer to the stacks thru separate pointers, to allow yyoverflow
     to reallocate them elsewhere.  */

  /* The state stack.  */
  short	yyssa[YYINITDEPTH];
  short *yyss = yyssa;
  register short *yyssp;

  /* The semantic value stack.  */
  YYSTYPE yyvsa[YYINITDEPTH];
  YYSTYPE *yyvs = yyvsa;
  register YYSTYPE *yyvsp;



#define YYPOPSTACK   (yyvsp--, yyssp--)

  YYSIZE_T yystacksize = YYINITDEPTH;

  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;


  /* When reducing, the number of symbols on the RHS of the reduced
     rule.  */
  int yylen;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed. so pushing a state here evens the stacks.
     */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack. Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	short *yyss1 = yyss;


	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow ("parser stack overflow",
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),

		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyoverflowlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyoverflowlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	short *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyoverflowlab;
	YYSTACK_RELOCATE (yyss);
	YYSTACK_RELOCATE (yyvs);

#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;


      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

/* Do appropriate processing given the current state.  */
/* Read a lookahead token if we need one and don't already have one.  */
/* yyresume: */

  /* First try to decide what to do without reference to lookahead token.  */

  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YYDSYMPRINTF ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Shift the lookahead token.  */
  YYDPRINTF ((stderr, "Shifting token %s, ", yytname[yytoken]));

  /* Discard the token being shifted unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  *++yyvsp = yylval;


  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  yystate = yyn;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 7:
#line 175 "ldgram.y"
    { ldlex_defsym(); }
    break;

  case 8:
#line 177 "ldgram.y"
    {
		  ldlex_popstate();
		  lang_add_assignment(exp_assop(yyvsp[-1].token,yyvsp[-2].name,yyvsp[0].etree));
		}
    break;

  case 9:
#line 185 "ldgram.y"
    {
		  ldlex_mri_script ();
		  PUSH_ERROR (_("MRI style script"));
		}
    break;

  case 10:
#line 190 "ldgram.y"
    {
		  ldlex_popstate ();
		  mri_draw_tree ();
		  POP_ERROR ();
		}
    break;

  case 15:
#line 205 "ldgram.y"
    {
			einfo(_("%P%F: unrecognised keyword in MRI style script '%s'\n"),yyvsp[0].name);
			}
    break;

  case 16:
#line 208 "ldgram.y"
    {
			config.map_filename = "-";
			}
    break;

  case 19:
#line 214 "ldgram.y"
    { mri_public(yyvsp[-2].name, yyvsp[0].etree); }
    break;

  case 20:
#line 216 "ldgram.y"
    { mri_public(yyvsp[-2].name, yyvsp[0].etree); }
    break;

  case 21:
#line 218 "ldgram.y"
    { mri_public(yyvsp[-1].name, yyvsp[0].etree); }
    break;

  case 22:
#line 220 "ldgram.y"
    { mri_format(yyvsp[0].name); }
    break;

  case 23:
#line 222 "ldgram.y"
    { mri_output_section(yyvsp[-2].name, yyvsp[0].etree);}
    break;

  case 24:
#line 224 "ldgram.y"
    { mri_output_section(yyvsp[-1].name, yyvsp[0].etree);}
    break;

  case 25:
#line 226 "ldgram.y"
    { mri_output_section(yyvsp[-2].name, yyvsp[0].etree);}
    break;

  case 26:
#line 228 "ldgram.y"
    { mri_align(yyvsp[-2].name,yyvsp[0].etree); }
    break;

  case 27:
#line 230 "ldgram.y"
    { mri_align(yyvsp[-2].name,yyvsp[0].etree); }
    break;

  case 28:
#line 232 "ldgram.y"
    { mri_alignmod(yyvsp[-2].name,yyvsp[0].etree); }
    break;

  case 29:
#line 234 "ldgram.y"
    { mri_alignmod(yyvsp[-2].name,yyvsp[0].etree); }
    break;

  case 32:
#line 238 "ldgram.y"
    { mri_name(yyvsp[0].name); }
    break;

  case 33:
#line 240 "ldgram.y"
    { mri_alias(yyvsp[-2].name,yyvsp[0].name,0);}
    break;

  case 34:
#line 242 "ldgram.y"
    { mri_alias (yyvsp[-2].name, 0, (int) yyvsp[0].bigint.integer); }
    break;

  case 35:
#line 244 "ldgram.y"
    { mri_base(yyvsp[0].etree); }
    break;

  case 36:
#line 246 "ldgram.y"
    { mri_truncate ((unsigned int) yyvsp[0].bigint.integer); }
    break;

  case 39:
#line 250 "ldgram.y"
    { ldlex_script (); ldfile_open_command_file(yyvsp[0].name); }
    break;

  case 40:
#line 252 "ldgram.y"
    { ldlex_popstate (); }
    break;

  case 41:
#line 254 "ldgram.y"
    { lang_add_entry (yyvsp[0].name, FALSE); }
    break;

  case 43:
#line 259 "ldgram.y"
    { mri_order(yyvsp[0].name); }
    break;

  case 44:
#line 260 "ldgram.y"
    { mri_order(yyvsp[0].name); }
    break;

  case 46:
#line 266 "ldgram.y"
    { mri_load(yyvsp[0].name); }
    break;

  case 47:
#line 267 "ldgram.y"
    { mri_load(yyvsp[0].name); }
    break;

  case 48:
#line 272 "ldgram.y"
    { mri_only_load(yyvsp[0].name); }
    break;

  case 49:
#line 274 "ldgram.y"
    { mri_only_load(yyvsp[0].name); }
    break;

  case 50:
#line 278 "ldgram.y"
    { yyval.name = NULL; }
    break;

  case 53:
#line 285 "ldgram.y"
    { ldlang_add_undef (yyvsp[0].name); }
    break;

  case 54:
#line 287 "ldgram.y"
    { ldlang_add_undef (yyvsp[0].name); }
    break;

  case 55:
#line 289 "ldgram.y"
    { ldlang_add_undef (yyvsp[0].name); }
    break;

  case 56:
#line 293 "ldgram.y"
    {
	 ldlex_both();
	}
    break;

  case 57:
#line 297 "ldgram.y"
    {
	ldlex_popstate();
	}
    break;

  case 70:
#line 322 "ldgram.y"
    { lang_add_target(yyvsp[-1].name); }
    break;

  case 71:
#line 324 "ldgram.y"
    { ldfile_add_library_path (yyvsp[-1].name, FALSE); }
    break;

  case 72:
#line 326 "ldgram.y"
    { lang_add_output(yyvsp[-1].name, 1); }
    break;

  case 73:
#line 328 "ldgram.y"
    { lang_add_output_format (yyvsp[-1].name, (char *) NULL,
					    (char *) NULL, 1); }
    break;

  case 74:
#line 331 "ldgram.y"
    { lang_add_output_format (yyvsp[-5].name, yyvsp[-3].name, yyvsp[-1].name, 1); }
    break;

  case 75:
#line 333 "ldgram.y"
    { ldfile_set_output_arch (yyvsp[-1].name, bfd_arch_unknown); }
    break;

  case 76:
#line 335 "ldgram.y"
    { command_line.force_common_definition = TRUE ; }
    break;

  case 77:
#line 337 "ldgram.y"
    { command_line.inhibit_common_definition = TRUE ; }
    break;

  case 79:
#line 340 "ldgram.y"
    { lang_enter_group (); }
    break;

  case 80:
#line 342 "ldgram.y"
    { lang_leave_group (); }
    break;

  case 81:
#line 344 "ldgram.y"
    { lang_add_map(yyvsp[-1].name); }
    break;

  case 82:
#line 346 "ldgram.y"
    { ldlex_script (); ldfile_open_command_file(yyvsp[0].name); }
    break;

  case 83:
#line 348 "ldgram.y"
    { ldlex_popstate (); }
    break;

  case 84:
#line 350 "ldgram.y"
    {
		  lang_add_nocrossref (yyvsp[-1].nocrossref);
		}
    break;

  case 86:
#line 358 "ldgram.y"
    { lang_add_input_file(yyvsp[0].name,lang_input_file_is_search_file_enum,
				 (char *)NULL); }
    break;

  case 87:
#line 361 "ldgram.y"
    { lang_add_input_file(yyvsp[0].name,lang_input_file_is_search_file_enum,
				 (char *)NULL); }
    break;

  case 88:
#line 364 "ldgram.y"
    { lang_add_input_file(yyvsp[0].name,lang_input_file_is_search_file_enum,
				 (char *)NULL); }
    break;

  case 89:
#line 367 "ldgram.y"
    { lang_add_input_file(yyvsp[0].name,lang_input_file_is_l_enum,
				 (char *)NULL); }
    break;

  case 90:
#line 370 "ldgram.y"
    { lang_add_input_file(yyvsp[0].name,lang_input_file_is_l_enum,
				 (char *)NULL); }
    break;

  case 91:
#line 373 "ldgram.y"
    { lang_add_input_file(yyvsp[0].name,lang_input_file_is_l_enum,
				 (char *)NULL); }
    break;

  case 96:
#line 389 "ldgram.y"
    { lang_add_entry (yyvsp[-1].name, FALSE); }
    break;

  case 98:
#line 391 "ldgram.y"
    {ldlex_expression ();}
    break;

  case 99:
#line 392 "ldgram.y"
    { ldlex_popstate ();
		  lang_add_assignment (exp_assert (yyvsp[-3].etree, yyvsp[-1].name)); }
    break;

  case 100:
#line 400 "ldgram.y"
    {
			  yyval.cname = yyvsp[0].name;
			}
    break;

  case 101:
#line 404 "ldgram.y"
    {
			  yyval.cname = "*";
			}
    break;

  case 102:
#line 408 "ldgram.y"
    {
			  yyval.cname = "?";
			}
    break;

  case 103:
#line 415 "ldgram.y"
    {
			  yyval.wildcard.name = yyvsp[0].cname;
			  yyval.wildcard.sorted = none;
			  yyval.wildcard.exclude_name_list = NULL;
			}
    break;

  case 104:
#line 421 "ldgram.y"
    {
			  yyval.wildcard.name = yyvsp[0].cname;
			  yyval.wildcard.sorted = none;
			  yyval.wildcard.exclude_name_list = yyvsp[-2].name_list;
			}
    break;

  case 105:
#line 427 "ldgram.y"
    {
			  yyval.wildcard.name = yyvsp[-1].cname;
			  yyval.wildcard.sorted = by_name;
			  yyval.wildcard.exclude_name_list = NULL;
			}
    break;

  case 106:
#line 433 "ldgram.y"
    {
			  yyval.wildcard.name = yyvsp[-1].cname;
			  yyval.wildcard.sorted = by_alignment;
			  yyval.wildcard.exclude_name_list = NULL;
			}
    break;

  case 107:
#line 439 "ldgram.y"
    {
			  yyval.wildcard.name = yyvsp[-2].cname;
			  yyval.wildcard.sorted = by_name_alignment;
			  yyval.wildcard.exclude_name_list = NULL;
			}
    break;

  case 108:
#line 445 "ldgram.y"
    {
			  yyval.wildcard.name = yyvsp[-2].cname;
			  yyval.wildcard.sorted = by_name;
			  yyval.wildcard.exclude_name_list = NULL;
			}
    break;

  case 109:
#line 451 "ldgram.y"
    {
			  yyval.wildcard.name = yyvsp[-2].cname;
			  yyval.wildcard.sorted = by_alignment_name;
			  yyval.wildcard.exclude_name_list = NULL;
			}
    break;

  case 110:
#line 457 "ldgram.y"
    {
			  yyval.wildcard.name = yyvsp[-2].cname;
			  yyval.wildcard.sorted = by_alignment;
			  yyval.wildcard.exclude_name_list = NULL;
			}
    break;

  case 111:
#line 463 "ldgram.y"
    {
			  yyval.wildcard.name = yyvsp[-1].cname;
			  yyval.wildcard.sorted = by_name;
			  yyval.wildcard.exclude_name_list = yyvsp[-3].name_list;
			}
    break;

  case 112:
#line 472 "ldgram.y"
    {
			  struct name_list *tmp;
			  tmp = (struct name_list *) xmalloc (sizeof *tmp);
			  tmp->name = yyvsp[0].cname;
			  tmp->next = yyvsp[-1].name_list;
			  yyval.name_list = tmp;
			}
    break;

  case 113:
#line 481 "ldgram.y"
    {
			  struct name_list *tmp;
			  tmp = (struct name_list *) xmalloc (sizeof *tmp);
			  tmp->name = yyvsp[0].cname;
			  tmp->next = NULL;
			  yyval.name_list = tmp;
			}
    break;

  case 114:
#line 492 "ldgram.y"
    {
			  struct wildcard_list *tmp;
			  tmp = (struct wildcard_list *) xmalloc (sizeof *tmp);
			  tmp->next = yyvsp[-2].wildcard_list;
			  tmp->spec = yyvsp[0].wildcard;
			  yyval.wildcard_list = tmp;
			}
    break;

  case 115:
#line 501 "ldgram.y"
    {
			  struct wildcard_list *tmp;
			  tmp = (struct wildcard_list *) xmalloc (sizeof *tmp);
			  tmp->next = NULL;
			  tmp->spec = yyvsp[0].wildcard;
			  yyval.wildcard_list = tmp;
			}
    break;

  case 116:
#line 512 "ldgram.y"
    {
			  struct wildcard_spec tmp;
			  tmp.name = yyvsp[0].name;
			  tmp.exclude_name_list = NULL;
			  tmp.sorted = none;
			  lang_add_wild (&tmp, NULL, ldgram_had_keep);
			}
    break;

  case 117:
#line 520 "ldgram.y"
    {
			  lang_add_wild (NULL, yyvsp[-1].wildcard_list, ldgram_had_keep);
			}
    break;

  case 118:
#line 524 "ldgram.y"
    {
			  lang_add_wild (&yyvsp[-3].wildcard, yyvsp[-1].wildcard_list, ldgram_had_keep);
			}
    break;

  case 120:
#line 532 "ldgram.y"
    { ldgram_had_keep = TRUE; }
    break;

  case 121:
#line 534 "ldgram.y"
    { ldgram_had_keep = FALSE; }
    break;

  case 123:
#line 540 "ldgram.y"
    {
 		lang_add_attribute(lang_object_symbols_statement_enum);
	      	}
    break;

  case 125:
#line 545 "ldgram.y"
    {

		  lang_add_attribute(lang_constructors_statement_enum);
		}
    break;

  case 126:
#line 550 "ldgram.y"
    {
		  constructors_sorted = TRUE;
		  lang_add_attribute (lang_constructors_statement_enum);
		}
    break;

  case 128:
#line 556 "ldgram.y"
    {
			  lang_add_data ((int) yyvsp[-3].integer, yyvsp[-1].etree);
			}
    break;

  case 129:
#line 561 "ldgram.y"
    {
			  lang_add_fill (yyvsp[-1].fill);
			}
    break;

  case 134:
#line 578 "ldgram.y"
    { yyval.integer = yyvsp[0].token; }
    break;

  case 135:
#line 580 "ldgram.y"
    { yyval.integer = yyvsp[0].token; }
    break;

  case 136:
#line 582 "ldgram.y"
    { yyval.integer = yyvsp[0].token; }
    break;

  case 137:
#line 584 "ldgram.y"
    { yyval.integer = yyvsp[0].token; }
    break;

  case 138:
#line 586 "ldgram.y"
    { yyval.integer = yyvsp[0].token; }
    break;

  case 139:
#line 591 "ldgram.y"
    {
		  yyval.fill = exp_get_fill (yyvsp[0].etree,
				     0,
				     "fill value",
				     lang_first_phase_enum);
		}
    break;

  case 140:
#line 601 "ldgram.y"
    { yyval.fill = yyvsp[0].fill; }
    break;

  case 141:
#line 602 "ldgram.y"
    { yyval.fill = (fill_type *) 0; }
    break;

  case 142:
#line 607 "ldgram.y"
    { yyval.token = '+'; }
    break;

  case 143:
#line 609 "ldgram.y"
    { yyval.token = '-'; }
    break;

  case 144:
#line 611 "ldgram.y"
    { yyval.token = '*'; }
    break;

  case 145:
#line 613 "ldgram.y"
    { yyval.token = '/'; }
    break;

  case 146:
#line 615 "ldgram.y"
    { yyval.token = LSHIFT; }
    break;

  case 147:
#line 617 "ldgram.y"
    { yyval.token = RSHIFT; }
    break;

  case 148:
#line 619 "ldgram.y"
    { yyval.token = '&'; }
    break;

  case 149:
#line 621 "ldgram.y"
    { yyval.token = '|'; }
    break;

  case 152:
#line 631 "ldgram.y"
    {
		  lang_add_assignment (exp_assop (yyvsp[-1].token, yyvsp[-2].name, yyvsp[0].etree));
		}
    break;

  case 153:
#line 635 "ldgram.y"
    {
		  lang_add_assignment (exp_assop ('=', yyvsp[-2].name,
						  exp_binop (yyvsp[-1].token,
							     exp_nameop (NAME,
									 yyvsp[-2].name),
							     yyvsp[0].etree)));
		}
    break;

  case 154:
#line 643 "ldgram.y"
    {
		  lang_add_assignment (exp_provide (yyvsp[-3].name, yyvsp[-1].etree));
		}
    break;

  case 161:
#line 665 "ldgram.y"
    { region = lang_memory_region_lookup (yyvsp[0].name, TRUE); }
    break;

  case 162:
#line 668 "ldgram.y"
    {}
    break;

  case 163:
#line 673 "ldgram.y"
    { region->current =
		 region->origin =
		 exp_get_vma(yyvsp[0].etree, 0L,"origin", lang_first_phase_enum);
}
    break;

  case 164:
#line 681 "ldgram.y"
    { region->length = exp_get_vma(yyvsp[0].etree,
					       ~((bfd_vma)0),
					       "length",
					       lang_first_phase_enum);
		}
    break;

  case 165:
#line 690 "ldgram.y"
    { /* dummy action to avoid bison 1.25 error message */ }
    break;

  case 169:
#line 701 "ldgram.y"
    { lang_set_flags (region, yyvsp[0].name, 0); }
    break;

  case 170:
#line 703 "ldgram.y"
    { lang_set_flags (region, yyvsp[0].name, 1); }
    break;

  case 171:
#line 708 "ldgram.y"
    { lang_startup(yyvsp[-1].name); }
    break;

  case 173:
#line 714 "ldgram.y"
    { ldemul_hll((char *)NULL); }
    break;

  case 174:
#line 719 "ldgram.y"
    { ldemul_hll(yyvsp[0].name); }
    break;

  case 175:
#line 721 "ldgram.y"
    { ldemul_hll(yyvsp[0].name); }
    break;

  case 177:
#line 729 "ldgram.y"
    { ldemul_syslib(yyvsp[0].name); }
    break;

  case 179:
#line 735 "ldgram.y"
    { lang_float(TRUE); }
    break;

  case 180:
#line 737 "ldgram.y"
    { lang_float(FALSE); }
    break;

  case 181:
#line 742 "ldgram.y"
    {
		  yyval.nocrossref = NULL;
		}
    break;

  case 182:
#line 746 "ldgram.y"
    {
		  struct lang_nocrossref *n;

		  n = (struct lang_nocrossref *) xmalloc (sizeof *n);
		  n->name = yyvsp[-1].name;
		  n->next = yyvsp[0].nocrossref;
		  yyval.nocrossref = n;
		}
    break;

  case 183:
#line 755 "ldgram.y"
    {
		  struct lang_nocrossref *n;

		  n = (struct lang_nocrossref *) xmalloc (sizeof *n);
		  n->name = yyvsp[-2].name;
		  n->next = yyvsp[0].nocrossref;
		  yyval.nocrossref = n;
		}
    break;

  case 184:
#line 765 "ldgram.y"
    { ldlex_expression (); }
    break;

  case 185:
#line 767 "ldgram.y"
    { ldlex_popstate (); yyval.etree=yyvsp[0].etree;}
    break;

  case 186:
#line 772 "ldgram.y"
    { yyval.etree = exp_unop ('-', yyvsp[0].etree); }
    break;

  case 187:
#line 774 "ldgram.y"
    { yyval.etree = yyvsp[-1].etree; }
    break;

  case 188:
#line 776 "ldgram.y"
    { yyval.etree = exp_unop ((int) yyvsp[-3].integer,yyvsp[-1].etree); }
    break;

  case 189:
#line 778 "ldgram.y"
    { yyval.etree = exp_unop ('!', yyvsp[0].etree); }
    break;

  case 190:
#line 780 "ldgram.y"
    { yyval.etree = yyvsp[0].etree; }
    break;

  case 191:
#line 782 "ldgram.y"
    { yyval.etree = exp_unop ('~', yyvsp[0].etree);}
    break;

  case 192:
#line 785 "ldgram.y"
    { yyval.etree = exp_binop ('*', yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 193:
#line 787 "ldgram.y"
    { yyval.etree = exp_binop ('/', yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 194:
#line 789 "ldgram.y"
    { yyval.etree = exp_binop ('%', yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 195:
#line 791 "ldgram.y"
    { yyval.etree = exp_binop ('+', yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 196:
#line 793 "ldgram.y"
    { yyval.etree = exp_binop ('-' , yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 197:
#line 795 "ldgram.y"
    { yyval.etree = exp_binop (LSHIFT , yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 198:
#line 797 "ldgram.y"
    { yyval.etree = exp_binop (RSHIFT , yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 199:
#line 799 "ldgram.y"
    { yyval.etree = exp_binop (EQ , yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 200:
#line 801 "ldgram.y"
    { yyval.etree = exp_binop (NE , yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 201:
#line 803 "ldgram.y"
    { yyval.etree = exp_binop (LE , yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 202:
#line 805 "ldgram.y"
    { yyval.etree = exp_binop (GE , yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 203:
#line 807 "ldgram.y"
    { yyval.etree = exp_binop ('<' , yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 204:
#line 809 "ldgram.y"
    { yyval.etree = exp_binop ('>' , yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 205:
#line 811 "ldgram.y"
    { yyval.etree = exp_binop ('&' , yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 206:
#line 813 "ldgram.y"
    { yyval.etree = exp_binop ('^' , yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 207:
#line 815 "ldgram.y"
    { yyval.etree = exp_binop ('|' , yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 208:
#line 817 "ldgram.y"
    { yyval.etree = exp_trinop ('?' , yyvsp[-4].etree, yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 209:
#line 819 "ldgram.y"
    { yyval.etree = exp_binop (ANDAND , yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 210:
#line 821 "ldgram.y"
    { yyval.etree = exp_binop (OROR , yyvsp[-2].etree, yyvsp[0].etree); }
    break;

  case 211:
#line 823 "ldgram.y"
    { yyval.etree = exp_nameop (DEFINED, yyvsp[-1].name); }
    break;

  case 212:
#line 825 "ldgram.y"
    { yyval.etree = exp_bigintop (yyvsp[0].bigint.integer, yyvsp[0].bigint.str); }
    break;

  case 213:
#line 827 "ldgram.y"
    { yyval.etree = exp_nameop (SIZEOF_HEADERS,0); }
    break;

  case 214:
#line 830 "ldgram.y"
    { yyval.etree = exp_nameop (SIZEOF,yyvsp[-1].name); }
    break;

  case 215:
#line 832 "ldgram.y"
    { yyval.etree = exp_nameop (ADDR,yyvsp[-1].name); }
    break;

  case 216:
#line 834 "ldgram.y"
    { yyval.etree = exp_nameop (LOADADDR,yyvsp[-1].name); }
    break;

  case 217:
#line 836 "ldgram.y"
    { yyval.etree = exp_unop (ABSOLUTE, yyvsp[-1].etree); }
    break;

  case 218:
#line 838 "ldgram.y"
    { yyval.etree = exp_unop (ALIGN_K,yyvsp[-1].etree); }
    break;

  case 219:
#line 840 "ldgram.y"
    { yyval.etree = exp_binop (ALIGN_K,yyvsp[-3].etree,yyvsp[-1].etree); }
    break;

  case 220:
#line 842 "ldgram.y"
    { yyval.etree = exp_binop (DATA_SEGMENT_ALIGN, yyvsp[-3].etree, yyvsp[-1].etree); }
    break;

  case 221:
#line 844 "ldgram.y"
    { yyval.etree = exp_binop (DATA_SEGMENT_RELRO_END, yyvsp[-1].etree, yyvsp[-3].etree); }
    break;

  case 222:
#line 846 "ldgram.y"
    { yyval.etree = exp_unop (DATA_SEGMENT_END, yyvsp[-1].etree); }
    break;

  case 223:
#line 848 "ldgram.y"
    { /* The operands to the expression node are
			     placed in the opposite order from the way
			     in which they appear in the script as
			     that allows us to reuse more code in
			     fold_binary.  */
			  yyval.etree = exp_binop (SEGMENT_START,
					  yyvsp[-1].etree,
					  exp_nameop (NAME, yyvsp[-3].name)); }
    break;

  case 224:
#line 857 "ldgram.y"
    { yyval.etree = exp_unop (ALIGN_K,yyvsp[-1].etree); }
    break;

  case 225:
#line 859 "ldgram.y"
    { yyval.etree = exp_nameop (NAME,yyvsp[0].name); }
    break;

  case 226:
#line 861 "ldgram.y"
    { yyval.etree = exp_binop (MAX_K, yyvsp[-3].etree, yyvsp[-1].etree ); }
    break;

  case 227:
#line 863 "ldgram.y"
    { yyval.etree = exp_binop (MIN_K, yyvsp[-3].etree, yyvsp[-1].etree ); }
    break;

  case 228:
#line 865 "ldgram.y"
    { yyval.etree = exp_assert (yyvsp[-3].etree, yyvsp[-1].name); }
    break;

  case 229:
#line 867 "ldgram.y"
    { yyval.etree = exp_nameop (ORIGIN, yyvsp[-1].name); }
    break;

  case 230:
#line 869 "ldgram.y"
    { yyval.etree = exp_nameop (LENGTH, yyvsp[-1].name); }
    break;

  case 231:
#line 874 "ldgram.y"
    { yyval.name = yyvsp[0].name; }
    break;

  case 232:
#line 875 "ldgram.y"
    { yyval.name = 0; }
    break;

  case 233:
#line 879 "ldgram.y"
    { yyval.etree = yyvsp[-1].etree; }
    break;

  case 234:
#line 880 "ldgram.y"
    { yyval.etree = 0; }
    break;

  case 235:
#line 884 "ldgram.y"
    { yyval.etree = yyvsp[-1].etree; }
    break;

  case 236:
#line 885 "ldgram.y"
    { yyval.etree = 0; }
    break;

  case 237:
#line 889 "ldgram.y"
    { yyval.token = ONLY_IF_RO; }
    break;

  case 238:
#line 890 "ldgram.y"
    { yyval.token = ONLY_IF_RW; }
    break;

  case 239:
#line 891 "ldgram.y"
    { yyval.token = 0; }
    break;

  case 240:
#line 894 "ldgram.y"
    { ldlex_expression(); }
    break;

  case 241:
#line 897 "ldgram.y"
    { ldlex_popstate (); ldlex_script (); }
    break;

  case 242:
#line 900 "ldgram.y"
    {
			  lang_enter_output_section_statement(yyvsp[-7].name, yyvsp[-5].etree,
							      sectype,
							      0, yyvsp[-3].etree, yyvsp[-4].etree, yyvsp[-1].token);
			}
    break;

  case 243:
#line 906 "ldgram.y"
    { ldlex_popstate (); ldlex_expression (); }
    break;

  case 244:
#line 908 "ldgram.y"
    {
		  ldlex_popstate ();
		  lang_leave_output_section_statement (yyvsp[0].fill, yyvsp[-3].name, yyvsp[-1].section_phdr, yyvsp[-2].name);
		}
    break;

  case 245:
#line 913 "ldgram.y"
    {}
    break;

  case 246:
#line 915 "ldgram.y"
    { ldlex_expression (); }
    break;

  case 247:
#line 917 "ldgram.y"
    { ldlex_popstate (); ldlex_script (); }
    break;

  case 248:
#line 919 "ldgram.y"
    {
			  lang_enter_overlay (yyvsp[-5].etree, yyvsp[-2].etree);
			}
    break;

  case 249:
#line 924 "ldgram.y"
    { ldlex_popstate (); ldlex_expression (); }
    break;

  case 250:
#line 926 "ldgram.y"
    {
			  ldlex_popstate ();
			  lang_leave_overlay (yyvsp[-11].etree, (int) yyvsp[-12].integer,
					      yyvsp[0].fill, yyvsp[-3].name, yyvsp[-1].section_phdr, yyvsp[-2].name);
			}
    break;

  case 252:
#line 936 "ldgram.y"
    { ldlex_expression (); }
    break;

  case 253:
#line 938 "ldgram.y"
    {
		  ldlex_popstate ();
		  lang_add_assignment (exp_assop ('=', ".", yyvsp[0].etree));
		}
    break;

  case 255:
#line 946 "ldgram.y"
    { sectype = noload_section; }
    break;

  case 256:
#line 947 "ldgram.y"
    { sectype = dsect_section; }
    break;

  case 257:
#line 948 "ldgram.y"
    { sectype = copy_section; }
    break;

  case 258:
#line 949 "ldgram.y"
    { sectype = info_section; }
    break;

  case 259:
#line 950 "ldgram.y"
    { sectype = overlay_section; }
    break;

  case 261:
#line 955 "ldgram.y"
    { sectype = normal_section; }
    break;

  case 262:
#line 956 "ldgram.y"
    { sectype = normal_section; }
    break;

  case 263:
#line 960 "ldgram.y"
    { yyval.etree = yyvsp[-2].etree; }
    break;

  case 264:
#line 961 "ldgram.y"
    { yyval.etree = (etree_type *)NULL;  }
    break;

  case 265:
#line 966 "ldgram.y"
    { yyval.etree = yyvsp[-3].etree; }
    break;

  case 266:
#line 968 "ldgram.y"
    { yyval.etree = yyvsp[-7].etree; }
    break;

  case 267:
#line 972 "ldgram.y"
    { yyval.etree = yyvsp[-1].etree; }
    break;

  case 268:
#line 973 "ldgram.y"
    { yyval.etree = (etree_type *) NULL;  }
    break;

  case 269:
#line 978 "ldgram.y"
    { yyval.integer = 0; }
    break;

  case 270:
#line 980 "ldgram.y"
    { yyval.integer = 1; }
    break;

  case 271:
#line 985 "ldgram.y"
    { yyval.name = yyvsp[0].name; }
    break;

  case 272:
#line 986 "ldgram.y"
    { yyval.name = DEFAULT_MEMORY_REGION; }
    break;

  case 273:
#line 991 "ldgram.y"
    {
		  yyval.section_phdr = NULL;
		}
    break;

  case 274:
#line 995 "ldgram.y"
    {
		  struct lang_output_section_phdr_list *n;

		  n = ((struct lang_output_section_phdr_list *)
		       xmalloc (sizeof *n));
		  n->name = yyvsp[0].name;
		  n->used = FALSE;
		  n->next = yyvsp[-2].section_phdr;
		  yyval.section_phdr = n;
		}
    break;

  case 276:
#line 1011 "ldgram.y"
    {
			  ldlex_script ();
			  lang_enter_overlay_section (yyvsp[0].name);
			}
    break;

  case 277:
#line 1016 "ldgram.y"
    { ldlex_popstate (); ldlex_expression (); }
    break;

  case 278:
#line 1018 "ldgram.y"
    {
			  ldlex_popstate ();
			  lang_leave_overlay_section (yyvsp[0].fill, yyvsp[-1].section_phdr);
			}
    break;

  case 283:
#line 1035 "ldgram.y"
    { ldlex_expression (); }
    break;

  case 284:
#line 1036 "ldgram.y"
    { ldlex_popstate (); }
    break;

  case 285:
#line 1038 "ldgram.y"
    {
		  lang_new_phdr (yyvsp[-5].name, yyvsp[-3].etree, yyvsp[-2].phdr.filehdr, yyvsp[-2].phdr.phdrs, yyvsp[-2].phdr.at,
				 yyvsp[-2].phdr.flags);
		}
    break;

  case 286:
#line 1046 "ldgram.y"
    {
		  yyval.etree = yyvsp[0].etree;

		  if (yyvsp[0].etree->type.node_class == etree_name
		      && yyvsp[0].etree->type.node_code == NAME)
		    {
		      const char *s;
		      unsigned int i;
		      static const char * const phdr_types[] =
			{
			  "PT_NULL", "PT_LOAD", "PT_DYNAMIC",
			  "PT_INTERP", "PT_NOTE", "PT_SHLIB",
			  "PT_PHDR", "PT_TLS"
			};

		      s = yyvsp[0].etree->name.name;
		      for (i = 0;
			   i < sizeof phdr_types / sizeof phdr_types[0];
			   i++)
			if (strcmp (s, phdr_types[i]) == 0)
			  {
			    yyval.etree = exp_intop (i);
			    break;
			  }
		      if (i == sizeof phdr_types / sizeof phdr_types[0])
			{
			  if (strcmp (s, "PT_GNU_EH_FRAME") == 0)
			    yyval.etree = exp_intop (0x6474e550);
			  else if (strcmp (s, "PT_GNU_STACK") == 0)
			    yyval.etree = exp_intop (0x6474e551);
			  else
			    {
			      einfo (_("\
%X%P:%S: unknown phdr type `%s' (try integer literal)\n"),
				     s);
			      yyval.etree = exp_intop (0);
			    }
			}
		    }
		}
    break;

  case 287:
#line 1090 "ldgram.y"
    {
		  memset (&yyval.phdr, 0, sizeof (struct phdr_info));
		}
    break;

  case 288:
#line 1094 "ldgram.y"
    {
		  yyval.phdr = yyvsp[0].phdr;
		  if (strcmp (yyvsp[-2].name, "FILEHDR") == 0 && yyvsp[-1].etree == NULL)
		    yyval.phdr.filehdr = TRUE;
		  else if (strcmp (yyvsp[-2].name, "PHDRS") == 0 && yyvsp[-1].etree == NULL)
		    yyval.phdr.phdrs = TRUE;
		  else if (strcmp (yyvsp[-2].name, "FLAGS") == 0 && yyvsp[-1].etree != NULL)
		    yyval.phdr.flags = yyvsp[-1].etree;
		  else
		    einfo (_("%X%P:%S: PHDRS syntax error at `%s'\n"), yyvsp[-2].name);
		}
    break;

  case 289:
#line 1106 "ldgram.y"
    {
		  yyval.phdr = yyvsp[0].phdr;
		  yyval.phdr.at = yyvsp[-2].etree;
		}
    break;

  case 290:
#line 1114 "ldgram.y"
    {
		  yyval.etree = NULL;
		}
    break;

  case 291:
#line 1118 "ldgram.y"
    {
		  yyval.etree = yyvsp[-1].etree;
		}
    break;

  case 292:
#line 1126 "ldgram.y"
    {
		  ldlex_version_file ();
		  PUSH_ERROR (_("VERSION script"));
		}
    break;

  case 293:
#line 1131 "ldgram.y"
    {
		  ldlex_popstate ();
		  POP_ERROR ();
		}
    break;

  case 294:
#line 1140 "ldgram.y"
    {
		  ldlex_version_script ();
		}
    break;

  case 295:
#line 1144 "ldgram.y"
    {
		  ldlex_popstate ();
		}
    break;

  case 298:
#line 1156 "ldgram.y"
    {
		  lang_register_vers_node (NULL, yyvsp[-2].versnode, NULL);
		}
    break;

  case 299:
#line 1160 "ldgram.y"
    {
		  lang_register_vers_node (yyvsp[-4].name, yyvsp[-2].versnode, NULL);
		}
    break;

  case 300:
#line 1164 "ldgram.y"
    {
		  lang_register_vers_node (yyvsp[-5].name, yyvsp[-3].versnode, yyvsp[-1].deflist);
		}
    break;

  case 301:
#line 1171 "ldgram.y"
    {
		  yyval.deflist = lang_add_vers_depend (NULL, yyvsp[0].name);
		}
    break;

  case 302:
#line 1175 "ldgram.y"
    {
		  yyval.deflist = lang_add_vers_depend (yyvsp[-1].deflist, yyvsp[0].name);
		}
    break;

  case 303:
#line 1182 "ldgram.y"
    {
		  yyval.versnode = lang_new_vers_node (NULL, NULL);
		}
    break;

  case 304:
#line 1186 "ldgram.y"
    {
		  yyval.versnode = lang_new_vers_node (yyvsp[-1].versyms, NULL);
		}
    break;

  case 305:
#line 1190 "ldgram.y"
    {
		  yyval.versnode = lang_new_vers_node (yyvsp[-1].versyms, NULL);
		}
    break;

  case 306:
#line 1194 "ldgram.y"
    {
		  yyval.versnode = lang_new_vers_node (NULL, yyvsp[-1].versyms);
		}
    break;

  case 307:
#line 1198 "ldgram.y"
    {
		  yyval.versnode = lang_new_vers_node (yyvsp[-5].versyms, yyvsp[-1].versyms);
		}
    break;

  case 308:
#line 1205 "ldgram.y"
    {
		  yyval.versyms = lang_new_vers_pattern (NULL, yyvsp[0].name, ldgram_vers_current_lang);
		}
    break;

  case 309:
#line 1209 "ldgram.y"
    {
		  yyval.versyms = lang_new_vers_pattern (yyvsp[-2].versyms, yyvsp[0].name, ldgram_vers_current_lang);
		}
    break;

  case 310:
#line 1213 "ldgram.y"
    {
			  yyval.name = ldgram_vers_current_lang;
			  ldgram_vers_current_lang = yyvsp[-1].name;
			}
    break;

  case 311:
#line 1218 "ldgram.y"
    {
			  yyval.versyms = yyvsp[-2].versyms;
			  ldgram_vers_current_lang = yyvsp[-3].name;
			}
    break;

  case 312:
#line 1223 "ldgram.y"
    {
			  yyval.name = ldgram_vers_current_lang;
			  ldgram_vers_current_lang = yyvsp[-1].name;
			}
    break;

  case 313:
#line 1228 "ldgram.y"
    {
			  yyval.versyms = yyvsp[-2].versyms;
			  ldgram_vers_current_lang = yyvsp[-3].name;
			}
    break;


    }

/* Line 991 of yacc.c.  */
#line 3619 "y.tab.c"

  yyvsp -= yylen;
  yyssp -= yylen;


  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;


  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if YYERROR_VERBOSE
      yyn = yypact[yystate];

      if (YYPACT_NINF < yyn && yyn < YYLAST)
	{
	  YYSIZE_T yysize = 0;
	  int yytype = YYTRANSLATE (yychar);
	  char *yymsg;
	  int yyx, yycount;

	  yycount = 0;
	  /* Start YYX at -YYN if negative to avoid negative indexes in
	     YYCHECK.  */
	  for (yyx = yyn < 0 ? -yyn : 0;
	       yyx < (int) (sizeof (yytname) / sizeof (char *)); yyx++)
	    if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	      yysize += yystrlen (yytname[yyx]) + 15, yycount++;
	  yysize += yystrlen ("syntax error, unexpected ") + 1;
	  yysize += yystrlen (yytname[yytype]);
	  yymsg = (char *) YYSTACK_ALLOC (yysize);
	  if (yymsg != 0)
	    {
	      char *yyp = yystpcpy (yymsg, "syntax error, unexpected ");
	      yyp = yystpcpy (yyp, yytname[yytype]);

	      if (yycount < 5)
		{
		  yycount = 0;
		  for (yyx = yyn < 0 ? -yyn : 0;
		       yyx < (int) (sizeof (yytname) / sizeof (char *));
		       yyx++)
		    if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
		      {
			const char *yyq = ! yycount ? ", expecting " : " or ";
			yyp = yystpcpy (yyp, yyq);
			yyp = yystpcpy (yyp, yytname[yyx]);
			yycount++;
		      }
		}
	      yyerror (yymsg);
	      YYSTACK_FREE (yymsg);
	    }
	  else
	    yyerror ("syntax error; also virtual memory exhausted");
	}
      else
#endif /* YYERROR_VERBOSE */
	yyerror ("syntax error");
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      /* Return failure if at end of input.  */
      if (yychar == YYEOF)
        {
	  /* Pop the error token.  */
          YYPOPSTACK;
	  /* Pop the rest of the stack.  */
	  while (yyss < yyssp)
	    {
	      YYDSYMPRINTF ("Error: popping", yystos[*yyssp], yyvsp, yylsp);
	      yydestruct (yystos[*yyssp], yyvsp);
	      YYPOPSTACK;
	    }
	  YYABORT;
        }

      YYDSYMPRINTF ("Error: discarding", yytoken, &yylval, &yylloc);
      yydestruct (yytoken, &yylval);
      yychar = YYEMPTY;

    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab2;


/*----------------------------------------------------.
| yyerrlab1 -- error raised explicitly by an action.  |
`----------------------------------------------------*/
yyerrlab1:

  /* Suppress GCC warning that yyerrlab1 is unused when no action
     invokes YYERROR.  */
#if defined (__GNUC_MINOR__) && 2093 <= (__GNUC__ * 1000 + __GNUC_MINOR__) \
    && !defined __cplusplus
  __attribute__ ((__unused__))
#endif


  goto yyerrlab2;


/*---------------------------------------------------------------.
| yyerrlab2 -- pop states until the error token can be shifted.  |
`---------------------------------------------------------------*/
yyerrlab2:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;

      YYDSYMPRINTF ("Error: popping", yystos[*yyssp], yyvsp, yylsp);
      yydestruct (yystos[yystate], yyvsp);
      yyvsp--;
      yystate = *--yyssp;

      YY_STACK_PRINT (yyss, yyssp);
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  YYDPRINTF ((stderr, "Shifting error token, "));

  *++yyvsp = yylval;


  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#ifndef yyoverflow
/*----------------------------------------------.
| yyoverflowlab -- parser overflow comes here.  |
`----------------------------------------------*/
yyoverflowlab:
  yyerror ("parser stack overflow");
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
  return yyresult;
}


#line 1239 "ldgram.y"

void
yyerror(arg)
     const char *arg;
{
  if (ldfile_assumed_script)
    einfo (_("%P:%s: file format not recognized; treating as linker script\n"),
	   ldfile_input_filename);
  if (error_index > 0 && error_index < ERROR_NAME_MAX)
     einfo ("%P%F:%S: %s in %s\n", arg, error_names[error_index-1]);
  else
     einfo ("%P%F:%S: %s\n", arg);
}

