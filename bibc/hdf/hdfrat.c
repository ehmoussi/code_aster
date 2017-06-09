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

/* person_in_charge: j-pierre.lefebvre at edf.fr */
#include "aster.h"
#include "aster_fort.h"
/*-----------------------------------------------------------------------------/
/ Lire un attribut de type chaine de caractères associé à un dataset 
/ au sein d'un fichier HDF 
/  Paramètres :
/   - in  iddat : identificateur du dataset (hid_t)
/   - in  nomat : nom de l'attribut (char *)
/   - in  nbv   : nombre de valeurs associées à l'attribut (long)
/   - out valat : valeur de l'attribut (char *)
/  Résultats :
/     =0 OK, =-1 problème 
/-----------------------------------------------------------------------------*/
#ifndef _DISABLE_HDF5
#include <hdf5.h>
#endif

ASTERINTEGER DEFPSPS(HDFRAT, hdfrat, ASTERINTEGER *iddat, char *nomat, STRING_SIZE ln,
                ASTERINTEGER *nbv, char *valat, STRING_SIZE lv)
{
  ASTERINTEGER iret=-1;
#ifndef _DISABLE_HDF5
  hid_t ida,attr,atyp,aspa;  
  herr_t ret;
  int k;
  int rank;
  size_t lt;
  hsize_t sdim[1]; 
  char *nom;
  void *malloc(size_t size); 
   
  ida=(hid_t) *iddat;
  nom = (char *) malloc((ln+1) * sizeof(char));
  for (k=0;k<ln;k++) {
     nom[k] = nomat[k];
  }
  k=ln-1;
  while (nom[k] == ' ') { k--;}
  nom[k+1] = '\0';
  if ( (attr = H5Aopen(ida,nom,H5P_DEFAULT)) >= 0) { 
    atyp = H5Aget_type(attr);
    lt=H5Tget_size(atyp);
    aspa = H5Aget_space(attr);
    if ( (rank = H5Sget_simple_extent_ndims(aspa)) == 1) {
      ret  = H5Sget_simple_extent_dims(aspa, sdim, NULL);
      ret  = H5Aread(attr, atyp, valat);
      iret = 0;
    } 
    ret  = H5Aclose(attr);
  } 
  free(nom);
#else
  CALL_UTMESS("F", "FERMETUR_3");
#endif
  return iret;
}
