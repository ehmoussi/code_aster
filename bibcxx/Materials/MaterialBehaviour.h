#ifndef MATERIALBEHAVIOUR_H_
#define MATERIALBEHAVIOUR_H_

/**
 * @file MaterialBehaviour.h
 * @brief Fichier entete de la classe MaterialBehaviour
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

#include <iomanip>
#include <map>
#include <sstream>
#include <string>

#include "astercxx.h"
#include "MemoryManager/JeveuxVector.h"
#include "aster_utils.h"

extern "C"
{
    void CopyCStrToFStr( char *, char *, STRING_SIZE );
}

/**
 * @struct template AllowedMaterialPropertyType
 * @brief Structure permettant de limiter le type instanciable de MaterialPropertyInstance
 * @author Nicolas Sellenet
 */
template<typename T>
struct AllowedMaterialPropertyType;

template<> struct AllowedMaterialPropertyType< double >
{};

template<> struct AllowedMaterialPropertyType< double complex >
{};

/**
 * @class MaterialPropertyInstance
 * @brief Cette classe template permet de definir un type elementaire de propriete materielle
 * @author Nicolas Sellenet
 */
template< class ValueType >
class MaterialPropertyInstance: private AllowedMaterialPropertyType< ValueType >
{
    private:
        /** @brief Nom Aster du type elementaire de propriete materielle */
        // ex : "NU" pour le coefficient de Poisson
        std::string _name;
        /** @brief Description de parametre, ex : "Young's modulus" */
        std::string _description;
        /** @brief Valeur du parametre (double, complex, ...) */
        ValueType   _value;

    public:
        /**
         * @brief Constructeur vide (utile pour ajouter une MaterialPropertyInstance a une std::map
         */
        MaterialPropertyInstance()
        {};

        /**
         * @brief Constructeur
         * @param name Nom Aster du parametre materiau (ex : "NU")
         * @param description Description libre
         */
        MaterialPropertyInstance( std::string name,
                                  std::string description = "" ): _name( name ),
                                                                  _description( description )
        {};

        /**
         * @brief Recuperation de la valeur du parametre
         * @return le nom Aster du parametre
         */
        const std::string& getName() const
        {
            return _name;
        };

        /**
         * @brief Recuperation de la valeur du parametre
         * @return renvoit la valeur du parametre
         */
        const ValueType& getValue() const
        {
            return _value;
        };

        /**
         * @brief Fonction servant a fixer la valeur du parametre
         * @param currentValue valeur donnee par l'utilisateur
         */
        void setValue( ValueType& currentValue )
        {
            _value = currentValue;
        };
};

/** @typedef Definition d'une propriete materiau de type double */
typedef MaterialPropertyInstance< double > ElementaryMaterialPropertyDouble;
/** @typedef Definition d'une propriete materiau de type complexe */
typedef MaterialPropertyInstance< double complex > ElementaryMaterialPropertyComplex;

/**
 * @class GeneralMaterialBehaviourInstance
 * @brief Cette classe permet de definir un ensemble de type elementaire de propriete materielle
 * @author Nicolas Sellenet
 */
class GeneralMaterialBehaviourInstance
{
    protected:
        /** @typedef std::map d'une chaine et d'un ElementaryMaterialPropertyDouble */
        typedef std::map< std::string, ElementaryMaterialPropertyDouble > mapStrEMPD;
        /** @typedef Iterateur sur mapStrEMPD */
        typedef mapStrEMPD::iterator mapStrEMPDIterator;
        /** @typedef Valeur contenue dans un mapStrEMPD */
        typedef mapStrEMPD::value_type mapStrEMPDValue;

        /** @typedef std::map d'une chaine et d'un ElementaryMaterialPropertyComplex */
        typedef std::map< std::string, ElementaryMaterialPropertyComplex > mapStrEMPC;
        /** @typedef Iterateur sur mapStrEMPC */
        typedef mapStrEMPC::iterator mapStrEMPCIterator;
        /** @typedef Valeur contenue dans un mapStrEMPC */
        typedef mapStrEMPC::value_type mapStrEMPCValue;

        /** @typedef std::list< std::string > */
        typedef std::list< std::string > ListString;
        typedef ListString::iterator ListStringIter;

        friend class MaterialInstance;
        /** @brief Chaine correspondant au nom Aster du MaterialBehaviourInstance */
        // ex : ELAS ou ELAS_FO
        std::string              _asterName;
        /** @brief Vector Jeveux 'CPT.XXXXXX.VALC' */
        JeveuxVectorComplex      _complexValues;
        /** @brief Vector Jeveux 'CPT.XXXXXX.VALR' */
        JeveuxVectorDouble       _doubleValues;
        /** @brief Vector Jeveux 'CPT.XXXXXX.VALK' */
        JeveuxVectorChar16       _char16Values;
        /** @brief Map contenant les noms des proprietes double ainsi que les
                   MaterialPropertyInstance correspondant */
        mapStrEMPD               _mapOfDoubleMaterialProperties;
        /** @brief Map contenant les noms des proprietes complex ainsi que les
                   MaterialPropertyInstance correspondant */
        mapStrEMPC               _mapOfComplexMaterialProperties;
        /** @brief Liste contenant tous les noms des parametres materiau */
        ListString _listOfNameOfMaterialProperties;

