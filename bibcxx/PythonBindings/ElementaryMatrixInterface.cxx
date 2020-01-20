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

    py::class_< BaseElementaryMatrixInstance, BaseElementaryMatrixPtr,
            py::bases< DataStructure > >( "ElementaryMatrixDisplacementDouble", py::no_init )
    // fake initFactoryPtr: not buildable
    // fake initFactoryPtr: not buildable
        .def( "addFiniteElementDescriptor",
              &ElementaryMatrixDisplacementDoubleInstance::addFiniteElementDescriptor )
        .def( "getFiniteElementDescriptors",
              &ElementaryMatrixDisplacementDoubleInstance::getFiniteElementDescriptors )
        .def( "getMaterialOnMesh", &ElementaryMatrixDisplacementDoubleInstance::getMaterialOnMesh )
        .def( "getModel", &ElementaryMatrixDisplacementDoubleInstance::getModel )
        .def( "setMaterialOnMesh", &ElementaryMatrixDisplacementDoubleInstance::setMaterialOnMesh )
        .def( "setModel", &ElementaryMatrixDisplacementDoubleInstance::setModel );

    py::class_< ElementaryMatrixDisplacementDoubleInstance,
            ElementaryMatrixDisplacementDoubleInstance::ElementaryMatrixPtr,
            py::bases< BaseElementaryMatrixInstance > >( "ElementaryMatrixDisplacementDouble",
                                                     py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryMatrixDisplacementDoubleInstance >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryMatrixDisplacementDoubleInstance,
                                                std::string >))
        .def( "update", &ElementaryMatrixDisplacementDoubleInstance::update );

    py::class_< ElementaryMatrixDisplacementComplexInstance,
            ElementaryMatrixDisplacementComplexInstance::ElementaryMatrixPtr,
            py::bases< BaseElementaryMatrixInstance > >( "ElementaryMatrixDisplacementComplex",
                                                     py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryMatrixDisplacementComplexInstance >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryMatrixDisplacementComplexInstance,
                                                std::string >))
        .def( "update", &ElementaryMatrixDisplacementComplexInstance::update );

    py::class_< ElementaryMatrixTemperatureDoubleInstance,
            ElementaryMatrixTemperatureDoubleInstance::ElementaryMatrixPtr,
            py::bases< BaseElementaryMatrixInstance > >( "ElementaryMatrixTemperatureDouble",
                                                     py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryMatrixTemperatureDoubleInstance >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryMatrixTemperatureDoubleInstance,
                                                std::string >))
        .def( "update", &ElementaryMatrixTemperatureDoubleInstance::update );

    py::class_< ElementaryMatrixPressureComplexInstance,
            ElementaryMatrixPressureComplexInstance::ElementaryMatrixPtr,
            py::bases< BaseElementaryMatrixInstance > >( "ElementaryMatrixPressureComplex",
                                                     py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryMatrixPressureComplexInstance >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ElementaryMatrixPressureComplexInstance,
                                                std::string >))
        .def( "update", &ElementaryMatrixPressureComplexInstance::update );
};
