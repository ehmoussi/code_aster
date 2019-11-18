/**
 * @file ElementaryCharacteristics.cxx
 * @brief Implementation de ElementaryCharacteristicsInstance
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

ElementaryCharacteristicsInstance::ElementaryCharacteristicsInstance( const std::string name,
                                                                      const ModelPtr &model )
    : DataStructure( name, 8, "CARA_ELEM" ), _model( model ), _mesh( model->getMesh() ),
      _numberOfSubpoints( new PCFieldOnMeshLongInstance( getName() + ".CANBSP", _mesh ) ),
      _curveBeam( new PCFieldOnMeshDoubleInstance( getName() + ".CARARCPO", _mesh ) ),
      _cable( new PCFieldOnMeshDoubleInstance( getName() + ".CARCABLE", _mesh ) ),
      _shell( new PCFieldOnMeshDoubleInstance( getName() + ".CARCOQUE", _mesh ) ),
      _dumping( new PCFieldOnMeshDoubleInstance( getName() + ".CARDISCA", _mesh ) ),
      _rigidity( new PCFieldOnMeshDoubleInstance( getName() + ".CARDISCK", _mesh ) ),
      _mass( new PCFieldOnMeshDoubleInstance( getName() + ".CARDISCM", _mesh ) ),
      _bar( new PCFieldOnMeshDoubleInstance( getName() + ".CARGENBA", _mesh ) ),
      _beamSection( new PCFieldOnMeshDoubleInstance( getName() + ".CARGENPO", _mesh ) ),
      _beamGeometry( new PCFieldOnMeshDoubleInstance( getName() + ".CARGEOPO", _mesh ) ),
      _orthotropicBasis( new PCFieldOnMeshDoubleInstance( getName() + ".CARMASSI", _mesh ) ),
      _localBasis( new PCFieldOnMeshDoubleInstance( getName() + ".CARORIEN", _mesh ) ),
      _beamCharacteristics( new PCFieldOnMeshDoubleInstance( getName() + ".CARPOUFL", _mesh ) ),
      _isEmpty( true ){};
