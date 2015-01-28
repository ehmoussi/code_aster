/*
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

%module code_aster
%{
#include "LinearAlgebra/ElementaryVector.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "Loads/MechanicalLoad.h"
#include "Materials/MaterialOnMesh.h"
#include "DataFields/FieldOnNodes.h"
#include "LinearAlgebra/DOFNumbering.h"

class ElementaryVector
{
    public:
        ElementaryVector();
        ~ElementaryVector();
};

%extend ElementaryVector
{
    void addMechanicalLoad( const MechanicalLoad& currentLoad )
    {
        return (*$self)->addMechanicalLoad( currentLoad );
    }

    const FieldOnNodesPtrDouble assembleVector( const DOFNumbering& currentNumerotation )
    {
        return (*$self)->assembleVector( currentNumerotation );
    }

    bool computeMechanicalLoads()
    {
        return (*$self)->computeMechanicalLoads();
    }

    void debugPrint( const int logicalUnit )
    {
        return (*$self)->debugPrint( logicalUnit );
    }

    void setMaterialOnMesh( const MaterialOnMesh& currentMaterial )
    {
        return (*$self)->setMaterialOnMesh( currentMaterial );
    }
}
