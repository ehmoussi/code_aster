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
/ Lecture sur un fichier HDF d'un segment de valeur associé à un objet JEVEUX
/  Paramètres : 
/   - in  idfic  : identificateur du dataset (hid_t)
/   - out  sv    : valeurs associées 
/   - in  lsv    : nombre de valeurs 
/   - in  icv    : active ou non la conversion Integer*8/integer*4
/  Résultats :
/     =0 OK, -1 sinon 
/-----------------------------------------------------------------------------*/
#ifndef _DISABLE_HDF5
#include <hdf5.h>
#endif

ASTERINTEGER DEFPPPP(HDFRSV, hdfrsv, ASTERINTEGER *idat, ASTERINTEGER *lsv,
                     void *sv, ASTERINTEGER *icv)
{
  ASTERINTEGER iret=-1;
#ifndef _DISABLE_HDF5
  hid_t ida,datatype,dasp,bidon=0;
  herr_t ier;
  hsize_t dims[1];
  int rank,status;

  ida = (hid_t) *idat;
  rank = 1;
  if ((datatype = H5Dget_type(ida))>=0 ) {     
    if ((dasp = H5Dget_space(ida))>=0 ) { 
      if ((rank = H5Sget_simple_extent_ndims(dasp))==1) {
        status = H5Sget_simple_extent_dims(dasp, dims, NULL);
      }
      if (*lsv >= (long) dims[0]) {
        if ((ier = H5Dread(ida, datatype, H5S_ALL, H5S_ALL, H5P_DEFAULT, sv))>=0 ) {
          if ( H5Tequal(H5T_STD_I32LE,datatype)>0 || H5Tequal(H5T_STD_I64LE,datatype)>0  ||
               H5Tequal(H5T_STD_I32BE,datatype)>0 || H5Tequal(H5T_STD_I64BE,datatype)>0 ) {
            if (*icv != 0) { 
          if ((H5Tconvert(datatype,H5T_NATIVE_LONG,*lsv,sv,NULL,bidon)) >= 0) {
                iret = 0;
              }
            } else { iret = 0; }
          } else { iret = 0; }
          H5Tclose(datatype);
        }
      }   
      H5Sclose(dasp);
    }
  }
#else
  CALL_UTMESS("F", "FERMETUR_3");
#endif
  return iret ; 
}
