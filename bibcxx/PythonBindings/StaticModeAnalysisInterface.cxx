/**
 * @file StaticModeAnalysisInterface.cxx
 * @brief Interface python de StaticModeAnalysis
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

#include "PythonBindings/StaticModeAnalysisInterface.h"
#include "PythonBindings/SharedPtrUtilities.h"
#include <boost/python.hpp>

void exportStaticModeAnalysisToPython()
{
    using namespace boost::python;

    class_< StaticModeDeplInstance, StaticModeDeplPtr >
        ( "StaticModeDepl", no_init )
        .def( "create", &createSharedPtr< StaticModeDeplInstance > )
        .staticmethod( "create" )
        .def( "setMassMatrix", &StaticModeDeplInstance::setMassMatrix )
        .def( "setStiffMatrix", &StaticModeDeplInstance::setStiffMatrix )
        .def( "setLinearSolver", &StaticModeDeplInstance::setLinearSolver )
        .def( "setAllLoc", &StaticModeDeplInstance::setAllLoc )
        .def( "setAllCmp", &StaticModeDeplInstance::setAllCmp )
        .def( "WantedGrno", &StaticModeDeplInstance::WantedGrno )
        .def( "Unwantedcmp", &StaticModeDeplInstance::Unwantedcmp )
        .def( "Wantedcmp", &StaticModeDeplInstance::Wantedcmp )
        .def( "execute", &StaticModeDeplInstance::execute )
    ;

    class_< StaticModeForcInstance, StaticModeForcPtr >
        ( "StaticModeForc", no_init )
        .def( "create", &createSharedPtr< StaticModeForcInstance > )
        .staticmethod( "create" )
        .def( "setMassMatrix", &StaticModeForcInstance::setMassMatrix )
        .def( "setStiffMatrix", &StaticModeForcInstance::setStiffMatrix )
        .def( "setLinearSolver", &StaticModeForcInstance::setLinearSolver )
        .def( "setAllLoc", &StaticModeForcInstance::setAllLoc )
        .def( "setAllCmp", &StaticModeForcInstance::setAllCmp )
        .def( "WantedGrno", &StaticModeForcInstance::WantedGrno )
        .def( "Unwantedcmp", &StaticModeForcInstance::Unwantedcmp )
        .def( "Wantedcmp", &StaticModeForcInstance::Wantedcmp )
        .def( "execute", &StaticModeForcInstance::execute )
    ;

    class_< StaticModePseudoInstance, StaticModePseudoPtr >
        ( "StaticModePseudo", no_init )
        .def( "create", &createSharedPtr< StaticModePseudoInstance > )
        .staticmethod( "create" )
        .def( "setMassMatrix", &StaticModePseudoInstance::setMassMatrix )
        .def( "setStiffMatrix", &StaticModePseudoInstance::setStiffMatrix )
        .def( "setLinearSolver", &StaticModePseudoInstance::setLinearSolver )
        .def( "setAllLoc", &StaticModePseudoInstance::setAllLoc )
        .def( "setAllCmp", &StaticModePseudoInstance::setAllCmp )
        .def( "WantedGrno", &StaticModePseudoInstance::WantedGrno )
        .def( "WantedDir", &StaticModePseudoInstance::WantedDir )
        .def( "setDirname", &StaticModePseudoInstance::setDirname )
        .def( "WantedAxe", &StaticModePseudoInstance::WantedAxe )
        .def( "Unwantedcmp", &StaticModePseudoInstance::Unwantedcmp )
        .def( "Wantedcmp", &StaticModePseudoInstance::Wantedcmp )
        .def( "execute", &StaticModePseudoInstance::execute )
    ;

    class_< StaticModeInterfInstance, StaticModeInterfPtr >
        ( "StaticModeInterf", no_init )
        .def( "create", &createSharedPtr< StaticModeInterfInstance > )
        .staticmethod( "create" )
        .def( "setMassMatrix", &StaticModeInterfInstance::setMassMatrix )
        .def( "setStiffMatrix", &StaticModeInterfInstance::setStiffMatrix )
        .def( "setLinearSolver", &StaticModeInterfInstance::setLinearSolver )
        .def( "setAllLoc", &StaticModeInterfInstance::setAllLoc )
        .def( "setAllCmp", &StaticModeInterfInstance::setAllCmp )
        .def( "WantedGrno", &StaticModeInterfInstance::WantedGrno )
        .def( "Unwantedcmp", &StaticModeInterfInstance::Unwantedcmp )
        .def( "Wantedcmp", &StaticModeInterfInstance::Wantedcmp )
        .def( "setNbmod", &StaticModeInterfInstance::setNbmod )
        .def( "setShift", &StaticModeInterfInstance::setShift )
        .def( "execute", &StaticModeInterfInstance::execute )
    ;
};
