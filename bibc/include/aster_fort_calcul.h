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

#ifndef ASTER_FORT_CALCUL_H
#define ASTER_FORT_CALCUL_H

#include "aster.h"

/* ******************************************************
 *
 * Interfaces of fortran subroutines called from C/C++.
 *
 * ******************************************************/

#ifdef __cplusplus
extern "C" {
#endif

#define CALLO_ASASVE( a, b, c, d ) CALLOOOO( ASASVE, asasve, a, b, c, d )
void DEFSSSS( ASASVE, asasve, const char *, STRING_SIZE, const char *, STRING_SIZE, const char *,
              STRING_SIZE, const char *, STRING_SIZE );

#define CALLO_ASCOVA( a, b, c, d, e, f, g ) CALLOOOOPOO( ASCOVA, ascova, a, b, c, d, e, f, g )
void DEFSSSSPSS( ASCOVA, ascova, const char *, STRING_SIZE, const char *, STRING_SIZE, const char *,
                 STRING_SIZE, const char *, STRING_SIZE, const ASTERDOUBLE *, const char *,
                 STRING_SIZE, const char *, STRING_SIZE );

#define CALLO_ASCAVC_WRAP( a, b, c, d, e, f )                                                      \
    CALLOOOOPO( ASCAVC_WRAP, ascavc_wrap, a, b, c, d, e, f )
void DEFSSSSPS( ASCAVC_WRAP, ascavc_wrap, const char *, STRING_SIZE, const char *, STRING_SIZE,
                const char *, STRING_SIZE, const char *, STRING_SIZE, const ASTERDOUBLE *,
                const char *, STRING_SIZE );

#define CALL_ASMATR( a, b, c, d, e, f, g, h, i )                                                   \
    CALLPSSSSSSPS( ASMATR, asmatr, a, b, c, d, e, f, g, h, i )
void DEFPSSSSSSPS( ASMATR, asmatr, ASTERINTEGER *, const char *, STRING_SIZE, const char *,
                   STRING_SIZE, const char *, STRING_SIZE, const char *, STRING_SIZE, const char *,
                   STRING_SIZE, const char *, STRING_SIZE, ASTERINTEGER *, const char *,
                   STRING_SIZE );

#define CALLO_CACHVC( a, b, c, d, e, f, g, h, i, j, k, l )                                         \
    CALLOOOOOOOOPPPP( CACHVC, cachvc, a, b, c, d, e, f, g, h, i, j, k, l )
void DEFSSSSSSSSPPPP( CACHVC, cachvc, const char *, STRING_SIZE, const char *, STRING_SIZE,
                      const char *, STRING_SIZE, const char *, STRING_SIZE, const char *,
                      STRING_SIZE, const char *, STRING_SIZE, const char *, STRING_SIZE,
                      const char *, STRING_SIZE, ASTERINTEGER *, ASTERINTEGER *, ASTERINTEGER *,
                      ASTERINTEGER * );

#define CALLO_CORICH( a, b, c, d ) CALLOOPP( CORICH, corich, a, b, c, d )
void DEFSSPP( CORICH, corich, const char *, STRING_SIZE, const char *, STRING_SIZE, ASTERINTEGER *,
              ASTERINTEGER * );

#define CALLO_CRESOL_WRAP( a, b, c ) CALLOOO( CRESOL_WRAP, cresol_wrap, a, b, c )
void DEFSSS( CRESOL_WRAP, cresol_wrap, const char *, STRING_SIZE, const char *, STRING_SIZE,
             const char *, STRING_SIZE );

#define CALLO_MATRIX_FACTOR( a, b, c, d, e, f, g )                                                 \
    CALLOOPOOPP( MATRIX_FACTOR, matrix_factor, a, b, c, d, e, f, g )
void DEFSSPSSPP( MATRIX_FACTOR, matrix_factor, const char *, STRING_SIZE, const char *, STRING_SIZE,
                 ASTERINTEGER *, const char *, STRING_SIZE, const char *, STRING_SIZE,
                 ASTERINTEGER *, ASTERINTEGER * );

#define CALLO_MERIME_WRAP( a, b, c, d, e, f, g, h, i, j, k )                                       \
    CALLOPOOOOPOOPO( MERIME_WRAP, merime_wrap, a, b, c, d, e, f, g, h, i, j, k )
void DEFSPSSSSPSSPS( MERIME_WRAP, merime_wrap, const char *, STRING_SIZE, ASTERINTEGER *,
                     const char *, STRING_SIZE, const char *, STRING_SIZE, const char *,
                     STRING_SIZE, const char *, STRING_SIZE, ASTERDOUBLE *, const char *,
                     STRING_SIZE, const char *, STRING_SIZE, ASTERINTEGER *, const char *,
                     STRING_SIZE );

#define CALLO_NMDOCH_WRAP( a, b, c, d ) CALLOPOO( NMDOCH_WRAP, nmdoch_wrap, a, b, c, d )
void DEFSPSS( NMDOCH_WRAP, nmdoch_wrap, const char *, STRING_SIZE, ASTERINTEGER *, const char *,
              STRING_SIZE, const char *, STRING_SIZE );

#define CALLO_NUMERO_WRAP( a, b, c, d, e, f )                                                      \
    CALLOOOOOO( NUMERO_WRAP, numero_wrap, a, b, c, d, e, f )
void DEFSSSSSS( NUMERO_WRAP, numero_wrap, const char *, STRING_SIZE, const char *, STRING_SIZE,
                const char *, STRING_SIZE, const char *, STRING_SIZE, const char *, STRING_SIZE,
                const char *, STRING_SIZE );

#define CALLO_RESOUD_WRAP( a, b, c, d, e, f, g, h, i, j, k, l )                                    \
    CALLOOOOPOOOOPPP( RESOUD_WRAP, resoud_wrap, a, b, c, d, e, f, g, h, i, j, k, l )
void DEFSSSSPSSSSPPP( RESOUD_WRAP, resoud_wrap, const char *, STRING_SIZE, const char *,
                      STRING_SIZE, const char *, STRING_SIZE, const char *, STRING_SIZE,
                      ASTERINTEGER *, const char *, STRING_SIZE, const char *, STRING_SIZE,
                      const char *, STRING_SIZE, const char *, STRING_SIZE, ASTERINTEGER *,
                      ASTERINTEGER *, ASTERINTEGER * );

#define CALLO_VECHME_WRAP( a, b, c, d, e, f, g, h, i, l )                                          \
    CALLOOOOPOOOOO( VECHME_WRAP, vechme_wrap, a, b, c, d, e, f, g, h, i, l )
void DEFSSSSPSSSSS( VECHME_WRAP, vechme_wrap, const char *, STRING_SIZE, const char *, STRING_SIZE,
                    const char *, STRING_SIZE, const char *, STRING_SIZE, const ASTERDOUBLE *,
                    const char *, STRING_SIZE, const char *, STRING_SIZE, const char *, STRING_SIZE,
                    const char *, STRING_SIZE, const char *, STRING_SIZE );

#define CALLO_VEDIME( a, b, c, d, e, f ) CALLOOOPOO( VEDIME, vedime, a, b, c, d, e, f )
void DEFSSSPSS( VEDIME, vedime, const char *, STRING_SIZE, const char *, STRING_SIZE, const char *,
                STRING_SIZE, ASTERDOUBLE *, const char *, STRING_SIZE, const char *, STRING_SIZE );

#define CALLO_VELAME( a, b, c, d, e ) CALLOOOOO( VELAME, velame, a, b, c, d, e )
void DEFSSSSS( VELAME, velame, const char *, STRING_SIZE, const char *, STRING_SIZE, const char *,
               STRING_SIZE, const char *, STRING_SIZE, const char *, STRING_SIZE );

#define CALLO_VRCINS_WRAP( a, b, c, d, e, f )                                                      \
    CALLOOOPOO( VRCINS_WRAP, vrcins_wrap, a, b, c, d, e, f )
void DEFSSSPSS( VRCINS_WRAP, vrcins_wrap, const char *, STRING_SIZE, const char *, STRING_SIZE,
                const char *, STRING_SIZE, const ASTERDOUBLE *, const char *, STRING_SIZE,
                const char *, STRING_SIZE );

#define CALLO_VRCREF( a, b, c, d ) CALLOOOO( VRCREF, vrcref, a, b, c, d )
void DEFSSSS( VRCREF, vrcref, const char *, STRING_SIZE, const char *, STRING_SIZE, const char *,
              STRING_SIZE, const char *, STRING_SIZE );

#define CALLO_VTCREB_WRAP( a, b, c, d ) CALLOOOO( VTCREB_WRAP, vtcreb_wrap, a, b, c, d )
void DEFSSSS( VTCREB_WRAP, vtcreb_wrap, const char *, STRING_SIZE, const char *, STRING_SIZE,
              const char *, STRING_SIZE, const char *, STRING_SIZE );

#ifdef __cplusplus
}
#endif

/* FIN ASTER_FORT_CALCUL_H */
#endif
