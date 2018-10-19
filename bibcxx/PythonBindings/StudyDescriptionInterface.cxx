/**
 * @file StudyDescriptionInterface.cxx
 * @brief Interface python de StudyDescription
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

#include <boost/python.hpp>
#include "PythonBindings/factory.h"
#include "PythonBindings/StudyDescriptionInterface.h"
#include "PythonBindings/LoadInterface.h"

void exportStudyDescriptionToPython() {
    using namespace boost::python;

    class_< StudyDescriptionInstance, StudyDescriptionPtr > c1( "StudyDescription", no_init );
    c1.def(
        "__init__",
        make_constructor(&initFactoryPtr< StudyDescriptionInstance, ModelPtr, MaterialOnMeshPtr >));
    addKinematicsLoadToInterface( c1 );
    addMechanicalLoadToInterface( c1 );
};
