#ifndef GENERICPARAMETER_H_
#define GENERICPARAMETER_H_

/**
 * @file GenericParameter.h
 * @brief Fichier entete de la class GenericParameter
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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

#include <map>
#include <string>
#include <list>
#include "boost/variant.hpp"
#include <iostream>

#include "Utilities/SyntaxDictionary.h"

/**
 * @class GenericParameter
 * @brief 
 * @author Nicolas Sellenet
 */
template< typename Type >
class GenericParameter
{
private:
    std::string _name;
    Type        _valeur;
    bool        _isSet;
    bool        _isMandatory;

public:
    GenericParameter( const std::string name,
                      const bool isMandatory = false ): _name( name ),
                                                        _isSet( false ),
                                                        _isMandatory( isMandatory )
    {
        std::cout << "Ici1 " << name << " " << isMandatory << std::endl;
    };

    GenericParameter( const std::string name, const Type val,
                      const bool isMandatory = false ): _name( name ),
                                                        _valeur( val ),
                                                        _isSet( true ),
                                                        _isMandatory( isMandatory )
    {
        std::cout << "Ici2 " << name << " " << val << " " << isMandatory << std::endl;
    };

    const std::string& getName() const
    {
        return _name;
    };

    const Type& getValue() const throw ( std::runtime_error )
    {
        if ( ! _isSet )
            throw std::runtime_error( "Value of parameter " + _name + " is not set" );
        return _valeur;
    };

    const bool& isMandatory() const
    {
        return _isMandatory;
    };

    const bool& isSet() const
    {
        return _isSet;
    };

    void setMandatory( const bool isSet )
    {
        _isMandatory = isSet;
    };

    void setIsSet( const bool isSet )
    {
        _isSet = isSet;
    };

    void setValue( const Type& valeur )
    {
        _valeur = valeur;
        _isSet = true;
    };

    void setValueIfUnset( const Type& valeur )
    {
        if ( ! _isSet )
            _valeur = valeur;
        _isSet = true;
    };

    GenericParameter& operator=( const Type& valeur )
    {
        _valeur = valeur;
        _isSet = true;
    };
};

typedef GenericParameter< boost::variant< double, int, std::string > > GenParam;

typedef std::list< GenParam* > ListGenParam;
typedef ListGenParam::iterator ListGenParamIter;
typedef ListGenParam::const_iterator ListGenParamCIter;


SyntaxMapContainer buildSyntaxMapFromParamList( const ListGenParam& lParam ) throw ( std::runtime_error );

#endif /* GENERICPARAMETER_H_ */
