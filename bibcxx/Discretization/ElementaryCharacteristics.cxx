/**
 * @file ElementaryCharacteristics.cxx
 * @brief Implementation de ElementaryCharacteristicsClass
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

#include "astercxx.h"

#include "Python.h"
#include "Discretization/ElementaryCharacteristics.h"

ElementaryCharacteristicsClass::ElementaryCharacteristicsClass( const std::string name,
                                                                      const ModelPtr &model )
    : DataStructure( name, 8, "CARA_ELEM" ), _model( model ), _mesh( model->getMesh() ),
      _numberOfSubpoints( new PCFieldOnMeshLongClass( getName() + ".CANBSP", _mesh ) ),
      _curveBeam( new PCFieldOnMeshRealClass( getName() + ".CARARCPO", _mesh ) ),
      _cable( new PCFieldOnMeshRealClass( getName() + ".CARCABLE", _mesh ) ),
      _shell( new PCFieldOnMeshRealClass( getName() + ".CARCOQUE", _mesh ) ),
      _dumping( new PCFieldOnMeshRealClass( getName() + ".CARDISCA", _mesh ) ),
      _rigidity( new PCFieldOnMeshRealClass( getName() + ".CARDISCK", _mesh ) ),
      _mass( new PCFieldOnMeshRealClass( getName() + ".CARDISCM", _mesh ) ),
      _bar( new PCFieldOnMeshRealClass( getName() + ".CARGENBA", _mesh ) ),
      _beamSection( new PCFieldOnMeshRealClass( getName() + ".CARGENPO", _mesh ) ),
      _beamGeometry( new PCFieldOnMeshRealClass( getName() + ".CARGEOPO", _mesh ) ),
      _orthotropicBasis( new PCFieldOnMeshRealClass( getName() + ".CARMASSI", _mesh ) ),
      _localBasis( new PCFieldOnMeshRealClass( getName() + ".CARORIEN", _mesh ) ),
      _beamCharacteristics( new PCFieldOnMeshRealClass( getName() + ".CARPOUFL", _mesh ) ),
      _isEmpty( true ){};
