/**
 * @file DOFNumberingInterface.cxx
 * @brief Interface python de DOFNumbering
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

#include <boost/python.hpp>
#include <PythonBindings/factory.h>
#include "PythonBindings/DOFNumberingInterface.h"


void exportDOFNumberingToPython()
{
    using namespace boost::python;

    class_< BaseDOFNumberingInstance, BaseDOFNumberingInstance::BaseDOFNumberingPtr,
            bases< DataStructure > > ( "BaseDOFNumbering", no_init )
        .def( "addKinematicsLoad", &BaseDOFNumberingInstance::addKinematicsLoad )
        .def( "addMechanicalLoad", &BaseDOFNumberingInstance::addMechanicalLoad )
        .def( "computeNumerotation", &BaseDOFNumberingInstance::computeNumerotation )
        .def( "isParallel", &BaseDOFNumberingInstance::isParallel )
        .def( "setElementaryMatrix", &BaseDOFNumberingInstance::setElementaryMatrix )
    ;

    class_< DOFNumberingInstance, DOFNumberingInstance::DOFNumberingPtr,
            bases< BaseDOFNumberingInstance > > ( "DOFNumbering", no_init )
        .def( "__init__", make_constructor(
            factory0< DOFNumberingInstance,
                      DOFNumberingInstance::DOFNumberingPtr >) )
        .def( "__init__", make_constructor(
            factory0Str< DOFNumberingInstance,
                          DOFNumberingInstance::DOFNumberingPtr >) )
        .def( "setSupportModel", &DOFNumberingInstance::setSupportModel )
    ;
};
