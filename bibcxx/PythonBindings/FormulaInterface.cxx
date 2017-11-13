/**
 * @file FormulaInterface.cxx
 * @brief Interface python de Formula
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

/* person_in_charge: mathieu.courtois@edf.fr */

#include <boost/python.hpp>

#include <PythonBindings/factory.h>
#include "PythonBindings/FormulaInterface.h"

void exportFormulaToPython()
{
    using namespace boost::python;

    class_< FormulaInstance, FormulaInstance::FormulaPtr,
            bases< DataStructure > > ( "Formula", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< FormulaInstance >) )
        .def( "__init__", make_constructor(
            &initFactoryPtr< FormulaInstance,
                             std::string >) )
        .def( "setVariables", &FormulaInstance::setVariables )
        .def( "setExpression", &FormulaInstance::setExpression )
        .def( "setComplex", &FormulaInstance::setComplex )
        .def( "setContext", &FormulaInstance::setContext )
        .def( "evaluate", &FormulaInstance::evaluate )
        .def( "getVariables", &FormulaInstance::getVariables )
        .def( "getExpression", &FormulaInstance::getExpression )
        .def( "getContext", &FormulaInstance::getContext )
        .def( "getProperties", &FormulaInstance::getProperties )
    ;
};
