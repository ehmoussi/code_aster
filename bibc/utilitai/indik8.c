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

#include "aster.h"
/* ------------------------------------------------------------------ */
/* recherche de la  n-ieme apparition d un K*8 dans une liste de K*8    */
/* resultat = indice si present / 0 si absent                           */

ASTERINTEGER DEFSSPP(INDIK8, indik8, char *lstmot, STRING_SIZE llm,
                char *mot, STRING_SIZE lm, ASTERINTEGER *n, ASTERINTEGER *nmot)
{
    long i,j=0;
    char *p,m[8];

    // m = mot[1:8] to allow fast comparisons
    if ( lm < 8 ) {
        for (i=0; i<lm;i++) m[i] = mot[i];
        for (i=lm;i<8 ;i++) m[i] = ' ';
    } else if ( lm == 8 ) {
        for (i=0;i<8;i++)  m[i] = mot[i];
    } else {
      return 0;
    }

    if ( *n == 1 ) {
       for (i=0;i<*nmot;i++){
          p = lstmot+8*i;
          if (! strncmp(m,p,8)) return (i+1);
       }
    } else {
       for (i=0;i<*nmot;i++){
          p = lstmot+8*i;
          if (! strncmp(m,p,8))
             if ( ++j == *n ) return (i+1);
       }
    }

    return 0;
}
