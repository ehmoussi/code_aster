/* -------------------------------------------------------------------- */
/* Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org             */
/* This file is part of code_aster.                                     */
/*                                                                      */
/* code_aster is free software: you can redistribute it and/or modify   */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation, either version 3 of the License, or    */
/* (at your option) any later version.                                  */
/*                                                                      */
/* code_aster is distributed in the hope that it will be useful,        */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of       */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        */
/* GNU General Public License for more details.                         */
/*                                                                      */
/* You should have received a copy of the GNU General Public License    */
/* along with code_aster.  If not, see <http://www.gnu.org/licenses/>.  */
/* -------------------------------------------------------------------- */

/* person_in_charge: mathieu.courtois at edf.fr */

#include <execinfo.h>
#include <stdio.h>
#include <stdlib.h>

#include "aster.h"

/*
 * This module defines a wrapper to call GNU libc backtrace functions.
 */
#define LEVEL 25

/* Obtain a backtrace and print it to stdout. */
void DEF0(PRINT_TRACE,print_trace)
{
#ifdef HAVE_BACKTRACE

    void *array[LEVEL];
    size_t size;
    char **strings;
    size_t i;

    size = backtrace(array, LEVEL);
    strings = backtrace_symbols(array, size);

    fprintf(stderr, "Traceback returned by GNU libc (last %zd stack frames):\n", size);

    for (i = 0; i < size; i++)
        fprintf(stderr, "%s\n", strings[i]);

    free(strings);

#endif
}
