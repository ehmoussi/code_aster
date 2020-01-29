/**
 * @file StaticNonLinearAnalysisInterface.cxx
 * @brief Interface python de StaticNonLinearAnalysis
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

#include "PythonBindings/StaticNonLinearAnalysisInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( addBehaviourOnElements_overloads, addBehaviourOnElements, 1,
                                        2 )

void exportStaticNonLinearAnalysisToPython() {

    void ( StaticNonLinearAnalysisClass::*c1 )( const GenericMechanicalLoadPtr & ) =
        &StaticNonLinearAnalysisClass::addStandardExcitation;

    void ( StaticNonLinearAnalysisClass::*c2 )( const KinematicsLoadPtr & ) =
        &StaticNonLinearAnalysisClass::addStandardExcitation;

    void ( StaticNonLinearAnalysisClass::*c3 )( const GenericMechanicalLoadPtr &,
                                                   const FunctionPtr &scalF ) =
        &StaticNonLinearAnalysisClass::addStandardScaledExcitation;

    void ( StaticNonLinearAnalysisClass::*c4 )( const KinematicsLoadPtr &,
                                                   const FunctionPtr &scalF ) =
        &StaticNonLinearAnalysisClass::addStandardScaledExcitation;

    py::class_< StaticNonLinearAnalysisClass, StaticNonLinearAnalysisPtr >(
        "StaticNonLinearAnalysis", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< StaticNonLinearAnalysisClass >))
        // fake initFactoryPtr: not a DataStructure
        .def( "execute", &StaticNonLinearAnalysisClass::execute )
        .def( "addBehaviourOnElements", &StaticNonLinearAnalysisClass::addBehaviourOnElements,
              addBehaviourOnElements_overloads() )
        .def( "setNonLinearMethod", &StaticNonLinearAnalysisClass::setNonLinearMethod )
        .def( "setLinearSolver", &StaticNonLinearAnalysisClass::setLinearSolver )
        .def( "setInitialState", &StaticNonLinearAnalysisClass::setInitialState )
        .def( "setLineSearchMethod", &StaticNonLinearAnalysisClass::setLineSearchMethod )
        .def( "setMaterialOnMesh", &StaticNonLinearAnalysisClass::setMaterialOnMesh )
        .def( "setLoadStepManager", &StaticNonLinearAnalysisClass::setLoadStepManager )
        .def( "setModel", &StaticNonLinearAnalysisClass::setModel )
        .def( "setDriving", &StaticNonLinearAnalysisClass::setDriving )
        .def( "addStandardExcitation", c1 )
        .def( "addStandardExcitation", c2 )
        .def( "addStandardScaledExcitation", c3 )
        .def( "addStandardScaledExcitation", c4 )
        .def( "addDrivenExcitation", &StaticNonLinearAnalysisClass::addDrivenExcitation )
        .def( "addExcitationOnUpdatedGeometry",
              &StaticNonLinearAnalysisClass::addExcitationOnUpdatedGeometry )
        .def( "addScaledExcitationOnUpdatedGeometry",
              &StaticNonLinearAnalysisClass::addScaledExcitationOnUpdatedGeometry )
        .def( "addIncrementalDirichletExcitation",
              &StaticNonLinearAnalysisClass::addIncrementalDirichletExcitation )
        .def( "addIncrementalDirichletScaledExcitation",
              &StaticNonLinearAnalysisClass::addIncrementalDirichletScaledExcitation );
};
