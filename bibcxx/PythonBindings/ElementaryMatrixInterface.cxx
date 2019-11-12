/**
 * @file ElementaryMatrixInterface.cxx
 * @brief Interface python de ElementaryMatrix
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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
#include "PythonBindings/ElementaryMatrixInterface.h"

void exportElementaryMatrixToPython() {
    using namespace boost::python;

    class_< BaseElementaryMatrixInstance, BaseElementaryMatrixPtr,
            bases< DataStructure > >( "ElementaryMatrixDisplacementDouble", no_init )
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

    class_< ElementaryMatrixDisplacementDoubleInstance,
            ElementaryMatrixDisplacementDoubleInstance::ElementaryMatrixPtr,
            bases< BaseElementaryMatrixInstance > >( "ElementaryMatrixDisplacementDouble",
                                                     no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< ElementaryMatrixDisplacementDoubleInstance >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< ElementaryMatrixDisplacementDoubleInstance,
                                                std::string >))
        .def( "update", &ElementaryMatrixDisplacementDoubleInstance::update );

    class_< ElementaryMatrixDisplacementComplexInstance,
            ElementaryMatrixDisplacementComplexInstance::ElementaryMatrixPtr,
            bases< BaseElementaryMatrixInstance > >( "ElementaryMatrixDisplacementComplex",
                                                     no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< ElementaryMatrixDisplacementComplexInstance >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< ElementaryMatrixDisplacementComplexInstance,
                                                std::string >))
        .def( "update", &ElementaryMatrixDisplacementComplexInstance::update );

    class_< ElementaryMatrixTemperatureDoubleInstance,
            ElementaryMatrixTemperatureDoubleInstance::ElementaryMatrixPtr,
            bases< BaseElementaryMatrixInstance > >( "ElementaryMatrixTemperatureDouble",
                                                     no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< ElementaryMatrixTemperatureDoubleInstance >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< ElementaryMatrixTemperatureDoubleInstance,
                                                std::string >))
        .def( "update", &ElementaryMatrixTemperatureDoubleInstance::update );

    class_< ElementaryMatrixPressureComplexInstance,
            ElementaryMatrixPressureComplexInstance::ElementaryMatrixPtr,
            bases< BaseElementaryMatrixInstance > >( "ElementaryMatrixPressureComplex",
                                                     no_init )
        .def( "__init__",
              make_constructor(&initFactoryPtr< ElementaryMatrixPressureComplexInstance >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< ElementaryMatrixPressureComplexInstance,
                                                std::string >))
        .def( "update", &ElementaryMatrixPressureComplexInstance::update );
};
