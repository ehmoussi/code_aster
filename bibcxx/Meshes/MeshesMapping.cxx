/**
 * @file MeshesMapping.cxx
 * @brief Implementation de MeshesMappingClass
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   Code_Aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "Meshes/MeshesMapping.h"

MeshesMappingClass::MeshesMappingClass( const std::string name )
    : DataStructure( name, 16, "CORRESP_2_MAILLA", Permanent ),
      _pjxxK1( JeveuxVectorChar24( getName() + ".PJXX_K1" ) ),
      _pjefNb( JeveuxVectorLong( getName() + ".PJEF_NB" ) ),
      _pjefNu( JeveuxVectorLong( getName() + ".PJEF_NU" ) ),
      _pjefM1( JeveuxVectorLong( getName() + ".PJEF_M1" ) ),
      _pjefCf( JeveuxVectorReal( getName() + ".PJEF_CF" ) ),
      _pjefTr( JeveuxVectorLong( getName() + ".PJEF_TR" ) ),
      _pjefCo( JeveuxVectorReal( getName() + ".PJEF_CO" ) ),
      _pjefEl( JeveuxVectorLong( getName() + ".PJEF_EL" ) ),
      _pjefMp( JeveuxVectorChar8( getName() + ".PJEF_MP" ) ),
      _pjngI1( JeveuxVectorLong( getName() + ".PJNG_I1" ) ),
      _pjngI2( JeveuxVectorLong( getName() + ".PJNG_I2" ) ){};
