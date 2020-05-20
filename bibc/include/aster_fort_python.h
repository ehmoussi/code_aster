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

#ifndef ASTER_FORT_PYTHON_H
#define ASTER_FORT_PYTHON_H

#include "aster.h"

/* ******************************************************
 *
 * Interfaces of fortran subroutines called from C/C++.
 *
 * ******************************************************/

#ifdef __cplusplus
extern "C" {
#endif

#define CALL_GMARDM(a,b,c) CALLSSP(GMARDM,gmardm,a,b,c)
extern void DEFSSP(GMARDM, gmardm, const char *,STRING_SIZE,
                       const char *,STRING_SIZE, ASTERINTEGER *);

#define CALL_POSTKUTIL(a,b,c,d) CALLSSSS(POSTKUTIL,postkutil,a,b,c,d)
extern void DEFSSSS(POSTKUTIL,postkutil,char *,STRING_SIZE,char *,STRING_SIZE,
                    char *,STRING_SIZE,char *,STRING_SIZE);

#ifdef __cplusplus
}
#endif

/* FIN ASTER_FORT_PYTHON_H */
#endif
