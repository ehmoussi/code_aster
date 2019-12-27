/**
 * @file CppToFortranGlossaryInterface.cxx
 * @brief Interface python de CppToFortranGlossary
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


#include "PythonBindings/CppToFortranGlossaryInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportCppToFortranGlossaryToPython() {

    py::class_< Glossary >( "Glossary", py::no_init )
        // fake initFactoryPtr: not a DataStructure
        // fake initFactoryPtr: not a DataStructure
        .def( "getComponent", &Glossary::getComponent )
        .def( "getIterativeSolverAlgorithm", &Glossary::getIterativeSolverAlgorithm )
        .def( "getLagrangeTreatment", &Glossary::getLagrangeTreatment )
        .def( "getMatrixType", &Glossary::getMatrixType )
        .def( "getMemoryManagement", &Glossary::getMemoryManagement )
        .def( "getModeling", &Glossary::getModeling )
        .def( "getMumpsAcceleration", &Glossary::getMumpsAcceleration )
        .def( "getMumpsPostTreatment", &Glossary::getMumpsPostTreatment )
        .def( "getPhysics", &Glossary::getPhysics )
        .def( "getRenumbering", &Glossary::getRenumbering )
        .def( "getPreconditioning", &Glossary::getPreconditioning )
        .def( "getSolver", &Glossary::getSolver );

    def( "getGlossary", &getReferenceToGlossary,
         py::return_value_policy< py::reference_existing_object >() );
};
