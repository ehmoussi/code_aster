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

#ifndef ASTERC_DEBUG_H
#define ASTERC_DEBUG_H

#include "Python.h"
#include <stdlib.h>
#include <stdio.h>

/*! Here are defined some flags to add debugging informations.

If the flag is defined, a function prints informations on stdout.
If the flag is not defined, the function must be empty macro.

to enable DEBUG_ASSERT
#define __DEBUG_ASSERT__

to add all traces
#define __DEBUG_ALL__
*/

/*! print the filename and line where the error occurred */
#define DEBUG_LOC       fprintf(stdout, "DEBUG: %s #%d: ", __FILE__, __LINE__); fflush(stdout);

/*! interrupt the execution, return SIGABRT */
#define INTERRUPT(code) { DEBUG_LOC; fprintf(stdout,"ABORT - exit code %d\n",code); \
            fflush(stdout); abort(); }

/*! internal utility to print a PyObject */
#define PYDBG(label, pyobj) { DEBUG_LOC; fprintf(stdout, label); \
            PyObject_Print(pyobj, stdout, 0); \
            printf("\n"); fflush(stdout); }

#define DBG(label)          { DEBUG_LOC; printf(label); printf("\n"); fflush(stdout); }
#define DBGV(fmt, a)        { DEBUG_LOC; printf(fmt, a); printf("\n"); fflush(stdout); }
#define DBGVV(fmt, a, b)    { DEBUG_LOC; printf(fmt, a, b); printf("\n"); fflush(stdout); }



/*! enable DEBUG_ASSERT */
#if defined(__DEBUG_ASSERT__) || defined(__DEBUG_ALL__)
#   define DEBUG_ASSERT(cond)  AS_ASSERT(cond)
#else
#   define DEBUG_ASSERT(cond)
#endif

/*! enable DEBUG_DLL */
#if defined(__DEBUG_DLL__) || defined(__DEBUG_ALL__)
#   define DEBUG_DLL_PYOB(label, pyobj)  PYDBG(label, pyobj)
#   define DEBUG_DLL_VV(fmt, a, b)  DBGVV(fmt, a, b)
#else
#   define DEBUG_DLL_PYOB(label, pyobj)
#   define DEBUG_DLL_VV(fmt, a, b)
#endif

/*! enable DEBUG_EXCEPT, not in __DEBUG_ALL__ */
#if defined(__DEBUG_EXCEPT__)
#   define DEBUG_EXCEPT(fmt, a)  DBGV(fmt, a)
#else
#   define DEBUG_EXCEPT(fmt, a)
#endif

/*! debug MPI communicator as aster_comm_t */
#if defined(__DEBUG_MPICOM__) || defined(__DEBUG_ALL__)
#   define COMM_DEBUG(c) { DEBUG_LOC; \
           printf("%-8s #%d (%d/@", (c).name, (int)MPI_Comm_c2f((c).id), (c).level); \
           if ((c).parent) { printf("%-8s", (c).parent->name); } \
           else { printf("        "); } \
           printf(")\n"); fflush(stdout); }
#else
#   define COMM_DEBUG(c)
#endif

/*! debug MPI communications */
#if defined(__DEBUG_MPI__) || defined(__DEBUG_ALL__)
#   define DEBUG_MPI(fmt, a, b) DBGVV(fmt, a, b)
#else
#   define DEBUG_MPI(fmt, a, b)
#endif

/*! enable DEBUG_ASTER_FONCTIONS */
#if defined(__DEBUG_ALL__)
#   define __DEBUG_ASTER_FONCTIONS__
#endif

/*! enable DEBUG_IODR */
#if defined(__DEBUG_IODR__) || defined(__DEBUG_ALL__)
#   define DEBUG_IODR(fmt, a, b) DBGVV(fmt, a, b)
#else
#   define DEBUG_IODR
#endif

#endif
