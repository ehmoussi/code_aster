/**
 * @file GeneralizedModeResultInterface.cxx
 * @brief Interface python de GeneralizedModeResult
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

#include "PythonBindings/GeneralizedModeResultInterface.h"
#include "PythonBindings/VariantStiffnessMatrixInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportGeneralizedModeResultToPython() {

    bool ( GeneralizedModeResultClass::*c1 )( const GeneralizedAssemblyMatrixRealPtr & ) =
        &GeneralizedModeResultClass::setStiffnessMatrix;
    bool ( GeneralizedModeResultClass::*c2 )( const GeneralizedAssemblyMatrixComplexPtr & ) =
        &GeneralizedModeResultClass::setStiffnessMatrix;

    py::class_< GeneralizedModeResultClass, GeneralizedModeResultPtr,
                py::bases< FullResultClass > >( "GeneralizedModeResult",
                                                             py::no_init )
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< GeneralizedModeResultClass, std::string >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< GeneralizedModeResultClass >))
        .def( "setDampingMatrix", &GeneralizedModeResultClass::setDampingMatrix )
        .def( "getGeneralizedDOFNumbering",
              &GeneralizedModeResultClass::getGeneralizedDOFNumbering )
        .def( "setGeneralizedDOFNumbering",
              &GeneralizedModeResultClass::setGeneralizedDOFNumbering )
        .def( "setStiffnessMatrix", c1 )
        .def( "setStiffnessMatrix", c2 )
        .def( "getDampingMatrix", &GeneralizedModeResultClass::getDampingMatrix )
        .def( "getStiffnessMatrix", &getGeneralizedStiffnessMatrix< GeneralizedModeResultPtr > );
};
