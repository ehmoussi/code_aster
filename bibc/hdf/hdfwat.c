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
/ Ecrire un attribut de type chaine de caractères associé à un dataset 
/ au sein d'un fichier HDF 
/  Paramètres :
/   - in  iddat : identificateur du dataset (hid_t)
/   - in  nomat : nom de l'attribut (char *)
/   - in  nbv   : nombre de valeurs 
/   - in  valat : valeur de l'attribut (char *)
/  Résultats :
/     =0 OK, =-1 problème 
/-----------------------------------------------------------------------------*/
#ifndef _DISABLE_HDF5
#include <hdf5.h>
#endif

ASTERINTEGER DEFPSPS(HDFWAT, hdfwat, ASTERINTEGER *iddat, char *nomat, STRING_SIZE ln,
                                ASTERINTEGER *nbv, char *valat, STRING_SIZE lv)
{
  ASTERINTEGER iret=-1;
#ifndef _DISABLE_HDF5
  hid_t ida,aid,aty,att;  
  herr_t ret,retc; 
  hsize_t dimsf[1];
  int rank=1;
  int k;
  char *nom;
  void *malloc(size_t size); 
      
  ida=(hid_t) *iddat;
  dimsf[0]=(hsize_t)*nbv;
  nom = (char *) malloc((ln+1) * sizeof(char));
  for (k=0;k<ln;k++) {
     nom[k] = nomat[k];
  }
  k=ln-1;
  while (nom[k] == ' ') { k--;}
  nom[k+1] = '\0';
  if ( (aid = H5Screate(H5S_SIMPLE)) >= 0) {  
    H5Sset_extent_simple( aid, rank, dimsf, NULL );
    if ( (aty = H5Tcopy(H5T_FORTRAN_S1)) >= 0) {
                H5Tset_size(aty, lv);
      if ( (att = H5Acreate(ida, nom, aty, aid, H5P_DEFAULT, H5P_DEFAULT)) >= 0) {
        if ( (ret = H5Awrite(att, aty, valat)) >= 0) { 
          if ( (retc = H5Sclose(aid)) >= 0)  iret = 0;
        } 
      } 
    } 
  } 
  free(nom);
#else
  CALL_UTMESS("F", "FERMETUR_3");
#endif
  return iret;
}
