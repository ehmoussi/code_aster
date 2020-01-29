/**
 * @file FullResultsContainer.cxx
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

#include "Results/FullResultsContainer.h"


bool FullResultsContainerClass::_setDOFNumbering( const BaseDOFNumberingPtr &dofNum ) {
    if ( dofNum != nullptr ) {
        _dofNum = dofNum;
        _mesh = _dofNum->getMesh();
        _fieldBuidler.addFieldOnNodesDescription( _dofNum->getFieldOnNodesDescription() );
        return true;
    }
    return false;
}

bool FullResultsContainerClass::setDOFNumbering( const DOFNumberingPtr &dofNum ) {
    FullResultsContainerClass::_setDOFNumbering( dofNum );
}

#ifdef _USE_MPI
bool FullResultsContainerClass::setParallelDOFNumbering(
        const ParallelDOFNumberingPtr &dofNum ) {
    FullResultsContainerClass::_setDOFNumbering( dofNum );
}
#endif
