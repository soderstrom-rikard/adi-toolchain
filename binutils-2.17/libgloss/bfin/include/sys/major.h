/*
 * major.h
 *
 * Copyright (C) 2007 Analog Devices, Inc.
 *
 * The authors hereby grant permission to use, copy, modify, distribute,
 * and license this software and its documentation for any purpose, provided
 * that existing copyright notices are retained in all copies and that this
 * notice is included verbatim in any distributions. No written agreement,
 * license, or royalty fee is required for any of the authorized uses.
 * Modifications to this software may be copyrighted by their authors
 * and need not follow the licensing terms described here, provided that
 * the new terms are clearly indicated on the first page of each file where
 * they apply.
 */

#pragma once
#ifndef __NO_BUILTIN
#pragma system_header /* major.h */
#endif

#warning This header file is deprecated and will be removed in a future version of VisualDSP++

#ifndef _SYS_MAJOR_H
#define _SYS_MAJOR_H

#define MAXDEVS  6
#define MAXFILES 20

#define DEV_TTY     1
#define DEV_MEM     2
#define DEV_SER     3
#define DEV_CONSOLE 4
#define DEV_AD1847  5

#endif /* _SYS_MAJOR_H */
