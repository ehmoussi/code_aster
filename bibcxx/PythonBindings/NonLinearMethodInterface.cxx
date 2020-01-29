/**
 * @file NonLinearMethodInterface.cxx
 * @brief Interface python de NonLinearMethod
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

#include "PythonBindings/NonLinearMethodInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

void exportNonLinearMethodToPython() {

    py::enum_< NonLinearMethodEnum >( "NonLinearMethodEnum" )
        .value( "NewtonMethod", NewtonMethod )
        .value( "Implex", Implex )
        .value( "NewtonKrylov", NewtonKrylov );

    py::enum_< PredictionEnum >( "PredictionEnum" )
        .value( "Tangente", Tangente )
        .value( "Elastique", Elastique )
        .value( "Extrapole", Extrapole )
        .value( "DeplCalcule", DeplCalcule );

    py::enum_< MatrixEnum >( "MatrixEnum" ).value( "MatriceTangente", MatriceTangente ).value(
        "MatriceElastique", MatriceElastique );

    py::class_< NonLinearMethodClass, NonLinearMethodPtr >( "NonLinearMethod", py::no_init )
        // fake initFactoryPtr: not a DataStructure
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< NonLinearMethodClass, NonLinearMethodEnum >))
        .def( "setPrediction", &NonLinearMethodClass::setPrediction )
        .def( "setMatrix", &NonLinearMethodClass::setMatrix )
        .def( "forceStiffnessSymetry", &NonLinearMethodClass::forceStiffnessSymetry );
};
