#ifndef FORMULA_H_
#define FORMULA_H_

/**
 * @file Formula.h
 * @brief Implementation of functions.
 * @section LICENCE
 * Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
#include <string>
#include <vector>
#include <cstdio>
#include <boost/shared_ptr.hpp>

#include "astercxx.h"
#include "definition.h"
#include "MemoryManager/JeveuxVector.h"
#include "Functions/GenericFunction.h"

/**
 * class FormulaInstance
 *   Create a datastructure for a formula with real values
 * @author Mathieu Courtois
 */
class FormulaInstance : public GenericFunctionInstance {
  private:
    // Nom Jeveux de la SD
    /** @todo remettre le const */
    std::string _jeveuxName;
    // Vecteur Jeveux '.PROL'
    JeveuxVectorChar24 _property;
    // Vecteur Jeveux '.NOVA'
    JeveuxVectorChar24 _variables;
    // Pointers to PyObject
    JeveuxVectorLong _pointers;
    // Expression
    std::string _expression;
    // Compiled expression
    PyObject *_code;
    // Evaluation context
    PyObject *_context;

    void propertyAllocate() {
        // Create Jeveux vector ".PROL"
        _property->allocate( Permanent, 6 );
        ( *_property )[0] = "INTERPRE";
        ( *_property )[1] = "INTERPRE";
        ( *_property )[2] = "";
        ( *_property )[3] = "TOUTRESU";
        ( *_property )[4] = "II";
        ( *_property )[5] = _jeveuxName;
    };

  public:
    /**
     * @typedef FormulaPtr
     * @brief Pointeur intelligent vers un Formula
     */
    typedef boost::shared_ptr< FormulaInstance > FormulaPtr;

    /**
     * Constructeur
     */
    FormulaInstance();

    FormulaInstance( const std::string jeveuxName );

    ~FormulaInstance();

    /**
     * @brief Get the result name
     * @return  name of the result
     */
    std::string getResultName() {
        if ( !_property->exists() )
            return "";
        _property->updateValuePointer();
        return ( *_property )[3].toString();
    }

    /**
     * @brief Definition of the name of the variables
     * @param name name of the parameter
     * @type  name string
     */
    void setVariables( const std::vector< std::string > &varnames ) throw( std::runtime_error );

    /**
     * @brief Return the name of the variables
     * @return name of the variables
     */
    std::vector< std::string > getVariables() const;

    /**
     * @brief Mark formula as a complex one.
     */
    void setComplex() {
        // because needed by gettco (in CALC_FONC_INTERP for example)
        setType( "FORMULE_C" );
    }

    /**
     * @brief Definition of the expression of the formula
     * @param expression expression of the formula
     * @type  expression string
     */
    void setExpression( const std::string expression ) throw( std::runtime_error );

    /**
     * @brief Return the expression of the formula.
     * @return expression of the formula.
     */
    std::string getExpression() const { return _expression; }

    VectorDouble evaluate( const VectorDouble &values ) const throw( std::runtime_error );

    /**
     * @brief Assign the context for evaluation
     * @param context context containing objects needed for evaluation.
     * @type  context dict object
     */
    void setContext( PyObject *context ) throw( std::runtime_error ) {
        if ( !PyDict_Check( context ) ) {
            throw std::runtime_error( "Formula: 'dict' object is expected." );
        }
        Py_XDECREF( _context );
        _context = context;
        ( *_pointers )[1] = (long)_context;
        Py_INCREF( _context );
    }

    /**
     * @brief Return the context needed to evaluate the formula.
     * @return context a dict object.
     */
    PyObject *getContext() {
        if ( !_context ) {
            _context = PyDict_New();
            ( *_pointers )[1] = (long)_context;
        }
        Py_INCREF( _context );
        return _context;
    }

    /**
     * @brief Return the properties of the function
     * @return vector of strings
     */
    std::vector< std::string > getProperties() const {
        _property->updateValuePointer();
        std::vector< std::string > prop;
        for ( int i = 0; i < 6; ++i ) {
            prop.push_back( ( *_property )[i].rstrip() );
        }
        return prop;
    }

    /**
     * @brief Update the pointers to the Jeveux objects
     * @return Return true if ok
     */
    bool build() { return _property->updateValuePointer() && _variables->updateValuePointer(); }
};

/**
 * @typedef FormulaPtr
 * @brief  Pointer to a FormulaInstance
 * @author Mathieu Courtois
 */
typedef boost::shared_ptr< FormulaInstance > FormulaPtr;

/**
 * @brief Evaluate Python code of a Formula
 */
VectorDouble evaluate_formula( const PyObject *code, PyObject *globals,
                               const std::vector< std::string > &variables,
                               const VectorDouble &values, int *retcode );

#ifdef __cplusplus
extern "C" {
#endif

void DEFPPSPPPPP( EVAL_FORMULA, eval_formula, ASTERINTEGER *pcode, ASTERINTEGER *pglobals,
                  char *array_vars, STRING_SIZE lenvars, ASTERDOUBLE *array_values,
                  ASTERINTEGER *nbvar, _OUT ASTERINTEGER *iret, ASTERINTEGER *nbres,
                  _OUT ASTERDOUBLE *result );

#ifdef __cplusplus
}
#endif

#endif /* FORMULA_H_ */
