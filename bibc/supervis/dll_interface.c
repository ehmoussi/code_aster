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

#include "Python.h"
#include "aster.h"
#include "aster_fort.h"
#include "definition_pt.h"

#include "dll_register.h"

#ifdef _POSIX
#include <dlfcn.h>
#endif

/* *********************************************************************
 * 
 * Utilities to Load Dynamically (optionnal) external Libraries
 * 
 * Supported components : UMAT
 * 
 * *********************************************************************/

/* Global dictionnary used to register (libraries, symbol) couples */
static PyObject* DLL_DICT = NULL;

void dll_init()
{
    /* Initialization */
    if ( ! DLL_DICT ) {
        DLL_DICT = PyDict_New();
    }
}

PyObject* get_dll_register_dict()
{
    /* Return the register dictionnary.
     * For external modules. */
    dll_init();
    return DLL_DICT;
}

void DEF0(DLLCLS, dllcls)
{
#ifdef _POSIX
    /* Unload all components
     */
    dll_init();
    libsymb_apply_on_all(DLL_DICT, (FUNC_PTR)dlclose, 1);
    Py_DECREF(DLL_DICT);
    DLL_DICT = NULL;
#endif
}
