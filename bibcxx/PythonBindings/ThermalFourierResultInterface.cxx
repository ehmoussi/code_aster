/**
 * @file ThermalFourierResultInterface.cxx
 * @brief Interface python de ThermalFourierResult
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

#include "PythonBindings/ThermalFourierResultInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportThermalFourierResultToPython() {

    py::class_< ThermalFourierResultClass, ThermalFourierResultPtr,
                py::bases< ResultClass > >( "ThermalFourierResult", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ThermalFourierResultClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ThermalFourierResultClass, std::string >));
};
