#ifndef CONVERTIBLEVALUE_H_
#define CCONVERTIBLEVALUE_H_

/**
 * @file ConvertibleValue.h
 * @brief Fichier entete de la class ConvertibleValue
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

#include <map>

 /**
 * @class ConvertibleValue
 * @brief Cette classe template permet de definir une variable convertible
 * @author Nicolas Sellenet
 */
template < class ValueType1, class ValueType2 > class ConvertibleValue {
  public:
    typedef ValueType2 ReturnValue;
    typedef ValueType1 BaseValue;

  private:
    typedef std::map< ValueType1, ValueType2 > mapVal1Val2;
    /** @brief map allowing conversion of ValueType1 into ValueType2 */
    mapVal1Val2 _matchMap;
    /** @brief value to convert */
    ValueType1 _valToConvert;
    /** @brief To know if value is set */
    bool _existsValue;

  public:
    ConvertibleValue() : _existsValue( false ){};

    ConvertibleValue( const mapVal1Val2 &matchMap )
        : _matchMap( matchMap ), _existsValue( false ){};

    ConvertibleValue( const mapVal1Val2 &matchMap, const ValueType1 &val )
        : _matchMap( matchMap ), _valToConvert( val ), _existsValue( true ){};

    void operator=( const ValueType1 &toSet ) {
        _existsValue = true;
        _valToConvert = toSet;
    };

    /**
     * @brief Recuperation de la valeur du parametre
     * @return la valeur du parametre
     */
    const ReturnValue &getValue() const {
        const auto &curIter = _matchMap.find( _valToConvert );
        if ( curIter == _matchMap.end() )
            throw std::runtime_error( "Impossible to convert " + _valToConvert );
        return curIter->second; //_matchMap[ _valToConvert ];
    };

    /**
     * @brief Is value already set ?
     */
    bool hasValue() const { return _existsValue; };

    /**
     * @brief Is value convertible (regarding the map of conversion) ?
     */
    bool isConvertible() const {
        if ( !_existsValue )
            return false;
        const auto &curIter = _matchMap.find( _valToConvert );
        if ( curIter == _matchMap.end() )
            return false;
        return true;
    };
};

#endif
