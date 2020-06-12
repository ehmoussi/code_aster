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

#ifndef SHARED_VARS_H
#define SHARED_VARS_H

#ifdef __cplusplus
extern "C" {
#endif

#include "Python.h"

/*
 *   PUBLIC FUNCTIONS
 *
 */

/*! Register the ExecutionParameter object as a global variable */
extern void register_sh_params(PyObject *);

/*! Register the MessageLog object as a global variable */
extern void register_sh_msglog(PyObject *);

/*! Register the current 'etape' object as a global variable */
extern void register_sh_etape(PyObject *);

/*! Register the status of jeveux */
extern void register_sh_jeveux_status(int);

/*! Return the global ExecutionParameter object */
extern PyObject * get_sh_params();

/*! Return the global MessageLog object */
extern PyObject * get_sh_msglog();

/*! Return the current 'etape' object */
extern PyObject * get_sh_etape();

/*! Return the status of jeveux */
extern int get_sh_jeveux_status();

/*! Initialize the stack of 'etape' objects */
extern void init_etape_stack();

/*! Append the given 'etape' object on stack */
extern PyObject * append_etape(PyObject *);

/*! Remove and return the last 'etape' object on stack */
extern PyObject * pop_etape();

#ifdef __cplusplus
}
#endif

/* FIN SHARED_VARS_H */
#endif
