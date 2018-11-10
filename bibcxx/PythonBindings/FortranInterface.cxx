/**
 * @file FortranInterface.cxx
 * @brief Python bindings for Fortran interface.
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

#include <boost/python.hpp>

#include "PythonBindings/FortranInterface.h"

void exportFortranToPython() {
    using namespace boost::python;

    // These functions are for internal use.
    def( "call_oper", &call_oper, R"(
Call a Fortran operator ('op' subroutine).

Arguments:
    syntax (CommandSyntax): Object containing the user syntax.
    jxveri (int): If non null `JXVERI` is called after calling the operator.
        )",
         ( arg( "syntax" ), arg( "jxveri" ) ) );

    def( "call_ops", &call_ops, R"(
Call a Fortran 'ops' subroutine.

Arguments:
    syntax (CommandSyntax): Object containing the user syntax.
    ops (int): Number of the `ops00x` subroutine.
        )",
         ( arg( "syntax" ), arg( "ops" ) ) );

    def( "write", &call_print, R"(
Print a string using the fortran subroutine.

Arguments:
    text (str): Text to be printed.
        )",
         ( arg( "text" ) ) );

    def( "affich", &call_affich, R"(
Print a string using the fortran subroutine on an internal file.

Arguments:
    code (str): Code name of the internal file : 'MESSAGE' or 'CODE'.
    text (str): Text to be printed.
        )",
         ( arg( "code" ), arg( "text" ) ) );

    def( "jeveux_status", &get_sh_jeveux_status, R"(
Return the status of the Jeveux memory manager.

Returns:
    int: 0 after initialization and after shutdown, 1 during the execution.
        )" );
};
