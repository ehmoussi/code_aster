/**
 * @file DynamicMacroElementInterface.cxx
 * @brief Interface python de DynamicMacroElement
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

#include "PythonBindings/DynamicMacroElementInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

void exportDynamicMacroElementToPython() {
    using namespace boost::python;

    bool ( DynamicMacroElementInstance::*c1 )(
        const AssemblyMatrixDisplacementComplexPtr &matrix ) =
        &DynamicMacroElementInstance::setStiffnessMatrix;
    bool ( DynamicMacroElementInstance::*c2 )( const AssemblyMatrixDisplacementDoublePtr &matrix ) =
        &DynamicMacroElementInstance::setStiffnessMatrix;

    class_< DynamicMacroElementInstance, DynamicMacroElementInstance::DynamicMacroElementPtr,
            bases< DataStructure > >( "DynamicMacroElement", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< DynamicMacroElementInstance >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< DynamicMacroElementInstance, std::string >))
        .def( "getDampingMatrix", &DynamicMacroElementInstance::getDampingMatrix )
        .def( "getDOFNumbering", &DynamicMacroElementInstance::getDOFNumbering )
        .def( "getImpedanceDampingMatrix",
&DynamicMacroElementInstance::getImpedanceDampingMatrix )
        .def( "getImpedanceMatrix", &DynamicMacroElementInstance::getImpedanceMatrix )
        .def( "getImpedanceMassMatrix", &DynamicMacroElementInstance::getImpedanceMassMatrix )
        .def( "getImpedanceStiffnessMatrix",
              &DynamicMacroElementInstance::getImpedanceStiffnessMatrix )
        .def( "getMassMatrix", &DynamicMacroElementInstance::getMassMatrix )
        .def( "getNumberOfNodes", &DynamicMacroElementInstance::getNumberOfNodes )
        .def( "getComplexStiffnessMatrix", &DynamicMacroElementInstance::getComplexStiffnessMatrix )
        .def( "getDoubleStiffnessMatrix", &DynamicMacroElementInstance::getDoubleStiffnessMatrix )
        .def( "setDampingMatrix", &DynamicMacroElementInstance::setDampingMatrix )
        .def( "setDOFNumbering", &DynamicMacroElementInstance::setDOFNumbering )
        .def( "setImpedanceDampingMatrix", &DynamicMacroElementInstance::setImpedanceDampingMatrix )
        .def( "setImpedanceMatrix", &DynamicMacroElementInstance::setImpedanceMatrix )
        .def( "setImpedanceMassMatrix", &DynamicMacroElementInstance::setImpedanceMassMatrix )
        .def( "setImpedanceStiffnessMatrix",
              &DynamicMacroElementInstance::setImpedanceStiffnessMatrix )
        .def( "setMassMatrix", &DynamicMacroElementInstance::setMassMatrix )
        .def( "setMechanicalMode", &DynamicMacroElementInstance::setMechanicalMode )
        .def( "setStiffnessMatrix", c1 )
        .def( "setStiffnessMatrix", c2 );
};
