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

#ifndef ASTER_CORE_H
#define ASTER_CORE_H

#include "Python.h"
#include "aster.h"
/*
 *   PUBLIC FUNCTIONS
 *
 */

extern PyMODINIT_FUNC init_aster_core();

ASTERINTEGER DEFS( JDCGET, jdcget, _IN char *, STRING_SIZE );
extern void DEFSP( JDCSET, jdcset, _IN char *, STRING_SIZE, _IN ASTERINTEGER * );
extern PyObject* GetJdcAttr(_IN char *);
extern double get_tpmax();
extern void DEFP(RDTMAX, rdtmax, ASTERDOUBLE *);

extern PyObject* asterc_getopt(_IN char *);
extern long asterc_getopt_long(_IN char *, _OUT int *);
extern double asterc_getopt_double(_IN char *, _OUT int *);
extern char* asterc_getopt_string(_IN char *, _OUT int *);
extern void DEFSPP(GTOPTI,gtopti, _IN char *, STRING_SIZE,
                   _OUT ASTERINTEGER *, _OUT ASTERINTEGER *);
extern void DEFSPP(GTOPTR,gtoptr, _IN char *, STRING_SIZE,
                   _OUT ASTERDOUBLE *, _OUT ASTERINTEGER *);
extern void DEFSSP(GTOPTK,gtoptk, _IN char *, STRING_SIZE, _OUT char *, STRING_SIZE,
                   _OUT ASTERINTEGER *);

extern void DEFSPSPSPPPPS(UTPRIN,utprin, _IN char *, _IN STRING_SIZE, _IN ASTERINTEGER *,
                         _IN char *, _IN STRING_SIZE,
                         _IN ASTERINTEGER *, _IN char *, _IN STRING_SIZE, _IN ASTERINTEGER *,
                         _IN ASTERINTEGER *, _IN ASTERINTEGER *, _IN ASTERDOUBLE *,
                         _IN char*, _IN STRING_SIZE);
extern void DEFPP(CHKMSG,chkmsg, _IN ASTERINTEGER *, _OUT ASTERINTEGER *);
extern void DEFSSP(CHEKSD,cheksd,_IN char *,_IN STRING_SIZE, _IN char *, _IN STRING_SIZE,
                   _OUT ASTERINTEGER *);

extern void DEFP(PRHEAD,prhead, _IN ASTERINTEGER *);

extern PyObject* aster_matfpe(PyObject*, PyObject *);

/* FIN ASTER_CORE_H */
#endif
