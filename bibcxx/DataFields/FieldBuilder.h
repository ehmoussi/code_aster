#ifndef FIELDBUILDER_H_
#define FIELDBUILDER_H_

/**
 * @file FieldBuilder.h
 * @brief Header of class FieldBuilder
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

#include "DataFields/FieldOnNodes.h"
#include "DataFields/FieldOnCells.h"
#include "Discretization/DOFNumbering.h"
#include "Modeling/FiniteElementDescriptor.h"

/**
 * @class FieldBuilderClass
 * @brief This class builds FieldOnNodes and FieldOnCells with respect of
 *        FieldOnNodesDescription and FiniteElementDescriptor
 * @author Nicolas Sellenet
 */
class FieldBuilder {
  private:
    std::map< std::string, FieldOnNodesDescriptionPtr > _mapProfChno;
    std::map< std::string, FiniteElementDescriptorPtr > _mapLigrel;

  public:
    /**
     * @brief Constructor
     */
    FieldBuilder(){};

    /**
     * @brief Add a existing FieldOnNodesDescription in FieldBuilder
     */
    void addFieldOnNodesDescription( const FieldOnNodesDescriptionPtr &fond ) {
        _mapProfChno[trim( fond->getName() )] = fond;
    };

    /**
     * @brief Add a existing FiniteElementDescriptor in FieldBuilder
     */
    void addFiniteElementDescriptor( const FiniteElementDescriptorPtr &fed ) {
        _mapLigrel[trim( fed->getName() )] = fed;
    };

    /**
     * @brief Build a FieldOnCells with a FiniteElementDescriptor
     */
    template < typename ValueType >
    boost::shared_ptr< FieldOnCellsClass< ValueType > >
    buildFieldOnCells( const std::string &name, const BaseMeshPtr mesh ) {
        typedef FiniteElementDescriptorClass FEDDesc;
        typedef FiniteElementDescriptorPtr FEDDescP;

        boost::shared_ptr< FieldOnCellsClass< ValueType > > result(
            new FieldOnCellsRealClass( name ) );
        result->updateValuePointers();

        const std::string name2 = trim( ( *( *result )._reference )[0].toString() );

        auto curIter = _mapLigrel.find( name2 );
        FEDDescP curDesc;
        if ( curIter != _mapLigrel.end() )
            curDesc = curIter->second;
        else {
            curDesc = FEDDescP( new FEDDesc( name2, mesh, result->getMemoryType() ) );
            _mapLigrel[name2] = curDesc;
        }
        result->setDescription( curDesc );

        return result;
    };

    /**
     * @brief Build a FieldOnCells with a FieldOnNodesDescription
     */
    template < typename ValueType >
    boost::shared_ptr< FieldOnNodesClass< ValueType > > buildFieldOnNodes( std::string name ) {
        typedef FieldOnNodesDescriptionClass FONDesc;
        typedef FieldOnNodesDescriptionPtr FONDescP;

        boost::shared_ptr< FieldOnNodesClass< ValueType > > result(
            new FieldOnNodesRealClass( name ) );
        result->updateValuePointers();

        const std::string name2 = trim( ( *( *result )._reference )[1].toString() );

        auto curIter = _mapProfChno.find( name2 );
        FONDescP curDesc;
        if ( curIter != _mapProfChno.end() )
            curDesc = curIter->second;
        else {
            curDesc = FONDescP( new FONDesc( name2, result->getMemoryType() ) );
            _mapProfChno[name2] = curDesc;
        }
        result->setDescription( curDesc );

        return result;
    };
};

#endif /* FIELDBUILDER_H_ */
