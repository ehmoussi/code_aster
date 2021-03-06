/**
 * @file FormulaInterface.cxx
 * @brief Interface python de Formula
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

/* person_in_charge: mathieu.courtois@edf.fr */

#include <boost/python.hpp>

namespace py = boost::python;

#include <PythonBindings/factory.h>
#include "PythonBindings/FormulaInterface.h"

void exportFormulaToPython() {

    py::class_< FormulaClass, FormulaClass::FormulaPtr, py::bases< GenericFunctionClass > >
        ( "Formula", py::no_init )
        .def( "__init__", py::make_constructor(&initFactoryPtr< FormulaClass >))
        .def( "__init__", py::make_constructor(&initFactoryPtr< FormulaClass, std::string >))

        .def( "setVariables", &FormulaClass::setVariables, R"(
Define the variables names.

Arguments:
    varnames (list[str]): List of variables names.
        )",
              ( py::arg( "self" ), py::arg( "varnames" ) ) )

        .def( "setExpression", &FormulaClass::setExpression, R"(
Define the expression of the formula.

If the expression uses non builtin objects, the evaluation context must be
defined using `:func:setContext`.

Arguments:
    expression (str): Expression of the formula.
        )",
              ( py::arg( "self" ), py::arg( "expression" ) ) )

        .def( "setComplex", &FormulaClass::setComplex, R"(
Set the type of the formula as complex.
        )",
              ( py::arg( "self" ) ) )

        .def( "setContext", &FormulaClass::setContext, R"(
Define the context holding objects required to evaluate the expression.

Arguments:
    context (dict): Context for the evaluation.
        )",
              ( py::arg( "self" ), py::arg( "context" ) ) )

        .def( "evaluate", &FormulaClass::evaluate, R"(
Evaluate the formula with the given variables values.

Arguments:
    val (list[float]): List of the values of the variables.

Returns:
    float/complex: Value of the formula for these values.
        )",
              ( py::arg( "self" ), py::arg( "*val" ) ) )

        .def( "getVariables", &FormulaClass::getVariables, R"(
Return the variables names.

Returns:
    list[str]: List of the names of the variables.
        )",
              ( py::arg( "self" ) ) )

        .def( "getExpression", &FormulaClass::getExpression, R"(
Return expression of the formula.

Returns:
    str: Expression of the formula.
        )",
              ( py::arg( "self" ) ) )

        .def( "getContext", &FormulaClass::getContext, R"(
Return the context used to evaluate the formula.

Returns:
    dict: Context used for evaluation.
        )",
              py::arg( "self" ) )

        .def( "getProperties", &FormulaClass::getProperties, R"(
Return the properties of the formula (for compatibility with function objects).

Returns:
    list[str]: List of 6 strings as function objects contain.
        )",
              py::arg( "self" ) );
};