    public:
        /**
         * @brief Constructeur
         */
        GeneralMaterialBehaviourInstance(): _asterName( " " ),
                                            _complexValues( JeveuxVectorComplex("") ),
                                            _doubleValues( JeveuxVectorDouble("") ),
                                            _char16Values( JeveuxVectorChar16("") )
        {};

        /**
         * @brief Recuperation du nom Aster du GeneralMaterialBehaviourInstance
         *        ex : 'ELAS', 'ELAS_FO', ...
         * @return Chaine contenant le nom Aster
         */
        const std::string getAsterName() const
        {
            return _asterName;
        };

        /**
         * @brief Fonction servant a fixer un parametre materiau au GeneralMaterialBehaviourInstance
         * @param nameOfProperty Nom de la propriete
         * @param value Double correspondant a la valeur donnee par l'utilisateur
         * @return Booleen valant true si la tache s'est bien deroulee
         */
        bool setDoubleValue( std::string nameOfProperty, double value )
        {
            // Recherche de la propriete materielle
            mapStrEMPDIterator curIter = _mapOfDoubleMaterialProperties.find(nameOfProperty);
            if ( curIter ==  _mapOfDoubleMaterialProperties.end() ) return false;
            // Ajout de la valeur
            (*curIter).second.setValue(value);
            return true;
        };

        /**
         * @brief Fonction servant a fixer un parametre materiau au GeneralMaterialBehaviourInstance
         * @param nameOfProperty Nom de la propriete
         * @param value Complex correspondant a la valeur donnee par l'utilisateur
         * @return Booleen valant true si la tache s'est bien deroulee
         */
        bool setComplexValue( std::string nameOfProperty, double complex value )
        {
            // Recherche de la propriete materielle
            mapStrEMPCIterator curIter = _mapOfComplexMaterialProperties.find(nameOfProperty);
            if ( curIter ==  _mapOfComplexMaterialProperties.end() ) return false;
            // Ajout de la valeur
            (*curIter).second.setValue(value);
            return true;
        };

        /**
         * @brief Construction du GeneralMaterialBehaviourInstance
         * @return Booleen valant true si la tache s'est bien deroulee
         */
        bool build() throw ( std::runtime_error );

    private:
        /**
         * @brief Modification a posteriori des objets Jeveux ".VALC", ...
         * @param name Nom des objets Jeveux contenus dans la classe
         */
        void setJeveuxObjectNames( const std::string name )
        {
            _complexValues = JeveuxVectorComplex( name + ".VALC" );
            _doubleValues = JeveuxVectorDouble( name + ".VALR" );
            _char16Values = JeveuxVectorChar16( name + ".VALK" );
        };

    protected:
        bool addDoubleProperty( std::string key, ElementaryMaterialPropertyDouble value )
        {
            _mapOfDoubleMaterialProperties[ key ] = value;
            _listOfNameOfMaterialProperties.push_back( key );
            return true;
        };
};

/**
 * @class ElasticMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau elastique
 * @author Nicolas Sellenet
 */
class ElasticMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasticMaterialBehaviourInstance()
        {
            // Mot cle "ELAS" dans Aster
            _asterName = "ELAS";

            // Deux parametres E et Nu
            this->addDoubleProperty( "E", ElementaryMaterialPropertyDouble( "E", "Young Modulus" ) );
            this->addDoubleProperty( "Nu", ElementaryMaterialPropertyDouble( "NU", "Poisson's ratio" ) );
        };
};

/**
 * class template MaterialBehaviour
 * @brief Enveloppe d'un pointeur intelligent vers un MaterialBehaviourInstance
 * @author Nicolas Sellenet
 */
template< class MaterialBehaviourInstance >
class MaterialBehaviour
{
    public:
        typedef boost::shared_ptr< MaterialBehaviourInstance > MaterialBehaviourPtr;

    private:
        MaterialBehaviourPtr _materialBehaviourPtr;

    public:
        MaterialBehaviour(bool initilisation = true): _materialBehaviourPtr()
        {
            if ( initilisation == true )
                _materialBehaviourPtr = MaterialBehaviourPtr( new MaterialBehaviourInstance() );
        };

        ~MaterialBehaviour()
        {};

        MaterialBehaviour& operator=(const MaterialBehaviour& tmp)
        {
            _materialBehaviourPtr = tmp._materialBehaviourPtr;
            return *this;
        };

        const MaterialBehaviourPtr& operator->() const
        {
            return _materialBehaviourPtr;
        };

        MaterialBehaviourInstance& operator*(void) const
        {
            return *_materialBehaviourPtr;
        };

        bool isEmpty() const
        {
            if ( _materialBehaviourPtr.use_count() == 0 ) return true;
            return false;
        };
};

/** @typedef Definition d'un comportement materiau elastique */
typedef class MaterialBehaviour< ElasticMaterialBehaviourInstance > ElasticMaterialBehaviour;
/** @typedef Definition d'un comportement materiau quelconque */
typedef class MaterialBehaviour< GeneralMaterialBehaviourInstance > GeneralMaterialBehaviour;

#endif /* MATERIALBEHAVIOUR_H_ */
