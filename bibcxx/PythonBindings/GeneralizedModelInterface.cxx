/**
 * @file GeneralizedModelInterface.cxx
 * @brief Interface python de GeneralizedModel
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

#include "PythonBindings/GeneralizedModelInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportGeneralizedModelToPython() {

    py::class_< GeneralizedModelInstance, GeneralizedModelInstance::GeneralizedModelPtr,
            py::bases< DataStructure > >( "GeneralizedModel", py::no_init )
        .def( "__init__", py::make_constructor( &initFactoryPtr< GeneralizedModelInstance > ) )
        .def( "__init__",
              py::make_constructor( &initFactoryPtr< GeneralizedModelInstance, std::string > ) )
        .def( "addDynamicMacroElement", &GeneralizedModelInstance::addDynamicMacroElement )
        .def( "getDynamicMacroElementFromName",
              &GeneralizedModelInstance::getDynamicMacroElementFromName );
};
