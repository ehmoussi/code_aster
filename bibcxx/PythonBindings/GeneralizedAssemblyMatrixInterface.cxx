/**
 * @file GeneralizedAssemblyMatrixInterface.cxx
 * @brief Interface python de GeneralizedAssemblyMatrix
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

#include "PythonBindings/GeneralizedAssemblyMatrixInterface.h"
#include "Discretization/GeneralizedDOFNumbering.h"
#include "PythonBindings/VariantModalBasisInterface.h"
#include <PythonBindings/factory.h>
#include <boost/python.hpp>

namespace py = boost::python;

void exportGeneralizedAssemblyMatrixToPython() {

    bool ( GenericGeneralizedAssemblyMatrixClass::*c1 )( const MechanicalModeContainerPtr & ) =
        &GenericGeneralizedAssemblyMatrixClass::setModalBasis;
    bool ( GenericGeneralizedAssemblyMatrixClass::*c2 )( const GeneralizedModeContainerPtr & ) =
        &GenericGeneralizedAssemblyMatrixClass::setModalBasis;

    py::class_< GenericGeneralizedAssemblyMatrixClass, GenericGeneralizedAssemblyMatrixPtr,
                py::bases< DataStructure > >( "GeneralizedAssemblyMatrix", py::no_init )
        // fake initFactoryPtr: created by subclasses
        // fake initFactoryPtr: created by subclasses
        .def( "getGeneralizedDOFNumbering",
              &GenericGeneralizedAssemblyMatrixClass::getGeneralizedDOFNumbering )
        .def("getModalBasis", &getModalBasis< GenericGeneralizedAssemblyMatrixPtr >)
        .def( "setGeneralizedDOFNumbering",
              &GenericGeneralizedAssemblyMatrixClass::setGeneralizedDOFNumbering )
        .def( "setModalBasis", c1 )
        .def( "setModalBasis", c2 );

    py::class_< GeneralizedAssemblyMatrixDoubleClass, GeneralizedAssemblyMatrixDoublePtr,
                py::bases< GenericGeneralizedAssemblyMatrixClass > >(
        "GeneralizedAssemblyMatrixDouble", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< GeneralizedAssemblyMatrixDoubleClass >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< GeneralizedAssemblyMatrixDoubleClass, std::string >));

    py::class_< GeneralizedAssemblyMatrixComplexClass, GeneralizedAssemblyMatrixComplexPtr,
                py::bases< GenericGeneralizedAssemblyMatrixClass > >(
        "GeneralizedAssemblyMatrixComplex", py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< GeneralizedAssemblyMatrixComplexClass >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< GeneralizedAssemblyMatrixComplexClass, std::string >));
};
