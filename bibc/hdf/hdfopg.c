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
#include "aster_fort.h"
/*-----------------------------------------------------------------------------/
/ Ouverture d'un groupe HDF, renvoie une erreur si le groupe ne peut être ouvert 
/  Paramètres :
/   - in idfile : identificateur du fichier (hid_t)
/   - in  nomgr : nom du groupe (contient toute l'arborescence depuis "/")
/  Résultats :
/     identificateur du groupe, -1 sinon (hid_t = int)
/-----------------------------------------------------------------------------*/
#ifndef _DISABLE_HDF5
#include <hdf5.h>
#endif

ASTERINTEGER DEFPS(HDFOPG, hdfopg, ASTERINTEGER *idf, char *nomgr, STRING_SIZE ln)
{
  ASTERINTEGER iret=-1;
#ifndef _DISABLE_HDF5
  hid_t  idgrp,idfic;     
  char *nomd;
  int k;
  void *malloc(size_t size);
  
  idfic=(hid_t) *idf;
  nomd = (char *) malloc((ln+1) * sizeof(char));
  for (k=0;k<ln;k++) {
     nomd[k] = nomgr[k];
  }
  k=ln-1;
  while (k>=0){
     if (nomd[k] == ' ' || nomd[k] == '/') { k--;}
     else break;
  }
  if ( k == -1 ) {
    nomd[k+1] = '/';
    k++;
  } 
  nomd[k+1] = '\0';

  if ((idgrp = H5Gopen2(idfic, nomd, H5P_DEFAULT)) >= 0) 
    iret = (ASTERINTEGER) idgrp;
  free (nomd);
#else
  CALL_UTMESS("F", "FERMETUR_3");
#endif
  return iret;
}     
