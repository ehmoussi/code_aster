/**
 * @file FormulaInterface.cxx
 * @brief Interface python de Formula
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

#include <PythonBindings/factory.h>
#include "PythonBindings/FormulaInterface.h"

void exportFormulaToPython() {
    using namespace boost::python;

    class_< FormulaInstance, FormulaInstance::FormulaPtr, bases< GenericFunctionInstance > >
        ( "Formula", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< FormulaInstance >))
        .def( "__init__", make_constructor(&initFactoryPtr< FormulaInstance, std::string >))

        .def( "setVariables", &FormulaInstance::setVariables, R"(
Define the variables names.

Arguments:
    varnames (list[str]): List of variables names.
        )",
              ( arg( "self" ), arg( "varnames" ) ) )

        .def( "setExpression", &FormulaInstance::setExpression, R"(
Define the expression of the formula.

If the expression uses non builtin objects, the evaluation context must be
defined using `:func:setContext`.

Arguments:
    expression (str): Expression of the formula.
        )",
              ( arg( "self" ), arg( "expression" ) ) )

        .def( "setComplex", &FormulaInstance::setComplex, R"(
Set the type of the formula as complex.
        )",
              ( arg( "self" ) ) )

        .def( "setContext", &FormulaInstance::setContext, R"(
Define the context holding objects required to evaluate the expression.

Arguments:
    context (dict): Context for the evaluation.
        )",
              ( arg( "self" ), arg( "context" ) ) )

        .def( "evaluate", &FormulaInstance::evaluate, R"(
Evaluate the formula with the given variables values.

Arguments:
    val (list[float]): List of the values of the variables.

Returns:
    float/complex: Value of the formula for these values.
        )",
              ( arg( "self" ), arg( "*val" ) ) )

        .def( "getVariables", &FormulaInstance::getVariables, R"(
Return the variables names.

Returns:
    list[str]: List of the names of the variables.
        )",
              ( arg( "self" ) ) )

        .def( "getExpression", &FormulaInstance::getExpression, R"(
Return expression of the formula.

Returns:
    str: Expression of the formula.
        )",
              ( arg( "self" ) ) )

        .def( "getContext", &FormulaInstance::getContext, R"(
Return the context used to evaluate the formula.

Returns:
    dict: Context used for evaluation.
        )",
              arg( "self" ) )

        .def( "getProperties", &FormulaInstance::getProperties, R"(
Return the properties of the formula (for compatibility with function objects).

Returns:
    list[str]: List of 6 strings as function objects contain.
        )",
              arg( "self" ) );
};
