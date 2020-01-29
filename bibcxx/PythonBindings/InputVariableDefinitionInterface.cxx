/**
 * @file InputVariableDefinitionInterface.cxx
 * @brief Interface python de GenericInputVariable
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

#include "PythonBindings/InputVariableDefinitionInterface.h"
#include <PythonBindings/factory.h>
#include <boost/python.hpp>

namespace py = boost::python;

void exportInputVariableDefinitionToPython() {

    void ( EvolutionParameterClass::*c1 )( const FormulaPtr & ) =
        &EvolutionParameterClass::setTimeFunction;
    void ( EvolutionParameterClass::*c2 )( const FunctionPtr & ) =
        &EvolutionParameterClass::setTimeFunction;

    py::class_< EvolutionParameterClass, EvolutionParameterPtr >( "EvolutionParameter",
                                                                     py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< EvolutionParameterClass,
                                                    const TimeDependantResultsContainerPtr & >))
        .def( "setFieldName", &EvolutionParameterClass::setFieldName )
        .def( "setTimeFunction", c1 )
        .def( "setTimeFunction", c2 )
        .def( "prohibitRightExtension", &EvolutionParameterClass::prohibitRightExtension )
        .def( "setConstantRightExtension", &EvolutionParameterClass::setConstantRightExtension )
        .def( "setLinearRightExtension", &EvolutionParameterClass::setLinearRightExtension )
        .def( "prohibitLeftExtension", &EvolutionParameterClass::prohibitLeftExtension )
        .def( "setConstantLeftExtension", &EvolutionParameterClass::setConstantLeftExtension )
        .def( "setLinearLeftExtension", &EvolutionParameterClass::setLinearLeftExtension );

    py::class_< GenericInputVariableClass,
                GenericInputVariableClass::GenericInputVariablePtr >( "GenericInputVariable",
                                                                         py::no_init )
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< GenericInputVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< GenericInputVariableClass,
                                                    const BaseMeshPtr &, const std::string & >))
        .def( "existsReferenceValue", &GenericInputVariableClass::existsReferenceValue )
        .def( "getReferenceValue", &GenericInputVariableClass::getReferenceValue )
        .def( "setEvolutionParameter", &GenericInputVariableClass::setEvolutionParameter )
        .def( "setInputValuesField", &GenericInputVariableClass::setInputValuesField )
        .def( "setReferenceValue", &GenericInputVariableClass::setReferenceValue );

    py::class_< TemperatureInputVariableClass, TemperatureInputVariablePtr,
                py::bases< GenericInputVariableClass > >( "TemperatureInputVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< TemperatureInputVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< TemperatureInputVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< GeometryInputVariableClass, GeometryInputVariablePtr,
                py::bases< GenericInputVariableClass > >( "GeometryInputVariable", py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< GeometryInputVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< GeometryInputVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< CorrosionInputVariableClass, CorrosionInputVariablePtr,
                py::bases< GenericInputVariableClass > >( "CorrosionInputVariable", py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< CorrosionInputVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< CorrosionInputVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< IrreversibleDeformationInputVariableClass,
                IrreversibleDeformationInputVariablePtr,
                py::bases< GenericInputVariableClass > >( "IrreversibleDeformationInputVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< IrreversibleDeformationInputVariableClass,
                                                    const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< IrreversibleDeformationInputVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< ConcreteHydratationInputVariableClass, ConcreteHydratationInputVariablePtr,
                py::bases< GenericInputVariableClass > >( "ConcreteHydratationInputVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ConcreteHydratationInputVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ConcreteHydratationInputVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< IrradiationInputVariableClass, IrradiationInputVariablePtr,
                py::bases< GenericInputVariableClass > >( "IrradiationInputVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< IrradiationInputVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< IrradiationInputVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< SteelPhasesInputVariableClass, SteelPhasesInputVariablePtr,
                py::bases< GenericInputVariableClass > >( "SteelPhasesInputVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< SteelPhasesInputVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< SteelPhasesInputVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< ZircaloyPhasesInputVariableClass, ZircaloyPhasesInputVariablePtr,
                py::bases< GenericInputVariableClass > >( "ZircaloyPhasesInputVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ZircaloyPhasesInputVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ZircaloyPhasesInputVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< Neutral1InputVariableClass, Neutral1InputVariablePtr,
                py::bases< GenericInputVariableClass > >( "Neutral1InputVariable", py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< Neutral1InputVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< Neutral1InputVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< Neutral2InputVariableClass, Neutral2InputVariablePtr,
                py::bases< GenericInputVariableClass > >( "Neutral2InputVariable", py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< Neutral2InputVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< Neutral2InputVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< Neutral3InputVariableClass, Neutral3InputVariablePtr,
                py::bases< GenericInputVariableClass > >( "Neutral3InputVariable", py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< Neutral3InputVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< Neutral3InputVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< ConcreteDryingInputVariableClass, ConcreteDryingInputVariablePtr,
                py::bases< GenericInputVariableClass > >( "ConcreteDryingInputVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ConcreteDryingInputVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ConcreteDryingInputVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< TotalFluidPressureInputVariableClass, TotalFluidPressureInputVariablePtr,
                py::bases< GenericInputVariableClass > >( "TotalFluidPressureInputVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< TotalFluidPressureInputVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< TotalFluidPressureInputVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< VolumetricDeformationInputVariableClass, VolumetricDeformationInputVariablePtr,
                py::bases< GenericInputVariableClass > >( "VolumetricDeformationInputVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< VolumetricDeformationInputVariableClass,
                                                    const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< VolumetricDeformationInputVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< InputVariableOnMeshClass, InputVariableOnMeshPtr > c3( "InputVariableOnMesh",
                                                                          py::no_init );
    c3.def( "__init__",
            py::make_constructor(&initFactoryPtr< InputVariableOnMeshClass, const MeshPtr & >));
    c3.def( "__init__", py::make_constructor(
                            &initFactoryPtr< InputVariableOnMeshClass, const SkeletonPtr & >));
#ifdef _USE_MPI
    c3.def( "__init__",
            py::make_constructor(
                &initFactoryPtr< InputVariableOnMeshClass, const ParallelMeshPtr & >));
#endif /* _USE_MPI */
    c3.def(
        "addInputVariableOnAllMesh",
        &InputVariableOnMeshClass::addInputVariableOnAllMesh< TemperatureInputVariablePtr > );
    c3.def( "addInputVariableOnGroupOfElements",
            &InputVariableOnMeshClass::addInputVariableOnGroupOfElements<
                TemperatureInputVariablePtr > );
    c3.def(
        "addInputVariableOnElement",
        &InputVariableOnMeshClass::addInputVariableOnElement< TemperatureInputVariablePtr > );
    c3.def( "addInputVariableOnAllMesh",
            &InputVariableOnMeshClass::addInputVariableOnAllMesh< GeometryInputVariablePtr > );
    c3.def( "addInputVariableOnGroupOfElements",
            &InputVariableOnMeshClass::addInputVariableOnGroupOfElements<
                GeometryInputVariablePtr > );
    c3.def( "addInputVariableOnElement",
            &InputVariableOnMeshClass::addInputVariableOnElement< GeometryInputVariablePtr > );
    c3.def( "addInputVariableOnAllMesh",
            &InputVariableOnMeshClass::addInputVariableOnAllMesh< CorrosionInputVariablePtr > );
    c3.def( "addInputVariableOnGroupOfElements",
            &InputVariableOnMeshClass::addInputVariableOnGroupOfElements<
                CorrosionInputVariablePtr > );
    c3.def( "addInputVariableOnElement",
            &InputVariableOnMeshClass::addInputVariableOnElement< CorrosionInputVariablePtr > );
    c3.def( "addInputVariableOnAllMesh", &InputVariableOnMeshClass::addInputVariableOnAllMesh<
                                             IrreversibleDeformationInputVariablePtr > );
    c3.def( "addInputVariableOnGroupOfElements",
            &InputVariableOnMeshClass::addInputVariableOnGroupOfElements<
                IrreversibleDeformationInputVariablePtr > );
    c3.def( "addInputVariableOnElement", &InputVariableOnMeshClass::addInputVariableOnElement<
                                             IrreversibleDeformationInputVariablePtr > );
    c3.def( "addInputVariableOnAllMesh", &InputVariableOnMeshClass::addInputVariableOnAllMesh<
                                             ConcreteHydratationInputVariablePtr > );
    c3.def( "addInputVariableOnGroupOfElements",
            &InputVariableOnMeshClass::addInputVariableOnGroupOfElements<
                ConcreteHydratationInputVariablePtr > );
    c3.def( "addInputVariableOnElement", &InputVariableOnMeshClass::addInputVariableOnElement<
                                             ConcreteHydratationInputVariablePtr > );
    c3.def(
        "addInputVariableOnAllMesh",
        &InputVariableOnMeshClass::addInputVariableOnAllMesh< IrradiationInputVariablePtr > );
    c3.def( "addInputVariableOnGroupOfElements",
            &InputVariableOnMeshClass::addInputVariableOnGroupOfElements<
                IrradiationInputVariablePtr > );
    c3.def(
        "addInputVariableOnElement",
        &InputVariableOnMeshClass::addInputVariableOnElement< IrradiationInputVariablePtr > );
    c3.def(
        "addInputVariableOnAllMesh",
        &InputVariableOnMeshClass::addInputVariableOnAllMesh< SteelPhasesInputVariablePtr > );
    c3.def( "addInputVariableOnGroupOfElements",
            &InputVariableOnMeshClass::addInputVariableOnGroupOfElements<
                SteelPhasesInputVariablePtr > );
    c3.def(
        "addInputVariableOnElement",
        &InputVariableOnMeshClass::addInputVariableOnElement< SteelPhasesInputVariablePtr > );
    c3.def(
        "addInputVariableOnAllMesh",
        &InputVariableOnMeshClass::addInputVariableOnAllMesh< ZircaloyPhasesInputVariablePtr > );
    c3.def( "addInputVariableOnGroupOfElements",
            &InputVariableOnMeshClass::addInputVariableOnGroupOfElements<
                ZircaloyPhasesInputVariablePtr > );
    c3.def(
        "addInputVariableOnElement",
        &InputVariableOnMeshClass::addInputVariableOnElement< ZircaloyPhasesInputVariablePtr > );
    c3.def( "addInputVariableOnAllMesh",
            &InputVariableOnMeshClass::addInputVariableOnAllMesh< Neutral1InputVariablePtr > );
    c3.def( "addInputVariableOnGroupOfElements",
            &InputVariableOnMeshClass::addInputVariableOnGroupOfElements<
                Neutral1InputVariablePtr > );
    c3.def( "addInputVariableOnElement",
            &InputVariableOnMeshClass::addInputVariableOnElement< Neutral1InputVariablePtr > );
    c3.def( "addInputVariableOnAllMesh",
            &InputVariableOnMeshClass::addInputVariableOnAllMesh< Neutral2InputVariablePtr > );
    c3.def( "addInputVariableOnGroupOfElements",
            &InputVariableOnMeshClass::addInputVariableOnGroupOfElements<
                Neutral2InputVariablePtr > );
    c3.def( "addInputVariableOnElement",
            &InputVariableOnMeshClass::addInputVariableOnElement< Neutral2InputVariablePtr > );
    c3.def( "addInputVariableOnAllMesh",
            &InputVariableOnMeshClass::addInputVariableOnAllMesh< Neutral3InputVariablePtr > );
    c3.def( "addInputVariableOnGroupOfElements",
            &InputVariableOnMeshClass::addInputVariableOnGroupOfElements<
                Neutral3InputVariablePtr > );
    c3.def( "addInputVariableOnElement",
            &InputVariableOnMeshClass::addInputVariableOnElement< Neutral3InputVariablePtr > );
    c3.def(
        "addInputVariableOnAllMesh",
        &InputVariableOnMeshClass::addInputVariableOnAllMesh< ConcreteDryingInputVariablePtr > );
    c3.def( "addInputVariableOnGroupOfElements",
            &InputVariableOnMeshClass::addInputVariableOnGroupOfElements<
                ConcreteDryingInputVariablePtr > );
    c3.def(
        "addInputVariableOnElement",
        &InputVariableOnMeshClass::addInputVariableOnElement< ConcreteDryingInputVariablePtr > );
    c3.def( "addInputVariableOnAllMesh", &InputVariableOnMeshClass::addInputVariableOnAllMesh<
                                             TotalFluidPressureInputVariablePtr > );
    c3.def( "addInputVariableOnGroupOfElements",
            &InputVariableOnMeshClass::addInputVariableOnGroupOfElements<
                TotalFluidPressureInputVariablePtr > );
    c3.def( "addInputVariableOnElement", &InputVariableOnMeshClass::addInputVariableOnElement<
                                             TotalFluidPressureInputVariablePtr > );
    c3.def( "addInputVariableOnAllMesh", &InputVariableOnMeshClass::addInputVariableOnAllMesh<
                                             VolumetricDeformationInputVariablePtr > );
    c3.def( "addInputVariableOnGroupOfElements",
            &InputVariableOnMeshClass::addInputVariableOnGroupOfElements<
                VolumetricDeformationInputVariablePtr > );
    c3.def( "addInputVariableOnElement", &InputVariableOnMeshClass::addInputVariableOnElement<
                                             VolumetricDeformationInputVariablePtr > );
};
