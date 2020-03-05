#ifndef CONSTANTFIELDONCELLS_H_
#define CONSTANTFIELDONCELLS_H_

/**
 * @file ConstantFieldOnCells.h
 * @brief Fichier entete de la classe ConstantFieldOnCells
 * @author Natacha Bereux
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

/* person_in_charge: natacha.bereux at edf.fr */

#include <assert.h>
#include <stdexcept>
#include <string>

#include "DataFields/DataField.h"
#include "MemoryManager/JeveuxCollection.h"
#include "MemoryManager/JeveuxVector.h"
#include "Meshes/Mesh.h"
#include "Modeling/FiniteElementDescriptor.h"
#include "Modeling/PhysicalQuantityManager.h"
#include "Supervis/ResultNaming.h"
#include "aster_fort.h"
#include "astercxx.h"

/**
 * @class ConstantFieldOnZone Piecewise Constant (PC) Field Zone
 * @author Natacha Bereux
 */
class ConstantFieldOnZone {
  public:
    enum LocalizationType {
        AllMesh,
        AllDelayedElements,
        OnGroupOfElements,
        ListOfElements,
        ListOfDelayedElements
    };

  private:
    BaseMeshPtr _mesh;
    FiniteElementDescriptorPtr _ligrel;
    const LocalizationType _localisation;
    GroupOfElementsPtr _grp;
    VectorLong _indexes;

  public:
    ConstantFieldOnZone( BaseMeshPtr mesh )
        : _mesh( mesh ), _localisation( AllMesh ), _grp( new GroupOfElements( "" ) ){};

    ConstantFieldOnZone( FiniteElementDescriptorPtr ligrel )
        : _ligrel( ligrel ), _localisation( AllDelayedElements ),
          _grp( new GroupOfElements( "" ) ){};

    ConstantFieldOnZone( BaseMeshPtr mesh, GroupOfElementsPtr grp )
        : _mesh( mesh ), _localisation( OnGroupOfElements ), _grp( grp ){};

    ConstantFieldOnZone( BaseMeshPtr mesh, const VectorLong &indexes )
        : _mesh( mesh ), _localisation( ListOfElements ), _grp( new GroupOfElements( "" ) ),
          _indexes( indexes ){};

    ConstantFieldOnZone( FiniteElementDescriptorPtr ligrel, const VectorLong &indexes )
        : _ligrel( ligrel ), _localisation( ListOfDelayedElements ), _indexes( indexes ){};

    BaseMeshPtr getMesh() const {
        if ( _localisation != AllMesh and _localisation != OnGroupOfElements and
             _localisation != ListOfElements )
            throw std::runtime_error( "Zone not on a mesh" );
        return _mesh;
    };

    const FiniteElementDescriptorPtr &getFiniteElementDescriptor() const
        {
        if ( _localisation != AllDelayedElements and _localisation != ListOfDelayedElements )
            throw std::runtime_error( "Zone not on a FiniteElementDescriptor" );
        return _ligrel;
    };

    LocalizationType getLocalizationType() const { return _localisation; };

    GroupOfElementsPtr getGroup() const { return _grp; };

    const VectorLong &getListOfElements() const { return _indexes; };
};

/**
 * @class ConstantFieldValues Piecewise Constant (PC) Field values
 * @author Natacha Bereux
 */
template < class ValueType > class ConstantFieldValues {
  private:
    VectorString _components;
    std::vector< ValueType > _values;

  public:
    ConstantFieldValues( const VectorString &comp, const std::vector< ValueType > &val )
        : _components( comp ), _values( val ){};

    const VectorString &getComponents() const { return _components; };

    const std::vector< ValueType > &getValues() const { return _values; };
};

/**
 * @class ConstantFieldOnCellsClass Piecewise Constant (PC) Field on Mesh template
 * @brief Cette classe permet de definir une carte (champ défini sur les mailles)
 * @author Natacha Bereux
 */
