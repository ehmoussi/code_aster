/**
 * @file GeneralizedAssemblyMatrixInterface.cxx
 * @brief Interface python de GeneralizedAssemblyMatrix
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "PythonBindings/GeneralizedAssemblyMatrixInterface.h"
#include "Discretization/GeneralizedDOFNumbering.h"
#include <PythonBindings/factory.h>
#include <boost/python.hpp>

void exportGeneralizedAssemblyMatrixToPython() {
    using namespace boost::python;

    class_< GenericGeneralizedAssemblyMatrixInstance, GenericGeneralizedAssemblyMatrixPtr,
            bases< DataStructure > >( "GeneralizedAssemblyMatrix", no_init )
        // fake initFactoryPtr: created by subclasses
        // fake initFactoryPtr: created by subclasses
        .def( "getGeneralizedDOFNumbering",
              &GenericGeneralizedAssemblyMatrixInstance::getGeneralizedDOFNumbering )
        .def( "setGeneralizedDOFNumbering",
              &GenericGeneralizedAssemblyMatrixInstance::setGeneralizedDOFNumbering );

    class_< GeneralizedAssemblyMatrixDoubleInstance, GeneralizedAssemblyMatrixDoublePtr,
            bases< GenericGeneralizedAssemblyMatrixInstance > >( "GeneralizedAssemblyMatrixDouble",
                                                                 no_init )
        .def( "__init__",
              make_constructor( &initFactoryPtr< GeneralizedAssemblyMatrixDoubleInstance > ) )
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< GeneralizedAssemblyMatrixDoubleInstance, std::string > ) );

    class_< GeneralizedAssemblyMatrixComplexInstance, GeneralizedAssemblyMatrixComplexPtr,
            bases< GenericGeneralizedAssemblyMatrixInstance > >( "GeneralizedAssemblyMatrixComplex",
                                                                 no_init )
        .def( "__init__",
              make_constructor( &initFactoryPtr< GeneralizedAssemblyMatrixComplexInstance > ) )
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< GeneralizedAssemblyMatrixComplexInstance, std::string > ) );
};
