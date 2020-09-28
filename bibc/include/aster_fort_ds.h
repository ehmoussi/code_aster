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

#ifndef ASTER_FORT_DS_H
#define ASTER_FORT_DS_H

#include "aster.h"

/* ******************************************************
 *
 * Interfaces of fortran subroutines called from C/C++.
 *
 * ******************************************************/

#ifdef __cplusplus
extern "C" {
#endif

#define CALLO_ALCART( a, b, c, d ) CALLOOOO( ALCART, alcart, a, b, c, d )
void DEFSSSS( ALCART, alcart, const char *, STRING_SIZE, const char *, STRING_SIZE, const char *,
              STRING_SIZE, const char *, STRING_SIZE );

#define CALLO_CELCES_WRAP( a, b, c ) CALLOOO( CELCES_WRAP, celces_wrap, a, b, c )
void DEFSSS( CELCES_WRAP, celces_wrap, const char *, STRING_SIZE, const char *, STRING_SIZE,
             const char *, STRING_SIZE );

#define CALLO_CNOCNS( a, b, c ) CALLOOO( CNOCNS, cnocns, a, b, c )
void DEFSSS( CNOCNS, cnocns, const char *, STRING_SIZE, const char *, STRING_SIZE, const char *,
             STRING_SIZE );

#define CALL_DETMAT() CALL0( DETMAT, detmat )
extern void DEF0( DETMAT, detmat );

#define CALL_DETMATRIX( a ) CALLS( DETMATRIX, detmatrix, a )
#define CALLO_DETMATRIX( a ) CALLO( DETMATRIX, detmatrix, a )
extern void DEFS( DETMATRIX, detmatrix, const char *, STRING_SIZE );

#define CALLO_DELETE_MATRIX( a, b ) CALLOO( DELETE_MATRIX, delete_matrix, a, b )
void DEFSS( DELETE_MATRIX, delete_matrix, const char *, STRING_SIZE, const char *, STRING_SIZE );

#define CALLO_MATR_ASSE_SET_VALUES( a, b, c, d, e) CALLOPPPP( MATR_ASSE_SET_VALUES, \
                                                            matr_asse_set_values, a, b, c, d, e)
extern void DEFSPPPP( MATR_ASSE_SET_VALUES, matr_asse_set_values, const char *, STRING_SIZE, \
            const ASTERINTEGER *, const ASTERINTEGER *, const ASTERINTEGER *, const ASTERDOUBLE *);

#define CALLO_MATR_ASSE_TRANSPOSE( a ) CALLO( MATR_ASSE_TRANSPOSE, matr_asse_transpose, a)
void DEFS( MATR_ASSE_TRANSPOSE, matr_asse_transpose, const char *, STRING_SIZE);

#define CALLO_MATR_ASSE_TRANSPOSE_CONJUGATE( a )                                                   \
    CALLO( MATR_ASSE_TRANSPOSE_CONJUGATE, matr_asse_transpose_conjugate, a)
void DEFS( MATR_ASSE_TRANSPOSE_CONJUGATE, matr_asse_transpose_conjugate, const char *, STRING_SIZE);

#define CALLO_POSDDL( a, b, c, d, e, f ) CALLOOOOPP( POSDDL, posddl, a, b, c, d, e, f)
void DEFSSSSPP( POSDDL, posddl, const char *, STRING_SIZE, const char *, STRING_SIZE, \
                                const char *, STRING_SIZE, const char *, STRING_SIZE, \
                                const ASTERINTEGER *, const ASTERINTEGER *);

#define CALLO_DETRSD( a, b ) CALLOO( DETRSD, detrsd, a, b )
extern void DEFSS( DETRSD, detrsd, const char *, STRING_SIZE, const char *, STRING_SIZE );

#define CALLO_RGNDAS_WRAP( a, b, c, d, e, f ) \
                                CALLOPOOOO( RGNDAS_WRAP, rgndas_wrap, a, b, c, d, e, f)
void DEFSPSSSS( RGNDAS_WRAP, rgndas_wrap, const char *, STRING_SIZE, const ASTERINTEGER *, \
                        const char *, STRING_SIZE, const char *, STRING_SIZE,  \
                        const char *, STRING_SIZE, const char *, STRING_SIZE );

#define CALL_NUMEDDL_GET_COMPONENTS( a, b, c, d, e, f ) \
                    CALLSSPPSP( NUMEDDL_GET_COMPONENTS, numeddl_get_components, a, b , c, d, e, f)
extern void DEFSSPPSP( NUMEDDL_GET_COMPONENTS, numeddl_get_components, const char *, STRING_SIZE, \
                                const char *, STRING_SIZE, const ASTERINTEGER *, ASTERINTEGER *, \
                                char *, STRING_SIZE, const ASTERINTEGER *);

