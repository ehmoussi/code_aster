#ifndef STRUCTUREINTERFACE_H_
#define STRUCTUREINTERFACE_H_

/**
 * @file StructureInterface.h
 * @brief Fichier entete de la classe StructureInterface
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

#include "astercxx.h"

#include "DataStructure/DataStructure.h"
#include "MemoryManager/JeveuxCollection.h"
#include "MemoryManager/JeveuxVector.h"
#include "Discretization/DOFNumbering.h"
#include "Loads/PhysicalQuantity.h"
#include "Utilities/CapyConvertibleValue.h"

/**
 * @enum InterfaceTypeEnum
 * @brief Tous les types de bases modales disponibles
 * @author Nicolas Sellenet
 */
enum InterfaceTypeEnum { MacNeal, CraigBampton, HarmonicalCraigBampton, NoInterfaceType };
extern const std::vector< InterfaceTypeEnum > allInterfaceType;
extern const std::vector< std::string > allInterfaceTypeNames;

/**
 * @class StructureInterfaceInstance
 * @brief Cette classe permet de definir les interfaces d'une structure et leur affecter un type
 * @author Nicolas Sellenet
 */
class StructureInterfaceInstance: public DataStructure
{
private:
    /** @brief Numérotation */
    const DOFNumberingPtr    _dofNum;
    double                   _frequency;
    bool                     _isEmpty;

    JeveuxCollectionLong     _codingNumbers;
    JeveuxVectorLong         _numbering;
    JeveuxVectorLong         _description;
    JeveuxCollectionLong     _nodes;
    JeveuxVectorChar8        _names;
    JeveuxVectorChar24       _reference;
    JeveuxVectorChar8        _types;
    JeveuxVectorDouble       _frequencyValue;
    CapyConvertibleContainer _container;

    struct InterfaceDefinition
    {
        const std::string        _name;
        const InterfaceTypeEnum  _type;
        VectorOfGroupOfNodesPtr  _groupsOfNodes;
        const VectorComponent    _components;
        CapyConvertibleContainer _container;

        InterfaceDefinition(const std::string& name, const InterfaceTypeEnum& type,
                            const VectorString& groupsOfNodes,
                            const VectorComponent& components):
            _name( name ),
            _type( type ),
            _components( components ),
            _container( CapyConvertibleContainer( "INTERFACE" ) )
        {
            _container.add( new CapyConvertibleValue< std::string >( true, "NOM", _name, true ) );
            _container.add( new CapyConvertibleValue< InterfaceTypeEnum >( true, "TYPE", _type,
                                                                           allInterfaceType,
                                                                           allInterfaceTypeNames,
                                                                           true ) );

            for( const auto& iter : groupsOfNodes )
                _groupsOfNodes.emplace_back( new GroupOfNodes( iter ) );
            _container.add( new CapyConvertibleValue< VectorOfGroupOfNodesPtr >
                                    ( true, "GROUP_NO", _groupsOfNodes, true ) );

            _container.add( new CapyConvertibleValue< VectorComponent >
                                    ( true, "MASQUE", _components,
                                      allComponents, allComponentsNames, true ) );
        };
    };

    std::vector< InterfaceDefinition > _interfDefs;

public:
    /**
     * @brief Constructeur
     */
    StructureInterfaceInstance( const DOFNumberingPtr& curDof ):
        DataStructure( "INTERF_DYNA_CLAS", Permanent ),
        _dofNum( curDof ),
        _frequency( 1. ),
        _isEmpty( true ),
        _codingNumbers( JeveuxCollectionLong( getName() + ".IDC_DDAC" ) ),
        _numbering( JeveuxVectorLong( getName() + ".IDC_DEFO" ) ),
        _description( JeveuxVectorLong( getName() + ".IDC_DESC" ) ),
        _nodes( JeveuxCollectionLong( getName() + ".IDC_LINO" ) ),
        _names( JeveuxVectorChar8( getName() + ".IDC_NOMS" ) ),
        _reference( JeveuxVectorChar24( getName() + ".IDC_REFE" ) ),
        _types( JeveuxVectorChar8( getName() + ".IDC_TYPE" ) ),
        _frequencyValue( JeveuxVectorDouble( getName() + ".IDC_DY_FREQ" ) )
    {
        _container.add( new CapyConvertibleValue< DOFNumberingPtr >
                                    ( true, "NUME_DDL", _dofNum, true ) );
        _container.add( new CapyConvertibleValue< double >
                                    ( false, "NUME_DDL", _frequency, false ) );
    };

    void addInterface( const std::string& name, const InterfaceTypeEnum& type,
                       const VectorString& groupsOfNodes,
                       const VectorComponent& components = {} )
    {
        _interfDefs.emplace_back( name, type, groupsOfNodes, components );
    };

    bool build() throw( std::runtime_error );
};

/**
 * @typedef StructureInterfacePtr
 * @brief Enveloppe d'un pointeur intelligent vers un StructureInterfaceInstance
 */
typedef boost::shared_ptr< StructureInterfaceInstance > StructureInterfacePtr;

#endif /* STRUCTUREINTERFACE_H_ */
