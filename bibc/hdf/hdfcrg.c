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
/ Création d'un groupe HDF, renvoie une erreur si le groupe ne peut être créé 
/  Paramètres :
/   - in idfile : identificateur du fichier (hid_t)
/   - in  nomgp : nom du groupe père (contient toute l'arborescence depuis "/")
/   - in  nomgr : nom du groupe (char *) à créer 
/  Résultats :
/     identificateur du groupe, -1 sinon (hid_t = int)
/-----------------------------------------------------------------------------*/
#ifndef _DISABLE_HDF5
#include <hdf5.h>
#endif

ASTERINTEGER DEFPSS(HDFCRG, hdfcrg, ASTERINTEGER *idf, char *nomgp, STRING_SIZE lp,
               char *nomgr, STRING_SIZE ln)
{
  ASTERINTEGER iret=-1;
#ifndef _DISABLE_HDF5
  hid_t  idgrp,idfic,lcpl_id,gcpl_id;     
  char *nomd;
  int k,lg2;
  void *malloc(size_t size);
  lcpl_id=0;gcpl_id=0;
  
  idfic=(hid_t) *idf;
  nomd = (char *) malloc((lp+ln+2) * sizeof(char));
  for (k=0;k<lp;k++) {
     nomd[k] = nomgp[k];
  }
  k=lp-1;
  while (k>=0){
     if(nomd[k] == ' ' || nomd[k] == '/') { k--;}
     else break;
  }
  nomd[k+1] = '/';
  lg2=k+1+1;
  for (k=0;k<ln;k++) {
     nomd[lg2+k] = nomgr[k];
  }
  k=lg2+ln-1;
  while (k>=0){
    if (nomd[k] == ' ') { k--;}
    else break;
  }
  nomd[k+1] = '\0';
 
  if ((idgrp = H5Gcreate2(idfic, nomd, lcpl_id, gcpl_id, H5P_DEFAULT)) >= 0) 
    iret = (ASTERINTEGER) idgrp;
  free (nomd);
#else
  CALL_UTMESS("F", "FERMETUR_3");
#endif
  return iret;
}     
