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
#include "Solvers/StaticMechanicalSolver.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "Loads/KinematicsLoad.h"
#include "Loads/MechanicalLoad.h"
#include "LinearAlgebra/LinearSolver.h"
#include "Materials/MaterialOnMesh.h"
#include "Modelisations/Model.h"
#include "Results/ResultsContainer.h"

class StaticMechanicalSolver
{
    public:
        StaticMechanicalSolver();
        ~StaticMechanicalSolver();
};

%extend StaticMechanicalSolver
{
    void addKinematicsLoad( const KinematicsLoad& currentLoad )
    {
        return (*$self)->addKinematicsLoad( currentLoad );
    }

    void addMechanicalLoad( const MechanicalLoad& currentLoad )
    {
        return (*$self)->addMechanicalLoad( currentLoad );
    }

    ResultsContainer execute()
    {
        return (*$self)->execute();
    }

    void setLinearSolver( const LinearSolver& currentSolver )
    {
        return (*$self)->setLinearSolver( currentSolver );
    }

    void setMaterialOnMesh( const MaterialOnMesh& currentMaterial )
    {
        return (*$self)->setMaterialOnMesh( currentMaterial );
    }

    void setSupportModel( const Model& currentModel )
    {
        return (*$self)->setSupportModel( currentModel );
    }
}
