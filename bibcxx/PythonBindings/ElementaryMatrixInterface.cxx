/**
 * @file ElementaryMatrixInterface.cxx
 * @brief Interface python de ElementaryMatrix
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
#include "PythonBindings/ElementaryMatrixInterface.h"

void exportElementaryMatrixToPython() {

    py::class_< BaseElementaryMatrixClass, BaseElementaryMatrixPtr,
            py::bases< DataStructure > >( "ElementaryMatrixDisplacementReal", py::no_init )
    // fake initFactoryPtr: not buildable
    // fake initFactoryPtr: not buildable
        .def( "addFiniteElementDescriptor",
              &ElementaryMatrixDisplacementRealClass::addFiniteElementDescriptor )
        .def( "getFiniteElementDescriptors",
              &ElementaryMatrixDisplacementRealClass::getFiniteElementDescriptors )
        .def( "getMaterialField", &ElementaryMatrixDisplacementRealClass::getMaterialField )
        .def( "getModel", &ElementaryMatrixDisplacementRealClass::getModel )
        .def( "setMaterialField", &ElementaryMatrixDisplacementRealClass::setMaterialField )
        .def( "setModel", &ElementaryMatrixDisplacementRealClass::setModel );

    py::class_< ElementaryMatrixDisplacementRealClass,
            ElementaryMatrixDisplacementRealClass::ElementaryMatrixPtr,
            py::bases< BaseElementaryMatrixClass > >( "ElementaryMatrixDisplacementReal",
                                                     py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryMatrixDisplacementRealClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryMatrixDisplacementRealClass,
                                                std::string >))
        .def( "update", &ElementaryMatrixDisplacementRealClass::update );

    py::class_< ElementaryMatrixDisplacementComplexClass,
            ElementaryMatrixDisplacementComplexClass::ElementaryMatrixPtr,
            py::bases< BaseElementaryMatrixClass > >( "ElementaryMatrixDisplacementComplex",
                                                     py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryMatrixDisplacementComplexClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryMatrixDisplacementComplexClass,
                                                std::string >))
        .def( "update", &ElementaryMatrixDisplacementComplexClass::update );

    py::class_< ElementaryMatrixTemperatureRealClass,
            ElementaryMatrixTemperatureRealClass::ElementaryMatrixPtr,
            py::bases< BaseElementaryMatrixClass > >( "ElementaryMatrixTemperatureReal",
                                                     py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryMatrixTemperatureRealClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryMatrixTemperatureRealClass,
                                                std::string >))
        .def( "update", &ElementaryMatrixTemperatureRealClass::update );

    py::class_< ElementaryMatrixPressureComplexClass,
            ElementaryMatrixPressureComplexClass::ElementaryMatrixPtr,
            py::bases< BaseElementaryMatrixClass > >( "ElementaryMatrixPressureComplex",
                                                     py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryMatrixPressureComplexClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryMatrixPressureComplexClass,
                                                std::string >))
        .def( "update", &ElementaryMatrixPressureComplexClass::update );
};
