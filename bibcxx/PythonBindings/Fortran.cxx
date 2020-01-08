/**
 * @file Fortran.h
 * @brief Definition of interface functions between C++ and Fortran
 * @author Mathieu Courtois
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
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

#include "PythonBindings/Fortran.h"
#include "aster_fort.h"
#include "aster_utils.h"
#include "astercxx.h"
#include "shared_vars.h"

void jeveux_init() {
    ASTERINTEGER dbg = 0;
    CALL_IBMAIN();

    // now Jeveux is available
    register_sh_jeveux_status( 1 );
}

void jeveux_finalize( const bool from_save ) {
    if ( get_sh_jeveux_status() != 1 ) {
        return;
    }
    ASTERINTEGER isave;
    isave = ( ASTERINTEGER ) int( from_save );
    CALL_OP9999( &isave );
    register_sh_jeveux_status( 0 );
}

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

void call_debut( PyObject *syntax ) { return call_ops( syntax, -1 ); }

void call_poursuite( PyObject *syntax ) { return call_ops( syntax, -2 ); }

void call_affich( const std::string &code, const std::string &text ) { CALL_AFFICH( code, text ); }

void call_print( const std::string &text ) { call_affich( "MESSAGE", text ); }

std::string onFatalError( const std::string value ) {
    ASTERINTEGER lng = 16;
    char *tmp = MakeBlankFStr( lng );
    std::string blank = " ";

    if ( value == "ABORT" || value == "EXCEPTION" ||
         value == "EXCEPTION+VALID" | value == "INIT" ) {
        CALL_ONERRF( (char *)value.c_str(), tmp, &lng );
    } else {
        CALL_ONERRF( (char *)blank.c_str(), tmp, &lng );
    }
    return std::string( tmp, lng );
}

extern "C" void _reset_tpmax();

void set_option( const std::string &option, double value ) {
    if ( option == "tpmax" ) {
        // only reset the cached value for the moment
        _reset_tpmax();
    }
}