template < class ValueType > class ConstantFieldOnCellsClass : public DataFieldClass {
  private:
    /** @brief Vecteur Jeveux '.NOMA' */
    JeveuxVectorChar8 _meshName;
    /** @brief Vecteur Jeveux '.DESC' */
    JeveuxVectorLong _descriptor;
    /** @brief Vecteur Jeveux '.NOLI' */
    JeveuxVectorChar24 _nameOfLigrels;
    /** @brief Collection  '.LIMA' */
    JeveuxCollectionLong _listOfMeshElements;
    /** @brief Vecteur Jeveux '.VALE' */
    JeveuxVector< ValueType > _valuesList;
    /** @brief Maillage sous-jacent */
    const BaseMeshPtr _mesh;
    /** @brief Ligrel */
    FiniteElementDescriptorPtr _FEDesc;
    /** @brief La carte est-elle allouée ? */
    bool _isAllocated;
    /** @brief Objet temporaire '.NCMP' */
    JeveuxVectorChar8 _componentNames;
    /** @brief Objet temporaire '.VALV' */
    JeveuxVector< ValueType > _valuesListTmp;

  private:
    void fortranAddValues( const ASTERINTEGER &code, const std::string &grp,
                           const std::string &mode, const ASTERINTEGER &nma,
                           const JeveuxVectorLong &limanu, const JeveuxVectorChar8 &component,
                           JeveuxVector< ValueType > &values ) {
        if ( ( code == -1 || code == -3 ) && !_FEDesc )
            throw std::runtime_error(
                "Build of ConstantFieldOnCells impossible, FiniteElementDescriptor is missing" );
        bool test = _componentNames->updateValuePointer();
        test = test && _valuesListTmp->updateValuePointer();
        if ( !test )
            throw std::runtime_error( "ConstantFieldOnCellsClass not allocate" );
        const ASTERINTEGER taille = _componentNames->size();

        const ASTERINTEGER tVerif1 = component->size();
        const ASTERINTEGER tVerif2 = values->size();
        if ( tVerif1 > taille || tVerif2 > taille || tVerif1 != tVerif2 )
            throw std::runtime_error( "Unconsistent size" );

        for ( int position = 0; position < tVerif1; ++position ) {
            ( *_componentNames )[position] = ( *component )[position];
            ( *_valuesListTmp )[position] = ( *values )[position];
        }

        const std::string limano( " " );
        try {
            CALLO_NOCARTC( getName(), &code, &tVerif1, grp, mode, &nma, limano, &( *limanu )[0],
                           _FEDesc->getName() );
        } catch ( ... ) {
            throw;
        }
    };

    void fortranAddValues( const ASTERINTEGER &code, const std::string &grp,
                           const std::string &mode, const ASTERINTEGER &nma,
                           const JeveuxVectorLong &limanu, const VectorString &component,
                           const std::vector< ValueType > &values ) {
        if ( ( code == -1 || code == -3 ) && !_FEDesc )
            throw std::runtime_error(
                "Build of ConstantFieldOnCells impossible, FiniteElementDescriptor is missing" );
        bool test = _componentNames->updateValuePointer();
        test = test && _valuesListTmp->updateValuePointer();
        if ( !test )
            throw std::runtime_error( "ConstantFieldOnCellsClass not allocate" );
        const ASTERINTEGER taille = _componentNames->size();

        const ASTERINTEGER tVerif1 = component.size();
        const ASTERINTEGER tVerif2 = values.size();
        if ( tVerif1 > taille || tVerif2 > taille || tVerif1 != tVerif2 )
            throw std::runtime_error( "Unconsistent size" );

        for ( int position = 0; position < tVerif1; ++position ) {
            ( *_componentNames )[position] = component[position];
            ( *_valuesListTmp )[position] = values[position];
        }
        std::string feDescName( " " );
        if ( _FEDesc != nullptr )
            feDescName = _FEDesc->getName();

        const std::string limano( " " );
        try {
            CALLO_NOCARTC( getName(), &code, &tVerif1, grp, mode, &nma, limano, &( *limanu )[0],
                           feDescName );
        } catch ( ... ) {
            throw;
        }
    };

    void fortranAllocate( const std::string base,
                          const std::string quantity ) {
        try {
            CALLO_ALCART( base, getName(), _mesh->getName(), quantity );
        } catch ( ... ) {
            throw;
        }
    };

  public:
    /**
     * @typedef ConstantFieldOnBaseMeshPtr
     * @brief Pointeur intelligent vers un ConstantFieldOnCells
     */
    typedef boost::shared_ptr< ConstantFieldOnCellsClass > ConstantFieldOnBaseMeshPtr;

    /**
     * @brief Constructeur
     * @param name Nom Jeveux de la carte
     * @param mesh Maillage
     */
    ConstantFieldOnCellsClass( const std::string &name, const BaseMeshPtr &mesh,
                           const JeveuxMemory memType = Permanent )
        : DataFieldClass( name, "CARTE", memType ),
          _meshName( JeveuxVectorChar8( getName() + ".NOMA" ) ),
          _descriptor( JeveuxVectorLong( getName() + ".DESC" ) ),
          _nameOfLigrels( JeveuxVectorChar24( getName() + ".NOLI" ) ),
          _listOfMeshElements( JeveuxCollectionLong( getName() + ".LIMA" ) ),
          _valuesList( JeveuxVector< ValueType >( getName() + ".VALE" ) ), _mesh( mesh ),
          _FEDesc( FiniteElementDescriptorPtr() ), _isAllocated( false ),
          _componentNames( getName() + ".NCMP" ), _valuesListTmp( getName() + ".VALV" ){};

    /**
     * @brief Constructeur
     * @param name Nom Jeveux de la carte
     * @param ligrel Ligrel support
     */
    ConstantFieldOnCellsClass( std::string name, const FiniteElementDescriptorPtr &ligrel,
                           const JeveuxMemory memType = Permanent )
        : DataFieldClass( name, "CARTE", memType ),
          _meshName( JeveuxVectorChar8( getName() + ".NOMA" ) ),
          _descriptor( JeveuxVectorLong( getName() + ".DESC" ) ),
          _nameOfLigrels( JeveuxVectorChar24( getName() + ".NOLI" ) ),
          _listOfMeshElements( JeveuxCollectionLong( getName() + ".LIMA" ) ),
          _valuesList( JeveuxVector< ValueType >( getName() + ".VALE" ) ),
          _mesh( ligrel->getMesh() ), _FEDesc( ligrel ), _isAllocated( false ),
          _componentNames( getName() + ".NCMP" ), _valuesListTmp( getName() + ".VALV" ){};

    /**
     * @brief Constructeur
     * @param mesh Maillage
     * @param name Nom Jeveux de la carte
     */
    ConstantFieldOnCellsClass( const BaseMeshPtr &mesh, const JeveuxMemory memType = Permanent )
        : DataFieldClass( memType, "CARTE" ),
          _meshName( JeveuxVectorChar8( getName() + ".NOMA" ) ),
          _descriptor( JeveuxVectorLong( getName() + ".DESC" ) ),
          _nameOfLigrels( JeveuxVectorChar24( getName() + ".NOLI" ) ),
          _listOfMeshElements( JeveuxCollectionLong( getName() + ".LIMA" ) ),
          _valuesList( JeveuxVector< ValueType >( getName() + ".VALE" ) ), _mesh( mesh ),
          _FEDesc( FiniteElementDescriptorPtr() ), _isAllocated( false ),
          _componentNames( getName() + ".NCMP" ), _valuesListTmp( getName() + ".VALV" ){};

    /**
     * @brief Constructeur
     * @param ligrel Ligrel support
     * @param name Nom Jeveux de la carte
     */
    ConstantFieldOnCellsClass( const FiniteElementDescriptorPtr &ligrel,
                           const JeveuxMemory memType = Permanent )
        : DataFieldClass( memType, "CARTE" ),
          _meshName( JeveuxVectorChar8( getName() + ".NOMA" ) ),
          _descriptor( JeveuxVectorLong( getName() + ".DESC" ) ),
          _nameOfLigrels( JeveuxVectorChar24( getName() + ".NOLI" ) ),
          _listOfMeshElements( JeveuxCollectionLong( getName() + ".LIMA" ) ),
          _valuesList( JeveuxVector< ValueType >( getName() + ".VALE" ) ),
          _mesh( ligrel->getMesh() ), _FEDesc( ligrel ), _isAllocated( false ),
          _componentNames( getName() + ".NCMP" ), _valuesListTmp( getName() + ".VALV" ){};

    typedef boost::shared_ptr< ConstantFieldOnCellsClass< ValueType > >
                                                                ConstantFieldOnCellsValueTypePtr;

    /**
     * @brief Destructeur
     */
    ~ConstantFieldOnCellsClass(){};

    /**
     * @brief Allocation de la carte
     * @return true si l'allocation s'est bien deroulee, false sinon
     */
    void allocate( const JeveuxMemory jeveuxBase,
                   const std::string componant ) {
        if ( _mesh.use_count() == 0 || _mesh->isEmpty() )
            throw std::runtime_error( "Mesh is empty" );

        std::string strJeveuxBase( "V" );
        if ( jeveuxBase == Permanent )
            strJeveuxBase = "G";
        fortranAllocate( strJeveuxBase, componant );
        _isAllocated = true;
    };

    /**
     * @brief Allocation de la carte
     * @return true si l'allocation s'est bien deroulee, false sinon
     */
    void allocate( const JeveuxMemory jeveuxBase,
                   const ConstantFieldOnCellsValueTypePtr &model ) {
        auto componant = model->getPhysicalQuantityName();
        std::string strJeveuxBase( "V" );
        if ( jeveuxBase == Permanent )
            strJeveuxBase = "G";
        fortranAllocate( strJeveuxBase, componant );
        _isAllocated = true;
    };

    /**
     * @brief Deallocate the ConstantField
     */
    void deallocate() {
        _meshName->deallocate();
        _descriptor->deallocate();
        _nameOfLigrels->deallocate();
        _listOfMeshElements->deallocate();
        _valuesList->deallocate();
        _isAllocated = false;
        _componentNames->deallocate();
        _valuesListTmp->deallocate();
    };

    /**
     * @brief Function to know if fiel exists
     * @return true if exists
     */
    bool exists() { return _descriptor->exists(); };

    /**
     * @brief Get support physical quantity
     */
    std::string getPhysicalQuantityName() const {
        _descriptor->updateValuePointer();
        ASTERINTEGER gdeur = ( *_descriptor )[0];
        return PhysicalQuantityManager::Class().getPhysicalQuantityName( gdeur );
    };

    /**
     * @brief Get mesh
     */
    BaseMeshPtr getMesh() const
    {
        return _mesh;
    };

    /**
     * @brief Get values of a zone
     */
    ConstantFieldValues< ValueType > getValues( const int &position ) const {
        _valuesList->updateValuePointer();
        _descriptor->updateValuePointer();
        if ( position >= ( *_descriptor )[2] )
            throw std::runtime_error( "Out of ConstantFieldOnCells bound" );

        ASTERINTEGER nbZoneMax = ( *_descriptor )[1];
        ASTERINTEGER gdeur = ( *_descriptor )[0];
        const auto name1 = PhysicalQuantityManager::Class().getPhysicalQuantityName( gdeur );
        ASTERINTEGER nec = PhysicalQuantityManager::Class().getNumberOfEncodedInteger( gdeur );
        const auto &compNames = PhysicalQuantityManager::Class().getComponentNames( gdeur );
        const ASTERINTEGER nbCmpMax = compNames.size();
        VectorString cmpToReturn;
        std::vector< ValueType > valToReturn;
        for ( int i = 0; i < nec; ++i ) {
            ASTERINTEGER encodedInt = ( *_descriptor )[3 + 2 * nbZoneMax + position * nec + i];
            VectorLong vecOfComp( 30, -1 );
            CALL_ISDECO( &encodedInt, vecOfComp.data(), &nec );
            ASTERINTEGER pos = 0;
            for ( const auto &val : vecOfComp ) {
                if ( val == 1 ) {
                    cmpToReturn.push_back( compNames[pos + i * 30].toString() );
                    const ASTERINTEGER posInVale = pos + i * 30 + nbCmpMax * position;
                    valToReturn.push_back( ( *_valuesList )[posInVale] );
                }
                ++pos;
            }
        }
        return ConstantFieldValues< ValueType >( cmpToReturn, valToReturn );
    };

    /**
     * @brief Get zone description
     */
    ConstantFieldOnZone getZoneDescription( const int &position ) const {
        _descriptor->updateValuePointer();
        if ( position >= ( *_descriptor )[2] )
            throw std::runtime_error( "Out of ConstantFieldOnCells bound" );

        ASTERINTEGER code = ( *_descriptor )[3 + 2 * position];
        if ( code == 1 )
            return ConstantFieldOnZone( _mesh );
        else if ( code == -1 )
            return ConstantFieldOnZone( _FEDesc );
        else if ( code == 2 ) {
            const auto numGrp = ( *_descriptor )[4 + 2 * position];
            const auto &map = _mesh->getGroupOfNodesNames();
            const auto name = map->findStringOfElement( numGrp );
            return ConstantFieldOnZone( _mesh, GroupOfElementsPtr( new GroupOfElements( name ) ) );
        } else if ( code == 3 ) {
            const auto numGrp = ( *_descriptor )[4 + 2 * position];
            _listOfMeshElements->buildFromJeveux();
            const auto &object = _listOfMeshElements->getObject( numGrp );
            return ConstantFieldOnZone( _mesh, object.toVector() );
        } else if ( code == -3 ) {
            const auto numGrp = ( *_descriptor )[4 + 2 * position];
            _listOfMeshElements->buildFromJeveux();
            const auto &object = _listOfMeshElements->getObject( numGrp );
            return ConstantFieldOnZone( _FEDesc, object.toVector() );
        } else
            throw std::runtime_error( "Error in ConstantFieldOnCells" );
    };

    /**
     * @brief Fixer une valeur sur tout le maillage
     * @param component JeveuxVectorChar8 contenant le nom des composantes à fixer
     * @param values JeveuxVector< ValueType > contenant les valeurs
     * @return renvoit true si l'ajout s'est bien deroulee, false sinon
     */
    bool setValueOnAllMesh( const JeveuxVectorChar8 &component,
                            const JeveuxVector< ValueType > &values ) {
        if ( _mesh.use_count() == 0 || _mesh->isEmpty() )
            throw std::runtime_error( "Mesh is empty" );

        const ASTERINTEGER code = 1;
        const std::string grp( " " );
        const std::string mode( " " );
        const ASTERINTEGER nbMa = 0;
        JeveuxVectorLong limanu( "empty" );
        limanu->allocate( Temporary, 1 );
        fortranAddValues( code, grp, mode, nbMa, limanu, component, values );
        return true;
    };

    /**
     * @brief Fixer une valeur sur un groupe de mailles
     * @param component JeveuxVectorChar8 contenant le nom des composantes à fixer
     * @param values JeveuxVector< ValueType > contenant les valeurs
     * @param grp Groupe de mailles
     * @return renvoit true si l'ajout s'est bien deroulee, false sinon
     */
    bool setValueOnListOfDelayedElements( const JeveuxVectorChar8 &component,
                                          const JeveuxVector< ValueType > &values,
                                          const VectorLong &grp ) {
        if ( _mesh.use_count() == 0 || _mesh->isEmpty() )
            throw std::runtime_error( "Mesh is empty" );

        const ASTERINTEGER code = -3;
        const std::string grp2( " " );
        const std::string mode( "NUM" );
        const ASTERINTEGER nbMa = 0;
        JeveuxVectorLong limanu( "&&TEMPORARY" );
        limanu->allocate( Temporary, grp.size() );
        for ( ASTERINTEGER pos = 0; pos < grp.size(); ++pos )
            ( *limanu )[pos] = grp[pos];
        fortranAddValues( code, grp2, mode, nbMa, limanu, component, values );
        return true;
    };

    /**
     * @brief Fixer une valeur sur un groupe de mailles
     * @param component JeveuxVectorChar8 contenant le nom des composantes à fixer
     * @param values JeveuxVector< ValueType > contenant les valeurs
     * @param grp Groupe de mailles
     * @return renvoit true si l'ajout s'est bien deroulee, false sinon
     */
    bool setValueOnGroupOfElements( const JeveuxVectorChar8 &component,
                                    const JeveuxVector< ValueType > &values,
                                    const GroupOfElements &grp ) {
        if ( _mesh.use_count() == 0 || _mesh->isEmpty() )
            throw std::runtime_error( "Mesh is empty" );
        if ( !_mesh->hasGroupOfElements( grp.getName() ) )
            throw std::runtime_error( "Group " + grp.getName() + " not in mesh" );

        const ASTERINTEGER code = 2;
        const std::string mode( " " );
        const ASTERINTEGER nbMa = 0;
        JeveuxVectorLong limanu( "empty" );
        limanu->allocate( Temporary, 1 );
        fortranAddValues( code, grp.getName(), mode, nbMa, limanu, component, values );
        return true;
    };

    /**
     * @brief Fixer une valeur sur un groupe de mailles
     * @param zone Zone sur laquelle on alloue la carte
     * @param values Valeur a allouer
     * @return renvoit true si l'ajout s'est bien deroulee, false sinon
     */
    bool setValueOnZone( const ConstantFieldOnZone &zone,
                         const ConstantFieldValues< ValueType > &values ) {
        if ( _mesh.use_count() == 0 || _mesh->isEmpty() )
            throw std::runtime_error( "Mesh is empty" );

        ASTERINTEGER code = 0;
        std::string grp( " " );
        std::string mode( " " );
        ASTERINTEGER nbMa = 0;
        JeveuxVectorLong limanu( "&&TEMPORARY" );
        if ( zone.getLocalizationType() == ConstantFieldOnZone::AllMesh ) {
            code = 1;
            limanu->allocate( Temporary, 1 );
        } else if ( zone.getLocalizationType() == ConstantFieldOnZone::AllDelayedElements ) {
            code = -1;
            limanu->allocate( Temporary, 1 );
        } else if ( zone.getLocalizationType() == ConstantFieldOnZone::OnGroupOfElements ) {
            code = 2;
            grp = zone.getGroup()->getName();
            limanu->allocate( Temporary, 1 );
        } else if ( zone.getLocalizationType() == ConstantFieldOnZone::ListOfElements ) {
            code = 3;
            mode = "NUM";
            const auto &vecTmp = zone.getListOfElements();
            nbMa = vecTmp.size();
            limanu->allocate( Temporary, nbMa );
            for ( ASTERINTEGER pos = 0; pos < nbMa; ++pos )
                ( *limanu )[pos] = vecTmp[pos];
        } else if ( zone.getLocalizationType() == ConstantFieldOnZone::ListOfDelayedElements ) {
            code = -3;
            mode = "NUM";
            const auto &vecTmp = zone.getListOfElements();
            nbMa = vecTmp.size();
            limanu->allocate( Temporary, nbMa );
            for ( ASTERINTEGER pos = 0; pos < nbMa; ++pos )
                ( *limanu )[pos] = vecTmp[pos];
        }
        fortranAddValues( code, grp, mode, nbMa, limanu, values.getComponents(),
                          values.getValues() );
        return true;
    };

    /**
     * @brief Get number of zone in ConstantFieldOnCells
     */
    int size() const {
        _descriptor->updateValuePointer();
        return ( *_descriptor )[2];
    };

    /**
     * @brief Mise a jour des pointeurs Jeveux
     * @return true si la mise a jour s'est bien deroulee, false sinon
     */
    bool updateValuePointers() {
        bool retour = _meshName->updateValuePointer();
        retour = ( retour && _descriptor->updateValuePointer() );
        retour = ( retour && _valuesList->updateValuePointer() );
        // Les deux elements suivants sont facultatifs
        _listOfMeshElements->buildFromJeveux();
        _nameOfLigrels->updateValuePointer();
        return retour;
    };
};

