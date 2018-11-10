/**
 * @file Fortran.h
 * @brief Definition of interface functions between C++ and Fortran
 * @author Mathieu Courtois
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   Code_Aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */

/* person_in_charge: mathieu.courtois@edf.fr */

#include "RunManager/Fortran.h"
#include "aster_fort.h"
#include "astercxx.h"
#include "shared_vars.h"

void call_oper( PyObject *syntax, int jxveri ) {
    ASTERINTEGER jxvrf = jxveri;

    // Add the new syntax object on the stack
    register_sh_etape( append_etape( syntax ) );

    try {
        CALL_EXPASS( &jxvrf );

    } catch ( ... ) {
        // unstack the syntax object
        register_sh_etape( pop_etape() );
        throw;
    }
    // unstack the syntax object
    register_sh_etape( pop_etape() );
}

void call_ops( PyObject *syntax, int ops ) {
    ASTERINTEGER nops = ops;

    // Add the new syntax object on the stack
    register_sh_etape( append_etape( syntax ) );

    try {
        CALL_OPSEXE( &nops );

    } catch ( ... ) {
        // unstack the syntax object
        register_sh_etape( pop_etape() );
        throw;
    }
    // unstack the syntax object
    register_sh_etape( pop_etape() );
}

void call_affich( const std::string &code, const std::string &text ) {
    CALL_AFFICH( code, text );
}

void call_print( const std::string &text ) { call_affich( "MESSAGE", text ); }
