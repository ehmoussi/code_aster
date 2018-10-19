/**
 * @file SimpleFieldOnNodesInterface.cxx
 * @brief Interface python de SimpleFieldOnNodes
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <boost/python.hpp>
#include <PythonBindings/factory.h>
#include "PythonBindings/DataStructureInterface.h"
#include "PythonBindings/SimpleFieldOnNodesInterface.h"

void exportSimpleFieldOnNodesToPython() {
    using namespace boost::python;
    class_< SimpleFieldOnNodesDoubleInstance, SimpleFieldOnNodesDoublePtr, bases< DataStructure > >(
        "SimpleFieldOnNodesDouble", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< SimpleFieldOnNodesDoubleInstance >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< SimpleFieldOnNodesDoubleInstance, std::string >))
        .def( "getValue", &SimpleFieldOnNodesDoubleInstance::getValue,
              return_value_policy< return_by_value >() )
        .def( "updateValuePointers", &SimpleFieldOnNodesDoubleInstance::updateValuePointers );
    class_< SimpleFieldOnNodesComplexInstance, SimpleFieldOnNodesComplexPtr,
            bases< DataStructure > >( "SimpleFieldOnNodesComplex", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< SimpleFieldOnNodesComplexInstance >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< SimpleFieldOnNodesComplexInstance, std::string >))
        .def( "getValue", &SimpleFieldOnNodesComplexInstance::getValue,
              return_value_policy< return_by_value >() )
        .def( "updateValuePointers", &SimpleFieldOnNodesComplexInstance::updateValuePointers );
};
