/**
 * @file DiscreteProblemInterface.cxx
 * @brief Interface python de DiscreteProblem
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "PythonBindings/DiscreteProblemInterface.h"
#include <boost/python.hpp>

void exportDiscreteProblemToPython()
{
    using namespace boost::python;

    class_< DiscreteProblemInstance, DiscreteProblemInstance::DiscreteProblemPtr >
            ( "DiscreteProblem", no_init )
        .def( "create", &DiscreteProblemInstance::create )
        .staticmethod( "create" )
        .def( "buildElementaryMechanicalLoadsVector",
              &DiscreteProblemInstance::buildElementaryMechanicalLoadsVector )
        .def( "buildElementaryDirichletVector",
              &DiscreteProblemInstance::buildElementaryDirichletVector )
        .def( "buildElementaryLaplaceVector",
              &DiscreteProblemInstance::buildElementaryLaplaceVector )
        .def( "buildElementaryNeumannVector",
              &DiscreteProblemInstance::buildElementaryNeumannVector )
        .def( "buildElementaryRigidityMatrix",
              &DiscreteProblemInstance::buildElementaryRigidityMatrix )
        .def( "buildElementaryTangentMatrix",
              &DiscreteProblemInstance::buildElementaryTangentMatrix )
        .def( "buildElementaryJacobianMatrix",
              &DiscreteProblemInstance::buildElementaryJacobianMatrix )
        .def( "computeDOFNumbering",
              &DiscreteProblemInstance::computeDOFNumbering )
        .def( "computeMechanicalDampingMatrix",
              &DiscreteProblemInstance::computeMechanicalDampingMatrix )
        .def( "computeMechanicalRigidityMatrix",
              &DiscreteProblemInstance::computeMechanicalRigidityMatrix )
        .def( "computeMechanicalMassMatrix",
              &DiscreteProblemInstance::computeMechanicalMassMatrix )
        .def( "getStudyDescription",
              &DiscreteProblemInstance::getStudyDescription )
    ;
};