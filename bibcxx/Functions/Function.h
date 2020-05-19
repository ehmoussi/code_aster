#ifndef FUNCTION_H_
#define FUNCTION_H_

/**
 * @file Function.h
 * @brief Implementation of functions.
 * @section LICENCE
 * Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
#include <boost/shared_ptr.hpp>

#include "MemoryManager/JeveuxVector.h"
#include "Functions/GenericFunction.h"

/**
 * class BaseFunctionClass
 *   Create a datastructure for a function with real values
 * @author Mathieu Courtois
 */
class BaseFunctionClass : public GenericFunctionClass {
  private:

  protected:
    // Vecteur Jeveux '.VALE'
    JeveuxVectorReal _value;

  public:
    /**
     * @typedef BaseFunctionPtr
     * @brief Pointeur intelligent vers un BaseFunction
     */
    typedef boost::shared_ptr< BaseFunctionClass > BaseFunctionPtr;

    /**
     * Constructeur
     */
    BaseFunctionClass( const std::string type, const std::string type2 );

    BaseFunctionClass( const std::string jeveuxName, const std::string type,
                          const std::string type2 );

    ~BaseFunctionClass(){};

    /**
     * @brief Allocate function
     */
    virtual void allocate( JeveuxMemory mem, ASTERINTEGER size );

    /**
     * @brief Deallocate function
     */
    void deallocate();

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
     * @brief Set the function type to CONSTANT
     */
    void setAsConstant();

    /**
     * @brief Definition of the name of the parameter (abscissa)
     * @param name name of the parameter
     * @type  name string
     */
    void setParameterName( const std::string name ) {
        if ( !_property->isAllocated() )
            propertyAllocate();
        ( *_property )[2] = name.substr( 0, 8 ).c_str();
    }

    /**
     * @brief Definition of the name of the result (ordinate)
     * @param name name of the result
     * @type  name string
     */
    void setResultName( const std::string name ) {
        if ( !_property->isAllocated() )
            propertyAllocate();
        ( *_property )[3] = name.substr( 0, 8 ).c_str();
    }

    /**
     * @brief Definition of the type of interpolation
     * @param interpolation type of interpolation
     * @type  interpolation string
     * @todo checking
     */
    void setInterpolation( const std::string type ) ;

    /**
     * @brief Assign the values of the function
     * @param absc values of the abscissa
     * @type  absc vector of double
     * @param ord values of the ordinates
     * @type  ord vector of double
     */
    virtual void setValues( const VectorReal &absc,
                            const VectorReal &ord ) ;

    /**
     * @brief Return the values of the function
     */
    const JeveuxVectorReal getValues() const {
        return _value;
    }

    /**
     * @brief Return a pointer to the vector of data
     */
    const double *getDataPtr() const { return _value->getDataPtr(); }

    /**
     * @brief Return the number of points of the function
     */
    virtual ASTERINTEGER maximumSize() const {
        return _value->size() / 2;
    }

    /**
     * @brief Return the number of points of the function
     */
    virtual ASTERINTEGER size() const { return _value->size() / 2; }

    /**
     * @brief Update the pointers to the Jeveux objects
     * @return Return true if ok
     */
    bool build() { return _property->updateValuePointer() && _value->updateValuePointer(); }
};

/**
 * class FunctionClass
 *   Create a datastructure for a function with real values
 * @author Mathieu Courtois
 */
class FunctionClass : public BaseFunctionClass {

  public:
    /**
     * @typedef FunctionPtr
     * @brief Pointeur intelligent vers un Function
     */
    typedef boost::shared_ptr< FunctionClass > FunctionPtr;

    /**
    * Constructeur
    */
    FunctionClass() : BaseFunctionClass( "FONCTION", "FONCTION" ){};

    FunctionClass( const std::string jeveuxName )
        : BaseFunctionClass( jeveuxName, "FONCTION", "FONCTION" ){};
};

/**
 * class FunctionComplexClass
 *   Create a datastructure for a function with complex values
 * @author Mathieu Courtois
 */
class FunctionComplexClass : public BaseFunctionClass {

  public:
    /**
     * @typedef FunctionPtr
     * @brief Pointeur intelligent vers un FunctionComplex
     */
    typedef boost::shared_ptr< FunctionComplexClass > FunctionComplexPtr;

    /**
    * Constructeur
    */
    FunctionComplexClass( const std::string jeveuxName )
        : BaseFunctionClass( jeveuxName, "FONCTION_C", "FONCT_C" ) {};

    FunctionComplexClass() : BaseFunctionClass( "FONCTION_C", "FONCT_C" ) {};

    /**
     * @brief Allocate function
     */
    void allocate( JeveuxMemory mem, ASTERINTEGER size ) ;

    /**
     * @brief Return the number of points of the function
     */
    virtual ASTERINTEGER maximumSize() const {
        return _value->size() / 3;
    }

    /**
     * @brief Return the number of points of the function
     */
    ASTERINTEGER size() const { return _value->size() / 3; }

    /**
     * @brief Assign the values of the function
     * @param absc values of the abscissa
     * @type  absc vector of double
     * @param ord values of the ordinates (real1, imag1, real2, imag2...)
     * @type  ord vector of double
     */
    void setValues( const VectorReal &absc, const VectorReal &ord ) ;

    /**
     * @brief Assign the values of the function
     * @param absc values of the abscissa
     * @type  absc vector of double
     * @param ord values of the ordinates
     * @type  ord vector of complex
     */
    void setValues( const VectorReal &absc,
                    const VectorComplex &ord ) ;
};

/**
 * @typedef BaseFunctionPtr
 * @brief  Pointer to a BaseFunctionClass
 */
typedef boost::shared_ptr< BaseFunctionClass > BaseFunctionPtr;

/**
 * @typedef FunctionPtr
 * @brief  Pointer to a FunctionClass
 */
typedef boost::shared_ptr< FunctionClass > FunctionPtr;

/**
 * @typedef FunctionComplexPtr
 * @brief  Pointer to a FunctionComplexClass
 */
typedef boost::shared_ptr< FunctionComplexClass > FunctionComplexPtr;

/**
 * @name emptyRealFunction
 * @brief  Empty function
 */
extern FunctionPtr emptyRealFunction;

/**
 * @typedef ListOfFunctions
 * @brief List of double functions
 */
typedef std::list< FunctionPtr > ListOfFunctions;

#endif /* FUNCTION_H_ */
