/**
 * @file MechanicalModeContainerInterface.cxx
 * @brief Interface python de MechanicalModeContainer
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

#include "PythonBindings/MechanicalModeContainerInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>
#include "PythonBindings/VariantStiffnessMatrixInterface.h"

void exportMechanicalModeContainerToPython() {
    using namespace boost::python;

    bool ( MechanicalModeContainerInstance::*c1 )( const AssemblyMatrixDisplacementDoublePtr & ) =
        &MechanicalModeContainerInstance::setStiffnessMatrix;
    bool ( MechanicalModeContainerInstance::*c2 )( const AssemblyMatrixTemperatureDoublePtr & ) =
        &MechanicalModeContainerInstance::setStiffnessMatrix;
    bool ( MechanicalModeContainerInstance::*c3 )( const AssemblyMatrixDisplacementComplexPtr & ) =
        &MechanicalModeContainerInstance::setStiffnessMatrix;
    bool ( MechanicalModeContainerInstance::*c4 )( const AssemblyMatrixPressureDoublePtr & ) =
        &MechanicalModeContainerInstance::setStiffnessMatrix;

    bool ( MechanicalModeContainerInstance::*c5 )( const AssemblyMatrixDisplacementDoublePtr & ) =
        &MechanicalModeContainerInstance::setMassMatrix;
    bool ( MechanicalModeContainerInstance::*c6 )( const AssemblyMatrixTemperatureDoublePtr & ) =
        &MechanicalModeContainerInstance::setMassMatrix;
    bool ( MechanicalModeContainerInstance::*c7 )( const AssemblyMatrixDisplacementComplexPtr & ) =
        &MechanicalModeContainerInstance::setMassMatrix;
    bool ( MechanicalModeContainerInstance::*c8 )( const AssemblyMatrixPressureDoublePtr & ) =
        &MechanicalModeContainerInstance::setMassMatrix;

    class_< MechanicalModeContainerInstance, MechanicalModeContainerPtr,
            bases< FullResultsContainerInstance > >( "MechanicalModeContainer", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< MechanicalModeContainerInstance >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< MechanicalModeContainerInstance, std::string >))
        .def( "getDOFNumbering", &MechanicalModeContainerInstance::getDOFNumbering )
        .def( "getStiffnessMatrix", &getStiffnessMatrix< MechanicalModeContainerPtr > )
        .def( "setStiffnessMatrix", c1 )
        .def( "setStiffnessMatrix", c2 )
        .def( "setStiffnessMatrix", c3 )
        .def( "setStiffnessMatrix", c4 )
        .def( "getMassMatrix", &getStiffnessMatrix< MechanicalModeContainerPtr > )
        .def( "setMassMatrix", c5 )
        .def( "setMassMatrix", c6 )
        .def( "setMassMatrix", c7 )
        .def( "setMassMatrix", c8 )
        .def( "setStructureInterface", &MechanicalModeContainerInstance::setStructureInterface );
};

void exportMechanicalModeComplexContainerToPython() {
    using namespace boost::python;

    bool ( MechanicalModeComplexContainerInstance::*c1 )(
        const AssemblyMatrixDisplacementDoublePtr & ) =
        &MechanicalModeComplexContainerInstance::setStiffnessMatrix;
    bool ( MechanicalModeComplexContainerInstance::*c2 )(
        const AssemblyMatrixDisplacementComplexPtr & ) =
        &MechanicalModeComplexContainerInstance::setStiffnessMatrix;
    bool ( MechanicalModeComplexContainerInstance::*c3 )(
        const AssemblyMatrixDisplacementComplexPtr & ) =
        &MechanicalModeComplexContainerInstance::setStiffnessMatrix;
    bool ( MechanicalModeComplexContainerInstance::*c4 )(
        const AssemblyMatrixPressureDoublePtr & ) =
        &MechanicalModeComplexContainerInstance::setStiffnessMatrix;

    class_< MechanicalModeComplexContainerInstance, MechanicalModeComplexContainerPtr,
            bases< MechanicalModeContainerInstance > >( "MechanicalModeComplexContainer", no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< MechanicalModeComplexContainerInstance >))
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< MechanicalModeComplexContainerInstance, std::string >))
        .def( "setDampingMatrix", &MechanicalModeComplexContainerInstance::setDampingMatrix )
        .def( "setStiffnessMatrix", c1 )
        .def( "setStiffnessMatrix", c2 )
        .def( "setStiffnessMatrix", c3 )
        .def( "setStiffnessMatrix", c4 )
        .def( "setStructureInterface",
              &MechanicalModeComplexContainerInstance::setStructureInterface );
};
