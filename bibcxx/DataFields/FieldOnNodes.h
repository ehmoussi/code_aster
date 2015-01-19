#ifndef FIELDONNODES_H_
#define FIELDONNODES_H_

/**
 * @file FieldOnNodes.h
 * @brief Fichier entete de la classe FieldOnNodes
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <string>
#include <assert.h>

#include "MemoryManager/JeveuxVector.h"
#include "DataStructure/DataStructure.h"
#include "RunManager/CommandSyntax.h"
#include "RunManager/LogicalUnitManager.h"

/**
 * @class FieldOnNodesInstance
 * @brief Cette classe template permet de definir un champ aux noeuds Aster
 * @author Nicolas Sellenet
 */
template< class ValueType >
class FieldOnNodesInstance: public DataStructure
{
    private:
        /** @brief Vecteur Jeveux '.DESC' */
        JeveuxVectorLong        _descriptor;
        /** @brief Vecteur Jeveux '.REFE' */
        JeveuxVectorChar24      _reference;
        /** @brief Vecteur Jeveux '.VALE' */
        JeveuxVector<ValueType> _valuesList;

    public:
        /**
         * @brief Constructeur
         * @param name Nom Jeveux du champ aux noeuds
         */
        FieldOnNodesInstance( string name ):
                        DataStructure( name, "CHAM_NO" ),
                        _descriptor( JeveuxVectorLong( getName() + ".DESC" ) ),
                        _reference( JeveuxVectorChar24( getName() + ".REFE" ) ),
                        _valuesList( JeveuxVector< ValueType >( getName() + ".VALE" ) )
        {
            assert(name.size() == 19);
        };

        ~FieldOnNodesInstance()
        {}

        /**
         * @brief Surcharge de l'operateur []
         * @param i Indice dans le tableau Jeveux
         * @return la valeur du tableau Jeveux a la position i
         */
        const ValueType &operator[](int i) const
        {
            return _valuesList->operator[](i);
        };

        /**
         * @brief Impression du champ au format MED
         * @param pathFichier path ne servant pour le moment a rien
         * @return true
        */
        bool printMEDFormat( string pathFichier );

        /**
         * @brief Mise a jour des pointeurs Jeveux
         * @return renvoit true si la mise a jour s'est bien deroulee, false sinon
         */
        bool updateValuePointers()
        {
            bool retour = _descriptor->updateValuePointer();
            retour = ( retour && _reference->updateValuePointer() );
            retour = ( retour && _valuesList->updateValuePointer() );
            return retour;
        };
};

template< class ValueType >
bool FieldOnNodesInstance< ValueType >::printMEDFormat( string pathFichier )
{
    LogicalUnitFile currentFile( pathFichier, Binary, New );
    int currentUL = currentFile.getLogicalUnit();

    CommandSyntax syntaxeImprResu( "IMPR_RESU", false );

    SimpleKeyWordStr mCSChamNo = SimpleKeyWordStr( "FORMAT" );
    mCSChamNo.addValues( "MED" );
    syntaxeImprResu.addSimpleKeywordString( mCSChamNo );

    SimpleKeyWordInt mCSUnite( "UNITE" );
    mCSUnite.addValues( currentUL );
    syntaxeImprResu.addSimpleKeywordInteger( mCSUnite );

    FactorKeyword motCleResu = FactorKeyword( "RESU", false );
    FactorKeywordOccurence occurResu = FactorKeywordOccurence();

    SimpleKeyWordStr mCSChamGd( "CHAM_GD" );
    mCSChamGd.addValues( getName() );
    occurResu.addSimpleKeywordString( mCSChamGd );

    SimpleKeyWordStr mCSInfo( "INFO_MAILLAGE" );
    mCSInfo.addValues( "NON" );
    occurResu.addSimpleKeywordString( mCSInfo );

    SimpleKeyWordStr mCSNomVari( "IMPR_NOM_VARI" );
    mCSNomVari.addValues( "NON" );
    occurResu.addSimpleKeywordString( mCSNomVari );

    motCleResu.addOccurence( occurResu );
    syntaxeImprResu.addFactorKeyword( motCleResu );

    CALL_EXECOP( 39 );

    return true;
};

/**
 * @class FieldOnNodes template
 * @brief Enveloppe d'un pointeur intelligent vers un FieldOnNodesInstance
 * @author Nicolas Sellenet
 */
template<class ValueType>
class FieldOnNodes
{
    public:
        typedef boost::shared_ptr< FieldOnNodesInstance< ValueType > > FieldOnNodesTypePtr;

    private:
        FieldOnNodesTypePtr _fieldOnNodesPtr;

    public:
        FieldOnNodes()
        {};

        FieldOnNodes(string nom): _fieldOnNodesPtr( new FieldOnNodesInstance< ValueType > (nom) )
        {};

        ~FieldOnNodes()
        {};

        FieldOnNodes& operator=(const FieldOnNodes< ValueType >& tmp)
        {
            _fieldOnNodesPtr = tmp._fieldOnNodesPtr;
            return *this;
        };

        const FieldOnNodesTypePtr& operator->(void) const
        {
            return _fieldOnNodesPtr;
        };

        FieldOnNodesInstance<ValueType>* getInstance() const
        {
            return &(*_fieldOnNodesPtr);
        };

        void setInstance( FieldOnNodesInstance< ValueType >* instance )
        {
            _fieldOnNodesPtr = FieldOnNodesTypePtr( instance );
        };

        bool isEmpty() const
        {
            if ( _fieldOnNodesPtr.use_count() == 0 ) return true;
            return false;
        };
};

/** @typedef Definition d'un champ aux noeuds de double */
typedef FieldOnNodes<double> FieldOnNodesDouble;

#endif /* FIELDONNODES_H_ */
