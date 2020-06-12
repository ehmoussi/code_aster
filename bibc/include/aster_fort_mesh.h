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

#ifndef ASTER_FORT_MESH_H
#define ASTER_FORT_MESH_H

#include "aster.h"

/* ******************************************************
 *
 * Interfaces of fortran subroutines called from C/C++.
 *
 * ******************************************************/

#ifdef __cplusplus
extern "C" {
#endif

#define CALLO_CARGEO( a ) CALLO( CARGEO, cargeo, a )
void DEFS( CARGEO, cargeo, const char *, STRING_SIZE );

#define CALLO_LRMJOI_WRAP( a, b ) CALLOO( LRMJOI_WRAP, lrmjoi_wrap, a, b )
void DEFSS( LRMJOI_WRAP, lrmjoi_wrap, const char *, STRING_SIZE, const char *, STRING_SIZE );

#define CALL_MDNOMA( a, b, c, d ) CALLSPSP( MDNOMA, mdnoma, a, b, c, d )
extern void DEFSPSP( MDNOMA, mdnoma, char *, STRING_SIZE, ASTERINTEGER *, char *, STRING_SIZE,
                     ASTERINTEGER * );

#define CALL_MDNOCH( a, b, c, d, e, f, g ) CALLSPPSSSP( MDNOCH, mdnoch, a, b, c, d, e, f, g )
extern void DEFSPPSSSP( MDNOCH, mdnoch, char *, STRING_SIZE, ASTERINTEGER *, ASTERINTEGER *, char *,
                        STRING_SIZE, char *, STRING_SIZE, char *, STRING_SIZE, ASTERINTEGER * );

#define CALL_GET_MED_TYPES( a, b ) CALLSS( GET_MED_TYPES, get_med_types, a, b )
#define CALLO_GET_MED_TYPES( a, b ) CALLOO( GET_MED_TYPES, get_med_types, a, b )
extern void DEFSS( GET_MED_TYPES, get_med_types, const char *, STRING_SIZE, const char *,
                   STRING_SIZE );

#define CALL_GET_MED_CONNECTIVITY( a, b ) CALLSS( GET_MED_CONNECTIVITY, get_med_connectivity, a, b )
#define CALLO_GET_MED_CONNECTIVITY( a, b ) \
    CALLOO( GET_MED_CONNECTIVITY, get_med_connectivity, a, b )
extern void DEFSS( GET_MED_CONNECTIVITY, get_med_connectivity, const char *, STRING_SIZE,
                   const char *, STRING_SIZE );

#ifdef __cplusplus
}
#endif

/* FIN ASTER_FORT_MESH_H */
#endif
