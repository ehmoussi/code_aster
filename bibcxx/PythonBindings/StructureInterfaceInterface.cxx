/**
 * @file StructureInterfaceInterface.cxx
 * @brief Interface python de StructureInterface
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

#include <boost/python.hpp>

namespace py = boost::python;
#include <PythonBindings/factory.h>
#include "PythonBindings/StructureInterfaceInterface.h"

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( StructureInterfaceInstance_overloads, addInterface, 3, 4 )

void exportStructureInterfaceToPython() {

    py::enum_< InterfaceTypeEnum >( "InterfaceType" )
        .value( "MacNeal", MacNeal )
        .value( "CraigBampton", CraigBampton )
        .value( "HarmonicCraigBampton", HarmonicCraigBampton )
        .value( "None", NoInterfaceType );

    py::class_< StructureInterfaceInstance, StructureInterfaceInstance::StructureInterfacePtr,
            py::bases< DataStructure > >( "StructureInterface", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< StructureInterfaceInstance >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< StructureInterfaceInstance, std::string >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< StructureInterfaceInstance, DOFNumberingPtr >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< StructureInterfaceInstance, std::string, DOFNumberingPtr >))
        .def( "addInterface", &StructureInterfaceInstance::addInterface,
              StructureInterfaceInstance_overloads() );
};
