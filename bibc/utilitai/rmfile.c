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

/*
Remove a file
    nom1 (char): Filename
    info (int): Enable verbosity if equal to 1.
    iret (int, out): Exit code, 0 means ok.
*/

#include "aster.h"
#include "aster_utils.h"

#include <stdio.h>
#include <stdlib.h>

void DEFSPP( RMFILE, rmfile, char *nom1, STRING_SIZE lnom1, ASTERINTEGER *info,
             ASTERINTEGER *iret ) {
    char *fname;

    fname = MakeCStrFromFStr( nom1, lnom1 );
    if ( *info == 1 ) {
    }

    *iret = (ASTERINTEGER)remove( fname );

    if ( *info == 1 ) {
        if ( *iret == 0 ) {
            fprintf( stderr, "Deleted: '%s'\n", fname );
        } else {
            fprintf( stderr, "Deleting '%s':", fname );
            perror( "" );
        }
    }
    FreeStr( fname );
}
