/**
 * @file CppToFortranGlossaryInterface.cxx
 * @brief Interface python de CppToFortranGlossary
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

// Not a DataStructure
// aslint: disable=C3006

#include "PythonBindings/CppToFortranGlossaryInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

void exportCppToFortranGlossaryToPython() {
    using namespace boost::python;

    class_< Glossary >( "Glossary", no_init )
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
         return_value_policy< reference_existing_object >() );
};
