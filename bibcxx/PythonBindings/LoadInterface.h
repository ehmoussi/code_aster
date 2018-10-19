#ifndef LOADINTERFACE_H_
#define LOADINTERFACE_H_

/**
 * @file LoadInterface.h
 * @brief Fichier entete de la classe LoadInterface
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

#include "astercxx.h"

#include <boost/python.hpp>
#include "Loads/KinematicsLoad.h"
#include "Loads/MechanicalLoad.h"
#include "Loads/ParallelMechanicalLoad.h"

template < class firstClass, typename... Args >
void addKinematicsLoadToInterface( boost::python::class_< firstClass, Args... > myInstance ) {
    typedef firstClass myClass;

    void ( myClass::*c1 )( const KinematicsLoadPtr & ) = &myClass::addLoad;
    void ( myClass::*c2 )( const KinematicsLoadPtr &currentLoad, const FunctionPtr &func ) =
        &myClass::addLoad;
    void ( myClass::*c3 )( const KinematicsLoadPtr &currentLoad, const FormulaPtr &func ) =
        &myClass::addLoad;
    void ( myClass::*c4 )( const KinematicsLoadPtr &currentLoad, const SurfacePtr &func ) =
        &myClass::addLoad;

    myInstance.def( "addKinematicsLoad", c1 );
    myInstance.def( "addKinematicsLoad", c2 );
    myInstance.def( "addKinematicsLoad", c3 );
    myInstance.def( "addKinematicsLoad", c4 );
};

template < class firstClass, typename... Args >
void addMechanicalLoadToInterface( boost::python::class_< firstClass, Args... > myInstance ) {
    typedef firstClass myClass;

    void ( myClass::*c5 )( const GenericMechanicalLoadPtr & ) = &myClass::addLoad;
    void ( myClass::*c6 )( const GenericMechanicalLoadPtr &currentLoad, const FunctionPtr &func ) =
        &myClass::addLoad;
    void ( myClass::*c7 )( const GenericMechanicalLoadPtr &currentLoad, const FormulaPtr &func ) =
        &myClass::addLoad;
    void ( myClass::*c8 )( const GenericMechanicalLoadPtr &currentLoad, const SurfacePtr &func ) =
        &myClass::addLoad;

    myInstance.def( "addMechanicalLoad", c5 );
    myInstance.def( "addMechanicalLoad", c6 );
    myInstance.def( "addMechanicalLoad", c7 );
    myInstance.def( "addMechanicalLoad", c8 );
};

#ifdef _USE_MPI
template < class firstClass, typename... Args >
void
addParallelMechanicalLoadToInterface( boost::python::class_< firstClass, Args... > myInstance ) {
    typedef firstClass myClass;

    void ( myClass::*c5 )( const ParallelMechanicalLoadPtr & ) = &myClass::addLoad;
    void ( myClass::*c6 )( const ParallelMechanicalLoadPtr &currentLoad, const FunctionPtr &func ) =
        &myClass::addLoad;
    void ( myClass::*c7 )( const ParallelMechanicalLoadPtr &currentLoad, const FormulaPtr &func ) =
        &myClass::addLoad;
    void ( myClass::*c8 )( const ParallelMechanicalLoadPtr &currentLoad, const SurfacePtr &func ) =
        &myClass::addLoad;

    myInstance.def( "addParallelMechanicalLoad", c5 );
    myInstance.def( "addParallelMechanicalLoad", c6 );
    myInstance.def( "addParallelMechanicalLoad", c7 );
    myInstance.def( "addParallelMechanicalLoad", c8 );
};
#endif /* _USE_MPI */

#endif /* LOADINTERFACE_H_ */
