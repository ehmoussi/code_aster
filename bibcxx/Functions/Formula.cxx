/**
 * @file ResultNaming.cxx
 * @brief Implementation of automatic naming of jeveux objects.
 * @section LICENCE
 * Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
 * This file is part of code_aster.
 *
 * code_aster is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * code_aster is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with code_aster.  If not, see <http://www.gnu.org/licenses/>.

 * person_in_charge: mathieu.courtois@edf.fr
 */

#include <stdexcept>
#include <string>
#include <vector>
#include <cstdio>

#include "astercxx.h"
#include "Functions/Formula.h"
#include "Supervis/ResultNaming.h"


FormulaInstance::FormulaInstance( const std::string jeveuxName ):
    DataStructure( jeveuxName + "           ", "FORMULE" ),
    _jeveuxName( getName() ),
    _property( JeveuxVectorChar24( getName() + ".PROL" ) ),
    _variables( JeveuxVectorChar8( getName() + ".NOVA" ) ),
    _expression( "" ),
    _code( NULL ),
    _context( NULL )
{
}

FormulaInstance::FormulaInstance() :
    FormulaInstance::FormulaInstance( ResultNaming::getNewResultName() )
{
propertyAllocate();
}

FormulaInstance::~FormulaInstance()
{
    Py_XDECREF(_code);
    Py_XDECREF(_context);
}

void FormulaInstance::setVariables( const std::vector< std::string > &names )
    throw ( std::runtime_error )
{
    const int nbvar = names.size();
    _variables->allocate( Permanent, nbvar );

    std::vector< std::string >::const_iterator varIt = names.begin();
    int idx = 0;
    for ( ; varIt != names.end(); ++varIt )
    {
        (*_variables)[idx] = *varIt;
        ++idx;
    }
}
std::vector< std::string > FormulaInstance::getVariables() const
{
    _variables->updateValuePointer();
    long nbvars = _variables->size();
    std::vector< std::string > vars;
    for ( int i = 0; i < nbvars; ++i )
    {
        vars.push_back( (*_variables)[i].rstrip() );
    }
    return vars;
}

void FormulaInstance::setExpression( const std::string expression )
    throw(std::runtime_error)
{
    const std::string name = "formula";
    _expression = expression;
    Py_XDECREF(_code);
    _code = (PyCodeObject*)Py_CompileString(_expression.c_str(), name.c_str(), Py_eval_input);
    if ( _code == NULL ) {
        PyErr_Print();
        throw std::runtime_error("Invalid syntax in expression.");
    }
}

double FormulaInstance::evaluate( const std::vector< double > values ) const
    throw ( std::runtime_error )
{
    const long nbvars = _variables->size();
    const long nbvalues = values.size();
    if ( nbvalues != nbvars ) {
        throw std::runtime_error("Expecting exactly " + std::to_string(nbvars)
        + " values, not " + std::to_string(nbvalues));
    }

    // PyObject* globals = PyDict_New();
    // PyDict_Update(globals, _context);

    PyObject* locals = PyDict_New();
    std::vector< double >::const_iterator valIt = values.begin();
    long i = 0;
    std::string param;
    for ( ; valIt != values.end(); ++valIt ) {
        param = (*_variables)[i].rstrip();
        PyDict_SetItemString(locals, param.c_str(), PyFloat_FromDouble(*valIt));
        ++i;
    }

    PyObject* res = PyEval_EvalCode(_code, _context, locals);
    Py_DECREF(locals);
    if ( res == NULL ) {
        PyErr_Print();
        std::cout << "Parameters values:";
        PyObject_Print(locals, stdout, 0);
        std::cout << std::endl;
        throw std::runtime_error("Error during evaluation of '" + _expression + "'.");
    }
    double result = PyFloat_AsDouble(res);
    Py_DECREF(res);
    // Py_DECREF(globals);
    return result;
}
