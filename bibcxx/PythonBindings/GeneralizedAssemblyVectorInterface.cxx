/**
 * @file GeneralizedAssemblyVectorInterface.cxx
 * @brief Interface python de GeneralizedAssemblyVector
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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

#include "PythonBindings/GeneralizedAssemblyVectorInterface.h"
#include <boost/python.hpp>

void exportGeneralizedAssemblyVectorToPython()
{
    using namespace boost::python;

    class_< GenericGeneralizedAssemblyVectorInstance,
            GenericGeneralizedAssemblyVectorPtr,
            bases< DataStructure > > ( "GeneralizedAssemblyVector", no_init )
    ;

    class_< GeneralizedAssemblyVectorDoubleInstance,
            GeneralizedAssemblyVectorDoublePtr,
            bases< GenericGeneralizedAssemblyVectorInstance > >
            ( "GeneralizedAssemblyVectorDouble", no_init )
        .def( "create", &GeneralizedAssemblyVectorDoubleInstance::create )
        .staticmethod( "create" )
    ;

    class_< GeneralizedAssemblyVectorComplexInstance,
            GeneralizedAssemblyVectorComplexPtr,
            bases< GenericGeneralizedAssemblyVectorInstance > >
            ( "GeneralizedAssemblyVectorComplex", no_init )
        .def( "create", &GeneralizedAssemblyVectorComplexInstance::create )
        .staticmethod( "create" )
    ;
};