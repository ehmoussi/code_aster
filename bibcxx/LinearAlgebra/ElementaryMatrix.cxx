/**
 * @file ElementaryMatrix.cxx
 * @brief Implementation de ElementaryMatrix
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
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

#include <stdexcept>
#include "astercxx.h"

#include "LinearAlgebra/ElementaryMatrix.h"
#include "RunManager/CommandSyntaxCython.h"

ElementaryMatrixInstance::ElementaryMatrixInstance( const JeveuxMemory memType ):
                DataStructure( "MATR_ELEM", memType ),
                _description( JeveuxVectorChar24( getName() + "           .RERR" ) ),
                _listOfElementaryResults( JeveuxVectorChar24( getName() + "           .RELR" ) ),
                _isEmpty( true )
{};

ElementaryMatrixInstance::ElementaryMatrixInstance( std::string type, const JeveuxMemory memType ):
                DataStructure( "MATR_ELEM_" + type, memType ),
                _description( JeveuxVectorChar24( getName() + "           .RERR" ) ),
                _listOfElementaryResults( JeveuxVectorChar24( getName() + "           .RELR" ) ),
                _isEmpty( true )
{};
