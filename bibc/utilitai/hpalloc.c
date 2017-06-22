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

#include "aster.h"
#include <errno.h>
#include <sys/mman.h>
// <malloc.h> is linux-specific
// http://stackoverflow.com/questions/12973311/difference-between-stdlib-h-and-malloc-h
// <stdlib.h> should now be used instead
#ifdef GNU_LINUX
#include <malloc.h>
#endif /* GNU_LINUX */

/*
This function uses mmap() to prevent memory fragmentation with malloc() on Linux.
mmap() is not available on other platforms but should not be needed at least on OS X (darwin).
*/

void DEFPPPP(HPALLOC, hpalloc, void **addr,ASTERINTEGER *length,
             ASTERINTEGER *errcode, ASTERINTEGER *abrt)
{
    void abort();
#ifdef GNU_LINUX
    int ir;
#endif /* GNU_LINUX */
    if ( *length <= 0 ) {
        *errcode = -1;
    }
    else
    {
#ifdef GNU_LINUX
        ir=mallopt(M_MMAP_THRESHOLD,0);
        *addr = (void *)malloc(*length * sizeof(ASTERINTEGER));
        ir=mallopt(M_MMAP_THRESHOLD,128*1024);
        if ( *addr == (void *)-1 )
#else
        *addr = (void *)malloc(*length * sizeof(ASTERINTEGER));
        if ( *addr == (void *)0 )
#endif /* GNU_LINUX */
        {
            *errcode = -2;
        }
        else if ( *addr == NULL )
        {
            *errcode = -3;
        }
        else
        {
            *errcode = 0;
        }
    }
    if ( *errcode != 0 && *abrt != 0 )
    {
     abort();
    }
}
