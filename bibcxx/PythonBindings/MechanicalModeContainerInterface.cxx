/**
 * @file MechanicalModeContainerInterface.cxx
 * @brief Interface python de MechanicalModeContainer
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

#include "PythonBindings/MechanicalModeContainerInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

void exportMechanicalModeContainerToPython()
{
    using namespace boost::python;

    bool (MechanicalModeContainerInstance::*c1)( const AssemblyMatrixDisplacementDoublePtr& ) =
        &MechanicalModeContainerInstance::setRigidityMatrix;
    bool (MechanicalModeContainerInstance::*c2)( const AssemblyMatrixTemperatureDoublePtr& ) =
        &MechanicalModeContainerInstance::setRigidityMatrix;

    class_< MechanicalModeContainerInstance, MechanicalModeContainerPtr,
            bases< FullResultsContainerInstance > > ( "MechanicalModeContainer", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MechanicalModeContainerInstance > ) )
        .def( "setRigidityMatrix", c1 )
        .def( "setRigidityMatrix", c2 )
        .def( "setStructureInterface", &MechanicalModeContainerInstance::setStructureInterface )
    ;
};

void exportMechanicalModeComplexContainerToPython()
{
    using namespace boost::python;

    bool (MechanicalModeComplexContainerInstance::*c1)(const AssemblyMatrixDisplacementDoublePtr&)=
        &MechanicalModeComplexContainerInstance::setRigidityMatrix;
    bool (MechanicalModeComplexContainerInstance::*c2)(const AssemblyMatrixDisplacementComplexPtr&)=
        &MechanicalModeComplexContainerInstance::setRigidityMatrix;

    class_< MechanicalModeComplexContainerInstance, MechanicalModeComplexContainerPtr,
            bases< FullResultsContainerInstance > > ( "MechanicalModeComplexContainer", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MechanicalModeComplexContainerInstance > ) )
        .def( "setDampingMatrix", &MechanicalModeComplexContainerInstance::setDampingMatrix )
        .def( "setRigidityMatrix", c1 )
        .def( "setRigidityMatrix", c2 )
        .def( "setStructureInterface",
              &MechanicalModeComplexContainerInstance::setStructureInterface )
    ;
};
