/**
 * @file MechanicalModeContainerInterface.cxx
 * @brief Interface python de MechanicalModeContainer
 * @author Nicolas Sellenet
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

#include "PythonBindings/MechanicalModeContainerInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;
#include "PythonBindings/VariantStiffnessMatrixInterface.h"

void exportMechanicalModeContainerToPython() {

    bool ( MechanicalModeContainerClass::*c1 )( const AssemblyMatrixDisplacementDoublePtr & ) =
        &MechanicalModeContainerClass::setStiffnessMatrix;
    bool ( MechanicalModeContainerClass::*c2 )( const AssemblyMatrixTemperatureDoublePtr & ) =
        &MechanicalModeContainerClass::setStiffnessMatrix;
    bool ( MechanicalModeContainerClass::*c3 )( const AssemblyMatrixDisplacementComplexPtr & ) =
        &MechanicalModeContainerClass::setStiffnessMatrix;
    bool ( MechanicalModeContainerClass::*c4 )( const AssemblyMatrixPressureDoublePtr & ) =
        &MechanicalModeContainerClass::setStiffnessMatrix;

    bool ( MechanicalModeContainerClass::*c5 )( const AssemblyMatrixDisplacementDoublePtr & ) =
        &MechanicalModeContainerClass::setMassMatrix;
    bool ( MechanicalModeContainerClass::*c6 )( const AssemblyMatrixTemperatureDoublePtr & ) =
        &MechanicalModeContainerClass::setMassMatrix;
    bool ( MechanicalModeContainerClass::*c7 )( const AssemblyMatrixDisplacementComplexPtr & ) =
        &MechanicalModeContainerClass::setMassMatrix;
    bool ( MechanicalModeContainerClass::*c8 )( const AssemblyMatrixPressureDoublePtr & ) =
        &MechanicalModeContainerClass::setMassMatrix;

    py::class_< MechanicalModeContainerClass, MechanicalModeContainerPtr,
                py::bases< FullResultsContainerClass > >( "MechanicalModeContainer",
                                                             py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< MechanicalModeContainerClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< MechanicalModeContainerClass, std::string >))
        .def( "getDOFNumbering", &MechanicalModeContainerClass::getDOFNumbering )
        .def("getStiffnessMatrix", &getStiffnessMatrix< MechanicalModeContainerPtr >)
        .def( "setStiffnessMatrix", c1 )
        .def( "setStiffnessMatrix", c2 )
        .def( "setStiffnessMatrix", c3 )
        .def( "setStiffnessMatrix", c4 )
        .def("getMassMatrix", &getStiffnessMatrix< MechanicalModeContainerPtr >)
        .def( "setMassMatrix", c5 )
        .def( "setMassMatrix", c6 )
        .def( "setMassMatrix", c7 )
        .def( "setMassMatrix", c8 )
        .def( "setStructureInterface", &MechanicalModeContainerClass::setStructureInterface );
};

void exportMechanicalModeComplexContainerToPython() {

    bool ( MechanicalModeComplexContainerClass::*c1 )(
        const AssemblyMatrixDisplacementDoublePtr & ) =
        &MechanicalModeComplexContainerClass::setStiffnessMatrix;
    bool ( MechanicalModeComplexContainerClass::*c2 )(
        const AssemblyMatrixDisplacementComplexPtr & ) =
        &MechanicalModeComplexContainerClass::setStiffnessMatrix;
    bool ( MechanicalModeComplexContainerClass::*c3 )(
        const AssemblyMatrixDisplacementComplexPtr & ) =
        &MechanicalModeComplexContainerClass::setStiffnessMatrix;
    bool ( MechanicalModeComplexContainerClass::*c4 )(
        const AssemblyMatrixPressureDoublePtr & ) =
        &MechanicalModeComplexContainerClass::setStiffnessMatrix;

    py::class_< MechanicalModeComplexContainerClass, MechanicalModeComplexContainerPtr,
                py::bases< MechanicalModeContainerClass > >( "MechanicalModeComplexContainer",
                                                                py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< MechanicalModeComplexContainerClass >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< MechanicalModeComplexContainerClass, std::string >))
        .def( "setDampingMatrix", &MechanicalModeComplexContainerClass::setDampingMatrix )
        .def( "setStiffnessMatrix", c1 )
        .def( "setStiffnessMatrix", c2 )
        .def( "setStiffnessMatrix", c3 )
        .def( "setStiffnessMatrix", c4 )
        .def( "setStructureInterface",
              &MechanicalModeComplexContainerClass::setStructureInterface );
};
