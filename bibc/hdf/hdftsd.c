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
/ Récupération du type et de la taille des valeurs stockées dans un dataset
/ au sein d'un fichier HDF 
/  Paramètres :
/   - in  iddat : identificateur du dataset (hid_t)
/   - out type  : type associé (char *)
/   - out ltype : longueur du type (long)
/   - out lv    : longueur du vecteur associé (dataspace de dim 1) (long)
/  Résultats :
/    =O OK, -1 sinon
/-----------------------------------------------------------------------------*/
#ifndef _DISABLE_HDF5
#include <hdf5.h>
#endif
#define FALSE   0

ASTERINTEGER DEFPSPP(HDFTSD, hdftsd, ASTERINTEGER *iddat, char *type, STRING_SIZE lt,
                ASTERINTEGER *ltype, ASTERINTEGER *lv)
{
  ASTERINTEGER iret=-1;
#ifndef _DISABLE_HDF5
  hid_t id,datatype,class,dataspace;
  hsize_t dims_out[1];
  int k,rank,status;

  id=(hid_t) *iddat;
  datatype  = H5Dget_type(id);     
  class     = H5Tget_class(datatype);
  if      (class == H5T_INTEGER)  *type='I';
  else if (class == H5T_FLOAT)    *type='R';
  else if (class == H5T_STRING)   *type='K';
  else                            *type='?';

  for (k=1;k<lt;k++) {
    *(type+k)=' ';
  }
  if ((*ltype = (ASTERINTEGER)H5Tget_size(datatype))>=0 ) {
    if ((dataspace = H5Dget_space(id))>=0 ) { 
      if ((rank = H5Sget_simple_extent_ndims(dataspace))==1) {
        status = H5Sget_simple_extent_dims(dataspace, dims_out, NULL);
        *lv = (ASTERINTEGER)dims_out[0];  
        H5Sclose(dataspace);
        iret=0;
      }
    }
  }
#else
  CALL_UTMESS("F", "FERMETUR_3");
#endif
  return iret;
}
