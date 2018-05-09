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

#ifndef _DISABLE_SCOTCH
/* scotch.h may use int64_t without including <sys/types.h> */
#include <sys/types.h>
#include "scotch.h"
#endif


void DEFPPPPPPPPPP(FETSCO,fetsco, ASTERINTEGER *nbmato, ASTERINTEGER *nblien,
                                  ASTERINTEGER4 *connect, ASTERINTEGER4 *idconnect,
                                  ASTERINTEGER *nbpart, ASTERINTEGER4 *mapsd,
                                  ASTERINTEGER4 *edlo, ASTERINTEGER4 *velo,
                                  ASTERINTEGER *numver, ASTERINTEGER *ier)
{
#ifndef _DISABLE_SCOTCH
  int err,numv;
  int version=0;
  int release=0;
  int patch=0;
  SCOTCH_Graph        grafdat;
  SCOTCH_Strat        mapstrat;  

/* INPUT : NBMATO (NBRE DE NOEUDS DU GRAPHE), NBLIEN (NBRE D'ARETES DU GRAPHE), 
           CONNECT (TABLEAU DE CONNECTIVITE), IDCONNECT (VECTEUR DE POINTEURS DS CONNECT),
       NBPART (NBRE DE SOUS-DOMAINES), EDLO/VELO (VECTEURS DE CONTRAINTES).
   OUTPUT: MPASD (VECTEUR MAILLE NUMERO DE SD), NUMVER (NUMERO DE VERSION),
          IER (CODE RETOUR SCOTCH) */
  err = SCOTCH_graphInit(&grafdat);

/* CET APPEL A SCOTCH_VERSION N'EST LICITE QU'A PARTIR DE LA V5.0.0*/  
  if ( err == 0){
    SCOTCH_version(&version, &release, &patch);
/*    printf("SCOTCH VERSION= %d.%d.%d\n", version, release, patch);
    printf("\n");*/
  }  
  if ( err == 0 )
    err = SCOTCH_graphBuild(&grafdat, 1, (int)*nbmato, (const SCOTCH_Num *const) idconnect, NULL,
                            (const SCOTCH_Num *const) velo, NULL, (int)*nblien, 
                            (const SCOTCH_Num *const) connect, (const SCOTCH_Num *const) edlo);

/* VERIFICATION DE GRAPHE DEBRANCHABLE SUR DE GROS GRAPHES CAR POTENTIELLEMENT COUTEUSE */
  if ( err == 0 ) 
    err = SCOTCH_graphCheck (&grafdat);  

  if ( err == 0 ) 
    err = SCOTCH_stratInit (&mapstrat);                     
  
  if ( err == 0 )
    err=SCOTCH_graphPart(&grafdat, (int)*nbpart, &mapstrat, (SCOTCH_Num *const) mapsd);  

  if ( err == 0 ) {
    SCOTCH_stratExit(&mapstrat);
    SCOTCH_graphExit(&grafdat);
  }
  
  numv = version*10000 + release*100 + patch;
  *numver = (ASTERINTEGER)numv;
  *ier = (ASTERINTEGER)err;
#endif
}
