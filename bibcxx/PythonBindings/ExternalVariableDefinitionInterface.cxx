/**
 * @file ExternalVariableDefinitionInterface.cxx
 * @brief Interface python de GenericExternalVariable
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "PythonBindings/ExternalVariableDefinitionInterface.h"
#include <PythonBindings/factory.h>
#include <boost/python.hpp>

namespace py = boost::python;

void exportExternalVariableDefinitionToPython() {

    void ( EvolutionParameterClass::*c1 )( const FormulaPtr & ) =
        &EvolutionParameterClass::setTimeFunction;
    void ( EvolutionParameterClass::*c2 )( const FunctionPtr & ) =
        &EvolutionParameterClass::setTimeFunction;

    py::class_< EvolutionParameterClass, EvolutionParameterPtr >( "EvolutionParameter",
                                                                     py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< EvolutionParameterClass,
                                                    const TransientResultPtr & >))
        .def( "setFieldName", &EvolutionParameterClass::setFieldName )
        .def( "setTimeFunction", c1 )
        .def( "setTimeFunction", c2 )
        .def( "prohibitRightExtension", &EvolutionParameterClass::prohibitRightExtension )
        .def( "setConstantRightExtension", &EvolutionParameterClass::setConstantRightExtension )
        .def( "setLinearRightExtension", &EvolutionParameterClass::setLinearRightExtension )
        .def( "prohibitLeftExtension", &EvolutionParameterClass::prohibitLeftExtension )
        .def( "setConstantLeftExtension", &EvolutionParameterClass::setConstantLeftExtension )
        .def( "setLinearLeftExtension", &EvolutionParameterClass::setLinearLeftExtension );

    py::class_< GenericExternalVariableClass,
                GenericExternalVariableClass::GenericExternalVariablePtr>("GenericExternalVariable",
                                                                         py::no_init )
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< GenericExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< GenericExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >))
        .def( "existsReferenceValue", &GenericExternalVariableClass::existsReferenceValue )
        .def( "getReferenceValue", &GenericExternalVariableClass::getReferenceValue )
        .def( "setEvolutionParameter", &GenericExternalVariableClass::setEvolutionParameter )
        .def( "setInputValuesField", &GenericExternalVariableClass::setInputValuesField )
        .def( "setReferenceValue", &GenericExternalVariableClass::setReferenceValue );

    py::class_< TemperatureExternalVariableClass, TemperatureExternalVariablePtr,
                py::bases< GenericExternalVariableClass > >( "TemperatureExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< TemperatureExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< TemperatureExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< GeometryExternalVariableClass, GeometryExternalVariablePtr,
                py::bases< GenericExternalVariableClass > >( "GeometryExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< GeometryExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< GeometryExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< CorrosionExternalVariableClass, CorrosionExternalVariablePtr,
                py::bases< GenericExternalVariableClass > >( "CorrosionExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< CorrosionExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< CorrosionExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< IrreversibleDeformationExternalVariableClass,
                IrreversibleDeformationExternalVariablePtr,
                py::bases< GenericExternalVariableClass > >(
                                                        "IrreversibleDeformationExternalVariable",
                                                        py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< IrreversibleDeformationExternalVariableClass,
                                                    const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< IrreversibleDeformationExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< ConcreteHydratationExternalVariableClass, ConcreteHydratationExternalVariablePtr,
                py::bases< GenericExternalVariableClass > >( "ConcreteHydratationExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ConcreteHydratationExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ConcreteHydratationExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< IrradiationExternalVariableClass, IrradiationExternalVariablePtr,
                py::bases< GenericExternalVariableClass > >( "IrradiationExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< IrradiationExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< IrradiationExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< SteelPhasesExternalVariableClass, SteelPhasesExternalVariablePtr,
                py::bases< GenericExternalVariableClass > >( "SteelPhasesExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< SteelPhasesExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< SteelPhasesExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< ZircaloyPhasesExternalVariableClass, ZircaloyPhasesExternalVariablePtr,
                py::bases< GenericExternalVariableClass > >( "ZircaloyPhasesExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ZircaloyPhasesExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ZircaloyPhasesExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< Neutral1ExternalVariableClass, Neutral1ExternalVariablePtr,
                py::bases< GenericExternalVariableClass > >( "Neutral1ExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< Neutral1ExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< Neutral1ExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< Neutral2ExternalVariableClass, Neutral2ExternalVariablePtr,
                py::bases< GenericExternalVariableClass > >( "Neutral2ExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< Neutral2ExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< Neutral2ExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< Neutral3ExternalVariableClass, Neutral3ExternalVariablePtr,
                py::bases< GenericExternalVariableClass > >( "Neutral3ExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< Neutral3ExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< Neutral3ExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< ConcreteDryingExternalVariableClass, ConcreteDryingExternalVariablePtr,
                py::bases< GenericExternalVariableClass > >( "ConcreteDryingExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ConcreteDryingExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ConcreteDryingExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< TotalFluidPressureExternalVariableClass, TotalFluidPressureExternalVariablePtr,
                py::bases< GenericExternalVariableClass > >( "TotalFluidPressureExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< TotalFluidPressureExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< TotalFluidPressureExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_<VolumetricDeformationExternalVariableClass, VolumetricDeformationExternalVariablePtr,
               py::bases< GenericExternalVariableClass > >( "VolumetricDeformationExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< VolumetricDeformationExternalVariableClass,
                                                    const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< VolumetricDeformationExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_<ExternalVariableOnMeshClass, ExternalVariableOnMeshPtr > c3("ExternalVariableOnMesh",
                                                                            py::no_init );
    c3.def( "__init__",
            py::make_constructor(&initFactoryPtr< ExternalVariableOnMeshClass, const MeshPtr & >));
    c3.def( "__init__", py::make_constructor(
                            &initFactoryPtr< ExternalVariableOnMeshClass, const SkeletonPtr & >));
#ifdef _USE_MPI
    c3.def( "__init__",
            py::make_constructor(
                &initFactoryPtr< ExternalVariableOnMeshClass, const ParallelMeshPtr & >));
#endif /* _USE_MPI */
    c3.def(
        "addExternalVariableOnAllMesh",
        &ExternalVariableOnMeshClass::addExternalVariableOnAllMesh<
        TemperatureExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfElements",
            &ExternalVariableOnMeshClass::addExternalVariableOnGroupOfElements<
                TemperatureExternalVariablePtr > );
    c3.def(
        "addExternalVariableOnElement",
        &ExternalVariableOnMeshClass::addExternalVariableOnElement<
        TemperatureExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
            &ExternalVariableOnMeshClass::addExternalVariableOnAllMesh<
            GeometryExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfElements",
            &ExternalVariableOnMeshClass::addExternalVariableOnGroupOfElements<
                GeometryExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
            &ExternalVariableOnMeshClass::addExternalVariableOnElement<
            GeometryExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
            &ExternalVariableOnMeshClass::addExternalVariableOnAllMesh<
            CorrosionExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfElements",
            &ExternalVariableOnMeshClass::addExternalVariableOnGroupOfElements<
                CorrosionExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
            &ExternalVariableOnMeshClass::addExternalVariableOnElement<
            CorrosionExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
    &ExternalVariableOnMeshClass::addExternalVariableOnAllMesh<
                                             IrreversibleDeformationExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfElements",
            &ExternalVariableOnMeshClass::addExternalVariableOnGroupOfElements<
                IrreversibleDeformationExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
    &ExternalVariableOnMeshClass::addExternalVariableOnElement<
                                             IrreversibleDeformationExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
    &ExternalVariableOnMeshClass::addExternalVariableOnAllMesh<
                                             ConcreteHydratationExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfElements",
            &ExternalVariableOnMeshClass::addExternalVariableOnGroupOfElements<
                ConcreteHydratationExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
           &ExternalVariableOnMeshClass::addExternalVariableOnElement<
                                             ConcreteHydratationExternalVariablePtr > );
    c3.def(
        "addExternalVariableOnAllMesh",
        &ExternalVariableOnMeshClass::addExternalVariableOnAllMesh<
        IrradiationExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfElements",
            &ExternalVariableOnMeshClass::addExternalVariableOnGroupOfElements<
                IrradiationExternalVariablePtr > );
    c3.def(
        "addExternalVariableOnElement",
        &ExternalVariableOnMeshClass::addExternalVariableOnElement<
        IrradiationExternalVariablePtr > );
    c3.def(
        "addExternalVariableOnAllMesh",
        &ExternalVariableOnMeshClass::addExternalVariableOnAllMesh<
        SteelPhasesExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfElements",
            &ExternalVariableOnMeshClass::addExternalVariableOnGroupOfElements<
                SteelPhasesExternalVariablePtr > );
    c3.def(
        "addExternalVariableOnElement",
        &ExternalVariableOnMeshClass::addExternalVariableOnElement<
        SteelPhasesExternalVariablePtr > );
    c3.def(
        "addExternalVariableOnAllMesh",
        &ExternalVariableOnMeshClass::addExternalVariableOnAllMesh<
        ZircaloyPhasesExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfElements",
            &ExternalVariableOnMeshClass::addExternalVariableOnGroupOfElements<
                ZircaloyPhasesExternalVariablePtr > );
    c3.def(
        "addExternalVariableOnElement",
        &ExternalVariableOnMeshClass::addExternalVariableOnElement<
        ZircaloyPhasesExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
            &ExternalVariableOnMeshClass::addExternalVariableOnAllMesh<
            Neutral1ExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfElements",
            &ExternalVariableOnMeshClass::addExternalVariableOnGroupOfElements<
                Neutral1ExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
            &ExternalVariableOnMeshClass::addExternalVariableOnElement<
            Neutral1ExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
            &ExternalVariableOnMeshClass::addExternalVariableOnAllMesh<
            Neutral2ExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfElements",
            &ExternalVariableOnMeshClass::addExternalVariableOnGroupOfElements<
                Neutral2ExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
            &ExternalVariableOnMeshClass::addExternalVariableOnElement<
            Neutral2ExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
            &ExternalVariableOnMeshClass::addExternalVariableOnAllMesh<
            Neutral3ExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfElements",
            &ExternalVariableOnMeshClass::addExternalVariableOnGroupOfElements<
                Neutral3ExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
            &ExternalVariableOnMeshClass::addExternalVariableOnElement<
            Neutral3ExternalVariablePtr > );
    c3.def(
        "addExternalVariableOnAllMesh",
        &ExternalVariableOnMeshClass::addExternalVariableOnAllMesh<
               ConcreteDryingExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfElements",
            &ExternalVariableOnMeshClass::addExternalVariableOnGroupOfElements<
                ConcreteDryingExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
            &ExternalVariableOnMeshClass::addExternalVariableOnElement<
                                             ConcreteDryingExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
            &ExternalVariableOnMeshClass::addExternalVariableOnAllMesh<
                                             TotalFluidPressureExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfElements",
            &ExternalVariableOnMeshClass::addExternalVariableOnGroupOfElements<
                TotalFluidPressureExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
            &ExternalVariableOnMeshClass::addExternalVariableOnElement<
                                             TotalFluidPressureExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
            &ExternalVariableOnMeshClass::addExternalVariableOnAllMesh<
                                             VolumetricDeformationExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfElements",
            &ExternalVariableOnMeshClass::addExternalVariableOnGroupOfElements<
                VolumetricDeformationExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
            &ExternalVariableOnMeshClass::addExternalVariableOnElement<
                                             VolumetricDeformationExternalVariablePtr > );
};
