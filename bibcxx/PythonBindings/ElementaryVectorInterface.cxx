/**
 * @file ElementaryVectorInterface.cxx
 * @brief Interface python de ElementaryVector
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <boost/python.hpp>

namespace py = boost::python;
#include <PythonBindings/factory.h>
#include "PythonBindings/ElementaryVectorInterface.h"

void exportElementaryVectorToPython() {

    FieldOnNodesRealPtr ( ElementaryVectorClass::*c1 )( const DOFNumberingPtr & ) =
        &ElementaryVectorClass::assembleVector;
#ifdef _USE_MPI
    FieldOnNodesRealPtr ( ElementaryVectorClass::*c2 )( const ParallelDOFNumberingPtr & ) =
        &ElementaryVectorClass::assembleVector;
#endif /* _USE_MPI */

    void ( ElementaryVectorClass::*c3 )( const GenericMechanicalLoadPtr & ) =
        &ElementaryVectorClass::addLoad;

    py::class_< ElementaryVectorClass, ElementaryVectorClass::ElementaryVectorPtr,
            py::bases< DataStructure > >( "ElementaryVector", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ElementaryVectorClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryVectorClass, std::string >))
        .def( "addMechanicalLoad", c3 )
        .def( "assembleVector", c1 )
        .def( "setType", &ElementaryVectorClass::setType )
#ifdef _USE_MPI
        .def( "assembleVector", c2 )
#endif /* _USE_MPI */
        .def( "setListOfLoads", &ElementaryVectorClass::setListOfLoads )
        .def( "update", &ElementaryVectorClass::update );

    py::class_< ElementaryVectorDisplacementRealClass,
            ElementaryVectorDisplacementRealPtr, py::bases< ElementaryVectorClass > >
            ( "ElementaryVectorDisplacementReal", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryVectorDisplacementRealClass > ) )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryVectorDisplacementRealClass,
                                                std::string >));

    py::class_< ElementaryVectorTemperatureRealClass,
            ElementaryVectorTemperatureRealPtr, py::bases< ElementaryVectorClass > >
            ( "ElementaryVectorTemperatureReal", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryVectorTemperatureRealClass > ) )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryVectorTemperatureRealClass,
                                                std::string >));

    py::class_< ElementaryVectorPressureComplexClass,
            ElementaryVectorPressureComplexPtr, py::bases< ElementaryVectorClass > >
            ( "ElementaryVectorPressureComplex", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryVectorPressureComplexClass > ) )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryVectorPressureComplexClass,
                                                std::string >));
};
