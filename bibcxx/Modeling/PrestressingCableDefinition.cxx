/**
 * @file PrestressingCableDefinition.cxx
 * @brief Implementation de PrestressingCableDefinitionClass
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 22018 EDF R&D                www.code-aster.org
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

#include "Modeling/PrestressingCableDefinition.h"
#include "Supervis/ResultNaming.h"

PrestressingCableDefinitionClass::PrestressingCableDefinitionClass(
    const std::string jeveuxName, const ModelPtr &model, const MaterialFieldPtr &mater,
    const ElementaryCharacteristicsPtr &cara )
    : DataStructure( jeveuxName, 8, "CABL_PRECONT" ), _model( model ), _mater( mater ),
      _cara( cara ),
      _mesh( boost::static_pointer_cast< MeshClass >( _model->getMesh() ) ),
      _sigin( new ConstantFieldOnCellsRealClass( getName() + ".CHME.SIGIN", _mesh ) ),
      _cableBP( new TableClass( getName() + "CABLEBP    " ) ),
      _cableGL( new TableClass( getName() + "CABLEGL    " ) ),
      _lirela( new ListOfLinearRelationsReal( getName() + ".LIRELA    " ) ), _isEmpty( true ) {}

PrestressingCableDefinitionClass::PrestressingCableDefinitionClass(
    const ModelPtr &model, const MaterialFieldPtr &mater,
    const ElementaryCharacteristicsPtr &cara )
    : PrestressingCableDefinitionClass::PrestressingCableDefinitionClass(
          ResultNaming::getNewResultName(), model, mater, cara ) {}
