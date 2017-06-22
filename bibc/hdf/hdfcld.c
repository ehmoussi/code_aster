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
/ Fermeture d'un dataset HDF 
/  Paramètres :
/   - in  idfic : identificateur du dataset (hid_t)
/  Résultats :
/     0 = fermeture OK, -1 sinon (long)
/-----------------------------------------------------------------------------*/
#ifndef _DISABLE_HDF5
#include <hdf5.h>
#endif

ASTERINTEGER DEFP(HDFCLD, hdfcld, ASTERINTEGER *idd)
{
#ifndef _DISABLE_HDF5
    hid_t id;
    herr_t icode;
 
    id=(hid_t) *idd;
    if ((icode = H5Dclose(id)) < 0) 
        return -1 ;
#else
    CALL_UTMESS("F", "FERMETUR_3");
#endif
    return 0;
}     
