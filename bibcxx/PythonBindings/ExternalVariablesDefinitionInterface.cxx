/**
 * @file ExternalVariablesInterface.cxx
 * @brief Interface python de BaseExternalVariables
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

#include "PythonBindings/ExternalVariablesDefinitionInterface.h"
#include <PythonBindings/factory.h>
#include <boost/python.hpp>

namespace py = boost::python;

void exportExternalVariablesToPython() {

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

    py::class_< BaseExternalVariablesClass,
                BaseExternalVariablesClass::BaseExternalVariablesPtr>("BaseExternalVariables",
                                                                         py::no_init )
        .def( "__init__", py::make_constructor(
                              &initFactoryPtr< BaseExternalVariablesClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< BaseExternalVariablesClass,
                                                    const BaseMeshPtr &, const std::string & >))
        .def( "existsReferenceValue", &BaseExternalVariablesClass::existsReferenceValue )
        .def( "getReferenceValue", &BaseExternalVariablesClass::getReferenceValue )
        .def( "setEvolutionParameter", &BaseExternalVariablesClass::setEvolutionParameter )
        .def( "setInputValuesField", &BaseExternalVariablesClass::setInputValuesField )
        .def( "setReferenceValue", &BaseExternalVariablesClass::setReferenceValue );

    py::class_< TemperatureExternalVariableClass, TemperatureExternalVariablePtr,
                py::bases< BaseExternalVariablesClass > >( "TemperatureExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< TemperatureExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< TemperatureExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< GeometryExternalVariableClass, GeometryExternalVariablePtr,
                py::bases< BaseExternalVariablesClass > >( "GeometryExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< GeometryExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< GeometryExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< CorrosionExternalVariableClass, CorrosionExternalVariablePtr,
                py::bases< BaseExternalVariablesClass > >( "CorrosionExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< CorrosionExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< CorrosionExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< IrreversibleDeformationExternalVariableClass,
                IrreversibleDeformationExternalVariablePtr,
                py::bases< BaseExternalVariablesClass > >(
                                                        "IrreversibleDeformationExternalVariable",
                                                        py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< IrreversibleDeformationExternalVariableClass,
                                                    const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< IrreversibleDeformationExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< ConcreteHydratationExternalVariableClass, ConcreteHydratationExternalVariablePtr,
                py::bases< BaseExternalVariablesClass > >( "ConcreteHydratationExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ConcreteHydratationExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ConcreteHydratationExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< IrradiationExternalVariableClass, IrradiationExternalVariablePtr,
                py::bases< BaseExternalVariablesClass > >( "IrradiationExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< IrradiationExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< IrradiationExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< SteelPhasesExternalVariableClass, SteelPhasesExternalVariablePtr,
                py::bases< BaseExternalVariablesClass > >( "SteelPhasesExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< SteelPhasesExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< SteelPhasesExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< ZircaloyPhasesExternalVariableClass, ZircaloyPhasesExternalVariablePtr,
                py::bases< BaseExternalVariablesClass > >( "ZircaloyPhasesExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ZircaloyPhasesExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ZircaloyPhasesExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< Neutral1ExternalVariableClass, Neutral1ExternalVariablePtr,
                py::bases< BaseExternalVariablesClass > >( "Neutral1ExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< Neutral1ExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< Neutral1ExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< Neutral2ExternalVariableClass, Neutral2ExternalVariablePtr,
                py::bases< BaseExternalVariablesClass > >( "Neutral2ExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< Neutral2ExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< Neutral2ExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< Neutral3ExternalVariableClass, Neutral3ExternalVariablePtr,
                py::bases< BaseExternalVariablesClass > >( "Neutral3ExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< Neutral3ExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< Neutral3ExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< ConcreteDryingExternalVariableClass, ConcreteDryingExternalVariablePtr,
                py::bases< BaseExternalVariablesClass > >( "ConcreteDryingExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ConcreteDryingExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ConcreteDryingExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_< TotalFluidPressureExternalVariableClass, TotalFluidPressureExternalVariablePtr,
                py::bases< BaseExternalVariablesClass > >( "TotalFluidPressureExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< TotalFluidPressureExternalVariableClass, const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< TotalFluidPressureExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_<VolumetricDeformationExternalVariableClass, VolumetricDeformationExternalVariablePtr,
               py::bases< BaseExternalVariablesClass > >( "VolumetricDeformationExternalVariable",
                                                             py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< VolumetricDeformationExternalVariableClass,
                                                    const BaseMeshPtr & >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< VolumetricDeformationExternalVariableClass,
                                                    const BaseMeshPtr &, const std::string & >));

    py::class_<ExternalVariablesFieldClass, ExternalVariablesFieldPtr > c3("ExternalVariablesField",
                                                                            py::no_init );
    c3.def( "__init__",
            py::make_constructor(&initFactoryPtr< ExternalVariablesFieldClass, const MeshPtr & >));
    c3.def( "__init__", py::make_constructor(
                            &initFactoryPtr< ExternalVariablesFieldClass, const SkeletonPtr & >));
#ifdef _USE_MPI
    c3.def( "__init__",
            py::make_constructor(
                &initFactoryPtr< ExternalVariablesFieldClass, const ParallelMeshPtr & >));
#endif /* _USE_MPI */
    c3.def(
        "addExternalVariableOnAllMesh",
        &ExternalVariablesFieldClass::addExternalVariableOnAllMesh<
        TemperatureExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfCells",
            &ExternalVariablesFieldClass::addExternalVariableOnGroupOfCells<
                TemperatureExternalVariablePtr > );
    c3.def(
        "addExternalVariableOnElement",
        &ExternalVariablesFieldClass::addExternalVariableOnElement<
        TemperatureExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
            &ExternalVariablesFieldClass::addExternalVariableOnAllMesh<
            GeometryExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfCells",
            &ExternalVariablesFieldClass::addExternalVariableOnGroupOfCells<
                GeometryExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
            &ExternalVariablesFieldClass::addExternalVariableOnElement<
            GeometryExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
            &ExternalVariablesFieldClass::addExternalVariableOnAllMesh<
            CorrosionExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfCells",
            &ExternalVariablesFieldClass::addExternalVariableOnGroupOfCells<
                CorrosionExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
            &ExternalVariablesFieldClass::addExternalVariableOnElement<
            CorrosionExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
    &ExternalVariablesFieldClass::addExternalVariableOnAllMesh<
                                             IrreversibleDeformationExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfCells",
            &ExternalVariablesFieldClass::addExternalVariableOnGroupOfCells<
                IrreversibleDeformationExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
    &ExternalVariablesFieldClass::addExternalVariableOnElement<
                                             IrreversibleDeformationExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
    &ExternalVariablesFieldClass::addExternalVariableOnAllMesh<
                                             ConcreteHydratationExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfCells",
            &ExternalVariablesFieldClass::addExternalVariableOnGroupOfCells<
                ConcreteHydratationExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
           &ExternalVariablesFieldClass::addExternalVariableOnElement<
                                             ConcreteHydratationExternalVariablePtr > );
    c3.def(
        "addExternalVariableOnAllMesh",
        &ExternalVariablesFieldClass::addExternalVariableOnAllMesh<
        IrradiationExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfCells",
            &ExternalVariablesFieldClass::addExternalVariableOnGroupOfCells<
                IrradiationExternalVariablePtr > );
    c3.def(
        "addExternalVariableOnElement",
        &ExternalVariablesFieldClass::addExternalVariableOnElement<
        IrradiationExternalVariablePtr > );
    c3.def(
        "addExternalVariableOnAllMesh",
        &ExternalVariablesFieldClass::addExternalVariableOnAllMesh<
        SteelPhasesExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfCells",
            &ExternalVariablesFieldClass::addExternalVariableOnGroupOfCells<
                SteelPhasesExternalVariablePtr > );
    c3.def(
        "addExternalVariableOnElement",
        &ExternalVariablesFieldClass::addExternalVariableOnElement<
        SteelPhasesExternalVariablePtr > );
    c3.def(
        "addExternalVariableOnAllMesh",
        &ExternalVariablesFieldClass::addExternalVariableOnAllMesh<
        ZircaloyPhasesExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfCells",
            &ExternalVariablesFieldClass::addExternalVariableOnGroupOfCells<
                ZircaloyPhasesExternalVariablePtr > );
    c3.def(
        "addExternalVariableOnElement",
        &ExternalVariablesFieldClass::addExternalVariableOnElement<
        ZircaloyPhasesExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
            &ExternalVariablesFieldClass::addExternalVariableOnAllMesh<
            Neutral1ExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfCells",
            &ExternalVariablesFieldClass::addExternalVariableOnGroupOfCells<
                Neutral1ExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
            &ExternalVariablesFieldClass::addExternalVariableOnElement<
            Neutral1ExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
            &ExternalVariablesFieldClass::addExternalVariableOnAllMesh<
            Neutral2ExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfCells",
            &ExternalVariablesFieldClass::addExternalVariableOnGroupOfCells<
                Neutral2ExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
            &ExternalVariablesFieldClass::addExternalVariableOnElement<
            Neutral2ExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
            &ExternalVariablesFieldClass::addExternalVariableOnAllMesh<
            Neutral3ExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfCells",
            &ExternalVariablesFieldClass::addExternalVariableOnGroupOfCells<
                Neutral3ExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
            &ExternalVariablesFieldClass::addExternalVariableOnElement<
            Neutral3ExternalVariablePtr > );
    c3.def(
        "addExternalVariableOnAllMesh",
        &ExternalVariablesFieldClass::addExternalVariableOnAllMesh<
               ConcreteDryingExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfCells",
            &ExternalVariablesFieldClass::addExternalVariableOnGroupOfCells<
                ConcreteDryingExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
            &ExternalVariablesFieldClass::addExternalVariableOnElement<
                                             ConcreteDryingExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
            &ExternalVariablesFieldClass::addExternalVariableOnAllMesh<
                                             TotalFluidPressureExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfCells",
            &ExternalVariablesFieldClass::addExternalVariableOnGroupOfCells<
                TotalFluidPressureExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
            &ExternalVariablesFieldClass::addExternalVariableOnElement<
                                             TotalFluidPressureExternalVariablePtr > );
    c3.def( "addExternalVariableOnAllMesh",
            &ExternalVariablesFieldClass::addExternalVariableOnAllMesh<
                                             VolumetricDeformationExternalVariablePtr > );
    c3.def( "addExternalVariableOnGroupOfCells",
            &ExternalVariablesFieldClass::addExternalVariableOnGroupOfCells<
                VolumetricDeformationExternalVariablePtr > );
    c3.def( "addExternalVariableOnElement",
            &ExternalVariablesFieldClass::addExternalVariableOnElement<
                                             VolumetricDeformationExternalVariablePtr > );
};
