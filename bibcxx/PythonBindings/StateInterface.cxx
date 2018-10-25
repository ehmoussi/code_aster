/**
 * @file StateInterface.cxx
 * @brief Interface python de State
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

#include "PythonBindings/StateInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

void exportStateToPython() {
    using namespace boost::python;

    void ( StateInstance::*c1 )( const NonLinearEvolutionContainerPtr &, double, double ) =
        &StateInstance::setFromNonLinearEvolution;
    void ( StateInstance::*c3 )( const NonLinearEvolutionContainerPtr &, ASTERINTEGER ) =
        &StateInstance::setFromNonLinearEvolution;
    void ( StateInstance::*c4 )( const NonLinearEvolutionContainerPtr & ) =
        &StateInstance::setFromNonLinearEvolution;

    class_< StateInstance, StatePtr >( "State", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< StateInstance, ASTERINTEGER, double >))
        .def( "__init__", make_constructor(&initFactoryPtr< StateInstance, ASTERINTEGER >))
        .def( "__init__", make_constructor(&initFactoryPtr< StateInstance, double >))
        .def( "setFromNonLinearEvolution", c1 )
        .def( "setFromNonLinearEvolution", c3 )
        .def( "setFromNonLinearEvolution", c4 )
        .def( "setCurrentStep", &StateInstance::setCurrentStep )
        .def( "setDisplacement", &StateInstance::setDisplacement );
};
