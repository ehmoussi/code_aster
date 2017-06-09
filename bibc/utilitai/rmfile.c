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

/* appel de la commande systeme de destruction de fichier */
/* rm ou del suivant les plates-formes                    */
/* si info  = 1 mode bavard                               */
/* si info != 1 mode silencieux                           */
#include "aster.h"
#include "aster_utils.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void DEFSP(RMFILE, rmfile, char *nom1, STRING_SIZE lnom1, ASTERINTEGER *info)
{
    char *cmdline, *fname;
    size_t ldeb;
    int ier;

#if defined _POSIX
    char ncmd[] = "rm -f ";
#else
    char ncmd[] = "del ";
#endif
    ldeb = strlen(ncmd);

    if ( lnom1 == 0 || nom1[0] == ' ') return;

    cmdline = (char*)malloc((ldeb + lnom1 + 1) * sizeof(char));
    fname = MakeCStrFromFStr(nom1, lnom1);
    strncpy(cmdline, ncmd, (size_t)ldeb);
    strcpy(cmdline + ldeb, fname);

    if ( *info == 1 ) {
        printf("\n\nLancement de la commande : %s\n\n", cmdline);
    }

    ier = system(cmdline);
    free(cmdline);
    FreeStr(fname);

    if ( *info == 1 && ier == -1 ) {
        perror("\n<rmfile> code retour system");
    }
#if defined _POSIX
    fflush(stderr);
    fflush(stdout);
#else
    _flushall();
#endif
}
