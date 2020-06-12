/**
 * @file ModeResultInterface.cxx
 * @brief Interface python de ModeResult
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

#include "PythonBindings/ModeResultInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

namespace py = boost::python;
#include "PythonBindings/VariantStiffnessMatrixInterface.h"

void exportModeResultToPython() {

    bool ( ModeResultClass::*c1 )( const AssemblyMatrixDisplacementRealPtr & ) =
        &ModeResultClass::setStiffnessMatrix;
    bool ( ModeResultClass::*c2 )( const AssemblyMatrixTemperatureRealPtr & ) =
        &ModeResultClass::setStiffnessMatrix;
    bool ( ModeResultClass::*c3 )( const AssemblyMatrixDisplacementComplexPtr & ) =
        &ModeResultClass::setStiffnessMatrix;
    bool ( ModeResultClass::*c4 )( const AssemblyMatrixPressureRealPtr & ) =
        &ModeResultClass::setStiffnessMatrix;

    bool ( ModeResultClass::*c5 )( const AssemblyMatrixDisplacementRealPtr & ) =
        &ModeResultClass::setMassMatrix;
    bool ( ModeResultClass::*c6 )( const AssemblyMatrixTemperatureRealPtr & ) =
        &ModeResultClass::setMassMatrix;
    bool ( ModeResultClass::*c7 )( const AssemblyMatrixDisplacementComplexPtr & ) =
        &ModeResultClass::setMassMatrix;
    bool ( ModeResultClass::*c8 )( const AssemblyMatrixPressureRealPtr & ) =
        &ModeResultClass::setMassMatrix;

    py::class_< ModeResultClass, ModeResultPtr,
                py::bases< FullResultClass > >( "ModeResult",
                                                             py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< ModeResultClass >))
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ModeResultClass, std::string >))
        .def( "getDOFNumbering", &ModeResultClass::getDOFNumbering )
        .def("getStiffnessMatrix", &getStiffnessMatrix< ModeResultPtr >)
        .def( "setStiffnessMatrix", c1 )
        .def( "setStiffnessMatrix", c2 )
        .def( "setStiffnessMatrix", c3 )
        .def( "setStiffnessMatrix", c4 )
        .def("getMassMatrix", &getStiffnessMatrix< ModeResultPtr >)
        .def( "setMassMatrix", c5 )
        .def( "setMassMatrix", c6 )
        .def( "setMassMatrix", c7 )
        .def( "setMassMatrix", c8 )
        .def( "setStructureInterface", &ModeResultClass::setStructureInterface );
};

void exportModeResultComplexToPython() {

    bool ( ModeResultComplexClass::*c1 )(
        const AssemblyMatrixDisplacementRealPtr & ) =
        &ModeResultComplexClass::setStiffnessMatrix;
    bool ( ModeResultComplexClass::*c2 )(
        const AssemblyMatrixDisplacementComplexPtr & ) =
        &ModeResultComplexClass::setStiffnessMatrix;
    bool ( ModeResultComplexClass::*c3 )(
        const AssemblyMatrixDisplacementComplexPtr & ) =
        &ModeResultComplexClass::setStiffnessMatrix;
    bool ( ModeResultComplexClass::*c4 )(
        const AssemblyMatrixPressureRealPtr & ) =
        &ModeResultComplexClass::setStiffnessMatrix;

    py::class_< ModeResultComplexClass, ModeResultComplexPtr,
                py::bases< ModeResultClass > >( "ModeResultComplex",
                                                                py::no_init )
        .def( "__init__",
              py::make_constructor(&initFactoryPtr< ModeResultComplexClass >))
        .def( "__init__",
              py::make_constructor(
                  &initFactoryPtr< ModeResultComplexClass, std::string >))
        .def( "setDampingMatrix", &ModeResultComplexClass::setDampingMatrix )
        .def( "setStiffnessMatrix", c1 )
        .def( "setStiffnessMatrix", c2 )
        .def( "setStiffnessMatrix", c3 )
        .def( "setStiffnessMatrix", c4 )
        .def( "setStructureInterface",
              &ModeResultComplexClass::setStructureInterface );
};