/** @typedef ConstantFieldOnCellsRealClass Class d'une carte de double */
typedef ConstantFieldOnCellsClass< double > ConstantFieldOnCellsRealClass;
/** @typedef ConstantFieldOnCellsLongClass Class d'une carte de long */
typedef ConstantFieldOnCellsClass< ASTERINTEGER > ConstantFieldOnCellsLongClass;
/** @typedef ConstantFieldOnCellsComplexClass Class d'une carte de complexe */
typedef ConstantFieldOnCellsClass< RealComplex > ConstantFieldOnCellsComplexClass;
/** @typedef ConstantFieldOnCellsChar8Class Class d'une carte de char*8 */
typedef ConstantFieldOnCellsClass< JeveuxChar8 > ConstantFieldOnCellsChar8Class;
/** @typedef ConstantFieldOnCellsChar16Class Class d'une carte de char*16 */
typedef ConstantFieldOnCellsClass< JeveuxChar8 > ConstantFieldOnCellsChar16Class;

/**
 * @typedef ConstantFieldOnBaseMeshPtrReal
 * @brief   Definition d'une carte de double
 */
typedef boost::shared_ptr< ConstantFieldOnCellsRealClass > ConstantFieldOnCellsRealPtr;

/**
 * @typedef ConstantFieldOnCellsLongPtr
 * @brief   Definition d'une carte de double
 */
typedef boost::shared_ptr< ConstantFieldOnCellsLongClass > ConstantFieldOnCellsLongPtr;

/**
 * @typedef ConstantFieldOnBaseMeshPtrComplex
 * @brief   Definition d'une carte de complexe
 */
typedef boost::shared_ptr< ConstantFieldOnCellsComplexClass > ConstantFieldOnCellsComplexPtr;

/**
 * @typedef ConstantFieldOnBaseMeshPtrChar8 Definition d'une carte de char[8]
 * @brief Pointeur intelligent vers un ConstantFieldOnCellsClass
 */
typedef boost::shared_ptr< ConstantFieldOnCellsChar8Class > ConstantFieldOnCellsChar8Ptr;

/**
 * @typedef ConstantFieldOnBaseMeshPtrChar16 Definition d'une carte de char[16]
 * @brief Pointeur intelligent vers un ConstantFieldOnCellsClass
 */
typedef boost::shared_ptr< ConstantFieldOnCellsChar16Class > ConstantFieldOnCellsChar16Ptr;
#endif /* CONSTANTFIELDONCELLS_H_ */
