/**
 * @file NonLinearMethodInterface.cxx
 * @brief Interface python de NonLinearMethod
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

#include "PythonBindings/NonLinearMethodInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

void exportNonLinearMethodToPython() {
    using namespace boost::python;

    enum_< NonLinearMethodEnum >( "NonLinearMethodEnum" )
        .value( "NewtonMethod", NewtonMethod )
        .value( "Implex", Implex )
        .value( "NewtonKrylov", NewtonKrylov );

    enum_< PredictionEnum >( "PredictionEnum" )
        .value( "Tangente", Tangente )
        .value( "Elastique", Elastique )
        .value( "Extrapole", Extrapole )
        .value( "DeplCalcule", DeplCalcule );

    enum_< MatrixEnum >( "MatrixEnum" ).value( "MatriceTangente", MatriceTangente ).value(
        "MatriceElastique", MatriceElastique );

    class_< NonLinearMethodInstance, NonLinearMethodPtr >( "NonLinearMethod", no_init )
        // fake initFactoryPtr: not a DataStructure
        .def( "__init__",
              make_constructor(&initFactoryPtr< NonLinearMethodInstance, NonLinearMethodEnum >))
        .def( "setPrediction", &NonLinearMethodInstance::setPrediction )
        .def( "setMatrix", &NonLinearMethodInstance::setMatrix )
        .def( "forceStiffnessSymetry", &NonLinearMethodInstance::forceStiffnessSymetry );
};
