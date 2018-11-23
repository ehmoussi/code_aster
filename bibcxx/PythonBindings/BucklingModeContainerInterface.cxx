/**
 * @file BucklingModeContainerInterface.cxx
 * @brief Interface python de BucklingModeContainer
 * @author Natacha Béreux
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

#include "PythonBindings/BucklingModeContainerInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>
#include "PythonBindings/VariantStiffnessMatrixInterface.h"

void exportBucklingModeContainerToPython() {
    using namespace boost::python;

    bool ( BucklingModeContainerInstance::*c1 )( const AssemblyMatrixDisplacementDoublePtr & ) =
        &BucklingModeContainerInstance::setStiffnessMatrix;
    bool ( BucklingModeContainerInstance::*c2 )( const AssemblyMatrixTemperatureDoublePtr & ) =
        &BucklingModeContainerInstance::setStiffnessMatrix;
    bool ( BucklingModeContainerInstance::*c3 )( const AssemblyMatrixDisplacementComplexPtr & ) =
        &BucklingModeContainerInstance::setStiffnessMatrix;
    bool ( BucklingModeContainerInstance::*c4 )( const AssemblyMatrixPressureDoublePtr & ) =
        &BucklingModeContainerInstance::setStiffnessMatrix;

    class_< BucklingModeContainerInstance, BucklingModeContainerPtr,
            bases< FullResultsContainerInstance > >( "BucklingModeContainer", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< BucklingModeContainerInstance >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< BucklingModeContainerInstance, std::string >))
        .def( "getStiffnessMatrix", &getStiffnessMatrix< BucklingModeContainerPtr > )
        .def( "setStiffnessMatrix", c1 )
        .def( "setStiffnessMatrix", c2 )
        .def( "setStiffnessMatrix", c3 )
        .def( "setStiffnessMatrix", c4 );
};
