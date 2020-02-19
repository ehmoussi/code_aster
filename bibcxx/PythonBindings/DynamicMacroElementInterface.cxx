/**
 * @file DynamicMacroElementInterface.cxx
 * @brief Interface python de DynamicMacroElement
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

#include "PythonBindings/DynamicMacroElementInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportDynamicMacroElementToPython() {

    bool ( DynamicMacroElementClass::*c1 )(
        const AssemblyMatrixDisplacementComplexPtr &matrix ) =
        &DynamicMacroElementClass::setStiffnessMatrix;
    bool ( DynamicMacroElementClass::*c2 )( const AssemblyMatrixDisplacementRealPtr &matrix ) =
        &DynamicMacroElementClass::setStiffnessMatrix;

    py::class_< DynamicMacroElementClass, DynamicMacroElementClass::DynamicMacroElementPtr,
            py::bases< DataStructure > >( "DynamicMacroElement", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< DynamicMacroElementClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< DynamicMacroElementClass, std::string >))
        .def( "getDampingMatrix", &DynamicMacroElementClass::getDampingMatrix )
        .def( "getDOFNumbering", &DynamicMacroElementClass::getDOFNumbering )
        .def( "getImpedanceDampingMatrix",
&DynamicMacroElementClass::getImpedanceDampingMatrix )
        .def( "getImpedanceMatrix", &DynamicMacroElementClass::getImpedanceMatrix )
        .def( "getImpedanceMassMatrix", &DynamicMacroElementClass::getImpedanceMassMatrix )
        .def( "getImpedanceStiffnessMatrix",
              &DynamicMacroElementClass::getImpedanceStiffnessMatrix )
        .def( "getMassMatrix", &DynamicMacroElementClass::getMassMatrix )
        .def( "getNumberOfNodes", &DynamicMacroElementClass::getNumberOfNodes )
        .def( "getComplexStiffnessMatrix", &DynamicMacroElementClass::getComplexStiffnessMatrix )
        .def( "getRealStiffnessMatrix", &DynamicMacroElementClass::getRealStiffnessMatrix )
        .def( "setDampingMatrix", &DynamicMacroElementClass::setDampingMatrix )
        .def( "setDOFNumbering", &DynamicMacroElementClass::setDOFNumbering )
        .def( "setImpedanceDampingMatrix", &DynamicMacroElementClass::setImpedanceDampingMatrix )
        .def( "setImpedanceMatrix", &DynamicMacroElementClass::setImpedanceMatrix )
        .def( "setImpedanceMassMatrix", &DynamicMacroElementClass::setImpedanceMassMatrix )
        .def( "setImpedanceStiffnessMatrix",
              &DynamicMacroElementClass::setImpedanceStiffnessMatrix )
        .def( "setMassMatrix", &DynamicMacroElementClass::setMassMatrix )
        .def( "setMechanicalMode", &DynamicMacroElementClass::setMechanicalMode )
        .def( "setStiffnessMatrix", c1 )
        .def( "setStiffnessMatrix", c2 );
};
