/**
 * @file MaterialOnMeshInterface.cxx
 * @brief Interface python de MaterialOnMesh
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

#include "PythonBindings/MaterialOnMeshInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

void exportMaterialOnMeshToPython()
{
    using namespace boost::python;

    class_< MaterialOnMeshInstance, MaterialOnMeshInstance::MaterialOnMeshPtr,
            bases< DataStructure > > c1( "MaterialOnMesh", no_init );
    c1.def( "__init__", make_constructor(
            &initFactoryPtr< MaterialOnMeshInstance,
                             const MeshPtr& > ) );
    c1.def( "__init__", make_constructor(
            &initFactoryPtr< MaterialOnMeshInstance,
                             const SkeletonPtr& > ) );
    c1.def( "__init__", make_constructor(
            &initFactoryPtr< MaterialOnMeshInstance,
                             const std::string&,
                             const MeshPtr& > ) );
#ifdef _USE_MPI
    c1.def( "__init__", make_constructor(
            &initFactoryPtr< MaterialOnMeshInstance,
                             const ParallelMeshPtr& > ) );
    c1.def( "__init__", make_constructor(
            &initFactoryPtr< MaterialOnMeshInstance,
                             const std::string&,
                             const ParallelMeshPtr& > ) );
#endif /* _USE_MPI */
    c1.def( "addBehaviourOnAllMesh", &MaterialOnMeshInstance::addBehaviourOnAllMesh );
    c1.def( "addBehaviourOnGroupOfElements",
              &MaterialOnMeshInstance::addBehaviourOnGroupOfElements );

    c1.def( "addInputVariableOnAllMesh",
            &MaterialOnMeshInstance::addInputVariableOnAllMesh< TemperatureInputVariablePtr > );
    c1.def( "addInputVariableOnGroupOfElements",
       &MaterialOnMeshInstance::addInputVariableOnGroupOfElements< TemperatureInputVariablePtr > );
    c1.def( "addInputVariableOnAllMesh",
            &MaterialOnMeshInstance::addInputVariableOnAllMesh< GeometryInputVariablePtr > );
    c1.def( "addInputVariableOnGroupOfElements",
       &MaterialOnMeshInstance::addInputVariableOnGroupOfElements< GeometryInputVariablePtr > );
    c1.def( "addInputVariableOnAllMesh",
            &MaterialOnMeshInstance::addInputVariableOnAllMesh< CorrosionInputVariablePtr > );
    c1.def( "addInputVariableOnGroupOfElements",
       &MaterialOnMeshInstance::addInputVariableOnGroupOfElements< CorrosionInputVariablePtr > );
    c1.def( "addInputVariableOnAllMesh",
        &MaterialOnMeshInstance::addInputVariableOnAllMesh< IrreversibleDeformationInputVariablePtr > );
    c1.def( "addInputVariableOnGroupOfElements",
       &MaterialOnMeshInstance::addInputVariableOnGroupOfElements< IrreversibleDeformationInputVariablePtr > );
    c1.def( "addInputVariableOnAllMesh",
            &MaterialOnMeshInstance::addInputVariableOnAllMesh< ConcreteHydratationInputVariablePtr > );
    c1.def( "addInputVariableOnGroupOfElements",
       &MaterialOnMeshInstance::addInputVariableOnGroupOfElements< ConcreteHydratationInputVariablePtr > );
    c1.def( "addInputVariableOnAllMesh",
            &MaterialOnMeshInstance::addInputVariableOnAllMesh< IrradiationInputVariablePtr > );
    c1.def( "addInputVariableOnGroupOfElements",
       &MaterialOnMeshInstance::addInputVariableOnGroupOfElements< IrradiationInputVariablePtr > );
    c1.def( "addInputVariableOnAllMesh",
            &MaterialOnMeshInstance::addInputVariableOnAllMesh< SteelPhasesInputVariablePtr > );
    c1.def( "addInputVariableOnGroupOfElements",
       &MaterialOnMeshInstance::addInputVariableOnGroupOfElements< SteelPhasesInputVariablePtr > );
    c1.def( "addInputVariableOnAllMesh",
            &MaterialOnMeshInstance::addInputVariableOnAllMesh< ZircaloyPhasesInputVariablePtr > );
    c1.def( "addInputVariableOnGroupOfElements",
       &MaterialOnMeshInstance::addInputVariableOnGroupOfElements< ZircaloyPhasesInputVariablePtr > );
    c1.def( "addInputVariableOnAllMesh",
            &MaterialOnMeshInstance::addInputVariableOnAllMesh< Neutral1InputVariablePtr > );
    c1.def( "addInputVariableOnGroupOfElements",
       &MaterialOnMeshInstance::addInputVariableOnGroupOfElements< Neutral1InputVariablePtr > );
    c1.def( "addInputVariableOnAllMesh",
            &MaterialOnMeshInstance::addInputVariableOnAllMesh< Neutral2InputVariablePtr > );
    c1.def( "addInputVariableOnGroupOfElements",
       &MaterialOnMeshInstance::addInputVariableOnGroupOfElements< Neutral2InputVariablePtr > );
    c1.def( "addInputVariableOnAllMesh",
            &MaterialOnMeshInstance::addInputVariableOnAllMesh< ConcreteDryingInputVariablePtr > );
    c1.def( "addInputVariableOnGroupOfElements",
       &MaterialOnMeshInstance::addInputVariableOnGroupOfElements< ConcreteDryingInputVariablePtr > );
    c1.def( "addInputVariableOnAllMesh",
            &MaterialOnMeshInstance::addInputVariableOnAllMesh< TotalFluidPressureInputVariablePtr > );
    c1.def( "addInputVariableOnGroupOfElements",
       &MaterialOnMeshInstance::addInputVariableOnGroupOfElements< TotalFluidPressureInputVariablePtr > );
    c1.def( "addInputVariableOnAllMesh",
            &MaterialOnMeshInstance::addInputVariableOnAllMesh< VolumetricDeformationInputVariablePtr > );
    c1.def( "addInputVariableOnGroupOfElements",
       &MaterialOnMeshInstance::addInputVariableOnGroupOfElements< VolumetricDeformationInputVariablePtr > );

    c1.def( "addMaterialOnAllMesh", &MaterialOnMeshInstance::addMaterialOnAllMesh );
    c1.def( "addMaterialOnGroupOfElements",
              &MaterialOnMeshInstance::addMaterialOnGroupOfElements );
    c1.def( "getSupportMesh", &MaterialOnMeshInstance::getSupportMesh );
    c1.def( "build", &MaterialOnMeshInstance::build );
};
