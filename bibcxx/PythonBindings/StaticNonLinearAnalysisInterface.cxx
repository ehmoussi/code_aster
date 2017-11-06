/**
 * @file StaticNonLinearAnalysisInterface.cxx
 * @brief Interface python de StaticNonLinearAnalysis
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

#include "PythonBindings/StaticNonLinearAnalysisInterface.h"
#include "PythonBindings/SharedPtrUtilities.h"
#include <boost/python.hpp>

BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS(addBehaviourOnElements_overloads,
    addBehaviourOnElements, 1, 2)

void exportStaticNonLinearAnalysisToPython()
{
    using namespace boost::python;

    void (StaticNonLinearAnalysisInstance::*c1)( const GenericMechanicalLoadPtr& ) =
            &StaticNonLinearAnalysisInstance::addStandardExcitation;

    void (StaticNonLinearAnalysisInstance::*c2)( const KinematicsLoadPtr& ) =
            &StaticNonLinearAnalysisInstance::addStandardExcitation;

    void (StaticNonLinearAnalysisInstance::*c3)( const GenericMechanicalLoadPtr&,
                                                 const FunctionPtr& scalF ) =
            &StaticNonLinearAnalysisInstance::addStandardScaledExcitation;

    void (StaticNonLinearAnalysisInstance::*c4)( const KinematicsLoadPtr&,
                                                 const FunctionPtr& scalF ) =
            &StaticNonLinearAnalysisInstance::addStandardScaledExcitation;

    class_< StaticNonLinearAnalysisInstance, StaticNonLinearAnalysisPtr >
        ( "StaticNonLinearAnalysis", no_init )
        .def( "create", &createSharedPtr< StaticNonLinearAnalysisInstance > )
        .staticmethod( "create" )
        .def( "execute", &StaticNonLinearAnalysisInstance::execute )
        .def( "addBehaviourOnElements",
              &StaticNonLinearAnalysisInstance::addBehaviourOnElements,
              addBehaviourOnElements_overloads())
        .def( "setNonLinearMethod",
              &StaticNonLinearAnalysisInstance::setNonLinearMethod )
        .def( "setLinearSolver", &StaticNonLinearAnalysisInstance::setLinearSolver )
        .def( "setInitialState", &StaticNonLinearAnalysisInstance::setInitialState )
        .def( "setLineSearchMethod",
              &StaticNonLinearAnalysisInstance::setLineSearchMethod )
        .def( "setMaterialOnMesh", &StaticNonLinearAnalysisInstance::setMaterialOnMesh )
        .def( "setLoadStepManager", &StaticNonLinearAnalysisInstance::setLoadStepManager )
        .def( "setSupportModel", &StaticNonLinearAnalysisInstance::setSupportModel )
        .def( "setDriving", &StaticNonLinearAnalysisInstance::setDriving )
        .def( "addStandardExcitation", c1 )
        .def( "addStandardExcitation", c2 )
        .def( "addStandardScaledExcitation", c3 )
        .def( "addStandardScaledExcitation", c4 )
        .def( "addDrivenExcitation",
              &StaticNonLinearAnalysisInstance::addDrivenExcitation )
        .def( "addExcitationOnUpdatedGeometry",
              &StaticNonLinearAnalysisInstance::addExcitationOnUpdatedGeometry )
        .def( "addScaledExcitationOnUpdatedGeometry",
              &StaticNonLinearAnalysisInstance::addScaledExcitationOnUpdatedGeometry )
        .def( "addIncrementalDirichletExcitation",
              &StaticNonLinearAnalysisInstance::addIncrementalDirichletExcitation )
        .def( "addIncrementalDirichletScaledExcitation",
              &StaticNonLinearAnalysisInstance::addIncrementalDirichletScaledExcitation )
    ;
};