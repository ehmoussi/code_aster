/**
 * @file GeneralizedAssemblyMatrixInterface.cxx
 * @brief Interface python de GeneralizedAssemblyMatrix
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "PythonBindings/GeneralizedAssemblyMatrixInterface.h"
#include "Discretization/GeneralizedDOFNumbering.h"
#include "PythonBindings/VariantModalBasisInterface.h"
#include <PythonBindings/factory.h>
#include <boost/python.hpp>

namespace py = boost::python;

void exportGeneralizedAssemblyMatrixToPython() {

    bool ( GenericGeneralizedAssemblyMatrixInstance::*c1 )( const MechanicalModeContainerPtr& ) =
        &GenericGeneralizedAssemblyMatrixInstance::setModalBasis;
    bool ( GenericGeneralizedAssemblyMatrixInstance::*c2 )( const GeneralizedModeContainerPtr& ) =
        &GenericGeneralizedAssemblyMatrixInstance::setModalBasis;

    py::class_< GenericGeneralizedAssemblyMatrixInstance, GenericGeneralizedAssemblyMatrixPtr,
            py::bases< DataStructure > >( "GeneralizedAssemblyMatrix", py::no_init )
        // fake initFactoryPtr: created by subclasses
        // fake initFactoryPtr: created by subclasses
        .def( "getGeneralizedDOFNumbering",
              &GenericGeneralizedAssemblyMatrixInstance::getGeneralizedDOFNumbering )
        .def( "getModalBasis", &getModalBasis< GenericGeneralizedAssemblyMatrixPtr > )
        .def( "setGeneralizedDOFNumbering",
              &GenericGeneralizedAssemblyMatrixInstance::setGeneralizedDOFNumbering )
        .def( "setModalBasis", c1 )
        .def( "setModalBasis", c2 );

    py::class_< GeneralizedAssemblyMatrixDoubleInstance, GeneralizedAssemblyMatrixDoublePtr,
            py::bases< GenericGeneralizedAssemblyMatrixInstance > >( "GeneralizedAssemblyMatrixDouble",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor( &initFactoryPtr< GeneralizedAssemblyMatrixDoubleInstance > ) )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< GeneralizedAssemblyMatrixDoubleInstance, std::string > ) );

    py::class_< GeneralizedAssemblyMatrixComplexInstance, GeneralizedAssemblyMatrixComplexPtr,
            py::bases< GenericGeneralizedAssemblyMatrixInstance > >( "GeneralizedAssemblyMatrixComplex",
                                                                 py::no_init )
        .def( "__init__",
              py::make_constructor( &initFactoryPtr< GeneralizedAssemblyMatrixComplexInstance > ) )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< GeneralizedAssemblyMatrixComplexInstance, std::string > ) );
};
