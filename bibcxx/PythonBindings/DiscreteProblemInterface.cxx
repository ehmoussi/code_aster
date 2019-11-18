/**
 * @file DiscreteProblemInterface.cxx
 * @brief Interface python de DiscreteProblem
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

#include <boost/python.hpp>
#include <PythonBindings/factory.h>
#include "PythonBindings/DiscreteProblemInterface.h"

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( buildKinematicsLoad_overloads, buildKinematicsLoad, 2, 2 )

void exportDiscreteProblemToPython() {
    using namespace boost::python;

    class_< DiscreteProblemInstance, DiscreteProblemInstance::DiscreteProblemPtr >(
        "DiscreteProblem", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< DiscreteProblemInstance, StudyDescriptionPtr >))
        // fake initFactoryPtr: not a DataStructure
        .def( "buildElementaryMechanicalLoadsVector",
              &DiscreteProblemInstance::buildElementaryMechanicalLoadsVector )
        .def( "buildElementaryDirichletVector",
              &DiscreteProblemInstance::buildElementaryDirichletVector )
        .def( "buildElementaryLaplaceVector",
              &DiscreteProblemInstance::buildElementaryLaplaceVector )
        .def( "buildElementaryNeumannVector",
              &DiscreteProblemInstance::buildElementaryNeumannVector )
        .def( "buildElementaryStiffnessMatrix",
              &DiscreteProblemInstance::buildElementaryStiffnessMatrix )
        .def( "buildElementaryTangentMatrix",
              &DiscreteProblemInstance::buildElementaryTangentMatrix )
        .def( "buildElementaryJacobianMatrix",
              &DiscreteProblemInstance::buildElementaryJacobianMatrix )
        .def( "buildKinematicsLoad", &DiscreteProblemInstance::buildKinematicsLoad,
              buildKinematicsLoad_overloads() )
        .def( "computeDOFNumbering", &DiscreteProblemInstance::computeDOFNumbering )
        .def( "computeMechanicalDampingMatrix",
              &DiscreteProblemInstance::computeMechanicalDampingMatrix )
        .def( "computeMechanicalStiffnessMatrix",
              &DiscreteProblemInstance::computeMechanicalStiffnessMatrix )
        .def( "computeMechanicalMassMatrix", &DiscreteProblemInstance::computeMechanicalMassMatrix )
        .def( "getStudyDescription", &DiscreteProblemInstance::getStudyDescription );
};
