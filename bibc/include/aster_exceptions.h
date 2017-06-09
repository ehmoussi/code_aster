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

#ifndef ASTER_EXCEPTIONS_H
#define ASTER_EXCEPTIONS_H

#include <setjmp.h>
#include "aster.h"
#include "asterc_debug.h"
#include "aster_module.h"

#define FatalError 18   /* kept for backward compatibility only */
#define EOFError   19
#define AsterError 21

#define NIVMAX     10

#define try                 _new_try(); DEBUG_EXCEPT("try: level=%d", gExcLvl); \
                            if ((gExcNumb = setjmp(gExcEnv[gExcLvl])) == 0)
#define interruptTry(val)   if(gExcLvl > 0) { \
                                DEBUG_EXCEPT("interruptTry: level=%d", gExcLvl); \
                                longjmp(gExcEnv[gExcLvl], val); } \
                            else { printf("Exception raised out of Code_Aster commands.\n"); \
                                _raiseException(val); }
#define except(val)         else if (gExcNumb == val)
#define exceptAll           else
#define endTry()            _end_try(); DEBUG_EXCEPT("endTry: level=%d", gExcLvl);
#define raiseException()    _end_try(); \
                            DEBUG_EXCEPT("raiseException: level=%d", gExcLvl); \
                            _raiseException(gExcNumb); \
                            return NULL
#define raiseExceptionString(exc, args) \
                            _end_try(); \
                            PyErr_SetString(exc, args); \
                            return NULL

/*
 *   PUBLIC FUNCTIONS
 *
 */
extern int gExcLvl;
extern int gExcNumb;
extern jmp_buf gExcEnv[NIVMAX+1];

extern void initExceptions(PyObject *dict);

/*
 *   PRIVATE/HIDDEN FUNCTIONS
 *
 */
extern void _new_try();
extern void _end_try();
void _raiseException( _IN int val );

/* FIN ASTER_EXCEPTIONS_H */
#endif
