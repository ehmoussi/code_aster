#ifndef EXTERNALVARIABLECONVERTER_H_
#define EXTERNALVARIABLECONVERTER_H_

/**
 * @file ExternalVariablesConverterClass.h
 * @brief Fichier entete de la classe ExternalVariablesConverterClass
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

#include "astercxx.h"

/**
 * @class ExternalVariablesConverterClass
 * @brief Input variable converter
 * @author Nicolas Sellenet
 */
class ExternalVariablesConverterClass
{
  private:
    class Container
    {
      private:
        /** @brief Name of input variable */
        const std::string _externalVariableName;
        /** @brief Names of components */
        const VectorString _compNames;
        /** @brief New type of imput variable */
        const std::string _variableType;
        /** @brief New component names */
        const VectorString _newCompNames;

      public:
        Container( const std::string& iVName, const VectorString& comp1,
                   const std::string& nIVName, const VectorString& comp2 ):
            _externalVariableName( iVName ),
            _compNames( comp1 ),
            _variableType( nIVName ),
            _newCompNames( comp2 )
        {};

        VectorString getComponentNames() const
        {
            return _compNames;
        };

        std::string getName() const
        {
            return _externalVariableName;
        };

        VectorString getNewComponentNames() const
        {
            return _newCompNames;
        };

        std::string getNewVariableType() const
        {
            return _variableType;
        };
    };
    std::vector< Container > _vecOfContainer;

  public:
    void addConverter( const std::string& iVName, const VectorString& comp1,
                       const std::string& nIVName, const VectorString& comp2 )
    {
        _vecOfContainer.push_back( Container( iVName, comp1, nIVName, comp2 ) );
    };

    /**
     * @brief Get component names
     */
    VectorString getComponentNames( const int& pos ) const
    {
        return _vecOfContainer[pos].getComponentNames();
    };

    /**
     * @brief Get variable name
     * @return variable name
     */
    std::string getName( const int& pos ) const
    {
        return _vecOfContainer[pos].getName();
    };

    /**
     * @brief Get new component names
     */
    VectorString getNewComponentNames( const int& pos ) const
    {
        return _vecOfContainer[pos].getNewComponentNames();
    };

    /**
     * @brief Get variable type
     */
    std::string getNewVariableType( const int& pos ) const
    {
        return _vecOfContainer[pos].getNewVariableType();
    };

    /**
     * @brief Get number of converter
     */
    int getNumberOfConverter() const
    {
        return _vecOfContainer.size();
    };
};

/**
 * @typedef ExternalVariablesConverterPtr
 * @brief Pointeur intelligent vers un ExternalVariablesConverterClass
 */
typedef boost::shared_ptr< ExternalVariablesConverterClass > ExternalVariablesConverterPtr;

#endif /* EXTERNALVARIABLECONVERTER_H_ */
