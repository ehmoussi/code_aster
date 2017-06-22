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

/* person_in_charge: nicolas.sellenet at edf.fr */

#ifndef DLL_MFRONT_H
#define DLL_MFRONT_H

#include "aster.h"

/* declarations of pointers on MFRONT functions */
#define FUNC_MFRONT(NAME)  void DEFMFRONTBEHAVIOUR(*NAME, \
        ASTERDOUBLE*, ASTERDOUBLE*, ASTERDOUBLE*, ASTERDOUBLE*, ASTERDOUBLE*, \
            ASTERDOUBLE*, ASTERDOUBLE*, ASTERDOUBLE*, ASTERDOUBLE*, ASTERDOUBLE*, \
            ASTERINTEGER*, ASTERINTEGER*, ASTERDOUBLE*, ASTERINTEGER*, ASTERDOUBLE*, \
            ASTERDOUBLE*, ASTERINTEGER*)
#define FUNC_MFRONT_SET_DOUBLE(NAME)  void DEFMFRONTSETDOUBLE(*NAME, char*, \
                                                              ASTERDOUBLE, STRING_SIZE)
#define FUNC_MFRONT_SET_INTEGER(NAME)  void DEFMFRONTSETINTEGER(*NAME, char*, ASTERINTEGER, \
                                                                STRING_SIZE)
#define FUNC_MFRONT_SET_OUTOFBOUNDS_POLICY(NAME) void DEFMFRONTSETOUTOFBOUNDSPOLICY(*NAME,\
                                                                                    ASTERINTEGER)

/*
 *   PUBLIC FUNCTIONS
 *
 */


/*
 *   PRIVATE FUNCTIONS - UTILITIES
 *
 */

/**
 * \brief Return the symbol name of the MFront lib after testing if it should
 *        contain the modeliaztion or not.
 * @param libname   Name of library
 * @param symbol    Name of the main function (ex. asterbehaviourname)
 * @param model     Name of the modelization
 * @param basename  Basename/suffix of the symbol to find
 * @param name      Pointer on the string containing the found symbol name,
 *                  it must be freed by the caller.
 */
void mfront_name(
         _IN char* libname, _IN char* symbol, _IN char* model,
         _IN char* basename, _OUT char** name);
/**
 * \brief Raise an error 'symbol not found'
 */
void error_symbol_not_found(const char* libname, const char* symbname);

/**
 * \brief Clean parameter names: convert 'name[i]' into 'name_i'
 */
void clean_parameter(_IN const char* src, _OUT char** dest);

/**
 * \brief Load MFRONT library and initialize pointers to MFRONT functions
 */
int load_mfront_lib(const char* libname, const char* symbol);

char* test_mfront_symbol(const char* libname, char* name1, char* name2);


/* FIN DLL_MFRONT_H */
#endif
