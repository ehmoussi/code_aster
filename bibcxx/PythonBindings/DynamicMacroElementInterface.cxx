/**
 * @file DynamicMacroElementInterface.cxx
 * @brief Interface python de DynamicMacroElement
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

#include "PythonBindings/DynamicMacroElementInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

void exportDynamicMacroElementToPython()
{
    using namespace boost::python;

    bool (DynamicMacroElementInstance::*c1)( const AssemblyMatrixDisplacementComplexPtr& matrix ) =
            &DynamicMacroElementInstance::setRigidityMatrix;
    bool (DynamicMacroElementInstance::*c2)( const AssemblyMatrixDisplacementDoublePtr& matrix ) =
            &DynamicMacroElementInstance::setRigidityMatrix;

    class_< DynamicMacroElementInstance, DynamicMacroElementInstance::DynamicMacroElementPtr,
            bases< DataStructure > > ( "DynamicMacroElement", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< DynamicMacroElementInstance > ) )
        .def( "getDampingMatrix",
              &DynamicMacroElementInstance::getDampingMatrix )
        .def( "getImpedanceDampingMatrix",
              &DynamicMacroElementInstance::getImpedanceDampingMatrix )
        .def( "getImpedanceMatrix",
              &DynamicMacroElementInstance::getImpedanceMatrix )
        .def( "getImpedanceMassMatrix",
              &DynamicMacroElementInstance::getImpedanceMassMatrix )
        .def( "getImpedanceRigidityMatrix",
              &DynamicMacroElementInstance::getImpedanceRigidityMatrix )
        .def( "getMassMatrix",
              &DynamicMacroElementInstance::getMassMatrix )
        .def( "getComplexRigidityMatrix",
              &DynamicMacroElementInstance::getComplexRigidityMatrix )
        .def( "getDoubleRigidityMatrix",
              &DynamicMacroElementInstance::getDoubleRigidityMatrix )
        .def( "setDampingMatrix",
              &DynamicMacroElementInstance::setDampingMatrix )
        .def( "setImpedanceDampingMatrix",
              &DynamicMacroElementInstance::setImpedanceDampingMatrix )
        .def( "setImpedanceMatrix",
              &DynamicMacroElementInstance::setImpedanceMatrix )
        .def( "setImpedanceMassMatrix",
              &DynamicMacroElementInstance::setImpedanceMassMatrix )
        .def( "setImpedanceRigidityMatrix",
              &DynamicMacroElementInstance::setImpedanceRigidityMatrix )
        .def( "setMassMatrix",
              &DynamicMacroElementInstance::setMassMatrix )
        .def( "setSupportMechanicalMode",
              &DynamicMacroElementInstance::setSupportMechanicalMode )
        .def( "setRigidityMatrix", c1 )
        .def( "setRigidityMatrix", c2 )
    ;
};
