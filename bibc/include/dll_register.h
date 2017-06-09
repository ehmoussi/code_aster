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

#ifndef DLL_REGISTER_H
#define DLL_REGISTER_H

/*
 *   PUBLIC FUNCTIONS
 * 
 */

// to avoid mistake when casting to pointer on function
#define FUNC_PTR            void (*)(void *)

int libsymb_register(PyObject* dict, const char* libname, const char* symbname,
                     void* handle, FUNC_PTR);
int libsymb_release(PyObject* dict, const char* libname, const char* symbname);
int libsymb_is_known(PyObject* dict, const char* libname, const char* symbname);
void* libsymb_get_handle(PyObject* dict, const char* libname, const char* symbname);
void* libsymb_get_symbol(PyObject* dict, const char* libname, const char* symbname);
void libsymb_apply_on_all(PyObject* dict, FUNC_PTR, int release);

void NULL_FUNCTION();

/*
 *   PRIVATE FUNCTIONS - UTILITIES
 * 
 */

PyObject* _libsymb_to_key(const char* libname, const char* symbname);
void* _libsymb_get_object(PyObject* dict, const char* libname, const char* symbname, int index);

/* FIN DLL_REGISTER_H */
#endif
