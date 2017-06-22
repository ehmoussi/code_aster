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
/ Ouverture d'un dataset HDF, renvoie éventuellement une erreur  
/  Paramètres :
/   - in  idfic : identificateur du fichier hdf (hid_t = int)
/   - in  nomg : nom du groupe (char *)
/   - in  nomd : nom du dataset (char *)
/  Résultats :
/     identificateur du dataset, -1 sinon (hid_t = int)
/-----------------------------------------------------------------------------*/
#ifndef _DISABLE_HDF5
#include <hdf5.h>
#endif

ASTERINTEGER DEFPSS(HDFOPD, hdfopd, ASTERINTEGER *idf, char *nomg,
                    STRING_SIZE lg, char *nomd, STRING_SIZE ln)
{
  ASTERINTEGER iret=-1;
#ifndef _DISABLE_HDF5
  hid_t id,idfic,dapl_id; 
  int k,lg2;
  char *nom;
  void *malloc(size_t size); 
  dapl_id=0;
  
  idfic=(hid_t) *idf;
  nom = (char *) malloc((lg+ln+2) * sizeof(char));
  for (k=0;k<lg;k++) {
     nom[k] = nomg[k];
  }
  k=lg-1;
  while (k>=0){
     if(nom[k] == ' ' || nom[k] == '/') { k--;}
     else break;
  }
  nom[k+1] = '/';
  lg2=k+2;
  for (k=0;k<ln;k++) {
     nom[lg2+k] = nomd[k];
  }
  k=lg2+ln-1;
  while (k>=0){
    if (nom[k] == ' ') { k--;}
    else break;
  }
  nom[k+1] = '\0';

  if ( (id = H5Dopen2(idfic,nom,dapl_id)) >= 0) 
    iret = (ASTERINTEGER) id;

  free (nom);
#else
  CALL_UTMESS("F", "FERMETUR_3");
#endif
  return iret;
}     
