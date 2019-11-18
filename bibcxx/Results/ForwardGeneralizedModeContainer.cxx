/**
 * @file GeneralizedModeContainer.cxx
 * @brief Implementation de GeneralizedModeContainer
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

#include "Results/ForwardGeneralizedModeContainer.h"
#include "Results/GeneralizedModeContainer.h"

ForwardGeneralizedModeContainerPtr::ForwardGeneralizedModeContainerPtr() : _isSet( false ){};

ForwardGeneralizedModeContainerPtr::ForwardGeneralizedModeContainerPtr(
    const GeneralizedModeContainerPtr &ptr )
    : _ptr( ptr ), _isSet( true ){};

void ForwardGeneralizedModeContainerPtr::operator=( const GeneralizedModeContainerPtr &ptr ) {
    _ptr = ptr;
    _isSet = true;
};

GeneralizedModeContainerPtr
ForwardGeneralizedModeContainerPtr::getPointer() {
    if ( !_isSet )
        throw std::runtime_error( "No pointer set" );
    return _ptr;
};

bool ForwardGeneralizedModeContainerPtr::isSet() const { return _isSet; };

void ForwardGeneralizedModeContainerPtr::setPointer( const GeneralizedModeContainerPtr &ptr ) {
    _ptr = ptr;
    _isSet = true;
};
