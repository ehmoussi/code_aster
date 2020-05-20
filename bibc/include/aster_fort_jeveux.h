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

#ifndef ASTER_FORT_JEVEUX_H
#define ASTER_FORT_JEVEUX_H

#include "aster.h"

/* ******************************************************
 *
 * Interfaces of fortran subroutines called from C/C++.
 *
 * ******************************************************/

#ifdef __cplusplus
extern "C" {
#endif

#define CALLO_JECREC( a, b, c, d, e, f ) CALLOOOOOP( JECREC, jecrec, a, b, c, d, e, f )
void DEFSSSSSP( JECREC, jecrec, const char *, STRING_SIZE, const char *, STRING_SIZE, const char *,
                STRING_SIZE, const char *, STRING_SIZE, const char *, STRING_SIZE, ASTERINTEGER * );

#define CALLO_JECREO( a, b ) CALLOO( JECREO, jecreo, a, b )
void DEFSS( JECREO, jecreo, const char *, STRING_SIZE, const char *, STRING_SIZE );

#define CALLO_JECROC( a ) CALLO( JECROC, jecroc, a )
void DEFS( JECROC, jecroc, const char *, STRING_SIZE );

#define CALL_JEDEMA() CALL0( JEDEMA, jedema )
extern void DEF0( JEDEMA, jedema );

#define CALL_JEDETR( a ) CALLS( JEDETR, jedetr, a )
#define CALLO_JEDETR( a ) CALLO( JEDETR, jedetr, a )
extern void DEFS( JEDETR, jedetr, const char *, STRING_SIZE );

#define CALLO_JEECRA_WRAP( a, b, c ) CALLOOP( JEECRA_WRAP, jeecra_wrap, a, b, c )
void DEFSSP( JEECRA_WRAP, jeecra_wrap, const char *, STRING_SIZE, const char *, STRING_SIZE,
             ASTERINTEGER * );

#define CALLO_JEECRA_STRING_WRAP( a, b, c )                                                        \
    CALLOOO( JEECRA_STRING_WRAP, jeecra_string_wrap, a, b, c )
void DEFSSS( JEECRA_STRING_WRAP, jeecra_string_wrap, const char *, STRING_SIZE, const char *,
             STRING_SIZE, const char *, STRING_SIZE );

#define CALL_JEEXIN( a, b ) CALLSP( JEEXIN, jeexin, a, b )
#define CALLO_JEEXIN( a, b ) CALLOP( JEEXIN, jeexin, a, b )
extern void DEFSP( JEEXIN, jeexin, const char *, STRING_SIZE, ASTERINTEGER * );

#define CALLO_JEIMPR( a, b, c ) CALLPOO( JEIMPR, jeimpr, a, b, c )
extern void DEFPSS( JEIMPR, jeimpr, _IN ASTERINTEGER *, const char *, STRING_SIZE, const char *,
                    STRING_SIZE );

#define CALL_JELST3( a, b, c, d ) CALLSSPP( JELST3, jelst3, a, b, c, d )
extern void DEFSSPP( JELST3, jelst3, char *, STRING_SIZE, char *, STRING_SIZE, ASTERINTEGER *,
                     ASTERINTEGER * );

#define CALL_JELIRA( a, b, c, d ) CALLSSPS( JELIRA, jelira, a, b, c, d )
#define CALLO_JELIRA( a, b, c, d ) CALLOOPO( JELIRA, jelira, a, b, c, d )
extern void DEFSSPS( JELIRA, jelira, const char *, STRING_SIZE, const char *, STRING_SIZE,
                     ASTERINTEGER *, const char *, STRING_SIZE );

#define CALLO_JELSTC( a, b, c, d, e, f ) CALLOOPPOP( JELSTC, jelstc, a, b, c, d, e, f )
void DEFSSPPSP( JELSTC, jelstc, const char *, STRING_SIZE, const char *, STRING_SIZE,
                ASTERINTEGER *, ASTERINTEGER *, const char *, STRING_SIZE, ASTERINTEGER * );

#define CALL_JEMARQ() CALL0( JEMARQ, jemarq )
extern void DEF0( JEMARQ, jemarq );

#define CALLO_JENONU( a, b ) CALLOP( JENONU, jenonu, a, b )
extern void DEFSP( JENONU, jenonu, const char *, STRING_SIZE, ASTERINTEGER * );

#define CALLO_JENUNO( a, b ) CALLOO( JENUNO, jenuno, a, b )
extern void DEFSS( JENUNO, jenuno, const char *, STRING_SIZE, const char *, STRING_SIZE );

/* char functions: the first two arguments is the result */
#define CALLO_JEXNUM( a, b, c ) CALLVOP( JEXNUM, jexnum, a, b, c )
extern void DEFVSP( JEXNUM, jexnum, const char *, STRING_SIZE, const char *, STRING_SIZE,
                    ASTERINTEGER * );

#define CALLO_JEXNOM( a, b, c ) CALLVOO( JEXNOM, jexnom, a, b, c )
extern void DEFVSS( JEXNOM, jexnom, const char *, STRING_SIZE, const char *, STRING_SIZE,
                    const char *, STRING_SIZE );

#define CALLO_JEVEUOC( a, b, c ) CALLOOP( JEVEUOC, jeveuoc, a, b, c )
void DEFSSP( JEVEUOC, jeveuoc, const char *, STRING_SIZE, const char *, STRING_SIZE, void * );

#define CALLO_JUCROC_WRAP( a, b, c, d, e ) CALLOOPPP( JUCROC_WRAP, jucroc_wrap, a, b, c, d, e )
void DEFSSPPP( JUCROC_WRAP, jucroc_wrap, const char *, STRING_SIZE, const char *, STRING_SIZE,
               ASTERINTEGER *, ASTERINTEGER *, void * );

#define CALLO_UTIMSD( a, b, c, d, e, f, g, h )                                                     \
    CALLPPPPOPOO( UTIMSD, utimsd, a, b, c, d, e, f, g, h )
void DEFPPPPSPSS( UTIMSD, utimsd, ASTERINTEGER *, ASTERINTEGER *, ASTERINTEGER *, ASTERINTEGER *,
                  const char *, STRING_SIZE, ASTERINTEGER *, const char *, STRING_SIZE,
                  const char *, STRING_SIZE );

#define CALLO_WKVECTC( a, b, c, d ) CALLOOPP( WKVECTC, wkvectc, a, b, c, d )
void DEFSSPP( WKVECTC, wkvectc, const char *, STRING_SIZE, const char *, STRING_SIZE,
              ASTERINTEGER *, void * );

/* probably now discouraged */
#define CALL_GETCON( nomsd, iob, ishf, ilng, ctype, lcon, iaddr, nomob )                           \
    CALLSPPPPPPS( GETCON, getcon, nomsd, iob, ishf, ilng, ctype, lcon, iaddr, nomob )
extern void DEFSPPPPPPS( GETCON, getcon, char *, STRING_SIZE, ASTERINTEGER *, ASTERINTEGER *,
                         ASTERINTEGER *, ASTERINTEGER *, ASTERINTEGER *, char **, char *,
                         STRING_SIZE );

#define CALL_PUTCON( nomsd, nbind, ind, valr, valc, num, iret )                                    \
    CALLSPPPPPP( PUTCON, putcon, nomsd, nbind, ind, valr, valc, num, iret )
extern void DEFSPPPPPP( PUTCON, putcon, char *, STRING_SIZE, ASTERINTEGER *, ASTERINTEGER *,
                        ASTERDOUBLE *, ASTERDOUBLE *, ASTERINTEGER *, ASTERINTEGER * );

#define CALL_TAILSD( nom, nomsd, val, nbval ) CALLSSPP( TAILSD, tailsd, nom, nomsd, val, nbval )
extern void DEFSSPP( TAILSD, tailsd, char *, STRING_SIZE, char *, STRING_SIZE, ASTERINTEGER *,
                     ASTERINTEGER * );

#define CALL_PRCOCH( nomce, nomcs, nomcmp, ktype, itopo, nval, groups )                            \
    CALLSSSSPPS( PRCOCH, prcoch, nomce, nomcs, nomcmp, ktype, itopo, nval, groups )
extern void DEFSSSSPPS( PRCOCH, prcoch, char *, STRING_SIZE, char *, STRING_SIZE, char *,
                        STRING_SIZE, char *, STRING_SIZE, ASTERINTEGER *, ASTERINTEGER *, char *,
                        STRING_SIZE );

#ifdef __cplusplus
}
#endif

/* FIN ASTER_FORT_JEVEUX_H */
#endif
