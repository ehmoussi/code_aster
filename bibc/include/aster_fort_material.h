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

#ifndef ASTER_FORT_MATERIAL_H
#define ASTER_FORT_MATERIAL_H

#include "aster.h"

/* ******************************************************
 *
 * Interfaces of fortran subroutines called from C/C++
 * for material and behaviour objects
 *
 * ******************************************************/

#ifdef __cplusplus
extern "C" {
#endif

#define CALLO_CREATE_ENTHALPY( a, b ) CALLOO( CREATE_ENTHALPY, create_enthalpy, a, b )
void DEFSS( CREATE_ENTHALPY, create_enthalpy, const char *, STRING_SIZE, const char *,
            STRING_SIZE );

#define CALLO_RCMFMC_WRAP( a, b, c, d, e, f )                                                      \
    CALLOOPPOO( RCMFMC_WRAP, rcmfmc_wrap, a, b, c, d, e, f )
void DEFSSPPSS( RCMFMC_WRAP, rcmfmc_wrap, const char *, STRING_SIZE, const char *, STRING_SIZE,
                ASTERINTEGER *, ASTERINTEGER *, const char *, STRING_SIZE, const char *,
                STRING_SIZE );

#define CALL_RCVALE_WRAP( a, b, c, d, e, f, g, h, i, j )                                           \
    CALLSSPSPPSPPP( RCVALE_WRAP, rcvale_wrap, a, b, c, d, e, f, g, h, i, j )
extern void DEFSSPSPPSPPP( RCVALE_WRAP, rcvale_wrap, char *, STRING_SIZE, char *, STRING_SIZE,
                           ASTERINTEGER *, char *, STRING_SIZE, ASTERDOUBLE *, ASTERINTEGER *,
                           char *, STRING_SIZE, ASTERDOUBLE *, ASTERINTEGER *, ASTERINTEGER * );

#define CALLO_RCSTOC_VERIF( a, b, c, d ) CALLOOOP( RCSTOC_VERIF, rcstoc_verif, a, b, c, d )
extern void DEFSSSP( RCSTOC_VERIF, rcstoc_verif, const char *, STRING_SIZE, const char *,
                     STRING_SIZE, const char *, STRING_SIZE, ASTERINTEGER * );

#ifdef __cplusplus
}
#endif

/* FIN ASTER_FORT_MATERIAL_H */
#endif