#define CALLO_NOCARTC( a, b, c, d, e, f, g, h, i )                                                 \
    CALLOPPOOPOPO( NOCART_C, nocart_c, a, b, c, d, e, f, g, h, i )
void DEFSPPSSPSPS( NOCART_C, nocart_c, const char *, STRING_SIZE, const ASTERINTEGER *,
                   const ASTERINTEGER *, const char *, STRING_SIZE, const char *, STRING_SIZE,
                   const ASTERINTEGER *, const char *, STRING_SIZE, const ASTERINTEGER *,
                   const char *, STRING_SIZE );

#ifdef _STRLEN_AT_END
#define CALL_RSACCH( nomsd, numch, nomch, nbord, liord, nbcmp, liscmp )                            \
    F_FUNC( RSACCH, rsacch )                                                                       \
    ( nomsd, numch, nomch, nbord, liord, nbcmp, liscmp, strlen( nomsd ), 16, 8 )
#else
#define CALL_RSACCH( nomsd, numch, nomch, nbord, liord, nbcmp, liscmp )                            \
    F_FUNC( RSACCH, rsacch )                                                                       \
    ( nomsd, strlen( nomsd ), numch, nomch, 16, nbord, liord, nbcmp, liscmp, 8 )
#endif
extern void DEFSPSPPPS( RSACCH, rsacch, char *, STRING_SIZE, ASTERINTEGER *, char *, STRING_SIZE,
                        ASTERINTEGER *, ASTERINTEGER *, ASTERINTEGER *, char *, STRING_SIZE );

#define CALL_RSACPA( nomsd, numva, icode, nomva, ctype, ival, rval, kval, ier )                    \
    CALLSPPSPPPSP( RSACPA, rsacpa, nomsd, numva, icode, nomva, ctype, ival, rval, kval, ier )
extern void DEFSPPSPPPSP( RSACPA, rsacpa, char *, STRING_SIZE, ASTERINTEGER *, ASTERINTEGER *,
                          char *, STRING_SIZE, ASTERINTEGER *, ASTERINTEGER *, ASTERDOUBLE *,
                          char *, STRING_SIZE, ASTERINTEGER * );

#define CALLO_RSADPA_ZK8_WRAP( a, b, c, d ) CALLOPOO( RSADPA_ZK8_WRAP, rsadpa_zk8_wrap, a, b, c, d )
extern void DEFSPSS( RSADPA_ZK8_WRAP, rsadpa_zk8_wrap, const char *, STRING_SIZE, ASTERINTEGER *,
                     const char *, STRING_SIZE, const char *, STRING_SIZE );

#define CALLO_RSADPA_ZR_WRAP( a, b, c, d ) CALLOPPO( RSADPA_ZR_WRAP, rsadpa_zr_wrap, a, b, c, d )
extern void DEFSPPS( RSADPA_ZR_WRAP, rsadpa_zr_wrap, const char *, STRING_SIZE, ASTERINTEGER *,
                     ASTERDOUBLE *, const char *, STRING_SIZE );

#define CALLO_RSADPA_ZK24_WRAP( a, b, c, d )                                                       \
    CALLOPOO( RSADPA_ZK24_WRAP, rsadpa_zk24_wrap, a, b, c, d )
extern void DEFSPSS( RSADPA_ZK24_WRAP, rsadpa_zk24_wrap, const char *, STRING_SIZE, ASTERINTEGER *,
                     const char *, STRING_SIZE, const char *, STRING_SIZE );

#define CALLO_RSCRSD( a, b, c, d ) CALLOOOP( RSCRSD, rscrsd, a, b, c, d )
void DEFSSSP( RSCRSD, rscrsd, const char *, STRING_SIZE, const char *, STRING_SIZE, const char *,
              STRING_SIZE, const ASTERINTEGER * );

#define CALLO_RSEXCH( a, b, c, d, e, f ) CALLOOOPOP( RSEXCH, rsexch, a, b, c, d, e, f )
void DEFSSSPSP( RSEXCH, rsexch, const char *, STRING_SIZE, const char *, STRING_SIZE, const char *,
                STRING_SIZE, const ASTERINTEGER *, const char *, STRING_SIZE,
                const ASTERINTEGER * );

#define CALLO_RSNOCH( a, b, c ) CALLOOP( RSNOCH_FORWARD, rsnoch_forward, a, b, c )
void DEFSSP( RSNOCH_FORWARD, rsnoch_forward, const char *, STRING_SIZE, const char *, STRING_SIZE,
             const ASTERINTEGER * );

#ifdef __cplusplus
}
#endif

/* FIN ASTER_FORT_DS_H */
#endif
