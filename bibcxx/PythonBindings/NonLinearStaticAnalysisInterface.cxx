/**
 * @file NonLinearStaticAnalysisInterface.cxx
 * @brief Interface python de NonLinearStaticAnalysis
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

#include "PythonBindings/NonLinearStaticAnalysisInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS( addBehaviourOnCells_overloads, addBehaviourOnCells, 1,
                                        2 )

void exportNonLinearStaticAnalysisToPython() {

    void ( NonLinearStaticAnalysisClass::*c1 )( const GenericMechanicalLoadPtr & ) =
        &NonLinearStaticAnalysisClass::addStandardExcitation;

    void ( NonLinearStaticAnalysisClass::*c2 )( const KinematicsLoadPtr & ) =
        &NonLinearStaticAnalysisClass::addStandardExcitation;

    void ( NonLinearStaticAnalysisClass::*c3 )( const GenericMechanicalLoadPtr &,
                                                   const FunctionPtr &scalF ) =
        &NonLinearStaticAnalysisClass::addStandardScaledExcitation;

    void ( NonLinearStaticAnalysisClass::*c4 )( const KinematicsLoadPtr &,
                                                   const FunctionPtr &scalF ) =
        &NonLinearStaticAnalysisClass::addStandardScaledExcitation;

    py::class_< NonLinearStaticAnalysisClass, NonLinearStaticAnalysisPtr >(
        "NonLinearStaticAnalysis", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< NonLinearStaticAnalysisClass >))
        // fake initFactoryPtr: not a DataStructure
        .def( "execute", &NonLinearStaticAnalysisClass::execute )
        .def( "addBehaviourOnCells", &NonLinearStaticAnalysisClass::addBehaviourOnCells,
              addBehaviourOnCells_overloads() )
        .def( "setNonLinearMethod", &NonLinearStaticAnalysisClass::setNonLinearMethod )
        .def( "setLinearSolver", &NonLinearStaticAnalysisClass::setLinearSolver )
        .def( "setInitialState", &NonLinearStaticAnalysisClass::setInitialState )
        .def( "setLineSearchMethod", &NonLinearStaticAnalysisClass::setLineSearchMethod )
        .def( "setMaterialField", &NonLinearStaticAnalysisClass::setMaterialField )
        .def( "setLoadStepManager", &NonLinearStaticAnalysisClass::setLoadStepManager )
        .def( "setModel", &NonLinearStaticAnalysisClass::setModel )
        .def( "setDriving", &NonLinearStaticAnalysisClass::setDriving )
        .def( "addStandardExcitation", c1 )
        .def( "addStandardExcitation", c2 )
        .def( "addStandardScaledExcitation", c3 )
        .def( "addStandardScaledExcitation", c4 )
        .def( "addDrivenExcitation", &NonLinearStaticAnalysisClass::addDrivenExcitation )
        .def( "addExcitationOnUpdatedGeometry",
              &NonLinearStaticAnalysisClass::addExcitationOnUpdatedGeometry )
        .def( "addScaledExcitationOnUpdatedGeometry",
              &NonLinearStaticAnalysisClass::addScaledExcitationOnUpdatedGeometry )
        .def( "addIncrementalDirichletExcitation",
              &NonLinearStaticAnalysisClass::addIncrementalDirichletExcitation )
        .def( "addIncrementalDirichletScaledExcitation",
              &NonLinearStaticAnalysisClass::addIncrementalDirichletScaledExcitation );
};
