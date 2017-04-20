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
#include "Function/Function.h"

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

template<> struct AllowedMaterialPropertyType< FunctionPtr >
{};

/**
 * @class MaterialPropertyInstance
 * @brief Cette classe template permet de definir un type elementaire de propriete materielle
 * @author Nicolas Sellenet
 * @todo on pourrait detemplatiser cette classe pour qu'elle prenne soit des doubles soit des fct
 *       on pourrait alors fusionner elas et elasFo par exemple
 */
template< class ValueType >
class MaterialPropertyInstance: private AllowedMaterialPropertyType< ValueType >
{
    private:
        /** @brief Nom Aster du type elementaire de propriete materielle */
        // ex : "NU" pour le coefficient de Poisson
        std::string _name;
        /** @brief Booleen qui precise si la propriété est obligatoire */
        bool        _isMandatory;
        /** @brief Description de parametre, ex : "Young's modulus" */
        std::string _description;
        /** @brief Valeur du parametre (double, FunctionPtr, ...) */
        ValueType   _value;
        /** @brief Booleen qui precise si la propriété a été initialisée */
        bool        _existsValue;

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
        MaterialPropertyInstance( const std::string name,
                                  const bool isMandatory = false,
                                  const std::string description = "" ): _name( name ),
                                                                        _isMandatory( isMandatory ),
                                                                        _description( description ),
                                                                        _existsValue( false )
        {};

        /**
         * @brief Constructeur
         * @param name Nom Aster du parametre materiau (ex : "NU")
         * @param ValueType Valeur par défaut
         * @param description Description libre
         */
        MaterialPropertyInstance( const std::string name,
                                  const ValueType& currentValue,
                                  const bool isMandatory = false,
                                  const std::string description = "" ): _name( name ),
                                                                        _isMandatory( isMandatory ),
                                                                        _description( description ),
                                                                        _value( currentValue ),
                                                                        _existsValue( true )
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
         * @return la valeur du parametre
         */
        const ValueType& getValue() const
        {
            return _value;
        };

        /**
         * @brief Cette propriété est-elle obligatoire ?
         * @return true si la propriété est obligatoire
         */
        bool isMandatory() const
        {
            return _isMandatory;
        };

        /**
         * @brief Cette propriété a-t-elle une valeur fixée par l'utilisateur ?
         * @return true si la valeur a été précisée
         */
        bool hasValue() const
        {
            return _existsValue;
        };

        /**
         * @brief Fonction servant a fixer la valeur du parametre
         * @param currentValue valeur donnee par l'utilisateur
         */
        void setValue( ValueType& currentValue )
        {
            _existsValue = true;
            _value = currentValue;
        };
};

/** @typedef Definition d'une propriete materiau de type double */
typedef MaterialPropertyInstance< double > ElementaryMaterialPropertyDouble;
/** @typedef Definition d'une propriete materiau de type Function */
typedef MaterialPropertyInstance< FunctionPtr > ElementaryMaterialPropertyFunction;

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
        typedef mapStrEMPD::const_iterator mapStrEMPDConstIterator;
        /** @typedef Valeur contenue dans un mapStrEMPD */
        typedef mapStrEMPD::value_type mapStrEMPDValue;

        /** @typedef std::map d'une chaine et d'un ElementaryMaterialPropertyFunction */
        typedef std::map< std::string, ElementaryMaterialPropertyFunction > mapStrEMPF;
        /** @typedef Iterateur sur mapStrEMPF */
        typedef mapStrEMPF::iterator mapStrEMPFIterator;
        typedef mapStrEMPF::const_iterator mapStrEMPFConstIterator;
        /** @typedef Valeur contenue dans un mapStrEMPF */
        typedef mapStrEMPF::value_type mapStrEMPFValue;

        /** @typedef std::list< std::string > */
        typedef std::list< std::string > ListString;
        typedef ListString::iterator ListStringIter;
        typedef ListString::const_iterator ListStringConstIter;

        /** @brief Chaine correspondant au nom Aster du MaterialBehaviourInstance */
        // ex : ELAS ou ELASFo
        std::string              _asterName;
        /** @brief Map contenant les noms des proprietes double ainsi que les
                   MaterialPropertyInstance correspondant */
        mapStrEMPD               _mapOfDoubleMaterialProperties;
        /** @brief Map contenant les noms des proprietes function ainsi que les
                   MaterialPropertyInstance correspondant */
        mapStrEMPF               _mapOfFunctionMaterialProperties;
        /** @brief Liste contenant tous les noms des parametres materiau */
        ListString               _listOfNameOfMaterialProperties;

    public:
        /**
         * @brief Constructeur
         */
        GeneralMaterialBehaviourInstance()
        {};

        /**
         * @brief Recuperation du nom Aster du GeneralMaterialBehaviourInstance
         *        ex : 'ELAS', 'ELASFo', ...
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
         * @param value Function correspondant a la valeur donnee par l'utilisateur
         * @return Booleen valant true si la tache s'est bien deroulee
         */
        bool setFunctionValue( std::string nameOfProperty, FunctionPtr value )
        {
            // Recherche de la propriete materielle
            mapStrEMPFIterator curIter = _mapOfFunctionMaterialProperties.find(nameOfProperty);
            if ( curIter ==  _mapOfFunctionMaterialProperties.end() ) return false;
            // Ajout de la valeur
            (*curIter).second.setValue(value);
            return true;
        };

        /**
         * @brief Construction du GeneralMaterialBehaviourInstance
         * @return Booleen valant true si la tache s'est bien deroulee
         * @todo vérifier les valeurs réelles par défaut du .VALR
         */
        bool buildJeveuxVectors( JeveuxVectorComplex& complexValues,
                                 JeveuxVectorDouble& doubleValues,
                                 JeveuxVectorChar16& char16Values ) const
            throw ( std::runtime_error );

    protected:
        bool addDoubleProperty( std::string key, ElementaryMaterialPropertyDouble value )
        {
            _mapOfDoubleMaterialProperties[ key ] = value;
            _listOfNameOfMaterialProperties.push_back( key );
            return true;
        };

        bool addFunctionProperty( std::string key, ElementaryMaterialPropertyFunction value )
        {
            _mapOfFunctionMaterialProperties[ key ] = value;
            _listOfNameOfMaterialProperties.push_back( key );
            return true;
        };

};

/**
 * @class ElasMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Elas
 * @author Jean-Pierre Lefebvre
 */
class ElasMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasMaterialBehaviourInstance()
        {
            // Mot cle "ELAS" dans Aster
            _asterName = "ELAS";

            // Parametres matériau
            this->addDoubleProperty( "E", ElementaryMaterialPropertyDouble( "E" , true ) );
            this->addDoubleProperty( "Nu", ElementaryMaterialPropertyDouble( "NU" , true ) );
            this->addDoubleProperty( "Rho", ElementaryMaterialPropertyDouble( "RHO" , false ) );
            this->addDoubleProperty( "Alpha", ElementaryMaterialPropertyDouble( "ALPHA" , false ) );
            this->addDoubleProperty( "Amor_alpha", ElementaryMaterialPropertyDouble( "AMOR_ALPHA" , false ) );
            this->addDoubleProperty( "Amor_beta", ElementaryMaterialPropertyDouble( "AMOR_BETA" , false ) );
            this->addDoubleProperty( "Amor_hyst", ElementaryMaterialPropertyDouble( "AMOR_HYST" , false ) );
            this->addDoubleProperty( "Long_cara", ElementaryMaterialPropertyDouble( "LONG_CARA" , 0., false ) );
            this->addDoubleProperty( "Coef_amor", ElementaryMaterialPropertyDouble( "COEF_AMOR" , 1., false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Elas */
typedef boost::shared_ptr< ElasMaterialBehaviourInstance > ElasMaterialBehaviourPtr;


/**
 * @class ElasFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ElasFo
 * @author Jean-Pierre Lefebvre
 */
class ElasFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasFoMaterialBehaviourInstance()
        {
            // Mot cle "ELAS_FO" dans Aster
            _asterName = "ELAS_FO";

            // Parametres matériau
            this->addFunctionProperty( "E", ElementaryMaterialPropertyFunction( "E" , true ) );
            this->addFunctionProperty( "Nu", ElementaryMaterialPropertyFunction( "NU" , true ) );
            this->addDoubleProperty( "Rho", ElementaryMaterialPropertyDouble( "RHO" , false ) );
            this->addDoubleProperty( "Temp_def_alpha", ElementaryMaterialPropertyDouble( "TEMP_DEF_ALPHA" , false ) );
            this->addDoubleProperty( "Precision", ElementaryMaterialPropertyDouble( "PRECISION" , 1. , false ) );
            this->addFunctionProperty( "Alpha", ElementaryMaterialPropertyFunction( "ALPHA" , false ) );
            this->addFunctionProperty( "Amor_alpha", ElementaryMaterialPropertyFunction( "AMOR_ALPHA" , false ) );
            this->addFunctionProperty( "Amor_beta", ElementaryMaterialPropertyFunction( "AMOR_BETA" , false ) );
            this->addFunctionProperty( "Amor_hyst", ElementaryMaterialPropertyFunction( "AMOR_HYST" , false ) );
            this->addDoubleProperty( "K_dessic", ElementaryMaterialPropertyDouble( "K_DESSIC" , 0.E+0 , false ) );
            this->addDoubleProperty( "B_endoge", ElementaryMaterialPropertyDouble( "B_ENDOGE" , 0.E+0 , false ) );
            this->addFunctionProperty( "Fonc_desorp", ElementaryMaterialPropertyFunction( "FONC_DESORP" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasFo */
typedef boost::shared_ptr< ElasFoMaterialBehaviourInstance > ElasFoMaterialBehaviourPtr;


/**
 * @class ElasFluiMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ElasFlui
 * @author Jean-Pierre Lefebvre
 */
class ElasFluiMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasFluiMaterialBehaviourInstance()
        {
            // Mot cle "ELAS_FLUI" dans Aster
            _asterName = "ELAS_FLUI";

            // Parametres matériau
            this->addDoubleProperty( "E", ElementaryMaterialPropertyDouble( "E" , true ) );
            this->addDoubleProperty( "Nu", ElementaryMaterialPropertyDouble( "NU" , true ) );
            this->addDoubleProperty( "Rho", ElementaryMaterialPropertyDouble( "RHO" , true ) );
            this->addFunctionProperty( "Prof_rho_f_int", ElementaryMaterialPropertyFunction( "PROF_RHO_F_INT" , true ) );
            this->addFunctionProperty( "Prof_rho_f_ext", ElementaryMaterialPropertyFunction( "PROF_RHO_F_EXT" , true ) );
            this->addFunctionProperty( "Coef_mass_ajou", ElementaryMaterialPropertyFunction( "COEF_MASS_AJOU" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasFlui */
typedef boost::shared_ptr< ElasFluiMaterialBehaviourInstance > ElasFluiMaterialBehaviourPtr;


/**
 * @class ElasIstrMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ElasIstr
 * @author Jean-Pierre Lefebvre
 */
class ElasIstrMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasIstrMaterialBehaviourInstance()
        {
            // Mot cle "ELAS_ISTR" dans Aster
            _asterName = "ELAS_ISTR";

            // Parametres matériau
            this->addDoubleProperty( "E_l", ElementaryMaterialPropertyDouble( "E_L" , true ) );
            this->addDoubleProperty( "E_n", ElementaryMaterialPropertyDouble( "E_N" , true ) );
            this->addDoubleProperty( "Nu_lt", ElementaryMaterialPropertyDouble( "NU_LT" , true ) );
            this->addDoubleProperty( "Nu_ln", ElementaryMaterialPropertyDouble( "NU_LN" , true ) );
            this->addDoubleProperty( "G_ln", ElementaryMaterialPropertyDouble( "G_LN" , true ) );
            this->addDoubleProperty( "Rho", ElementaryMaterialPropertyDouble( "RHO" , false ) );
            this->addDoubleProperty( "Alpha_l", ElementaryMaterialPropertyDouble( "ALPHA_L" , 0.E+0 , false ) );
            this->addDoubleProperty( "Alpha_n", ElementaryMaterialPropertyDouble( "ALPHA_N" , 0.E+0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasIstr */
typedef boost::shared_ptr< ElasIstrMaterialBehaviourInstance > ElasIstrMaterialBehaviourPtr;


/**
 * @class ElasIstrFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ElasIstrFo
 * @author Jean-Pierre Lefebvre
 */
class ElasIstrFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasIstrFoMaterialBehaviourInstance()
        {
            // Mot cle "ELAS_ISTR_FO" dans Aster
            _asterName = "ELAS_ISTR_FO";

            // Parametres matériau
            this->addFunctionProperty( "E_l", ElementaryMaterialPropertyFunction( "E_L" , true ) );
            this->addFunctionProperty( "E_n", ElementaryMaterialPropertyFunction( "E_N" , true ) );
            this->addFunctionProperty( "Nu_lt", ElementaryMaterialPropertyFunction( "NU_LT" , true ) );
            this->addFunctionProperty( "Nu_ln", ElementaryMaterialPropertyFunction( "NU_LN" , true ) );
            this->addFunctionProperty( "G_ln", ElementaryMaterialPropertyFunction( "G_LN" , true ) );
            this->addDoubleProperty( "Rho", ElementaryMaterialPropertyDouble( "RHO" , false ) );
            this->addDoubleProperty( "Temp_def_alpha", ElementaryMaterialPropertyDouble( "TEMP_DEF_ALPHA" , false ) );
            this->addDoubleProperty( "Precision", ElementaryMaterialPropertyDouble( "PRECISION" , 1. , false ) );
            this->addFunctionProperty( "Alpha_l", ElementaryMaterialPropertyFunction( "ALPHA_L" , false ) );
            this->addFunctionProperty( "Alpha_n", ElementaryMaterialPropertyFunction( "ALPHA_N" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasIstrFo */
typedef boost::shared_ptr< ElasIstrFoMaterialBehaviourInstance > ElasIstrFoMaterialBehaviourPtr;


/**
 * @class ElasOrthMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ElasOrth
 * @author Jean-Pierre Lefebvre
 */
class ElasOrthMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasOrthMaterialBehaviourInstance()
        {
            // Mot cle "ELAS_ORTH" dans Aster
            _asterName = "ELAS_ORTH";

            // Parametres matériau
            this->addDoubleProperty( "E_l", ElementaryMaterialPropertyDouble( "E_L" , true ) );
            this->addDoubleProperty( "E_t", ElementaryMaterialPropertyDouble( "E_T" , true ) );
            this->addDoubleProperty( "E_n", ElementaryMaterialPropertyDouble( "E_N" , false ) );
            this->addDoubleProperty( "Nu_lt", ElementaryMaterialPropertyDouble( "NU_LT" , true ) );
            this->addDoubleProperty( "Nu_ln", ElementaryMaterialPropertyDouble( "NU_LN" , false ) );
            this->addDoubleProperty( "Nu_tn", ElementaryMaterialPropertyDouble( "NU_TN" , false ) );
            this->addDoubleProperty( "G_lt", ElementaryMaterialPropertyDouble( "G_LT" , true ) );
            this->addDoubleProperty( "G_ln", ElementaryMaterialPropertyDouble( "G_LN" , false ) );
            this->addDoubleProperty( "G_tn", ElementaryMaterialPropertyDouble( "G_TN" , false ) );
            this->addDoubleProperty( "Rho", ElementaryMaterialPropertyDouble( "RHO" , false ) );
            this->addDoubleProperty( "Alpha_l", ElementaryMaterialPropertyDouble( "ALPHA_L" , 0.E+0 , false ) );
            this->addDoubleProperty( "Alpha_t", ElementaryMaterialPropertyDouble( "ALPHA_T" , 0.E+0 , false ) );
            this->addDoubleProperty( "Alpha_n", ElementaryMaterialPropertyDouble( "ALPHA_N" , 0.E+0 , false ) );
            this->addDoubleProperty( "Xt", ElementaryMaterialPropertyDouble( "XT" , 1. , false ) );
            this->addDoubleProperty( "Xc", ElementaryMaterialPropertyDouble( "XC" , 1. , false ) );
            this->addDoubleProperty( "Yt", ElementaryMaterialPropertyDouble( "YT" , 1. , false ) );
            this->addDoubleProperty( "Yc", ElementaryMaterialPropertyDouble( "YC" , 1. , false ) );
            this->addDoubleProperty( "S_lt", ElementaryMaterialPropertyDouble( "S_LT" , 1. , false ) );
            this->addDoubleProperty( "Amor_alpha", ElementaryMaterialPropertyDouble( "AMOR_ALPHA" , false ) );
            this->addDoubleProperty( "Amor_beta", ElementaryMaterialPropertyDouble( "AMOR_BETA" , false ) );
            this->addDoubleProperty( "Amor_hyst", ElementaryMaterialPropertyDouble( "AMOR_HYST" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasOrth */
typedef boost::shared_ptr< ElasOrthMaterialBehaviourInstance > ElasOrthMaterialBehaviourPtr;


/**
 * @class ElasOrthFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ElasOrthFo
 * @author Jean-Pierre Lefebvre
 */
class ElasOrthFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasOrthFoMaterialBehaviourInstance()
        {
            // Mot cle "ELAS_ORTH_FO" dans Aster
            _asterName = "ELAS_ORTH_FO";

            // Parametres matériau
            this->addFunctionProperty( "E_l", ElementaryMaterialPropertyFunction( "E_L" , true ) );
            this->addFunctionProperty( "E_t", ElementaryMaterialPropertyFunction( "E_T" , true ) );
            this->addFunctionProperty( "E_n", ElementaryMaterialPropertyFunction( "E_N" , true ) );
            this->addFunctionProperty( "Nu_lt", ElementaryMaterialPropertyFunction( "NU_LT" , true ) );
            this->addFunctionProperty( "Nu_ln", ElementaryMaterialPropertyFunction( "NU_LN" , true ) );
            this->addFunctionProperty( "Nu_tn", ElementaryMaterialPropertyFunction( "NU_TN" , true ) );
            this->addFunctionProperty( "G_lt", ElementaryMaterialPropertyFunction( "G_LT" , true ) );
            this->addFunctionProperty( "G_ln", ElementaryMaterialPropertyFunction( "G_LN" , true ) );
            this->addFunctionProperty( "G_tn", ElementaryMaterialPropertyFunction( "G_TN" , true ) );
            this->addDoubleProperty( "Rho", ElementaryMaterialPropertyDouble( "RHO" , false ) );
            this->addDoubleProperty( "Temp_def_alpha", ElementaryMaterialPropertyDouble( "TEMP_DEF_ALPHA" , false ) );
            this->addDoubleProperty( "Precision", ElementaryMaterialPropertyDouble( "PRECISION" , 1. , false ) );
            this->addFunctionProperty( "Alpha_l", ElementaryMaterialPropertyFunction( "ALPHA_L" , false ) );
            this->addFunctionProperty( "Alpha_t", ElementaryMaterialPropertyFunction( "ALPHA_T" , false ) );
            this->addFunctionProperty( "Alpha_n", ElementaryMaterialPropertyFunction( "ALPHA_N" , false ) );
            this->addFunctionProperty( "Amor_alpha", ElementaryMaterialPropertyFunction( "AMOR_ALPHA" , false ) );
            this->addFunctionProperty( "Amor_beta", ElementaryMaterialPropertyFunction( "AMOR_BETA" , false ) );
            this->addFunctionProperty( "Amor_hyst", ElementaryMaterialPropertyFunction( "AMOR_HYST" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasOrthFo */
typedef boost::shared_ptr< ElasOrthFoMaterialBehaviourInstance > ElasOrthFoMaterialBehaviourPtr;


/**
 * @class ElasHyperMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ElasHyper
 * @author Jean-Pierre Lefebvre
 */
class ElasHyperMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasHyperMaterialBehaviourInstance()
        {
            // Mot cle "ELAS_HYPER" dans Aster
            _asterName = "ELAS_HYPER";

            // Parametres matériau
            this->addDoubleProperty( "C10", ElementaryMaterialPropertyDouble( "C10" , true ) );
            this->addDoubleProperty( "C01", ElementaryMaterialPropertyDouble( "C01" , 0.0 , false ) );
            this->addDoubleProperty( "C20", ElementaryMaterialPropertyDouble( "C20" , 0.0 , false ) );
            this->addDoubleProperty( "K", ElementaryMaterialPropertyDouble( "K" , false ) );
            this->addDoubleProperty( "Nu", ElementaryMaterialPropertyDouble( "NU" , false ) );
            this->addDoubleProperty( "Rho", ElementaryMaterialPropertyDouble( "RHO" , 0.0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasHyper */
typedef boost::shared_ptr< ElasHyperMaterialBehaviourInstance > ElasHyperMaterialBehaviourPtr;


/**
 * @class ElasCoqueMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ElasCoque
 * @author Jean-Pierre Lefebvre
 */
class ElasCoqueMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasCoqueMaterialBehaviourInstance()
        {
            // Mot cle "ELAS_COQUE" dans Aster
            _asterName = "ELAS_COQUE";

            // Parametres matériau
            this->addDoubleProperty( "Memb_l", ElementaryMaterialPropertyDouble( "MEMB_L" , false ) );
            this->addDoubleProperty( "Memb_lt", ElementaryMaterialPropertyDouble( "MEMB_LT" , false ) );
            this->addDoubleProperty( "Memb_t", ElementaryMaterialPropertyDouble( "MEMB_T" , false ) );
            this->addDoubleProperty( "Memb_g_lt", ElementaryMaterialPropertyDouble( "MEMB_G_LT" , false ) );
            this->addDoubleProperty( "Flex_l", ElementaryMaterialPropertyDouble( "FLEX_L" , false ) );
            this->addDoubleProperty( "Flex_lt", ElementaryMaterialPropertyDouble( "FLEX_LT" , false ) );
            this->addDoubleProperty( "Flex_t", ElementaryMaterialPropertyDouble( "FLEX_T" , false ) );
            this->addDoubleProperty( "Flex_g_lt", ElementaryMaterialPropertyDouble( "FLEX_G_LT" , false ) );
            this->addDoubleProperty( "Cisa_l", ElementaryMaterialPropertyDouble( "CISA_L" , false ) );
            this->addDoubleProperty( "Cisa_t", ElementaryMaterialPropertyDouble( "CISA_T" , false ) );
            this->addDoubleProperty( "M_llll", ElementaryMaterialPropertyDouble( "M_LLLL" , false ) );
            this->addDoubleProperty( "M_lltt", ElementaryMaterialPropertyDouble( "M_LLTT" , false ) );
            this->addDoubleProperty( "M_lllt", ElementaryMaterialPropertyDouble( "M_LLLT" , false ) );
            this->addDoubleProperty( "M_tttt", ElementaryMaterialPropertyDouble( "M_TTTT" , false ) );
            this->addDoubleProperty( "M_ttlt", ElementaryMaterialPropertyDouble( "M_TTLT" , false ) );
            this->addDoubleProperty( "M_ltlt", ElementaryMaterialPropertyDouble( "M_LTLT" , false ) );
            this->addDoubleProperty( "F_llll", ElementaryMaterialPropertyDouble( "F_LLLL" , false ) );
            this->addDoubleProperty( "F_lltt", ElementaryMaterialPropertyDouble( "F_LLTT" , false ) );
            this->addDoubleProperty( "F_lllt", ElementaryMaterialPropertyDouble( "F_LLLT" , false ) );
            this->addDoubleProperty( "F_tttt", ElementaryMaterialPropertyDouble( "F_TTTT" , false ) );
            this->addDoubleProperty( "F_ttlt", ElementaryMaterialPropertyDouble( "F_TTLT" , false ) );
            this->addDoubleProperty( "F_ltlt", ElementaryMaterialPropertyDouble( "F_LTLT" , false ) );
            this->addDoubleProperty( "Mf_llll", ElementaryMaterialPropertyDouble( "MF_LLLL" , false ) );
            this->addDoubleProperty( "Mf_lltt", ElementaryMaterialPropertyDouble( "MF_LLTT" , false ) );
            this->addDoubleProperty( "Mf_lllt", ElementaryMaterialPropertyDouble( "MF_LLLT" , false ) );
            this->addDoubleProperty( "Mf_tttt", ElementaryMaterialPropertyDouble( "MF_TTTT" , false ) );
            this->addDoubleProperty( "Mf_ttlt", ElementaryMaterialPropertyDouble( "MF_TTLT" , false ) );
            this->addDoubleProperty( "Mf_ltlt", ElementaryMaterialPropertyDouble( "MF_LTLT" , false ) );
            this->addDoubleProperty( "Mc_lllz", ElementaryMaterialPropertyDouble( "MC_LLLZ" , false ) );
            this->addDoubleProperty( "Mc_lltz", ElementaryMaterialPropertyDouble( "MC_LLTZ" , false ) );
            this->addDoubleProperty( "Mc_ttlz", ElementaryMaterialPropertyDouble( "MC_TTLZ" , false ) );
            this->addDoubleProperty( "Mc_tttz", ElementaryMaterialPropertyDouble( "MC_TTTZ" , false ) );
            this->addDoubleProperty( "Mc_ltlz", ElementaryMaterialPropertyDouble( "MC_LTLZ" , false ) );
            this->addDoubleProperty( "Mc_lttz", ElementaryMaterialPropertyDouble( "MC_LTTZ" , false ) );
            this->addDoubleProperty( "Fc_lllz", ElementaryMaterialPropertyDouble( "FC_LLLZ" , false ) );
            this->addDoubleProperty( "Fc_lltz", ElementaryMaterialPropertyDouble( "FC_LLTZ" , false ) );
            this->addDoubleProperty( "Fc_ttlz", ElementaryMaterialPropertyDouble( "FC_TTLZ" , false ) );
            this->addDoubleProperty( "Fc_tttz", ElementaryMaterialPropertyDouble( "FC_TTTZ" , false ) );
            this->addDoubleProperty( "Fc_ltlz", ElementaryMaterialPropertyDouble( "FC_LTLZ" , false ) );
            this->addDoubleProperty( "Fc_lttz", ElementaryMaterialPropertyDouble( "FC_LTTZ" , false ) );
            this->addDoubleProperty( "C_lzlz", ElementaryMaterialPropertyDouble( "C_LZLZ" , false ) );
            this->addDoubleProperty( "C_lztz", ElementaryMaterialPropertyDouble( "C_LZTZ" , false ) );
            this->addDoubleProperty( "C_tztz", ElementaryMaterialPropertyDouble( "C_TZTZ" , false ) );
            this->addDoubleProperty( "Rho", ElementaryMaterialPropertyDouble( "RHO" , false ) );
            this->addDoubleProperty( "Alpha", ElementaryMaterialPropertyDouble( "ALPHA" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasCoque */
typedef boost::shared_ptr< ElasCoqueMaterialBehaviourInstance > ElasCoqueMaterialBehaviourPtr;


/**
 * @class ElasCoqueFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ElasCoqueFo
 * @author Jean-Pierre Lefebvre
 */
class ElasCoqueFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasCoqueFoMaterialBehaviourInstance()
        {
            // Mot cle "ELAS_COQUE_FO" dans Aster
            _asterName = "ELAS_COQUE_FO";

            // Parametres matériau
            this->addFunctionProperty( "Memb_l", ElementaryMaterialPropertyFunction( "MEMB_L" , false ) );
            this->addFunctionProperty( "Memb_lt", ElementaryMaterialPropertyFunction( "MEMB_LT" , false ) );
            this->addFunctionProperty( "Memb_t", ElementaryMaterialPropertyFunction( "MEMB_T" , false ) );
            this->addFunctionProperty( "Memb_g_lt", ElementaryMaterialPropertyFunction( "MEMB_G_LT" , false ) );
            this->addFunctionProperty( "Flex_l", ElementaryMaterialPropertyFunction( "FLEX_L" , false ) );
            this->addFunctionProperty( "Flex_lt", ElementaryMaterialPropertyFunction( "FLEX_LT" , false ) );
            this->addFunctionProperty( "Flex_t", ElementaryMaterialPropertyFunction( "FLEX_T" , false ) );
            this->addFunctionProperty( "Flex_g_lt", ElementaryMaterialPropertyFunction( "FLEX_G_LT" , false ) );
            this->addFunctionProperty( "Cisa_l", ElementaryMaterialPropertyFunction( "CISA_L" , false ) );
            this->addFunctionProperty( "Cisa_t", ElementaryMaterialPropertyFunction( "CISA_T" , false ) );
            this->addFunctionProperty( "M_llll", ElementaryMaterialPropertyFunction( "M_LLLL" , false ) );
            this->addFunctionProperty( "M_lltt", ElementaryMaterialPropertyFunction( "M_LLTT" , false ) );
            this->addFunctionProperty( "M_lllt", ElementaryMaterialPropertyFunction( "M_LLLT" , false ) );
            this->addFunctionProperty( "M_tttt", ElementaryMaterialPropertyFunction( "M_TTTT" , false ) );
            this->addFunctionProperty( "M_ttlt", ElementaryMaterialPropertyFunction( "M_TTLT" , false ) );
            this->addFunctionProperty( "M_ltlt", ElementaryMaterialPropertyFunction( "M_LTLT" , false ) );
            this->addFunctionProperty( "F_llll", ElementaryMaterialPropertyFunction( "F_LLLL" , false ) );
            this->addFunctionProperty( "F_lltt", ElementaryMaterialPropertyFunction( "F_LLTT" , false ) );
            this->addFunctionProperty( "F_lllt", ElementaryMaterialPropertyFunction( "F_LLLT" , false ) );
            this->addFunctionProperty( "F_tttt", ElementaryMaterialPropertyFunction( "F_TTTT" , false ) );
            this->addFunctionProperty( "F_ttlt", ElementaryMaterialPropertyFunction( "F_TTLT" , false ) );
            this->addFunctionProperty( "F_ltlt", ElementaryMaterialPropertyFunction( "F_LTLT" , false ) );
            this->addFunctionProperty( "Mf_llll", ElementaryMaterialPropertyFunction( "MF_LLLL" , false ) );
            this->addFunctionProperty( "Mf_lltt", ElementaryMaterialPropertyFunction( "MF_LLTT" , false ) );
            this->addFunctionProperty( "Mf_lllt", ElementaryMaterialPropertyFunction( "MF_LLLT" , false ) );
            this->addFunctionProperty( "Mf_tttt", ElementaryMaterialPropertyFunction( "MF_TTTT" , false ) );
            this->addFunctionProperty( "Mf_ttlt", ElementaryMaterialPropertyFunction( "MF_TTLT" , false ) );
            this->addFunctionProperty( "Mf_ltlt", ElementaryMaterialPropertyFunction( "MF_LTLT" , false ) );
            this->addFunctionProperty( "Mc_lllz", ElementaryMaterialPropertyFunction( "MC_LLLZ" , false ) );
            this->addFunctionProperty( "Mc_lltz", ElementaryMaterialPropertyFunction( "MC_LLTZ" , false ) );
            this->addFunctionProperty( "Mc_ttlz", ElementaryMaterialPropertyFunction( "MC_TTLZ" , false ) );
            this->addFunctionProperty( "Mc_tttz", ElementaryMaterialPropertyFunction( "MC_TTTZ" , false ) );
            this->addFunctionProperty( "Mc_ltlz", ElementaryMaterialPropertyFunction( "MC_LTLZ" , false ) );
            this->addFunctionProperty( "Mc_lttz", ElementaryMaterialPropertyFunction( "MC_LTTZ" , false ) );
            this->addFunctionProperty( "Fc_lllz", ElementaryMaterialPropertyFunction( "FC_LLLZ" , false ) );
            this->addFunctionProperty( "Fc_lltz", ElementaryMaterialPropertyFunction( "FC_LLTZ" , false ) );
            this->addFunctionProperty( "Fc_ttlz", ElementaryMaterialPropertyFunction( "FC_TTLZ" , false ) );
            this->addFunctionProperty( "Fc_tttz", ElementaryMaterialPropertyFunction( "FC_TTTZ" , false ) );
            this->addFunctionProperty( "Fc_ltlz", ElementaryMaterialPropertyFunction( "FC_LTLZ" , false ) );
            this->addFunctionProperty( "Fc_lttz", ElementaryMaterialPropertyFunction( "FC_LTTZ" , false ) );
            this->addFunctionProperty( "C_lzlz", ElementaryMaterialPropertyFunction( "C_LZLZ" , false ) );
            this->addFunctionProperty( "C_lztz", ElementaryMaterialPropertyFunction( "C_LZTZ" , false ) );
            this->addFunctionProperty( "C_tztz", ElementaryMaterialPropertyFunction( "C_TZTZ" , false ) );
            this->addDoubleProperty( "Rho", ElementaryMaterialPropertyDouble( "RHO" , false ) );
            this->addFunctionProperty( "Alpha", ElementaryMaterialPropertyFunction( "ALPHA" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasCoqueFo */
typedef boost::shared_ptr< ElasCoqueFoMaterialBehaviourInstance > ElasCoqueFoMaterialBehaviourPtr;


/**
 * @class ElasMembraneMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ElasMembrane
 * @author Jean-Pierre Lefebvre
 */
class ElasMembraneMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasMembraneMaterialBehaviourInstance()
        {
            // Mot cle "ELAS_MEMBRANE" dans Aster
            _asterName = "ELAS_MEMBRANE";

            // Parametres matériau
            this->addDoubleProperty( "M_llll", ElementaryMaterialPropertyDouble( "M_LLLL" , true ) );
            this->addDoubleProperty( "M_lltt", ElementaryMaterialPropertyDouble( "M_LLTT" , true ) );
            this->addDoubleProperty( "M_lllt", ElementaryMaterialPropertyDouble( "M_LLLT" , true ) );
            this->addDoubleProperty( "M_tttt", ElementaryMaterialPropertyDouble( "M_TTTT" , true ) );
            this->addDoubleProperty( "M_ttlt", ElementaryMaterialPropertyDouble( "M_TTLT" , true ) );
            this->addDoubleProperty( "M_ltlt", ElementaryMaterialPropertyDouble( "M_LTLT" , true ) );
            this->addDoubleProperty( "Rho", ElementaryMaterialPropertyDouble( "RHO" , false ) );
            this->addDoubleProperty( "Alpha", ElementaryMaterialPropertyDouble( "ALPHA" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasMembrane */
typedef boost::shared_ptr< ElasMembraneMaterialBehaviourInstance > ElasMembraneMaterialBehaviourPtr;


/**
 * @class Elas2ndgMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Elas2ndg
 * @author Jean-Pierre Lefebvre
 */
class Elas2ndgMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        Elas2ndgMaterialBehaviourInstance()
        {
            // Mot cle "ELAS_2NDG" dans Aster
            _asterName = "ELAS_2NDG";

            // Parametres matériau
            this->addDoubleProperty( "A1", ElementaryMaterialPropertyDouble( "A1" , true ) );
            this->addDoubleProperty( "A2", ElementaryMaterialPropertyDouble( "A2" , false ) );
            this->addDoubleProperty( "A3", ElementaryMaterialPropertyDouble( "A3" , false ) );
            this->addDoubleProperty( "A4", ElementaryMaterialPropertyDouble( "A4" , false ) );
            this->addDoubleProperty( "A5", ElementaryMaterialPropertyDouble( "A5" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Elas2ndg */
typedef boost::shared_ptr< Elas2ndgMaterialBehaviourInstance > Elas2ndgMaterialBehaviourPtr;


/**
 * @class ElasGlrcMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ElasGlrc
 * @author Jean-Pierre Lefebvre
 */
class ElasGlrcMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasGlrcMaterialBehaviourInstance()
        {
            // Mot cle "ELAS_GLRC" dans Aster
            _asterName = "ELAS_GLRC";

            // Parametres matériau
            this->addDoubleProperty( "E_m", ElementaryMaterialPropertyDouble( "E_M" , true ) );
            this->addDoubleProperty( "Nu_m", ElementaryMaterialPropertyDouble( "NU_M" , true ) );
            this->addDoubleProperty( "E_f", ElementaryMaterialPropertyDouble( "E_F" , false ) );
            this->addDoubleProperty( "Nu_f", ElementaryMaterialPropertyDouble( "NU_F" , false ) );
            this->addDoubleProperty( "Bt1", ElementaryMaterialPropertyDouble( "BT1" , false ) );
            this->addDoubleProperty( "Bt2", ElementaryMaterialPropertyDouble( "BT2" , false ) );
            this->addDoubleProperty( "Rho", ElementaryMaterialPropertyDouble( "RHO" , false ) );
            this->addDoubleProperty( "Alpha", ElementaryMaterialPropertyDouble( "ALPHA" , false ) );
            this->addDoubleProperty( "Amor_alpha", ElementaryMaterialPropertyDouble( "AMOR_ALPHA" , false ) );
            this->addDoubleProperty( "Amor_beta", ElementaryMaterialPropertyDouble( "AMOR_BETA" , false ) );
            this->addDoubleProperty( "Amor_hyst", ElementaryMaterialPropertyDouble( "AMOR_HYST" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasGlrc */
typedef boost::shared_ptr< ElasGlrcMaterialBehaviourInstance > ElasGlrcMaterialBehaviourPtr;


/**
 * @class ElasGlrcFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ElasGlrcFo
 * @author Jean-Pierre Lefebvre
 */
class ElasGlrcFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasGlrcFoMaterialBehaviourInstance()
        {
            // Mot cle "ELAS_GLRC_FO" dans Aster
            _asterName = "ELAS_GLRC_FO";

            // Parametres matériau
            this->addFunctionProperty( "E_m", ElementaryMaterialPropertyFunction( "E_M" , true ) );
            this->addFunctionProperty( "Nu_m", ElementaryMaterialPropertyFunction( "NU_M" , true ) );
            this->addFunctionProperty( "E_f", ElementaryMaterialPropertyFunction( "E_F" , false ) );
            this->addFunctionProperty( "Nu_f", ElementaryMaterialPropertyFunction( "NU_F" , false ) );
            this->addFunctionProperty( "Bt1", ElementaryMaterialPropertyFunction( "BT1" , false ) );
            this->addFunctionProperty( "Bt2", ElementaryMaterialPropertyFunction( "BT2" , false ) );
            this->addDoubleProperty( "Rho", ElementaryMaterialPropertyDouble( "RHO" , false ) );
            this->addDoubleProperty( "Temp_def_alpha", ElementaryMaterialPropertyDouble( "TEMP_DEF_ALPHA" , false ) );
            this->addFunctionProperty( "Alpha", ElementaryMaterialPropertyFunction( "ALPHA" , false ) );
            this->addFunctionProperty( "Amor_alpha", ElementaryMaterialPropertyFunction( "AMOR_ALPHA" , false ) );
            this->addFunctionProperty( "Amor_beta", ElementaryMaterialPropertyFunction( "AMOR_BETA" , false ) );
            this->addFunctionProperty( "Amor_hyst", ElementaryMaterialPropertyFunction( "AMOR_HYST" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasGlrcFo */
typedef boost::shared_ptr< ElasGlrcFoMaterialBehaviourInstance > ElasGlrcFoMaterialBehaviourPtr;


/**
 * @class ElasDhrcMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ElasDhrc
 * @author Jean-Pierre Lefebvre
 */
class ElasDhrcMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasDhrcMaterialBehaviourInstance()
        {
            // Mot cle "ELAS_DHRC" dans Aster
            _asterName = "ELAS_DHRC";

            // Parametres matériau
            this->addDoubleProperty( "A011", ElementaryMaterialPropertyDouble( "A011" , true ) );
            this->addDoubleProperty( "A012", ElementaryMaterialPropertyDouble( "A012" , true ) );
            this->addDoubleProperty( "A013", ElementaryMaterialPropertyDouble( "A013" , true ) );
            this->addDoubleProperty( "A014", ElementaryMaterialPropertyDouble( "A014" , true ) );
            this->addDoubleProperty( "A015", ElementaryMaterialPropertyDouble( "A015" , true ) );
            this->addDoubleProperty( "A016", ElementaryMaterialPropertyDouble( "A016" , true ) );
            this->addDoubleProperty( "A022", ElementaryMaterialPropertyDouble( "A022" , true ) );
            this->addDoubleProperty( "A023", ElementaryMaterialPropertyDouble( "A023" , true ) );
            this->addDoubleProperty( "A024", ElementaryMaterialPropertyDouble( "A024" , true ) );
            this->addDoubleProperty( "A025", ElementaryMaterialPropertyDouble( "A025" , true ) );
            this->addDoubleProperty( "A026", ElementaryMaterialPropertyDouble( "A026" , true ) );
            this->addDoubleProperty( "A033", ElementaryMaterialPropertyDouble( "A033" , true ) );
            this->addDoubleProperty( "A034", ElementaryMaterialPropertyDouble( "A034" , true ) );
            this->addDoubleProperty( "A035", ElementaryMaterialPropertyDouble( "A035" , true ) );
            this->addDoubleProperty( "A036", ElementaryMaterialPropertyDouble( "A036" , true ) );
            this->addDoubleProperty( "A044", ElementaryMaterialPropertyDouble( "A044" , true ) );
            this->addDoubleProperty( "A045", ElementaryMaterialPropertyDouble( "A045" , true ) );
            this->addDoubleProperty( "A046", ElementaryMaterialPropertyDouble( "A046" , true ) );
            this->addDoubleProperty( "A055", ElementaryMaterialPropertyDouble( "A055" , true ) );
            this->addDoubleProperty( "A056", ElementaryMaterialPropertyDouble( "A056" , true ) );
            this->addDoubleProperty( "A066", ElementaryMaterialPropertyDouble( "A066" , true ) );
            this->addDoubleProperty( "Rho", ElementaryMaterialPropertyDouble( "RHO" , false ) );
            this->addDoubleProperty( "Alpha", ElementaryMaterialPropertyDouble( "ALPHA" , false ) );
            this->addDoubleProperty( "Amor_alpha", ElementaryMaterialPropertyDouble( "AMOR_ALPHA" , false ) );
            this->addDoubleProperty( "Amor_beta", ElementaryMaterialPropertyDouble( "AMOR_BETA" , false ) );
            this->addDoubleProperty( "Amor_hyst", ElementaryMaterialPropertyDouble( "AMOR_HYST" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasDhrc */
typedef boost::shared_ptr< ElasDhrcMaterialBehaviourInstance > ElasDhrcMaterialBehaviourPtr;


/**
 * @class CableMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Cable
 * @author Jean-Pierre Lefebvre
 */
class CableMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        CableMaterialBehaviourInstance()
        {
            // Mot cle "CABLE" dans Aster
            _asterName = "CABLE";

            // Parametres matériau
            this->addDoubleProperty( "Ec_sur_e", ElementaryMaterialPropertyDouble( "EC_SUR_E" , 1.E-4 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Cable */
typedef boost::shared_ptr< CableMaterialBehaviourInstance > CableMaterialBehaviourPtr;


/**
 * @class VeriBorneMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau VeriBorne
 * @author Jean-Pierre Lefebvre
 * @todo VeriBorne n'est pas un MaterialBehaviour !!!
 */
class VeriBorneMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        VeriBorneMaterialBehaviourInstance()
        {
            // Mot cle "VERI_BORNE" dans Aster
            _asterName = "VERI_BORNE";

            // Parametres matériau
            this->addDoubleProperty( "Epsi_maxi", ElementaryMaterialPropertyDouble( "EPSI_MAXI" , false ) );
            this->addDoubleProperty( "Temp_maxi", ElementaryMaterialPropertyDouble( "TEMP_MAXI" , false ) );
            this->addDoubleProperty( "Temp_mini", ElementaryMaterialPropertyDouble( "TEMP_MINI" , false ) );
            this->addDoubleProperty( "Veps_maxi", ElementaryMaterialPropertyDouble( "VEPS_MAXI" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau VeriBorne */
typedef boost::shared_ptr< VeriBorneMaterialBehaviourInstance > VeriBorneMaterialBehaviourPtr;


/**
 * @class TractionMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Traction
 * @author Jean-Pierre Lefebvre
 */
class TractionMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        TractionMaterialBehaviourInstance()
        {
            // Mot cle "TRACTION" dans Aster
            _asterName = "TRACTION";

            // Parametres matériau
            this->addFunctionProperty( "Sigm", ElementaryMaterialPropertyFunction( "SIGM" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Traction */
typedef boost::shared_ptr< TractionMaterialBehaviourInstance > TractionMaterialBehaviourPtr;


/**
 * @class EcroLineMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau EcroLine
 * @author Jean-Pierre Lefebvre
 */
class EcroLineMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        EcroLineMaterialBehaviourInstance()
        {
            // Mot cle "ECRO_LINE" dans Aster
            _asterName = "ECRO_LINE";

            // Parametres matériau
            this->addDoubleProperty( "D_sigm_epsi", ElementaryMaterialPropertyDouble( "D_SIGM_EPSI" , true ) );
            this->addDoubleProperty( "Sy", ElementaryMaterialPropertyDouble( "SY" , true ) );
            this->addDoubleProperty( "Sigm_lim", ElementaryMaterialPropertyDouble( "SIGM_LIM" , false ) );
            this->addDoubleProperty( "Epsi_lim", ElementaryMaterialPropertyDouble( "EPSI_LIM" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau EcroLine */
typedef boost::shared_ptr< EcroLineMaterialBehaviourInstance > EcroLineMaterialBehaviourPtr;


/**
 * @class EndoHeterogeneMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau EndoHeterogene
 * @author Jean-Pierre Lefebvre
 */
class EndoHeterogeneMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        EndoHeterogeneMaterialBehaviourInstance()
        {
            // Mot cle "ENDO_HETEROGENE" dans Aster
            _asterName = "ENDO_HETEROGENE";

            // Parametres matériau
            this->addDoubleProperty( "Weibull", ElementaryMaterialPropertyDouble( "WEIBULL" , true ) );
            this->addDoubleProperty( "Sy", ElementaryMaterialPropertyDouble( "SY" , true ) );
            this->addDoubleProperty( "Ki", ElementaryMaterialPropertyDouble( "KI" , true ) );
            this->addDoubleProperty( "Epai", ElementaryMaterialPropertyDouble( "EPAI" , true ) );
            this->addDoubleProperty( "Gr", ElementaryMaterialPropertyDouble( "GR" , 1.0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau EndoHeterogene */
typedef boost::shared_ptr< EndoHeterogeneMaterialBehaviourInstance > EndoHeterogeneMaterialBehaviourPtr;


/**
 * @class EcroLineFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau EcroLineFo
 * @author Jean-Pierre Lefebvre
 */
class EcroLineFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        EcroLineFoMaterialBehaviourInstance()
        {
            // Mot cle "ECRO_LINE_FO" dans Aster
            _asterName = "ECRO_LINE_FO";

            // Parametres matériau
            this->addFunctionProperty( "D_sigm_epsi", ElementaryMaterialPropertyFunction( "D_SIGM_EPSI" , true ) );
            this->addFunctionProperty( "Sy", ElementaryMaterialPropertyFunction( "SY" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau EcroLineFo */
typedef boost::shared_ptr< EcroLineFoMaterialBehaviourInstance > EcroLineFoMaterialBehaviourPtr;


/**
 * @class EcroPuisMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau EcroPuis
 * @author Jean-Pierre Lefebvre
 */
class EcroPuisMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        EcroPuisMaterialBehaviourInstance()
        {
            // Mot cle "ECRO_PUIS" dans Aster
            _asterName = "ECRO_PUIS";

            // Parametres matériau
            this->addDoubleProperty( "Sy", ElementaryMaterialPropertyDouble( "SY" , true ) );
            this->addDoubleProperty( "A_puis", ElementaryMaterialPropertyDouble( "A_PUIS" , true ) );
            this->addDoubleProperty( "N_puis", ElementaryMaterialPropertyDouble( "N_PUIS" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau EcroPuis */
typedef boost::shared_ptr< EcroPuisMaterialBehaviourInstance > EcroPuisMaterialBehaviourPtr;


/**
 * @class EcroPuisFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau EcroPuisFo
 * @author Jean-Pierre Lefebvre
 */
class EcroPuisFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        EcroPuisFoMaterialBehaviourInstance()
        {
            // Mot cle "ECRO_PUIS_FO" dans Aster
            _asterName = "ECRO_PUIS_FO";

            // Parametres matériau
            this->addFunctionProperty( "Sy", ElementaryMaterialPropertyFunction( "SY" , true ) );
            this->addFunctionProperty( "A_puis", ElementaryMaterialPropertyFunction( "A_PUIS" , true ) );
            this->addFunctionProperty( "N_puis", ElementaryMaterialPropertyFunction( "N_PUIS" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau EcroPuisFo */
typedef boost::shared_ptr< EcroPuisFoMaterialBehaviourInstance > EcroPuisFoMaterialBehaviourPtr;


/**
 * @class EcroCookMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau EcroCook
 * @author Jean-Pierre Lefebvre
 */
class EcroCookMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        EcroCookMaterialBehaviourInstance()
        {
            // Mot cle "ECRO_COOK" dans Aster
            _asterName = "ECRO_COOK";

            // Parametres matériau
            this->addDoubleProperty( "A", ElementaryMaterialPropertyDouble( "A" , true ) );
            this->addDoubleProperty( "B", ElementaryMaterialPropertyDouble( "B" , true ) );
            this->addDoubleProperty( "C", ElementaryMaterialPropertyDouble( "C" , false ) );
            this->addDoubleProperty( "N_puis", ElementaryMaterialPropertyDouble( "N_PUIS" , true ) );
            this->addDoubleProperty( "M_puis", ElementaryMaterialPropertyDouble( "M_PUIS" , false ) );
            this->addDoubleProperty( "Epsp0", ElementaryMaterialPropertyDouble( "EPSP0" , false ) );
            this->addDoubleProperty( "Troom", ElementaryMaterialPropertyDouble( "TROOM" , false ) );
            this->addDoubleProperty( "Tmelt", ElementaryMaterialPropertyDouble( "TMELT" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau EcroCook */
typedef boost::shared_ptr< EcroCookMaterialBehaviourInstance > EcroCookMaterialBehaviourPtr;


/**
 * @class EcroCookFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau EcroCookFo
 * @author Jean-Pierre Lefebvre
 */
class EcroCookFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        EcroCookFoMaterialBehaviourInstance()
        {
            // Mot cle "ECRO_COOK_FO" dans Aster
            _asterName = "ECRO_COOK_FO";

            // Parametres matériau
            this->addFunctionProperty( "A", ElementaryMaterialPropertyFunction( "A" , true ) );
            this->addFunctionProperty( "B", ElementaryMaterialPropertyFunction( "B" , true ) );
            this->addDoubleProperty( "C", ElementaryMaterialPropertyDouble( "C" , false ) );
            this->addDoubleProperty( "N_puis", ElementaryMaterialPropertyDouble( "N_PUIS" , true ) );
            this->addDoubleProperty( "M_puis", ElementaryMaterialPropertyDouble( "M_PUIS" , false ) );
            this->addDoubleProperty( "Epsp0", ElementaryMaterialPropertyDouble( "EPSP0" , false ) );
            this->addDoubleProperty( "Troom", ElementaryMaterialPropertyDouble( "TROOM" , false ) );
            this->addDoubleProperty( "Tmelt", ElementaryMaterialPropertyDouble( "TMELT" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau EcroCookFo */
typedef boost::shared_ptr< EcroCookFoMaterialBehaviourInstance > EcroCookFoMaterialBehaviourPtr;


/**
 * @class BetonEcroLineMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau BetonEcroLine
 * @author Jean-Pierre Lefebvre
 */
class BetonEcroLineMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        BetonEcroLineMaterialBehaviourInstance()
        {
            // Mot cle "BETON_ECRO_LINE" dans Aster
            _asterName = "BETON_ECRO_LINE";

            // Parametres matériau
            this->addDoubleProperty( "D_sigm_epsi", ElementaryMaterialPropertyDouble( "D_SIGM_EPSI" , true ) );
            this->addDoubleProperty( "Syt", ElementaryMaterialPropertyDouble( "SYT" , true ) );
            this->addDoubleProperty( "Syc", ElementaryMaterialPropertyDouble( "SYC" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau BetonEcroLine */
typedef boost::shared_ptr< BetonEcroLineMaterialBehaviourInstance > BetonEcroLineMaterialBehaviourPtr;


/**
 * @class BetonReglePrMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau BetonReglePr
 * @author Jean-Pierre Lefebvre
 */
class BetonReglePrMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        BetonReglePrMaterialBehaviourInstance()
        {
            // Mot cle "BETON_REGLE_PR" dans Aster
            _asterName = "BETON_REGLE_PR";

            // Parametres matériau
            this->addDoubleProperty( "D_sigm_epsi", ElementaryMaterialPropertyDouble( "D_SIGM_EPSI" , true ) );
            this->addDoubleProperty( "Syt", ElementaryMaterialPropertyDouble( "SYT" , true ) );
            this->addDoubleProperty( "Syc", ElementaryMaterialPropertyDouble( "SYC" , false ) );
            this->addDoubleProperty( "Epsc", ElementaryMaterialPropertyDouble( "EPSC" , false ) );
            this->addDoubleProperty( "N", ElementaryMaterialPropertyDouble( "N" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau BetonReglePr */
typedef boost::shared_ptr< BetonReglePrMaterialBehaviourInstance > BetonReglePrMaterialBehaviourPtr;


/**
 * @class EndoOrthBetonMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau EndoOrthBeton
 * @author Jean-Pierre Lefebvre
 */
class EndoOrthBetonMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        EndoOrthBetonMaterialBehaviourInstance()
        {
            // Mot cle "ENDO_ORTH_BETON" dans Aster
            _asterName = "ENDO_ORTH_BETON";

            // Parametres matériau
            this->addDoubleProperty( "Alpha", ElementaryMaterialPropertyDouble( "ALPHA" , 0.9 , false ) );
            this->addDoubleProperty( "K0", ElementaryMaterialPropertyDouble( "K0" , true ) );
            this->addDoubleProperty( "K1", ElementaryMaterialPropertyDouble( "K1" , true ) );
            this->addDoubleProperty( "K2", ElementaryMaterialPropertyDouble( "K2" , 7.E-4 , false ) );
            this->addDoubleProperty( "Ecrob", ElementaryMaterialPropertyDouble( "ECROB" , true ) );
            this->addDoubleProperty( "Ecrod", ElementaryMaterialPropertyDouble( "ECROD" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau EndoOrthBeton */
typedef boost::shared_ptr< EndoOrthBetonMaterialBehaviourInstance > EndoOrthBetonMaterialBehaviourPtr;


/**
 * @class PragerMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Prager
 * @author Jean-Pierre Lefebvre
 */
class PragerMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        PragerMaterialBehaviourInstance()
        {
            // Mot cle "PRAGER" dans Aster
            _asterName = "PRAGER";

            // Parametres matériau
            this->addDoubleProperty( "C", ElementaryMaterialPropertyDouble( "C" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Prager */
typedef boost::shared_ptr< PragerMaterialBehaviourInstance > PragerMaterialBehaviourPtr;


/**
 * @class PragerFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau PragerFo
 * @author Jean-Pierre Lefebvre
 */
class PragerFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        PragerFoMaterialBehaviourInstance()
        {
            // Mot cle "PRAGER_FO" dans Aster
            _asterName = "PRAGER_FO";

            // Parametres matériau
            this->addFunctionProperty( "C", ElementaryMaterialPropertyFunction( "C" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau PragerFo */
typedef boost::shared_ptr< PragerFoMaterialBehaviourInstance > PragerFoMaterialBehaviourPtr;


/**
 * @class TaheriMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Taheri
 * @author Jean-Pierre Lefebvre
 */
class TaheriMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        TaheriMaterialBehaviourInstance()
        {
            // Mot cle "TAHERI" dans Aster
            _asterName = "TAHERI";

            // Parametres matériau
            this->addDoubleProperty( "R_0", ElementaryMaterialPropertyDouble( "R_0" , true ) );
            this->addDoubleProperty( "Alpha", ElementaryMaterialPropertyDouble( "ALPHA" , true ) );
            this->addDoubleProperty( "M", ElementaryMaterialPropertyDouble( "M" , true ) );
            this->addDoubleProperty( "A", ElementaryMaterialPropertyDouble( "A" , true ) );
            this->addDoubleProperty( "B", ElementaryMaterialPropertyDouble( "B" , true ) );
            this->addDoubleProperty( "C1", ElementaryMaterialPropertyDouble( "C1" , true ) );
            this->addDoubleProperty( "C_inf", ElementaryMaterialPropertyDouble( "C_INF" , true ) );
            this->addDoubleProperty( "S", ElementaryMaterialPropertyDouble( "S" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Taheri */
typedef boost::shared_ptr< TaheriMaterialBehaviourInstance > TaheriMaterialBehaviourPtr;


/**
 * @class TaheriFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau TaheriFo
 * @author Jean-Pierre Lefebvre
 */
class TaheriFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        TaheriFoMaterialBehaviourInstance()
        {
            // Mot cle "TAHERI_FO" dans Aster
            _asterName = "TAHERI_FO";

            // Parametres matériau
            this->addFunctionProperty( "R_0", ElementaryMaterialPropertyFunction( "R_0" , true ) );
            this->addFunctionProperty( "Alpha", ElementaryMaterialPropertyFunction( "ALPHA" , true ) );
            this->addFunctionProperty( "M", ElementaryMaterialPropertyFunction( "M" , true ) );
            this->addFunctionProperty( "A", ElementaryMaterialPropertyFunction( "A" , true ) );
            this->addFunctionProperty( "B", ElementaryMaterialPropertyFunction( "B" , true ) );
            this->addFunctionProperty( "C1", ElementaryMaterialPropertyFunction( "C1" , true ) );
            this->addFunctionProperty( "C_inf", ElementaryMaterialPropertyFunction( "C_INF" , true ) );
            this->addFunctionProperty( "S", ElementaryMaterialPropertyFunction( "S" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau TaheriFo */
typedef boost::shared_ptr< TaheriFoMaterialBehaviourInstance > TaheriFoMaterialBehaviourPtr;


/**
 * @class RousselierMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Rousselier
 * @author Jean-Pierre Lefebvre
 */
class RousselierMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        RousselierMaterialBehaviourInstance()
        {
            // Mot cle "ROUSSELIER" dans Aster
            _asterName = "ROUSSELIER";

            // Parametres matériau
            this->addDoubleProperty( "D", ElementaryMaterialPropertyDouble( "D" , true ) );
            this->addDoubleProperty( "Sigm_1", ElementaryMaterialPropertyDouble( "SIGM_1" , true ) );
            this->addDoubleProperty( "Poro_init", ElementaryMaterialPropertyDouble( "PORO_INIT" , true ) );
            this->addDoubleProperty( "Poro_crit", ElementaryMaterialPropertyDouble( "PORO_CRIT" , 1. , false ) );
            this->addDoubleProperty( "Poro_acce", ElementaryMaterialPropertyDouble( "PORO_ACCE" , 1. , false ) );
            this->addDoubleProperty( "Poro_limi", ElementaryMaterialPropertyDouble( "PORO_LIMI" , 0.999 , false ) );
            this->addDoubleProperty( "D_sigm_epsi_norm", ElementaryMaterialPropertyDouble( "D_SIGM_EPSI_NORM" , false ) );
            this->addDoubleProperty( "An", ElementaryMaterialPropertyDouble( "AN" , 0. , false ) );
            this->addDoubleProperty( "Dp_maxi", ElementaryMaterialPropertyDouble( "DP_MAXI" , 0.1 , false ) );
            this->addDoubleProperty( "Beta", ElementaryMaterialPropertyDouble( "BETA" , 0.85 , false ) );
            this->addDoubleProperty( "Poro_type", ElementaryMaterialPropertyDouble( "PORO_TYPE" , 1. , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Rousselier */
typedef boost::shared_ptr< RousselierMaterialBehaviourInstance > RousselierMaterialBehaviourPtr;


/**
 * @class RousselierFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau RousselierFo
 * @author Jean-Pierre Lefebvre
 */
class RousselierFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        RousselierFoMaterialBehaviourInstance()
        {
            // Mot cle "ROUSSELIER_FO" dans Aster
            _asterName = "ROUSSELIER_FO";

            // Parametres matériau
            this->addFunctionProperty( "D", ElementaryMaterialPropertyFunction( "D" , true ) );
            this->addFunctionProperty( "Sigm_1", ElementaryMaterialPropertyFunction( "SIGM_1" , true ) );
            this->addFunctionProperty( "Poro_init", ElementaryMaterialPropertyFunction( "PORO_INIT" , true ) );
            this->addDoubleProperty( "Poro_crit", ElementaryMaterialPropertyDouble( "PORO_CRIT" , 1. , false ) );
            this->addDoubleProperty( "Poro_acce", ElementaryMaterialPropertyDouble( "PORO_ACCE" , 1. , false ) );
            this->addDoubleProperty( "Poro_limi", ElementaryMaterialPropertyDouble( "PORO_LIMI" , 0.999 , false ) );
            this->addDoubleProperty( "D_sigm_epsi_norm", ElementaryMaterialPropertyDouble( "D_SIGM_EPSI_NORM" , false ) );
            this->addDoubleProperty( "An", ElementaryMaterialPropertyDouble( "AN" , 0. , false ) );
            this->addDoubleProperty( "Dp_maxi", ElementaryMaterialPropertyDouble( "DP_MAXI" , 0.1 , false ) );
            this->addDoubleProperty( "Beta", ElementaryMaterialPropertyDouble( "BETA" , 0.85 , false ) );
            this->addDoubleProperty( "Poro_type", ElementaryMaterialPropertyDouble( "PORO_TYPE" , 1. , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau RousselierFo */
typedef boost::shared_ptr< RousselierFoMaterialBehaviourInstance > RousselierFoMaterialBehaviourPtr;


/**
 * @class ViscSinhMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ViscSinh
 * @author Jean-Pierre Lefebvre
 */
class ViscSinhMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ViscSinhMaterialBehaviourInstance()
        {
            // Mot cle "VISC_SINH" dans Aster
            _asterName = "VISC_SINH";

            // Parametres matériau
            this->addDoubleProperty( "Sigm_0", ElementaryMaterialPropertyDouble( "SIGM_0" , true ) );
            this->addDoubleProperty( "Epsi_0", ElementaryMaterialPropertyDouble( "EPSI_0" , true ) );
            this->addDoubleProperty( "M", ElementaryMaterialPropertyDouble( "M" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ViscSinh */
typedef boost::shared_ptr< ViscSinhMaterialBehaviourInstance > ViscSinhMaterialBehaviourPtr;


/**
 * @class ViscSinhFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ViscSinhFo
 * @author Jean-Pierre Lefebvre
 */
class ViscSinhFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ViscSinhFoMaterialBehaviourInstance()
        {
            // Mot cle "VISC_SINH_FO" dans Aster
            _asterName = "VISC_SINH_FO";

            // Parametres matériau
            this->addFunctionProperty( "Sigm_0", ElementaryMaterialPropertyFunction( "SIGM_0" , true ) );
            this->addFunctionProperty( "Epsi_0", ElementaryMaterialPropertyFunction( "EPSI_0" , true ) );
            this->addFunctionProperty( "M", ElementaryMaterialPropertyFunction( "M" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ViscSinhFo */
typedef boost::shared_ptr< ViscSinhFoMaterialBehaviourInstance > ViscSinhFoMaterialBehaviourPtr;


/**
 * @class Cin1ChabMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Cin1Chab
 * @author Jean-Pierre Lefebvre
 */
class Cin1ChabMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        Cin1ChabMaterialBehaviourInstance()
        {
            // Mot cle "CIN1_CHAB" dans Aster
            _asterName = "CIN1_CHAB";

            // Parametres matériau
            this->addDoubleProperty( "R_0", ElementaryMaterialPropertyDouble( "R_0" , true ) );
            this->addDoubleProperty( "R_i", ElementaryMaterialPropertyDouble( "R_I" , false ) );
            this->addDoubleProperty( "B", ElementaryMaterialPropertyDouble( "B" , 0.0E+0 , false ) );
            this->addDoubleProperty( "C_i", ElementaryMaterialPropertyDouble( "C_I" , true ) );
            this->addDoubleProperty( "K", ElementaryMaterialPropertyDouble( "K" , 1.0E+0 , false ) );
            this->addDoubleProperty( "W", ElementaryMaterialPropertyDouble( "W" , 0.0E+0 , false ) );
            this->addDoubleProperty( "G_0", ElementaryMaterialPropertyDouble( "G_0" , true ) );
            this->addDoubleProperty( "A_i", ElementaryMaterialPropertyDouble( "A_I" , 1.0E+0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Cin1Chab */
typedef boost::shared_ptr< Cin1ChabMaterialBehaviourInstance > Cin1ChabMaterialBehaviourPtr;


/**
 * @class Cin1ChabFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Cin1ChabFo
 * @author Jean-Pierre Lefebvre
 */
class Cin1ChabFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        Cin1ChabFoMaterialBehaviourInstance()
        {
            // Mot cle "CIN1_CHAB_FO" dans Aster
            _asterName = "CIN1_CHAB_FO";

            // Parametres matériau
            this->addFunctionProperty( "R_0", ElementaryMaterialPropertyFunction( "R_0" , true ) );
            this->addFunctionProperty( "R_i", ElementaryMaterialPropertyFunction( "R_I" , true ) );
            this->addFunctionProperty( "B", ElementaryMaterialPropertyFunction( "B" , true ) );
            this->addFunctionProperty( "C_i", ElementaryMaterialPropertyFunction( "C_I" , true ) );
            this->addFunctionProperty( "K", ElementaryMaterialPropertyFunction( "K" , true ) );
            this->addFunctionProperty( "W", ElementaryMaterialPropertyFunction( "W" , true ) );
            this->addFunctionProperty( "G_0", ElementaryMaterialPropertyFunction( "G_0" , true ) );
            this->addFunctionProperty( "A_i", ElementaryMaterialPropertyFunction( "A_I" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Cin1ChabFo */
typedef boost::shared_ptr< Cin1ChabFoMaterialBehaviourInstance > Cin1ChabFoMaterialBehaviourPtr;


/**
 * @class Cin2ChabMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Cin2Chab
 * @author Jean-Pierre Lefebvre
 */
class Cin2ChabMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        Cin2ChabMaterialBehaviourInstance()
        {
            // Mot cle "CIN2_CHAB" dans Aster
            _asterName = "CIN2_CHAB";

            // Parametres matériau
            this->addDoubleProperty( "R_0", ElementaryMaterialPropertyDouble( "R_0" , true ) );
            this->addDoubleProperty( "R_i", ElementaryMaterialPropertyDouble( "R_I" , false ) );
            this->addDoubleProperty( "B", ElementaryMaterialPropertyDouble( "B" , 0.E+0 , false ) );
            this->addDoubleProperty( "C1_i", ElementaryMaterialPropertyDouble( "C1_I" , true ) );
            this->addDoubleProperty( "C2_i", ElementaryMaterialPropertyDouble( "C2_I" , true ) );
            this->addDoubleProperty( "K", ElementaryMaterialPropertyDouble( "K" , 1. , false ) );
            this->addDoubleProperty( "W", ElementaryMaterialPropertyDouble( "W" , 0.E+0 , false ) );
            this->addDoubleProperty( "G1_0", ElementaryMaterialPropertyDouble( "G1_0" , true ) );
            this->addDoubleProperty( "G2_0", ElementaryMaterialPropertyDouble( "G2_0" , true ) );
            this->addDoubleProperty( "A_i", ElementaryMaterialPropertyDouble( "A_I" , 1.E+0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Cin2Chab */
typedef boost::shared_ptr< Cin2ChabMaterialBehaviourInstance > Cin2ChabMaterialBehaviourPtr;


/**
 * @class Cin2ChabFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Cin2ChabFo
 * @author Jean-Pierre Lefebvre
 */
class Cin2ChabFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        Cin2ChabFoMaterialBehaviourInstance()
        {
            // Mot cle "CIN2_CHAB_FO" dans Aster
            _asterName = "CIN2_CHAB_FO";

            // Parametres matériau
            this->addFunctionProperty( "R_0", ElementaryMaterialPropertyFunction( "R_0" , true ) );
            this->addFunctionProperty( "R_i", ElementaryMaterialPropertyFunction( "R_I" , true ) );
            this->addFunctionProperty( "B", ElementaryMaterialPropertyFunction( "B" , true ) );
            this->addFunctionProperty( "C1_i", ElementaryMaterialPropertyFunction( "C1_I" , true ) );
            this->addFunctionProperty( "C2_i", ElementaryMaterialPropertyFunction( "C2_I" , true ) );
            this->addFunctionProperty( "K", ElementaryMaterialPropertyFunction( "K" , true ) );
            this->addFunctionProperty( "W", ElementaryMaterialPropertyFunction( "W" , true ) );
            this->addFunctionProperty( "G1_0", ElementaryMaterialPropertyFunction( "G1_0" , true ) );
            this->addFunctionProperty( "G2_0", ElementaryMaterialPropertyFunction( "G2_0" , true ) );
            this->addFunctionProperty( "A_i", ElementaryMaterialPropertyFunction( "A_I" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Cin2ChabFo */
typedef boost::shared_ptr< Cin2ChabFoMaterialBehaviourInstance > Cin2ChabFoMaterialBehaviourPtr;


/**
 * @class Cin2NradMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Cin2Nrad
 * @author Jean-Pierre Lefebvre
 */
class Cin2NradMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        Cin2NradMaterialBehaviourInstance()
        {
            // Mot cle "CIN2_NRAD" dans Aster
            _asterName = "CIN2_NRAD";

            // Parametres matériau
            this->addDoubleProperty( "Delta1", ElementaryMaterialPropertyDouble( "DELTA1" , 1.E+0 , false ) );
            this->addDoubleProperty( "Delta2", ElementaryMaterialPropertyDouble( "DELTA2" , 1.E+0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Cin2Nrad */
typedef boost::shared_ptr< Cin2NradMaterialBehaviourInstance > Cin2NradMaterialBehaviourPtr;


/**
 * @class MemoEcroMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MemoEcro
 * @author Jean-Pierre Lefebvre
 */
class MemoEcroMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MemoEcroMaterialBehaviourInstance()
        {
            // Mot cle "MEMO_ECRO" dans Aster
            _asterName = "MEMO_ECRO";

            // Parametres matériau
            this->addDoubleProperty( "Mu", ElementaryMaterialPropertyDouble( "MU" , true ) );
            this->addDoubleProperty( "Q_m", ElementaryMaterialPropertyDouble( "Q_M" , true ) );
            this->addDoubleProperty( "Q_0", ElementaryMaterialPropertyDouble( "Q_0" , true ) );
            this->addDoubleProperty( "Eta", ElementaryMaterialPropertyDouble( "ETA" , 0.5E+0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MemoEcro */
typedef boost::shared_ptr< MemoEcroMaterialBehaviourInstance > MemoEcroMaterialBehaviourPtr;


/**
 * @class MemoEcroFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MemoEcroFo
 * @author Jean-Pierre Lefebvre
 */
class MemoEcroFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MemoEcroFoMaterialBehaviourInstance()
        {
            // Mot cle "MEMO_ECRO_FO" dans Aster
            _asterName = "MEMO_ECRO_FO";

            // Parametres matériau
            this->addFunctionProperty( "Mu", ElementaryMaterialPropertyFunction( "MU" , true ) );
            this->addFunctionProperty( "Q_m", ElementaryMaterialPropertyFunction( "Q_M" , true ) );
            this->addFunctionProperty( "Q_0", ElementaryMaterialPropertyFunction( "Q_0" , true ) );
            this->addFunctionProperty( "Eta", ElementaryMaterialPropertyFunction( "ETA" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MemoEcroFo */
typedef boost::shared_ptr< MemoEcroFoMaterialBehaviourInstance > MemoEcroFoMaterialBehaviourPtr;


/**
 * @class ViscochabMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Viscochab
 * @author Jean-Pierre Lefebvre
 */
class ViscochabMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ViscochabMaterialBehaviourInstance()
        {
            // Mot cle "VISCOCHAB" dans Aster
            _asterName = "VISCOCHAB";

            // Parametres matériau
            this->addDoubleProperty( "K_0", ElementaryMaterialPropertyDouble( "K_0" , true ) );
            this->addDoubleProperty( "A_k", ElementaryMaterialPropertyDouble( "A_K" , 0.E+0 , false ) );
            this->addDoubleProperty( "A_r", ElementaryMaterialPropertyDouble( "A_R" , 1.E+0 , false ) );
            this->addDoubleProperty( "K", ElementaryMaterialPropertyDouble( "K" , true ) );
            this->addDoubleProperty( "N", ElementaryMaterialPropertyDouble( "N" , true ) );
            this->addDoubleProperty( "Alp", ElementaryMaterialPropertyDouble( "ALP" , 0.E+0 , false ) );
            this->addDoubleProperty( "B", ElementaryMaterialPropertyDouble( "B" , false ) );
            this->addDoubleProperty( "M_r", ElementaryMaterialPropertyDouble( "M_R" , 1.E+0 , false ) );
            this->addDoubleProperty( "G_r", ElementaryMaterialPropertyDouble( "G_R" , 0.E+0 , false ) );
            this->addDoubleProperty( "Mu", ElementaryMaterialPropertyDouble( "MU" , 0.E+0 , true ) );
            this->addDoubleProperty( "Q_m", ElementaryMaterialPropertyDouble( "Q_M" , true ) );
            this->addDoubleProperty( "Q_0", ElementaryMaterialPropertyDouble( "Q_0" , true ) );
            this->addDoubleProperty( "Qr_0", ElementaryMaterialPropertyDouble( "QR_0" , 0.E+0 , false ) );
            this->addDoubleProperty( "Eta", ElementaryMaterialPropertyDouble( "ETA" , 0.5E+0 , false ) );
            this->addDoubleProperty( "C1", ElementaryMaterialPropertyDouble( "C1" , true ) );
            this->addDoubleProperty( "M_1", ElementaryMaterialPropertyDouble( "M_1" , 1.E+0 , false ) );
            this->addDoubleProperty( "D1", ElementaryMaterialPropertyDouble( "D1" , 1.E+0 , false ) );
            this->addDoubleProperty( "G_x1", ElementaryMaterialPropertyDouble( "G_X1" , 0.E+0 , false ) );
            this->addDoubleProperty( "G1_0", ElementaryMaterialPropertyDouble( "G1_0" , true ) );
            this->addDoubleProperty( "C2", ElementaryMaterialPropertyDouble( "C2" , true ) );
            this->addDoubleProperty( "M_2", ElementaryMaterialPropertyDouble( "M_2" , 1.E+0 , false ) );
            this->addDoubleProperty( "D2", ElementaryMaterialPropertyDouble( "D2" , 1.E+0 , false ) );
            this->addDoubleProperty( "G_x2", ElementaryMaterialPropertyDouble( "G_X2" , 0.E+0 , false ) );
            this->addDoubleProperty( "G2_0", ElementaryMaterialPropertyDouble( "G2_0" , true ) );
            this->addDoubleProperty( "A_i", ElementaryMaterialPropertyDouble( "A_I" , 1.E+0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Viscochab */
typedef boost::shared_ptr< ViscochabMaterialBehaviourInstance > ViscochabMaterialBehaviourPtr;


/**
 * @class ViscochabFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ViscochabFo
 * @author Jean-Pierre Lefebvre
 */
class ViscochabFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ViscochabFoMaterialBehaviourInstance()
        {
            // Mot cle "VISCOCHAB_FO" dans Aster
            _asterName = "VISCOCHAB_FO";

            // Parametres matériau
            this->addFunctionProperty( "K_0", ElementaryMaterialPropertyFunction( "K_0" , true ) );
            this->addFunctionProperty( "A_k", ElementaryMaterialPropertyFunction( "A_K" , true ) );
            this->addFunctionProperty( "A_r", ElementaryMaterialPropertyFunction( "A_R" , true ) );
            this->addFunctionProperty( "K", ElementaryMaterialPropertyFunction( "K" , true ) );
            this->addFunctionProperty( "N", ElementaryMaterialPropertyFunction( "N" , true ) );
            this->addFunctionProperty( "Alp", ElementaryMaterialPropertyFunction( "ALP" , true ) );
            this->addFunctionProperty( "B", ElementaryMaterialPropertyFunction( "B" , true ) );
            this->addFunctionProperty( "M_r", ElementaryMaterialPropertyFunction( "M_R" , true ) );
            this->addFunctionProperty( "G_r", ElementaryMaterialPropertyFunction( "G_R" , true ) );
            this->addFunctionProperty( "Mu", ElementaryMaterialPropertyFunction( "MU" , true ) );
            this->addFunctionProperty( "Q_m", ElementaryMaterialPropertyFunction( "Q_M" , true ) );
            this->addFunctionProperty( "Q_0", ElementaryMaterialPropertyFunction( "Q_0" , true ) );
            this->addFunctionProperty( "Qr_0", ElementaryMaterialPropertyFunction( "QR_0" , true ) );
            this->addFunctionProperty( "Eta", ElementaryMaterialPropertyFunction( "ETA" , true ) );
            this->addFunctionProperty( "C1", ElementaryMaterialPropertyFunction( "C1" , true ) );
            this->addFunctionProperty( "M_1", ElementaryMaterialPropertyFunction( "M_1" , true ) );
            this->addFunctionProperty( "D1", ElementaryMaterialPropertyFunction( "D1" , true ) );
            this->addFunctionProperty( "G_x1", ElementaryMaterialPropertyFunction( "G_X1" , true ) );
            this->addFunctionProperty( "G1_0", ElementaryMaterialPropertyFunction( "G1_0" , true ) );
            this->addFunctionProperty( "C2", ElementaryMaterialPropertyFunction( "C2" , true ) );
            this->addFunctionProperty( "M_2", ElementaryMaterialPropertyFunction( "M_2" , true ) );
            this->addFunctionProperty( "D2", ElementaryMaterialPropertyFunction( "D2" , true ) );
            this->addFunctionProperty( "G_x2", ElementaryMaterialPropertyFunction( "G_X2" , true ) );
            this->addFunctionProperty( "G2_0", ElementaryMaterialPropertyFunction( "G2_0" , true ) );
            this->addFunctionProperty( "A_i", ElementaryMaterialPropertyFunction( "A_I" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ViscochabFo */
typedef boost::shared_ptr< ViscochabFoMaterialBehaviourInstance > ViscochabFoMaterialBehaviourPtr;


/**
 * @class LemaitreMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Lemaitre
 * @author Jean-Pierre Lefebvre
 */
class LemaitreMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        LemaitreMaterialBehaviourInstance()
        {
            // Mot cle "LEMAITRE" dans Aster
            _asterName = "LEMAITRE";

            // Parametres matériau
            this->addDoubleProperty( "N", ElementaryMaterialPropertyDouble( "N" , true ) );
            this->addDoubleProperty( "Un_sur_k", ElementaryMaterialPropertyDouble( "UN_SUR_K" , true ) );
            this->addDoubleProperty( "Un_sur_m", ElementaryMaterialPropertyDouble( "UN_SUR_M" , 0.E+0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Lemaitre */
typedef boost::shared_ptr< LemaitreMaterialBehaviourInstance > LemaitreMaterialBehaviourPtr;


/**
 * @class LemaitreIrraMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau LemaitreIrra
 * @author Jean-Pierre Lefebvre
 */
class LemaitreIrraMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        LemaitreIrraMaterialBehaviourInstance()
        {
            // Mot cle "LEMAITRE_IRRA" dans Aster
            _asterName = "LEMAITRE_IRRA";

            // Parametres matériau
            this->addDoubleProperty( "N", ElementaryMaterialPropertyDouble( "N" , true ) );
            this->addDoubleProperty( "Un_sur_k", ElementaryMaterialPropertyDouble( "UN_SUR_K" , true ) );
            this->addDoubleProperty( "Un_sur_m", ElementaryMaterialPropertyDouble( "UN_SUR_M" , 0.E+0 , false ) );
            this->addDoubleProperty( "Qsr_k", ElementaryMaterialPropertyDouble( "QSR_K" , 0.E+0 , false ) );
            this->addDoubleProperty( "Beta", ElementaryMaterialPropertyDouble( "BETA" , 0.E+0 , false ) );
            this->addDoubleProperty( "Phi_zero", ElementaryMaterialPropertyDouble( "PHI_ZERO" , 1.E+20 , false ) );
            this->addDoubleProperty( "L", ElementaryMaterialPropertyDouble( "L" , 0.E+0 , false ) );
            this->addFunctionProperty( "GranFo", ElementaryMaterialPropertyFunction( "GRAN_FO" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau LemaitreIrra */
typedef boost::shared_ptr< LemaitreIrraMaterialBehaviourInstance > LemaitreIrraMaterialBehaviourPtr;


/**
 * @class LmarcIrraMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau LmarcIrra
 * @author Jean-Pierre Lefebvre
 */
class LmarcIrraMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        LmarcIrraMaterialBehaviourInstance()
        {
            // Mot cle "LMARC_IRRA" dans Aster
            _asterName = "LMARC_IRRA";

            // Parametres matériau
            this->addDoubleProperty( "De_0", ElementaryMaterialPropertyDouble( "DE_0" , true ) );
            this->addDoubleProperty( "R_0", ElementaryMaterialPropertyDouble( "R_0" , true ) );
            this->addDoubleProperty( "N", ElementaryMaterialPropertyDouble( "N" , true ) );
            this->addDoubleProperty( "K", ElementaryMaterialPropertyDouble( "K" , true ) );
            this->addDoubleProperty( "Y_i", ElementaryMaterialPropertyDouble( "Y_I" , true ) );
            this->addDoubleProperty( "Y_0", ElementaryMaterialPropertyDouble( "Y_0" , true ) );
            this->addDoubleProperty( "B", ElementaryMaterialPropertyDouble( "B" , true ) );
            this->addDoubleProperty( "A_0", ElementaryMaterialPropertyDouble( "A_0" , true ) );
            this->addDoubleProperty( "Rm", ElementaryMaterialPropertyDouble( "RM" , true ) );
            this->addDoubleProperty( "M", ElementaryMaterialPropertyDouble( "M" , true ) );
            this->addDoubleProperty( "P", ElementaryMaterialPropertyDouble( "P" , true ) );
            this->addDoubleProperty( "P1", ElementaryMaterialPropertyDouble( "P1" , true ) );
            this->addDoubleProperty( "P2", ElementaryMaterialPropertyDouble( "P2" , true ) );
            this->addDoubleProperty( "M11", ElementaryMaterialPropertyDouble( "M11" , true ) );
            this->addDoubleProperty( "M22", ElementaryMaterialPropertyDouble( "M22" , true ) );
            this->addDoubleProperty( "M33", ElementaryMaterialPropertyDouble( "M33" , true ) );
            this->addDoubleProperty( "M66", ElementaryMaterialPropertyDouble( "M66" , true ) );
            this->addDoubleProperty( "N11", ElementaryMaterialPropertyDouble( "N11" , true ) );
            this->addDoubleProperty( "N22", ElementaryMaterialPropertyDouble( "N22" , true ) );
            this->addDoubleProperty( "N33", ElementaryMaterialPropertyDouble( "N33" , true ) );
            this->addDoubleProperty( "N66", ElementaryMaterialPropertyDouble( "N66" , true ) );
            this->addDoubleProperty( "Q11", ElementaryMaterialPropertyDouble( "Q11" , true ) );
            this->addDoubleProperty( "Q22", ElementaryMaterialPropertyDouble( "Q22" , true ) );
            this->addDoubleProperty( "Q33", ElementaryMaterialPropertyDouble( "Q33" , true ) );
            this->addDoubleProperty( "Q66", ElementaryMaterialPropertyDouble( "Q66" , true ) );
            this->addDoubleProperty( "R11", ElementaryMaterialPropertyDouble( "R11" , true ) );
            this->addDoubleProperty( "R22", ElementaryMaterialPropertyDouble( "R22" , true ) );
            this->addDoubleProperty( "R33", ElementaryMaterialPropertyDouble( "R33" , true ) );
            this->addDoubleProperty( "R66", ElementaryMaterialPropertyDouble( "R66" , true ) );
            this->addFunctionProperty( "GranFo", ElementaryMaterialPropertyFunction( "GRAN_FO" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau LmarcIrra */
typedef boost::shared_ptr< LmarcIrraMaterialBehaviourInstance > LmarcIrraMaterialBehaviourPtr;


/**
 * @class ViscIrraLogMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ViscIrraLog
 * @author Jean-Pierre Lefebvre
 */
class ViscIrraLogMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ViscIrraLogMaterialBehaviourInstance()
        {
            // Mot cle "VISC_IRRA_LOG" dans Aster
            _asterName = "VISC_IRRA_LOG";

            // Parametres matériau
            this->addDoubleProperty( "A", ElementaryMaterialPropertyDouble( "A" , 1.28E-1 , false ) );
            this->addDoubleProperty( "B", ElementaryMaterialPropertyDouble( "B" , 0.01159 , false ) );
            this->addDoubleProperty( "Cste_tps", ElementaryMaterialPropertyDouble( "CSTE_TPS" , 0.3540 , false ) );
            this->addDoubleProperty( "Ener_act", ElementaryMaterialPropertyDouble( "ENER_ACT" , 5000. , false ) );
            this->addDoubleProperty( "Flux_phi", ElementaryMaterialPropertyDouble( "FLUX_PHI" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ViscIrraLog */
typedef boost::shared_ptr< ViscIrraLogMaterialBehaviourInstance > ViscIrraLogMaterialBehaviourPtr;


/**
 * @class GranIrraLogMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau GranIrraLog
 * @author Jean-Pierre Lefebvre
 */
class GranIrraLogMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        GranIrraLogMaterialBehaviourInstance()
        {
            // Mot cle "GRAN_IRRA_LOG" dans Aster
            _asterName = "GRAN_IRRA_LOG";

            // Parametres matériau
            this->addDoubleProperty( "A", ElementaryMaterialPropertyDouble( "A" , 1.28E-1 , false ) );
            this->addDoubleProperty( "B", ElementaryMaterialPropertyDouble( "B" , 0.01159 , false ) );
            this->addDoubleProperty( "Cste_tps", ElementaryMaterialPropertyDouble( "CSTE_TPS" , 0.3540 , false ) );
            this->addDoubleProperty( "Ener_act", ElementaryMaterialPropertyDouble( "ENER_ACT" , 5000. , false ) );
            this->addDoubleProperty( "Flux_phi", ElementaryMaterialPropertyDouble( "FLUX_PHI" , true ) );
            this->addFunctionProperty( "GranFo", ElementaryMaterialPropertyFunction( "GRAN_FO" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau GranIrraLog */
typedef boost::shared_ptr< GranIrraLogMaterialBehaviourInstance > GranIrraLogMaterialBehaviourPtr;


/**
 * @class LemaSeuilMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau LemaSeuil
 * @author Jean-Pierre Lefebvre
 */
class LemaSeuilMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        LemaSeuilMaterialBehaviourInstance()
        {
            // Mot cle "LEMA_SEUIL" dans Aster
            _asterName = "LEMA_SEUIL";

            // Parametres matériau
            this->addDoubleProperty( "A", ElementaryMaterialPropertyDouble( "A" , true ) );
            this->addDoubleProperty( "S", ElementaryMaterialPropertyDouble( "S" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau LemaSeuil */
typedef boost::shared_ptr< LemaSeuilMaterialBehaviourInstance > LemaSeuilMaterialBehaviourPtr;


/**
 * @class LemaSeuilFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau LemaSeuilFo
 * @author Jean-Pierre Lefebvre
 */
class LemaSeuilFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        LemaSeuilFoMaterialBehaviourInstance()
        {
            // Mot cle "LEMA_SEUIL_FO" dans Aster
            _asterName = "LEMA_SEUIL_FO";

            // Parametres matériau
            this->addFunctionProperty( "A", ElementaryMaterialPropertyFunction( "A" , true ) );
            this->addFunctionProperty( "S", ElementaryMaterialPropertyFunction( "S" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau LemaSeuilFo */
typedef boost::shared_ptr< LemaSeuilFoMaterialBehaviourInstance > LemaSeuilFoMaterialBehaviourPtr;


/**
 * @class Irrad3mMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Irrad3m
 * @author Jean-Pierre Lefebvre
 */
class Irrad3mMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        Irrad3mMaterialBehaviourInstance()
        {
            // Mot cle "IRRAD3M" dans Aster
            _asterName = "IRRAD3M";

            // Parametres matériau
            this->addFunctionProperty( "R02", ElementaryMaterialPropertyFunction( "R02" , true ) );
            this->addFunctionProperty( "Epsi_u", ElementaryMaterialPropertyFunction( "EPSI_U" , true ) );
            this->addFunctionProperty( "Rm", ElementaryMaterialPropertyFunction( "RM" , true ) );
            this->addDoubleProperty( "Ai0", ElementaryMaterialPropertyDouble( "AI0" , true ) );
            this->addFunctionProperty( "Zeta_f", ElementaryMaterialPropertyFunction( "ZETA_F" , false ) );
            this->addDoubleProperty( "Etai_s", ElementaryMaterialPropertyDouble( "ETAI_S" , true ) );
            this->addDoubleProperty( "Rg0", ElementaryMaterialPropertyDouble( "RG0" , true ) );
            this->addDoubleProperty( "Alpha", ElementaryMaterialPropertyDouble( "ALPHA" , true ) );
            this->addDoubleProperty( "Phi0", ElementaryMaterialPropertyDouble( "PHI0" , true ) );
            this->addDoubleProperty( "Kappa", ElementaryMaterialPropertyDouble( "KAPPA" , 0.8 , false ) );
            this->addFunctionProperty( "Zeta_g", ElementaryMaterialPropertyFunction( "ZETA_G" , false ) );
            this->addDoubleProperty( "Toler_et", ElementaryMaterialPropertyDouble( "TOLER_ET" , 0.15 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Irrad3m */
typedef boost::shared_ptr< Irrad3mMaterialBehaviourInstance > Irrad3mMaterialBehaviourPtr;


/**
 * @class LemaitreFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau LemaitreFo
 * @author Jean-Pierre Lefebvre
 */
class LemaitreFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        LemaitreFoMaterialBehaviourInstance()
        {
            // Mot cle "LEMAITRE_FO" dans Aster
            _asterName = "LEMAITRE_FO";

            // Parametres matériau
            this->addFunctionProperty( "N", ElementaryMaterialPropertyFunction( "N" , true ) );
            this->addFunctionProperty( "Un_sur_k", ElementaryMaterialPropertyFunction( "UN_SUR_K" , true ) );
            this->addFunctionProperty( "Un_sur_m", ElementaryMaterialPropertyFunction( "UN_SUR_M" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau LemaitreFo */
typedef boost::shared_ptr< LemaitreFoMaterialBehaviourInstance > LemaitreFoMaterialBehaviourPtr;


/**
 * @class MetaLemaAniMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MetaLemaAni
 * @author Jean-Pierre Lefebvre
 */
class MetaLemaAniMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MetaLemaAniMaterialBehaviourInstance()
        {
            // Mot cle "META_LEMA_ANI" dans Aster
            _asterName = "META_LEMA_ANI";

            // Parametres matériau
            this->addDoubleProperty( "F1_a", ElementaryMaterialPropertyDouble( "F1_A" , true ) );
            this->addDoubleProperty( "F2_a", ElementaryMaterialPropertyDouble( "F2_A" , true ) );
            this->addDoubleProperty( "C_a", ElementaryMaterialPropertyDouble( "C_A" , true ) );
            this->addDoubleProperty( "F1_m", ElementaryMaterialPropertyDouble( "F1_M" , true ) );
            this->addDoubleProperty( "F2_m", ElementaryMaterialPropertyDouble( "F2_M" , true ) );
            this->addDoubleProperty( "C_m", ElementaryMaterialPropertyDouble( "C_M" , true ) );
            this->addDoubleProperty( "F1_n", ElementaryMaterialPropertyDouble( "F1_N" , true ) );
            this->addDoubleProperty( "F2_n", ElementaryMaterialPropertyDouble( "F2_N" , true ) );
            this->addDoubleProperty( "C_n", ElementaryMaterialPropertyDouble( "C_N" , true ) );
            this->addDoubleProperty( "F1_q", ElementaryMaterialPropertyDouble( "F1_Q" , true ) );
            this->addDoubleProperty( "F2_q", ElementaryMaterialPropertyDouble( "F2_Q" , true ) );
            this->addDoubleProperty( "C_q", ElementaryMaterialPropertyDouble( "C_Q" , true ) );
            this->addDoubleProperty( "F_mrr_rr", ElementaryMaterialPropertyDouble( "F_MRR_RR" , false ) );
            this->addDoubleProperty( "C_mrr_rr", ElementaryMaterialPropertyDouble( "C_MRR_RR" , false ) );
            this->addDoubleProperty( "F_mtt_tt", ElementaryMaterialPropertyDouble( "F_MTT_TT" , false ) );
            this->addDoubleProperty( "C_mtt_tt", ElementaryMaterialPropertyDouble( "C_MTT_TT" , false ) );
            this->addDoubleProperty( "F_mzz_zz", ElementaryMaterialPropertyDouble( "F_MZZ_ZZ" , false ) );
            this->addDoubleProperty( "C_mzz_zz", ElementaryMaterialPropertyDouble( "C_MZZ_ZZ" , false ) );
            this->addDoubleProperty( "F_mrt_rt", ElementaryMaterialPropertyDouble( "F_MRT_RT" , false ) );
            this->addDoubleProperty( "C_mrt_rt", ElementaryMaterialPropertyDouble( "C_MRT_RT" , false ) );
            this->addDoubleProperty( "F_mrz_rz", ElementaryMaterialPropertyDouble( "F_MRZ_RZ" , false ) );
            this->addDoubleProperty( "C_mrz_rz", ElementaryMaterialPropertyDouble( "C_MRZ_RZ" , false ) );
            this->addDoubleProperty( "F_mtz_tz", ElementaryMaterialPropertyDouble( "F_MTZ_TZ" , false ) );
            this->addDoubleProperty( "C_mtz_tz", ElementaryMaterialPropertyDouble( "C_MTZ_TZ" , false ) );
            this->addDoubleProperty( "F_mxx_xx", ElementaryMaterialPropertyDouble( "F_MXX_XX" , false ) );
            this->addDoubleProperty( "C_mxx_xx", ElementaryMaterialPropertyDouble( "C_MXX_XX" , false ) );
            this->addDoubleProperty( "F_myy_yy", ElementaryMaterialPropertyDouble( "F_MYY_YY" , false ) );
            this->addDoubleProperty( "C_myy_yy", ElementaryMaterialPropertyDouble( "C_MYY_YY" , false ) );
            this->addDoubleProperty( "F_mxy_xy", ElementaryMaterialPropertyDouble( "F_MXY_XY" , false ) );
            this->addDoubleProperty( "C_mxy_xy", ElementaryMaterialPropertyDouble( "C_MXY_XY" , false ) );
            this->addDoubleProperty( "F_mxz_xz", ElementaryMaterialPropertyDouble( "F_MXZ_XZ" , false ) );
            this->addDoubleProperty( "C_mxz_xz", ElementaryMaterialPropertyDouble( "C_MXZ_XZ" , false ) );
            this->addDoubleProperty( "F_myz_yz", ElementaryMaterialPropertyDouble( "F_MYZ_YZ" , false ) );
            this->addDoubleProperty( "C_myz_yz", ElementaryMaterialPropertyDouble( "C_MYZ_YZ" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MetaLemaAni */
typedef boost::shared_ptr< MetaLemaAniMaterialBehaviourInstance > MetaLemaAniMaterialBehaviourPtr;


/**
 * @class MetaLemaAniFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MetaLemaAniFo
 * @author Jean-Pierre Lefebvre
 */
class MetaLemaAniFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MetaLemaAniFoMaterialBehaviourInstance()
        {
            // Mot cle "META_LEMA_ANI_FO" dans Aster
            _asterName = "META_LEMA_ANI_FO";

            // Parametres matériau
            this->addFunctionProperty( "F1_a", ElementaryMaterialPropertyFunction( "F1_A" , true ) );
            this->addFunctionProperty( "F2_a", ElementaryMaterialPropertyFunction( "F2_A" , true ) );
            this->addFunctionProperty( "C_a", ElementaryMaterialPropertyFunction( "C_A" , true ) );
            this->addFunctionProperty( "F1_m", ElementaryMaterialPropertyFunction( "F1_M" , true ) );
            this->addFunctionProperty( "F2_m", ElementaryMaterialPropertyFunction( "F2_M" , true ) );
            this->addFunctionProperty( "C_m", ElementaryMaterialPropertyFunction( "C_M" , true ) );
            this->addFunctionProperty( "F1_n", ElementaryMaterialPropertyFunction( "F1_N" , true ) );
            this->addFunctionProperty( "F2_n", ElementaryMaterialPropertyFunction( "F2_N" , true ) );
            this->addFunctionProperty( "C_n", ElementaryMaterialPropertyFunction( "C_N" , true ) );
            this->addFunctionProperty( "F1_q", ElementaryMaterialPropertyFunction( "F1_Q" , true ) );
            this->addFunctionProperty( "F2_q", ElementaryMaterialPropertyFunction( "F2_Q" , true ) );
            this->addFunctionProperty( "C_q", ElementaryMaterialPropertyFunction( "C_Q" , true ) );
            this->addFunctionProperty( "F_mrr_rr", ElementaryMaterialPropertyFunction( "F_MRR_RR" , false ) );
            this->addFunctionProperty( "C_mrr_rr", ElementaryMaterialPropertyFunction( "C_MRR_RR" , false ) );
            this->addFunctionProperty( "F_mtt_tt", ElementaryMaterialPropertyFunction( "F_MTT_TT" , false ) );
            this->addFunctionProperty( "C_mtt_tt", ElementaryMaterialPropertyFunction( "C_MTT_TT" , false ) );
            this->addFunctionProperty( "F_mzz_zz", ElementaryMaterialPropertyFunction( "F_MZZ_ZZ" , false ) );
            this->addFunctionProperty( "C_mzz_zz", ElementaryMaterialPropertyFunction( "C_MZZ_ZZ" , false ) );
            this->addFunctionProperty( "F_mrt_rt", ElementaryMaterialPropertyFunction( "F_MRT_RT" , false ) );
            this->addFunctionProperty( "C_mrt_rt", ElementaryMaterialPropertyFunction( "C_MRT_RT" , false ) );
            this->addFunctionProperty( "F_mrz_rz", ElementaryMaterialPropertyFunction( "F_MRZ_RZ" , false ) );
            this->addFunctionProperty( "C_mrz_rz", ElementaryMaterialPropertyFunction( "C_MRZ_RZ" , false ) );
            this->addFunctionProperty( "F_mtz_tz", ElementaryMaterialPropertyFunction( "F_MTZ_TZ" , false ) );
            this->addFunctionProperty( "C_mtz_tz", ElementaryMaterialPropertyFunction( "C_MTZ_TZ" , false ) );
            this->addFunctionProperty( "F_mxx_xx", ElementaryMaterialPropertyFunction( "F_MXX_XX" , false ) );
            this->addFunctionProperty( "C_mxx_xx", ElementaryMaterialPropertyFunction( "C_MXX_XX" , false ) );
            this->addFunctionProperty( "F_myy_yy", ElementaryMaterialPropertyFunction( "F_MYY_YY" , false ) );
            this->addFunctionProperty( "C_myy_yy", ElementaryMaterialPropertyFunction( "C_MYY_YY" , false ) );
            this->addFunctionProperty( "F_mxy_xy", ElementaryMaterialPropertyFunction( "F_MXY_XY" , false ) );
            this->addFunctionProperty( "C_mxy_xy", ElementaryMaterialPropertyFunction( "C_MXY_XY" , false ) );
            this->addFunctionProperty( "F_mxz_xz", ElementaryMaterialPropertyFunction( "F_MXZ_XZ" , false ) );
            this->addFunctionProperty( "C_mxz_xz", ElementaryMaterialPropertyFunction( "C_MXZ_XZ" , false ) );
            this->addFunctionProperty( "F_myz_yz", ElementaryMaterialPropertyFunction( "F_MYZ_YZ" , false ) );
            this->addFunctionProperty( "C_myz_yz", ElementaryMaterialPropertyFunction( "C_MYZ_YZ" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MetaLemaAniFo */
typedef boost::shared_ptr< MetaLemaAniFoMaterialBehaviourInstance > MetaLemaAniFoMaterialBehaviourPtr;


/**
 * @class ArmeMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Arme
 * @author Jean-Pierre Lefebvre
 */
class ArmeMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ArmeMaterialBehaviourInstance()
        {
            // Mot cle "ARME" dans Aster
            _asterName = "ARME";

            // Parametres matériau
            this->addDoubleProperty( "Kye", ElementaryMaterialPropertyDouble( "KYE" , true ) );
            this->addDoubleProperty( "Dle", ElementaryMaterialPropertyDouble( "DLE" , true ) );
            this->addDoubleProperty( "Kyp", ElementaryMaterialPropertyDouble( "KYP" , true ) );
            this->addDoubleProperty( "Dlp", ElementaryMaterialPropertyDouble( "DLP" , true ) );
            this->addDoubleProperty( "Kyg", ElementaryMaterialPropertyDouble( "KYG" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Arme */
typedef boost::shared_ptr< ArmeMaterialBehaviourInstance > ArmeMaterialBehaviourPtr;


/**
 * @class AsseCornMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau AsseCorn
 * @author Jean-Pierre Lefebvre
 */
class AsseCornMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        AsseCornMaterialBehaviourInstance()
        {
            // Mot cle "ASSE_CORN" dans Aster
            _asterName = "ASSE_CORN";

            // Parametres matériau
            this->addDoubleProperty( "Nu_1", ElementaryMaterialPropertyDouble( "NU_1" , true ) );
            this->addDoubleProperty( "Mu_1", ElementaryMaterialPropertyDouble( "MU_1" , true ) );
            this->addDoubleProperty( "Dxu_1", ElementaryMaterialPropertyDouble( "DXU_1" , true ) );
            this->addDoubleProperty( "Dryu_1", ElementaryMaterialPropertyDouble( "DRYU_1" , true ) );
            this->addDoubleProperty( "C_1", ElementaryMaterialPropertyDouble( "C_1" , true ) );
            this->addDoubleProperty( "Nu_2", ElementaryMaterialPropertyDouble( "NU_2" , true ) );
            this->addDoubleProperty( "Mu_2", ElementaryMaterialPropertyDouble( "MU_2" , true ) );
            this->addDoubleProperty( "Dxu_2", ElementaryMaterialPropertyDouble( "DXU_2" , true ) );
            this->addDoubleProperty( "Dryu_2", ElementaryMaterialPropertyDouble( "DRYU_2" , true ) );
            this->addDoubleProperty( "C_2", ElementaryMaterialPropertyDouble( "C_2" , true ) );
            this->addDoubleProperty( "Ky", ElementaryMaterialPropertyDouble( "KY" , true ) );
            this->addDoubleProperty( "Kz", ElementaryMaterialPropertyDouble( "KZ" , true ) );
            this->addDoubleProperty( "Krx", ElementaryMaterialPropertyDouble( "KRX" , true ) );
            this->addDoubleProperty( "Krz", ElementaryMaterialPropertyDouble( "KRZ" , true ) );
            this->addDoubleProperty( "R_p0", ElementaryMaterialPropertyDouble( "R_P0" , 1.E+4 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau AsseCorn */
typedef boost::shared_ptr< AsseCornMaterialBehaviourInstance > AsseCornMaterialBehaviourPtr;


/**
 * @class DisContactMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau DisContact
 * @author Jean-Pierre Lefebvre
 */
class DisContactMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        DisContactMaterialBehaviourInstance()
        {
            // Mot cle "DIS_CONTACT" dans Aster
            _asterName = "DIS_CONTACT";

            // Parametres matériau
            this->addDoubleProperty( "Rigi_nor", ElementaryMaterialPropertyDouble( "RIGI_NOR" , false ) );
            this->addDoubleProperty( "Rigi_tan", ElementaryMaterialPropertyDouble( "RIGI_TAN" , 0.E+0 , false ) );
            this->addDoubleProperty( "Amor_nor", ElementaryMaterialPropertyDouble( "AMOR_NOR" , false ) );
            this->addDoubleProperty( "Amor_tan", ElementaryMaterialPropertyDouble( "AMOR_TAN" , false ) );
            this->addDoubleProperty( "Coulomb", ElementaryMaterialPropertyDouble( "COULOMB" , 0.E+0 , false ) );
            this->addDoubleProperty( "Dist_1", ElementaryMaterialPropertyDouble( "DIST_1" , 0.E+0 , false ) );
            this->addDoubleProperty( "Dist_2", ElementaryMaterialPropertyDouble( "DIST_2" , 0.E+0 , false ) );
            this->addDoubleProperty( "Jeu", ElementaryMaterialPropertyDouble( "JEU" , 0.E+0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau DisContact */
typedef boost::shared_ptr< DisContactMaterialBehaviourInstance > DisContactMaterialBehaviourPtr;


/**
 * @class EndoScalaireMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau EndoScalaire
 * @author Jean-Pierre Lefebvre
 */
class EndoScalaireMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        EndoScalaireMaterialBehaviourInstance()
        {
            // Mot cle "ENDO_SCALAIRE" dans Aster
            _asterName = "ENDO_SCALAIRE";

            // Parametres matériau
            this->addDoubleProperty( "K", ElementaryMaterialPropertyDouble( "K" , true ) );
            this->addDoubleProperty( "P", ElementaryMaterialPropertyDouble( "P" , true ) );
            this->addDoubleProperty( "Q", ElementaryMaterialPropertyDouble( "Q" , 0.0 , false ) );
            this->addDoubleProperty( "M", ElementaryMaterialPropertyDouble( "M" , true ) );
            this->addDoubleProperty( "C_comp", ElementaryMaterialPropertyDouble( "C_COMP" , 0.0 , false ) );
            this->addDoubleProperty( "C_volu", ElementaryMaterialPropertyDouble( "C_VOLU" , 1.0 , false ) );
            this->addDoubleProperty( "Coef_rigi_mini", ElementaryMaterialPropertyDouble( "COEF_RIGI_MINI" , 1.E-5 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau EndoScalaire */
typedef boost::shared_ptr< EndoScalaireMaterialBehaviourInstance > EndoScalaireMaterialBehaviourPtr;


/**
 * @class EndoScalaireFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau EndoScalaireFo
 * @author Jean-Pierre Lefebvre
 */
class EndoScalaireFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        EndoScalaireFoMaterialBehaviourInstance()
        {
            // Mot cle "ENDO_SCALAIRE_FO" dans Aster
            _asterName = "ENDO_SCALAIRE_FO";

            // Parametres matériau
            this->addFunctionProperty( "K", ElementaryMaterialPropertyFunction( "K" , true ) );
            this->addFunctionProperty( "P", ElementaryMaterialPropertyFunction( "P" , true ) );
            this->addDoubleProperty( "Q", ElementaryMaterialPropertyDouble( "Q" , 0.0 , false ) );
            this->addFunctionProperty( "M", ElementaryMaterialPropertyFunction( "M" , true ) );
            this->addFunctionProperty( "C_comp", ElementaryMaterialPropertyFunction( "C_COMP" , true ) );
            this->addFunctionProperty( "C_volu", ElementaryMaterialPropertyFunction( "C_VOLU" , true ) );
            this->addDoubleProperty( "Coef_rigi_mini", ElementaryMaterialPropertyDouble( "COEF_RIGI_MINI" , 1.E-5 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau EndoScalaireFo */
typedef boost::shared_ptr< EndoScalaireFoMaterialBehaviourInstance > EndoScalaireFoMaterialBehaviourPtr;


/**
 * @class EndoFissExpMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau EndoFissExp
 * @author Jean-Pierre Lefebvre
 */
class EndoFissExpMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        EndoFissExpMaterialBehaviourInstance()
        {
            // Mot cle "ENDO_FISS_EXP" dans Aster
            _asterName = "ENDO_FISS_EXP";

            // Parametres matériau
            this->addDoubleProperty( "K", ElementaryMaterialPropertyDouble( "K" , true ) );
            this->addDoubleProperty( "P", ElementaryMaterialPropertyDouble( "P" , true ) );
            this->addDoubleProperty( "Q", ElementaryMaterialPropertyDouble( "Q" , 0.0 , false ) );
            this->addDoubleProperty( "M", ElementaryMaterialPropertyDouble( "M" , true ) );
            this->addDoubleProperty( "Tau", ElementaryMaterialPropertyDouble( "TAU" , true ) );
            this->addDoubleProperty( "Sig0", ElementaryMaterialPropertyDouble( "SIG0" , true ) );
            this->addDoubleProperty( "Beta", ElementaryMaterialPropertyDouble( "BETA" , 0.1 , false ) );
            this->addDoubleProperty( "Coef_rigi_mini", ElementaryMaterialPropertyDouble( "COEF_RIGI_MINI" , 1.E-5 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau EndoFissExp */
typedef boost::shared_ptr< EndoFissExpMaterialBehaviourInstance > EndoFissExpMaterialBehaviourPtr;


/**
 * @class EndoFissExpFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau EndoFissExpFo
 * @author Jean-Pierre Lefebvre
 */
class EndoFissExpFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        EndoFissExpFoMaterialBehaviourInstance()
        {
            // Mot cle "ENDO_FISS_EXP_FO" dans Aster
            _asterName = "ENDO_FISS_EXP_FO";

            // Parametres matériau
            this->addFunctionProperty( "K", ElementaryMaterialPropertyFunction( "K" , true ) );
            this->addFunctionProperty( "P", ElementaryMaterialPropertyFunction( "P" , true ) );
            this->addDoubleProperty( "Q", ElementaryMaterialPropertyDouble( "Q" , 0.0 , false ) );
            this->addFunctionProperty( "M", ElementaryMaterialPropertyFunction( "M" , true ) );
            this->addFunctionProperty( "Tau", ElementaryMaterialPropertyFunction( "TAU" , true ) );
            this->addFunctionProperty( "Sig0", ElementaryMaterialPropertyFunction( "SIG0" , true ) );
            this->addDoubleProperty( "Beta", ElementaryMaterialPropertyDouble( "BETA" , 0.1 , false ) );
            this->addDoubleProperty( "Coef_rigi_mini", ElementaryMaterialPropertyDouble( "COEF_RIGI_MINI" , 1.E-5 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau EndoFissExpFo */
typedef boost::shared_ptr< EndoFissExpFoMaterialBehaviourInstance > EndoFissExpFoMaterialBehaviourPtr;


/**
 * @class DisGricraMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau DisGricra
 * @author Jean-Pierre Lefebvre
 */
class DisGricraMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        DisGricraMaterialBehaviourInstance()
        {
            // Mot cle "DIS_GRICRA" dans Aster
            _asterName = "DIS_GRICRA";

            // Parametres matériau
            this->addDoubleProperty( "Kn_ax", ElementaryMaterialPropertyDouble( "KN_AX" , true ) );
            this->addDoubleProperty( "Kt_ax", ElementaryMaterialPropertyDouble( "KT_AX" , true ) );
            this->addDoubleProperty( "Coul_ax", ElementaryMaterialPropertyDouble( "COUL_AX" , true ) );
            this->addDoubleProperty( "F_ser", ElementaryMaterialPropertyDouble( "F_SER" , false ) );
            this->addFunctionProperty( "F_serFo", ElementaryMaterialPropertyFunction( "F_SER_FO" , false ) );
            this->addDoubleProperty( "Et_ax", ElementaryMaterialPropertyDouble( "ET_AX" , 1.e-7 , false ) );
            this->addDoubleProperty( "Et_rot", ElementaryMaterialPropertyDouble( "ET_ROT" , 1.e-7 , false ) );
            this->addDoubleProperty( "Ang1", ElementaryMaterialPropertyDouble( "ANG1" , false ) );
            this->addDoubleProperty( "Ang2", ElementaryMaterialPropertyDouble( "ANG2" , false ) );
            this->addDoubleProperty( "Pen1", ElementaryMaterialPropertyDouble( "PEN1" , false ) );
            this->addDoubleProperty( "Pen2", ElementaryMaterialPropertyDouble( "PEN2" , false ) );
            this->addDoubleProperty( "Pen3", ElementaryMaterialPropertyDouble( "PEN3" , false ) );
            this->addFunctionProperty( "Ang1Fo", ElementaryMaterialPropertyFunction( "ANG1_FO" , false ) );
            this->addFunctionProperty( "Ang2Fo", ElementaryMaterialPropertyFunction( "ANG2_FO" , false ) );
            this->addFunctionProperty( "Pen1Fo", ElementaryMaterialPropertyFunction( "PEN1_FO" , false ) );
            this->addFunctionProperty( "Pen2Fo", ElementaryMaterialPropertyFunction( "PEN2_FO" , false ) );
            this->addFunctionProperty( "Pen3Fo", ElementaryMaterialPropertyFunction( "PEN3_FO" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau DisGricra */
typedef boost::shared_ptr< DisGricraMaterialBehaviourInstance > DisGricraMaterialBehaviourPtr;


/**
 * @class BetonDoubleDpMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau BetonDoubleDp
 * @author Jean-Pierre Lefebvre
 */
class BetonDoubleDpMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        BetonDoubleDpMaterialBehaviourInstance()
        {
            // Mot cle "BETON_DOUBLE_DP" dans Aster
            _asterName = "BETON_DOUBLE_DP";

            // Parametres matériau
            this->addFunctionProperty( "F_c", ElementaryMaterialPropertyFunction( "F_C" , true ) );
            this->addFunctionProperty( "F_t", ElementaryMaterialPropertyFunction( "F_T" , true ) );
            this->addFunctionProperty( "Coef_biax", ElementaryMaterialPropertyFunction( "COEF_BIAX" , true ) );
            this->addFunctionProperty( "Ener_comp_rupt", ElementaryMaterialPropertyFunction( "ENER_COMP_RUPT" , true ) );
            this->addFunctionProperty( "Ener_trac_rupt", ElementaryMaterialPropertyFunction( "ENER_TRAC_RUPT" , true ) );
            this->addDoubleProperty( "Coef_elas_comp", ElementaryMaterialPropertyDouble( "COEF_ELAS_COMP" , true ) );
            this->addDoubleProperty( "Long_cara", ElementaryMaterialPropertyDouble( "LONG_CARA" , false ) );
            this->addDoubleProperty( "Ecro_comp_p_pic", ElementaryMaterialPropertyDouble( "ECRO_COMP_P_PIC" , 0.0 , false ) );
            this->addDoubleProperty( "Ecro_trac_p_pic", ElementaryMaterialPropertyDouble( "ECRO_TRAC_P_PIC" , 8.0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau BetonDoubleDp */
typedef boost::shared_ptr< BetonDoubleDpMaterialBehaviourInstance > BetonDoubleDpMaterialBehaviourPtr;


/**
 * @class MazarsMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Mazars
 * @author Jean-Pierre Lefebvre
 */
class MazarsMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MazarsMaterialBehaviourInstance()
        {
            // Mot cle "MAZARS" dans Aster
            _asterName = "MAZARS";

            // Parametres matériau
            this->addDoubleProperty( "Epsd0", ElementaryMaterialPropertyDouble( "EPSD0" , true ) );
            this->addDoubleProperty( "K", ElementaryMaterialPropertyDouble( "K" , true ) );
            this->addDoubleProperty( "Ac", ElementaryMaterialPropertyDouble( "AC" , true ) );
            this->addDoubleProperty( "Bc", ElementaryMaterialPropertyDouble( "BC" , true ) );
            this->addDoubleProperty( "At", ElementaryMaterialPropertyDouble( "AT" , true ) );
            this->addDoubleProperty( "Bt", ElementaryMaterialPropertyDouble( "BT" , true ) );
            this->addDoubleProperty( "Chi", ElementaryMaterialPropertyDouble( "CHI" , false ) );
            this->addDoubleProperty( "Sigm_lim", ElementaryMaterialPropertyDouble( "SIGM_LIM" , false ) );
            this->addDoubleProperty( "Epsi_lim", ElementaryMaterialPropertyDouble( "EPSI_LIM" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Mazars */
typedef boost::shared_ptr< MazarsMaterialBehaviourInstance > MazarsMaterialBehaviourPtr;


/**
 * @class MazarsFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MazarsFo
 * @author Jean-Pierre Lefebvre
 */
class MazarsFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MazarsFoMaterialBehaviourInstance()
        {
            // Mot cle "MAZARS_FO" dans Aster
            _asterName = "MAZARS_FO";

            // Parametres matériau
            this->addFunctionProperty( "Epsd0", ElementaryMaterialPropertyFunction( "EPSD0" , true ) );
            this->addFunctionProperty( "K", ElementaryMaterialPropertyFunction( "K" , true ) );
            this->addFunctionProperty( "Ac", ElementaryMaterialPropertyFunction( "AC" , true ) );
            this->addFunctionProperty( "Bc", ElementaryMaterialPropertyFunction( "BC" , true ) );
            this->addFunctionProperty( "At", ElementaryMaterialPropertyFunction( "AT" , true ) );
            this->addFunctionProperty( "Bt", ElementaryMaterialPropertyFunction( "BT" , true ) );
            this->addDoubleProperty( "Chi", ElementaryMaterialPropertyDouble( "CHI" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MazarsFo */
typedef boost::shared_ptr< MazarsFoMaterialBehaviourInstance > MazarsFoMaterialBehaviourPtr;


/**
 * @class JointBaMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau JointBa
 * @author Jean-Pierre Lefebvre
 */
class JointBaMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        JointBaMaterialBehaviourInstance()
        {
            // Mot cle "JOINT_BA" dans Aster
            _asterName = "JOINT_BA";

            // Parametres matériau
            this->addDoubleProperty( "Hpen", ElementaryMaterialPropertyDouble( "HPEN" , 1.E+0 , true ) );
            this->addDoubleProperty( "Gtt", ElementaryMaterialPropertyDouble( "GTT" , true ) );
            this->addDoubleProperty( "Gamd0", ElementaryMaterialPropertyDouble( "GAMD0" , true ) );
            this->addDoubleProperty( "Ad1", ElementaryMaterialPropertyDouble( "AD1" , true ) );
            this->addDoubleProperty( "Bd1", ElementaryMaterialPropertyDouble( "BD1" , 5.E-1 , true ) );
            this->addDoubleProperty( "Gamd2", ElementaryMaterialPropertyDouble( "GAMD2" , true ) );
            this->addDoubleProperty( "Ad2", ElementaryMaterialPropertyDouble( "AD2" , true ) );
            this->addDoubleProperty( "Bd2", ElementaryMaterialPropertyDouble( "BD2" , 1.E+0 , true ) );
            this->addDoubleProperty( "Vifrot", ElementaryMaterialPropertyDouble( "VIFROT" , true ) );
            this->addDoubleProperty( "Fa", ElementaryMaterialPropertyDouble( "FA" , true ) );
            this->addDoubleProperty( "Fc", ElementaryMaterialPropertyDouble( "FC" , true ) );
            this->addDoubleProperty( "Epstr0", ElementaryMaterialPropertyDouble( "EPSTR0" , true ) );
            this->addDoubleProperty( "Adn", ElementaryMaterialPropertyDouble( "ADN" , true ) );
            this->addDoubleProperty( "Bdn", ElementaryMaterialPropertyDouble( "BDN" , 1.E+0 , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau JointBa */
typedef boost::shared_ptr< JointBaMaterialBehaviourInstance > JointBaMaterialBehaviourPtr;


/**
 * @class VendochabMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Vendochab
 * @author Jean-Pierre Lefebvre
 */
class VendochabMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        VendochabMaterialBehaviourInstance()
        {
            // Mot cle "VENDOCHAB" dans Aster
            _asterName = "VENDOCHAB";

            // Parametres matériau
            this->addDoubleProperty( "Sy", ElementaryMaterialPropertyDouble( "SY" , 0.E+0 , true ) );
            this->addDoubleProperty( "Alpha_d", ElementaryMaterialPropertyDouble( "ALPHA_D" , 0.E+0 , true ) );
            this->addDoubleProperty( "Beta_d", ElementaryMaterialPropertyDouble( "BETA_D" , 0.E+0 , true ) );
            this->addDoubleProperty( "R_d", ElementaryMaterialPropertyDouble( "R_D" , true ) );
            this->addDoubleProperty( "A_d", ElementaryMaterialPropertyDouble( "A_D" , true ) );
            this->addDoubleProperty( "K_d", ElementaryMaterialPropertyDouble( "K_D" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Vendochab */
typedef boost::shared_ptr< VendochabMaterialBehaviourInstance > VendochabMaterialBehaviourPtr;


/**
 * @class VendochabFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau VendochabFo
 * @author Jean-Pierre Lefebvre
 */
class VendochabFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        VendochabFoMaterialBehaviourInstance()
        {
            // Mot cle "VENDOCHAB_FO" dans Aster
            _asterName = "VENDOCHAB_FO";

            // Parametres matériau
            this->addFunctionProperty( "Sy", ElementaryMaterialPropertyFunction( "SY" , true ) );
            this->addFunctionProperty( "Alpha_d", ElementaryMaterialPropertyFunction( "ALPHA_D" , true ) );
            this->addFunctionProperty( "Beta_d", ElementaryMaterialPropertyFunction( "BETA_D" , true ) );
            this->addFunctionProperty( "R_d", ElementaryMaterialPropertyFunction( "R_D" , true ) );
            this->addFunctionProperty( "A_d", ElementaryMaterialPropertyFunction( "A_D" , true ) );
            this->addFunctionProperty( "K_d", ElementaryMaterialPropertyFunction( "K_D" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau VendochabFo */
typedef boost::shared_ptr< VendochabFoMaterialBehaviourInstance > VendochabFoMaterialBehaviourPtr;


/**
 * @class HayhurstMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Hayhurst
 * @author Jean-Pierre Lefebvre
 */
class HayhurstMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        HayhurstMaterialBehaviourInstance()
        {
            // Mot cle "HAYHURST" dans Aster
            _asterName = "HAYHURST";

            // Parametres matériau
            this->addDoubleProperty( "Eps0", ElementaryMaterialPropertyDouble( "EPS0" , true ) );
            this->addDoubleProperty( "K", ElementaryMaterialPropertyDouble( "K" , true ) );
            this->addDoubleProperty( "H1", ElementaryMaterialPropertyDouble( "H1" , true ) );
            this->addDoubleProperty( "H2", ElementaryMaterialPropertyDouble( "H2" , true ) );
            this->addDoubleProperty( "Delta1", ElementaryMaterialPropertyDouble( "DELTA1" , true ) );
            this->addDoubleProperty( "Delta2", ElementaryMaterialPropertyDouble( "DELTA2" , true ) );
            this->addDoubleProperty( "H1st", ElementaryMaterialPropertyDouble( "H1ST" , true ) );
            this->addDoubleProperty( "H2st", ElementaryMaterialPropertyDouble( "H2ST" , true ) );
            this->addDoubleProperty( "Kc", ElementaryMaterialPropertyDouble( "KC" , 0. , false ) );
            this->addDoubleProperty( "Biga", ElementaryMaterialPropertyDouble( "BIGA" , true ) );
            this->addDoubleProperty( "Sig0", ElementaryMaterialPropertyDouble( "SIG0" , true ) );
            this->addDoubleProperty( "Alphad", ElementaryMaterialPropertyDouble( "ALPHAD" , 0. , false ) );
            this->addDoubleProperty( "S_equi_d", ElementaryMaterialPropertyDouble( "S_EQUI_D" , 0. , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Hayhurst */
typedef boost::shared_ptr< HayhurstMaterialBehaviourInstance > HayhurstMaterialBehaviourPtr;


/**
 * @class ViscEndoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ViscEndo
 * @author Jean-Pierre Lefebvre
 */
class ViscEndoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ViscEndoMaterialBehaviourInstance()
        {
            // Mot cle "VISC_ENDO" dans Aster
            _asterName = "VISC_ENDO";

            // Parametres matériau
            this->addDoubleProperty( "Sy", ElementaryMaterialPropertyDouble( "SY" , 0.E+0 , true ) );
            this->addDoubleProperty( "R_d", ElementaryMaterialPropertyDouble( "R_D" , true ) );
            this->addDoubleProperty( "A_d", ElementaryMaterialPropertyDouble( "A_D" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ViscEndo */
typedef boost::shared_ptr< ViscEndoMaterialBehaviourInstance > ViscEndoMaterialBehaviourPtr;


/**
 * @class ViscEndoFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ViscEndoFo
 * @author Jean-Pierre Lefebvre
 */
class ViscEndoFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ViscEndoFoMaterialBehaviourInstance()
        {
            // Mot cle "VISC_ENDO_FO" dans Aster
            _asterName = "VISC_ENDO_FO";

            // Parametres matériau
            this->addFunctionProperty( "Sy", ElementaryMaterialPropertyFunction( "SY" , true ) );
            this->addFunctionProperty( "R_d", ElementaryMaterialPropertyFunction( "R_D" , true ) );
            this->addFunctionProperty( "A_d", ElementaryMaterialPropertyFunction( "A_D" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ViscEndoFo */
typedef boost::shared_ptr< ViscEndoFoMaterialBehaviourInstance > ViscEndoFoMaterialBehaviourPtr;


/**
 * @class PintoMenegottoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau PintoMenegotto
 * @author Jean-Pierre Lefebvre
 */
class PintoMenegottoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        PintoMenegottoMaterialBehaviourInstance()
        {
            // Mot cle "PINTO_MENEGOTTO" dans Aster
            _asterName = "PINTO_MENEGOTTO";

            // Parametres matériau
            this->addDoubleProperty( "Sy", ElementaryMaterialPropertyDouble( "SY" , true ) );
            this->addDoubleProperty( "Epsi_ultm", ElementaryMaterialPropertyDouble( "EPSI_ULTM" , true ) );
            this->addDoubleProperty( "Sigm_ultm", ElementaryMaterialPropertyDouble( "SIGM_ULTM" , true ) );
            this->addDoubleProperty( "Elan", ElementaryMaterialPropertyDouble( "ELAN" , 4. , false ) );
            this->addDoubleProperty( "Epsp_hard", ElementaryMaterialPropertyDouble( "EPSP_HARD" , true ) );
            this->addDoubleProperty( "R_pm", ElementaryMaterialPropertyDouble( "R_PM" , 20. , false ) );
            this->addDoubleProperty( "Ep_sur_e", ElementaryMaterialPropertyDouble( "EP_SUR_E" , false ) );
            this->addDoubleProperty( "A1_pm", ElementaryMaterialPropertyDouble( "A1_PM" , 18.5 , false ) );
            this->addDoubleProperty( "A2_pm", ElementaryMaterialPropertyDouble( "A2_PM" , 0.15 , false ) );
            this->addDoubleProperty( "A6_pm", ElementaryMaterialPropertyDouble( "A6_PM" , 620. , false ) );
            this->addDoubleProperty( "C_pm", ElementaryMaterialPropertyDouble( "C_PM" , 0.5 , false ) );
            this->addDoubleProperty( "A_pm", ElementaryMaterialPropertyDouble( "A_PM" , 6.0E-3 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau PintoMenegotto */
typedef boost::shared_ptr< PintoMenegottoMaterialBehaviourInstance > PintoMenegottoMaterialBehaviourPtr;


/**
 * @class BpelBetonMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau BpelBeton
 * @author Jean-Pierre Lefebvre
 */
class BpelBetonMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        BpelBetonMaterialBehaviourInstance()
        {
            // Mot cle "BPEL_BETON" dans Aster
            _asterName = "BPEL_BETON";

            // Parametres matériau
            this->addDoubleProperty( "Pert_flua", ElementaryMaterialPropertyDouble( "PERT_FLUA" , 0.E+0 , false ) );
            this->addDoubleProperty( "Pert_retr", ElementaryMaterialPropertyDouble( "PERT_RETR" , 0.E+0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau BpelBeton */
typedef boost::shared_ptr< BpelBetonMaterialBehaviourInstance > BpelBetonMaterialBehaviourPtr;


/**
 * @class BpelAcierMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau BpelAcier
 * @author Jean-Pierre Lefebvre
 */
class BpelAcierMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        BpelAcierMaterialBehaviourInstance()
        {
            // Mot cle "BPEL_ACIER" dans Aster
            _asterName = "BPEL_ACIER";

            // Parametres matériau
            this->addDoubleProperty( "Relax_1000", ElementaryMaterialPropertyDouble( "RELAX_1000" , 0.E+0 , false ) );
            this->addDoubleProperty( "Mu0_relax", ElementaryMaterialPropertyDouble( "MU0_RELAX" , 0.E+0 , false ) );
            this->addDoubleProperty( "F_prg", ElementaryMaterialPropertyDouble( "F_PRG" , false ) );
            this->addDoubleProperty( "Frot_courb", ElementaryMaterialPropertyDouble( "FROT_COURB" , 0.E+0 , false ) );
            this->addDoubleProperty( "Frot_line", ElementaryMaterialPropertyDouble( "FROT_LINE" , 0.E+0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau BpelAcier */
typedef boost::shared_ptr< BpelAcierMaterialBehaviourInstance > BpelAcierMaterialBehaviourPtr;


/**
 * @class EtccBetonMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau EtccBeton
 * @author Jean-Pierre Lefebvre
 */
class EtccBetonMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        EtccBetonMaterialBehaviourInstance()
        {
            // Mot cle "ETCC_BETON" dans Aster
            _asterName = "ETCC_BETON";

            // Parametres matériau
            this->addDoubleProperty( "Ep_beton", ElementaryMaterialPropertyDouble( "EP_BETON" , 0. , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau EtccBeton */
typedef boost::shared_ptr< EtccBetonMaterialBehaviourInstance > EtccBetonMaterialBehaviourPtr;


/**
 * @class EtccAcierMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau EtccAcier
 * @author Jean-Pierre Lefebvre
 */
class EtccAcierMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        EtccAcierMaterialBehaviourInstance()
        {
            // Mot cle "ETCC_ACIER" dans Aster
            _asterName = "ETCC_ACIER";

            // Parametres matériau
            this->addDoubleProperty( "F_prg", ElementaryMaterialPropertyDouble( "F_PRG" , false ) );
            this->addDoubleProperty( "Coef_frot", ElementaryMaterialPropertyDouble( "COEF_FROT" , 0.E+0 , false ) );
            this->addDoubleProperty( "Pert_ligne", ElementaryMaterialPropertyDouble( "PERT_LIGNE" , 0.E+0 , false ) );
            this->addDoubleProperty( "Relax_1000", ElementaryMaterialPropertyDouble( "RELAX_1000" , 0.E+0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau EtccAcier */
typedef boost::shared_ptr< EtccAcierMaterialBehaviourInstance > EtccAcierMaterialBehaviourPtr;


/**
 * @class MohrCoulombMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MohrCoulomb
 * @author Jean-Pierre Lefebvre
 */
class MohrCoulombMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MohrCoulombMaterialBehaviourInstance()
        {
            // Mot cle "MOHR_COULOMB" dans Aster
            _asterName = "MOHR_COULOMB";

            // Parametres matériau
            this->addDoubleProperty( "Phi", ElementaryMaterialPropertyDouble( "PHI" , true ) );
            this->addDoubleProperty( "Angdil", ElementaryMaterialPropertyDouble( "ANGDIL" , true ) );
            this->addDoubleProperty( "Cohesion", ElementaryMaterialPropertyDouble( "COHESION" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MohrCoulomb */
typedef boost::shared_ptr< MohrCoulombMaterialBehaviourInstance > MohrCoulombMaterialBehaviourPtr;


/**
 * @class CamClayMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau CamClay
 * @author Jean-Pierre Lefebvre
 */
class CamClayMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        CamClayMaterialBehaviourInstance()
        {
            // Mot cle "CAM_CLAY" dans Aster
            _asterName = "CAM_CLAY";

            // Parametres matériau
            this->addDoubleProperty( "Mu", ElementaryMaterialPropertyDouble( "MU" , true ) );
            this->addDoubleProperty( "Poro", ElementaryMaterialPropertyDouble( "PORO" , true ) );
            this->addDoubleProperty( "Lambda", ElementaryMaterialPropertyDouble( "LAMBDA" , true ) );
            this->addDoubleProperty( "Kapa", ElementaryMaterialPropertyDouble( "KAPA" , true ) );
            this->addDoubleProperty( "M", ElementaryMaterialPropertyDouble( "M" , true ) );
            this->addDoubleProperty( "Pres_crit", ElementaryMaterialPropertyDouble( "PRES_CRIT" , true ) );
            this->addDoubleProperty( "Kcam", ElementaryMaterialPropertyDouble( "KCAM" , false ) );
            this->addDoubleProperty( "Ptrac", ElementaryMaterialPropertyDouble( "PTRAC" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau CamClay */
typedef boost::shared_ptr< CamClayMaterialBehaviourInstance > CamClayMaterialBehaviourPtr;


/**
 * @class BarceloneMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Barcelone
 * @author Jean-Pierre Lefebvre
 */
class BarceloneMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        BarceloneMaterialBehaviourInstance()
        {
            // Mot cle "BARCELONE" dans Aster
            _asterName = "BARCELONE";

            // Parametres matériau
            this->addDoubleProperty( "Mu", ElementaryMaterialPropertyDouble( "MU" , true ) );
            this->addDoubleProperty( "Poro", ElementaryMaterialPropertyDouble( "PORO" , true ) );
            this->addDoubleProperty( "Lambda", ElementaryMaterialPropertyDouble( "LAMBDA" , true ) );
            this->addDoubleProperty( "Kapa", ElementaryMaterialPropertyDouble( "KAPA" , true ) );
            this->addDoubleProperty( "M", ElementaryMaterialPropertyDouble( "M" , true ) );
            this->addDoubleProperty( "Pres_crit", ElementaryMaterialPropertyDouble( "PRES_CRIT" , true ) );
            this->addDoubleProperty( "Pa", ElementaryMaterialPropertyDouble( "PA" , true ) );
            this->addDoubleProperty( "R", ElementaryMaterialPropertyDouble( "R" , true ) );
            this->addDoubleProperty( "Beta", ElementaryMaterialPropertyDouble( "BETA" , true ) );
            this->addDoubleProperty( "Kc", ElementaryMaterialPropertyDouble( "KC" , true ) );
            this->addDoubleProperty( "Pc0_init", ElementaryMaterialPropertyDouble( "PC0_INIT" , true ) );
            this->addDoubleProperty( "Kapas", ElementaryMaterialPropertyDouble( "KAPAS" , true ) );
            this->addDoubleProperty( "Lambdas", ElementaryMaterialPropertyDouble( "LAMBDAS" , true ) );
            this->addDoubleProperty( "Alphab", ElementaryMaterialPropertyDouble( "ALPHAB" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Barcelone */
typedef boost::shared_ptr< BarceloneMaterialBehaviourInstance > BarceloneMaterialBehaviourPtr;


/**
 * @class CjsMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Cjs
 * @author Jean-Pierre Lefebvre
 */
class CjsMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        CjsMaterialBehaviourInstance()
        {
            // Mot cle "CJS" dans Aster
            _asterName = "CJS";

            // Parametres matériau
            this->addDoubleProperty( "Beta_cjs", ElementaryMaterialPropertyDouble( "BETA_CJS" , true ) );
            this->addDoubleProperty( "Rm", ElementaryMaterialPropertyDouble( "RM" , true ) );
            this->addDoubleProperty( "N_cjs", ElementaryMaterialPropertyDouble( "N_CJS" , 0.E+0 , false ) );
            this->addDoubleProperty( "Kp", ElementaryMaterialPropertyDouble( "KP" , 0.E+0 , false ) );
            this->addDoubleProperty( "Rc", ElementaryMaterialPropertyDouble( "RC" , 0.E+0 , false ) );
            this->addDoubleProperty( "A_cjs", ElementaryMaterialPropertyDouble( "A_CJS" , 0.E+0 , false ) );
            this->addDoubleProperty( "B_cjs", ElementaryMaterialPropertyDouble( "B_CJS" , 1.0E+25 , false ) );
            this->addDoubleProperty( "C_cjs", ElementaryMaterialPropertyDouble( "C_CJS" , 0.E+0 , false ) );
            this->addDoubleProperty( "Gamma_cjs", ElementaryMaterialPropertyDouble( "GAMMA_CJS" , true ) );
            this->addDoubleProperty( "Mu_cjs", ElementaryMaterialPropertyDouble( "MU_CJS" , 0.E+0 , false ) );
            this->addDoubleProperty( "Pco", ElementaryMaterialPropertyDouble( "PCO" , 0.E+0 , false ) );
            this->addDoubleProperty( "Pa", ElementaryMaterialPropertyDouble( "PA" , true ) );
            this->addDoubleProperty( "Q_init", ElementaryMaterialPropertyDouble( "Q_INIT" , 0.E+0 , false ) );
            this->addDoubleProperty( "R_init", ElementaryMaterialPropertyDouble( "R_INIT" , 0.E+0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Cjs */
typedef boost::shared_ptr< CjsMaterialBehaviourInstance > CjsMaterialBehaviourPtr;


/**
 * @class HujeuxMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Hujeux
 * @author Jean-Pierre Lefebvre
 */
class HujeuxMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        HujeuxMaterialBehaviourInstance()
        {
            // Mot cle "HUJEUX" dans Aster
            _asterName = "HUJEUX";

            // Parametres matériau
            this->addDoubleProperty( "N", ElementaryMaterialPropertyDouble( "N" , true ) );
            this->addDoubleProperty( "Beta", ElementaryMaterialPropertyDouble( "BETA" , true ) );
            this->addDoubleProperty( "B", ElementaryMaterialPropertyDouble( "B" , true ) );
            this->addDoubleProperty( "D", ElementaryMaterialPropertyDouble( "D" , true ) );
            this->addDoubleProperty( "Phi", ElementaryMaterialPropertyDouble( "PHI" , true ) );
            this->addDoubleProperty( "Angdil", ElementaryMaterialPropertyDouble( "ANGDIL" , true ) );
            this->addDoubleProperty( "Pco", ElementaryMaterialPropertyDouble( "PCO" , true ) );
            this->addDoubleProperty( "Pref", ElementaryMaterialPropertyDouble( "PREF" , true ) );
            this->addDoubleProperty( "Acyc", ElementaryMaterialPropertyDouble( "ACYC" , true ) );
            this->addDoubleProperty( "Amon", ElementaryMaterialPropertyDouble( "AMON" , true ) );
            this->addDoubleProperty( "Ccyc", ElementaryMaterialPropertyDouble( "CCYC" , true ) );
            this->addDoubleProperty( "Cmon", ElementaryMaterialPropertyDouble( "CMON" , true ) );
            this->addDoubleProperty( "Rd_ela", ElementaryMaterialPropertyDouble( "RD_ELA" , true ) );
            this->addDoubleProperty( "Ri_ela", ElementaryMaterialPropertyDouble( "RI_ELA" , true ) );
            this->addDoubleProperty( "Rhys", ElementaryMaterialPropertyDouble( "RHYS" , true ) );
            this->addDoubleProperty( "Rmob", ElementaryMaterialPropertyDouble( "RMOB" , true ) );
            this->addDoubleProperty( "Xm", ElementaryMaterialPropertyDouble( "XM" , true ) );
            this->addDoubleProperty( "Rd_cyc", ElementaryMaterialPropertyDouble( "RD_CYC" , true ) );
            this->addDoubleProperty( "Ri_cyc", ElementaryMaterialPropertyDouble( "RI_CYC" , true ) );
            this->addDoubleProperty( "Dila", ElementaryMaterialPropertyDouble( "DILA" , true ) );
            this->addDoubleProperty( "Ptrac", ElementaryMaterialPropertyDouble( "PTRAC" , 0.E+0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Hujeux */
typedef boost::shared_ptr< HujeuxMaterialBehaviourInstance > HujeuxMaterialBehaviourPtr;


/**
 * @class EcroAsymLineMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau EcroAsymLine
 * @author Jean-Pierre Lefebvre
 */
class EcroAsymLineMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        EcroAsymLineMaterialBehaviourInstance()
        {
            // Mot cle "ECRO_ASYM_LINE" dans Aster
            _asterName = "ECRO_ASYM_LINE";

            // Parametres matériau
            this->addDoubleProperty( "Dc_sigm_epsi", ElementaryMaterialPropertyDouble( "DC_SIGM_EPSI" , true ) );
            this->addDoubleProperty( "Sy_c", ElementaryMaterialPropertyDouble( "SY_C" , true ) );
            this->addDoubleProperty( "Dt_sigm_epsi", ElementaryMaterialPropertyDouble( "DT_SIGM_EPSI" , true ) );
            this->addDoubleProperty( "Sy_t", ElementaryMaterialPropertyDouble( "SY_T" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau EcroAsymLine */
typedef boost::shared_ptr< EcroAsymLineMaterialBehaviourInstance > EcroAsymLineMaterialBehaviourPtr;


/**
 * @class GrangerFpMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau GrangerFp
 * @author Jean-Pierre Lefebvre
 */
class GrangerFpMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        GrangerFpMaterialBehaviourInstance()
        {
            // Mot cle "GRANGER_FP" dans Aster
            _asterName = "GRANGER_FP";

            // Parametres matériau
            this->addDoubleProperty( "J1", ElementaryMaterialPropertyDouble( "J1" , false ) );
            this->addDoubleProperty( "J2", ElementaryMaterialPropertyDouble( "J2" , false ) );
            this->addDoubleProperty( "J3", ElementaryMaterialPropertyDouble( "J3" , false ) );
            this->addDoubleProperty( "J4", ElementaryMaterialPropertyDouble( "J4" , false ) );
            this->addDoubleProperty( "J5", ElementaryMaterialPropertyDouble( "J5" , false ) );
            this->addDoubleProperty( "J6", ElementaryMaterialPropertyDouble( "J6" , false ) );
            this->addDoubleProperty( "J7", ElementaryMaterialPropertyDouble( "J7" , false ) );
            this->addDoubleProperty( "J8", ElementaryMaterialPropertyDouble( "J8" , false ) );
            this->addDoubleProperty( "Taux_1", ElementaryMaterialPropertyDouble( "TAUX_1" , false ) );
            this->addDoubleProperty( "Taux_2", ElementaryMaterialPropertyDouble( "TAUX_2" , false ) );
            this->addDoubleProperty( "Taux_3", ElementaryMaterialPropertyDouble( "TAUX_3" , false ) );
            this->addDoubleProperty( "Taux_4", ElementaryMaterialPropertyDouble( "TAUX_4" , false ) );
            this->addDoubleProperty( "Taux_5", ElementaryMaterialPropertyDouble( "TAUX_5" , false ) );
            this->addDoubleProperty( "Taux_6", ElementaryMaterialPropertyDouble( "TAUX_6" , false ) );
            this->addDoubleProperty( "Taux_7", ElementaryMaterialPropertyDouble( "TAUX_7" , false ) );
            this->addDoubleProperty( "Taux_8", ElementaryMaterialPropertyDouble( "TAUX_8" , false ) );
            this->addDoubleProperty( "Qsr_k", ElementaryMaterialPropertyDouble( "QSR_K" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau GrangerFp */
typedef boost::shared_ptr< GrangerFpMaterialBehaviourInstance > GrangerFpMaterialBehaviourPtr;


/**
 * @class GrangerFp_indtMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau GrangerFp_indt
 * @author Jean-Pierre Lefebvre
 */
class GrangerFp_indtMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        GrangerFp_indtMaterialBehaviourInstance()
        {
            // Mot cle "GRANGER_FP_INDT" dans Aster
            _asterName = "GRANGER_FP_INDT";

            // Parametres matériau
            this->addDoubleProperty( "J1", ElementaryMaterialPropertyDouble( "J1" , false ) );
            this->addDoubleProperty( "J2", ElementaryMaterialPropertyDouble( "J2" , false ) );
            this->addDoubleProperty( "J3", ElementaryMaterialPropertyDouble( "J3" , false ) );
            this->addDoubleProperty( "J4", ElementaryMaterialPropertyDouble( "J4" , false ) );
            this->addDoubleProperty( "J5", ElementaryMaterialPropertyDouble( "J5" , false ) );
            this->addDoubleProperty( "J6", ElementaryMaterialPropertyDouble( "J6" , false ) );
            this->addDoubleProperty( "J7", ElementaryMaterialPropertyDouble( "J7" , false ) );
            this->addDoubleProperty( "J8", ElementaryMaterialPropertyDouble( "J8" , false ) );
            this->addDoubleProperty( "Taux_1", ElementaryMaterialPropertyDouble( "TAUX_1" , false ) );
            this->addDoubleProperty( "Taux_2", ElementaryMaterialPropertyDouble( "TAUX_2" , false ) );
            this->addDoubleProperty( "Taux_3", ElementaryMaterialPropertyDouble( "TAUX_3" , false ) );
            this->addDoubleProperty( "Taux_4", ElementaryMaterialPropertyDouble( "TAUX_4" , false ) );
            this->addDoubleProperty( "Taux_5", ElementaryMaterialPropertyDouble( "TAUX_5" , false ) );
            this->addDoubleProperty( "Taux_6", ElementaryMaterialPropertyDouble( "TAUX_6" , false ) );
            this->addDoubleProperty( "Taux_7", ElementaryMaterialPropertyDouble( "TAUX_7" , false ) );
            this->addDoubleProperty( "Taux_8", ElementaryMaterialPropertyDouble( "TAUX_8" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau GrangerFp_indt */
typedef boost::shared_ptr< GrangerFp_indtMaterialBehaviourInstance > GrangerFp_indtMaterialBehaviourPtr;


/**
 * @class VGrangerFpMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau VGrangerFp
 * @author Jean-Pierre Lefebvre
 */
class VGrangerFpMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        VGrangerFpMaterialBehaviourInstance()
        {
            // Mot cle "V_GRANGER_FP" dans Aster
            _asterName = "V_GRANGER_FP";

            // Parametres matériau
            this->addDoubleProperty( "Qsr_veil", ElementaryMaterialPropertyDouble( "QSR_VEIL" , false ) );
            this->addFunctionProperty( "Fonc_v", ElementaryMaterialPropertyFunction( "FONC_V" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau VGrangerFp */
typedef boost::shared_ptr< VGrangerFpMaterialBehaviourInstance > VGrangerFpMaterialBehaviourPtr;


/**
 * @class BetonBurgerFpMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau BetonBurgerFp
 * @author Jean-Pierre Lefebvre
 */
class BetonBurgerFpMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        BetonBurgerFpMaterialBehaviourInstance()
        {
            // Mot cle "BETON_BURGER_FP" dans Aster
            _asterName = "BETON_BURGER_FP";

            // Parametres matériau
            this->addDoubleProperty( "K_rs", ElementaryMaterialPropertyDouble( "K_RS" , true ) );
            this->addDoubleProperty( "Eta_rs", ElementaryMaterialPropertyDouble( "ETA_RS" , true ) );
            this->addDoubleProperty( "Kappa", ElementaryMaterialPropertyDouble( "KAPPA" , true ) );
            this->addDoubleProperty( "Eta_is", ElementaryMaterialPropertyDouble( "ETA_IS" , true ) );
            this->addDoubleProperty( "K_rd", ElementaryMaterialPropertyDouble( "K_RD" , true ) );
            this->addDoubleProperty( "Eta_rd", ElementaryMaterialPropertyDouble( "ETA_RD" , true ) );
            this->addDoubleProperty( "Eta_id", ElementaryMaterialPropertyDouble( "ETA_ID" , true ) );
            this->addDoubleProperty( "Eta_fd", ElementaryMaterialPropertyDouble( "ETA_FD" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau BetonBurgerFp */
typedef boost::shared_ptr< BetonBurgerFpMaterialBehaviourInstance > BetonBurgerFpMaterialBehaviourPtr;


/**
 * @class BetonUmlvFpMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau BetonUmlvFp
 * @author Jean-Pierre Lefebvre
 */
class BetonUmlvFpMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        BetonUmlvFpMaterialBehaviourInstance()
        {
            // Mot cle "BETON_UMLV_FP" dans Aster
            _asterName = "BETON_UMLV_FP";

            // Parametres matériau
            this->addDoubleProperty( "K_rs", ElementaryMaterialPropertyDouble( "K_RS" , true ) );
            this->addDoubleProperty( "Eta_rs", ElementaryMaterialPropertyDouble( "ETA_RS" , true ) );
            this->addDoubleProperty( "K_is", ElementaryMaterialPropertyDouble( "K_IS" , true ) );
            this->addDoubleProperty( "Eta_is", ElementaryMaterialPropertyDouble( "ETA_IS" , true ) );
            this->addDoubleProperty( "K_rd", ElementaryMaterialPropertyDouble( "K_RD" , true ) );
            this->addDoubleProperty( "Eta_rd", ElementaryMaterialPropertyDouble( "ETA_RD" , true ) );
            this->addDoubleProperty( "Eta_id", ElementaryMaterialPropertyDouble( "ETA_ID" , true ) );
            this->addDoubleProperty( "Eta_fd", ElementaryMaterialPropertyDouble( "ETA_FD" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau BetonUmlvFp */
typedef boost::shared_ptr< BetonUmlvFpMaterialBehaviourInstance > BetonUmlvFpMaterialBehaviourPtr;


/**
 * @class BetonRagMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau BetonRag
 * @author Jean-Pierre Lefebvre
 */
class BetonRagMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        BetonRagMaterialBehaviourInstance()
        {
            // Mot cle "BETON_RAG" dans Aster
            _asterName = "BETON_RAG";

            // Parametres matériau
            this->addDoubleProperty( "Activ_fl", ElementaryMaterialPropertyDouble( "ACTIV_FL" , 1.0 , false ) );
            this->addDoubleProperty( "K_rs", ElementaryMaterialPropertyDouble( "K_RS" , true ) );
            this->addDoubleProperty( "K_is", ElementaryMaterialPropertyDouble( "K_IS" , true ) );
            this->addDoubleProperty( "Eta_rs", ElementaryMaterialPropertyDouble( "ETA_RS" , true ) );
            this->addDoubleProperty( "Eta_is", ElementaryMaterialPropertyDouble( "ETA_IS" , true ) );
            this->addDoubleProperty( "K_rd", ElementaryMaterialPropertyDouble( "K_RD" , true ) );
            this->addDoubleProperty( "K_id", ElementaryMaterialPropertyDouble( "K_ID" , true ) );
            this->addDoubleProperty( "Eta_rd", ElementaryMaterialPropertyDouble( "ETA_RD" , true ) );
            this->addDoubleProperty( "Eta_id", ElementaryMaterialPropertyDouble( "ETA_ID" , true ) );
            this->addDoubleProperty( "Eps_0", ElementaryMaterialPropertyDouble( "EPS_0" , true ) );
            this->addDoubleProperty( "Tau_0", ElementaryMaterialPropertyDouble( "TAU_0" , true ) );
            this->addDoubleProperty( "Eps_fl_l", ElementaryMaterialPropertyDouble( "EPS_FL_L" , 3.0e-2 , false ) );
            this->addDoubleProperty( "Activ_lo", ElementaryMaterialPropertyDouble( "ACTIV_LO" , 1.0 , false ) );
            this->addDoubleProperty( "F_c", ElementaryMaterialPropertyDouble( "F_C" , true ) );
            this->addDoubleProperty( "F_t", ElementaryMaterialPropertyDouble( "F_T" , true ) );
            this->addDoubleProperty( "Ang_crit", ElementaryMaterialPropertyDouble( "ANG_CRIT" , 8.594367 , false ) );
            this->addDoubleProperty( "Eps_comp", ElementaryMaterialPropertyDouble( "EPS_COMP" , true ) );
            this->addDoubleProperty( "Eps_trac", ElementaryMaterialPropertyDouble( "EPS_TRAC" , true ) );
            this->addDoubleProperty( "Lc_comp", ElementaryMaterialPropertyDouble( "LC_COMP" , 1.0 , true ) );
            this->addDoubleProperty( "Lc_trac", ElementaryMaterialPropertyDouble( "LC_TRAC" , 1.0 , true ) );
            this->addDoubleProperty( "Hyd_pres", ElementaryMaterialPropertyDouble( "HYD_PRES" , 0. , false ) );
            this->addDoubleProperty( "A_van_ge", ElementaryMaterialPropertyDouble( "A_VAN_GE" , 0.0 , false ) );
            this->addDoubleProperty( "B_van_ge", ElementaryMaterialPropertyDouble( "B_VAN_GE" , 1.9 , false ) );
            this->addDoubleProperty( "Biot_eau", ElementaryMaterialPropertyDouble( "BIOT_EAU" , 0.3 , true ) );
            this->addDoubleProperty( "Modu_eau", ElementaryMaterialPropertyDouble( "MODU_EAU" , 0.0 , true ) );
            this->addDoubleProperty( "W_eau_0", ElementaryMaterialPropertyDouble( "W_EAU_0" , true ) );
            this->addDoubleProperty( "Biot_gel", ElementaryMaterialPropertyDouble( "BIOT_GEL" , true ) );
            this->addDoubleProperty( "Modu_gel", ElementaryMaterialPropertyDouble( "MODU_GEL" , true ) );
            this->addDoubleProperty( "Vol_gel", ElementaryMaterialPropertyDouble( "VOL_GEL" , true ) );
            this->addDoubleProperty( "Avanc_li", ElementaryMaterialPropertyDouble( "AVANC_LI" , true ) );
            this->addDoubleProperty( "Seuil_sr", ElementaryMaterialPropertyDouble( "SEUIL_SR" , true ) );
            this->addDoubleProperty( "Para_cin", ElementaryMaterialPropertyDouble( "PARA_CIN" , true ) );
            this->addDoubleProperty( "Enr_ac_g", ElementaryMaterialPropertyDouble( "ENR_AC_G" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau BetonRag */
typedef boost::shared_ptr< BetonRagMaterialBehaviourInstance > BetonRagMaterialBehaviourPtr;


/**
 * @class PoroBetonMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau PoroBeton
 * @author Jean-Pierre Lefebvre
 */
class PoroBetonMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        PoroBetonMaterialBehaviourInstance()
        {
            // Mot cle "PORO_BETON" dans Aster
            _asterName = "PORO_BETON";

            // Parametres matériau
            this->addDoubleProperty( "Hyds", ElementaryMaterialPropertyDouble( "HYDS" , true ) );
            this->addDoubleProperty( "F_c", ElementaryMaterialPropertyDouble( "F_C" , false ) );
            this->addDoubleProperty( "F_t", ElementaryMaterialPropertyDouble( "F_T" , false ) );
            this->addDoubleProperty( "Eps_comp", ElementaryMaterialPropertyDouble( "EPS_COMP" , false ) );
            this->addDoubleProperty( "Eps_trac", ElementaryMaterialPropertyDouble( "EPS_TRAC" , false ) );
            this->addDoubleProperty( "Ekvp", ElementaryMaterialPropertyDouble( "EKVP" , false ) );
            this->addDoubleProperty( "Cbio", ElementaryMaterialPropertyDouble( "CBIO" , false ) );
            this->addDoubleProperty( "Modu_eau", ElementaryMaterialPropertyDouble( "MODU_EAU" , false ) );
            this->addDoubleProperty( "Sfld", ElementaryMaterialPropertyDouble( "SFLD" , false ) );
            this->addDoubleProperty( "Modu_gel", ElementaryMaterialPropertyDouble( "MODU_GEL" , false ) );
            this->addDoubleProperty( "Vol_gel", ElementaryMaterialPropertyDouble( "VOL_GEL" , false ) );
            this->addDoubleProperty( "Poro", ElementaryMaterialPropertyDouble( "PORO" , true ) );
            this->addDoubleProperty( "Tkvp", ElementaryMaterialPropertyDouble( "TKVP" , false ) );
            this->addDoubleProperty( "Nrja", ElementaryMaterialPropertyDouble( "NRJA" , false ) );
            this->addDoubleProperty( "Mshr", ElementaryMaterialPropertyDouble( "MSHR" , false ) );
            this->addDoubleProperty( "Kd", ElementaryMaterialPropertyDouble( "KD" , false ) );
            this->addDoubleProperty( "Mu", ElementaryMaterialPropertyDouble( "MU" , false ) );
            this->addDoubleProperty( "Dt80", ElementaryMaterialPropertyDouble( "DT80" , true ) );
            this->addDoubleProperty( "Stmp", ElementaryMaterialPropertyDouble( "STMP" , false ) );
            this->addDoubleProperty( "Ktmp", ElementaryMaterialPropertyDouble( "KTMP" , false ) );
            this->addDoubleProperty( "Tref", ElementaryMaterialPropertyDouble( "TREF" , false ) );
            this->addDoubleProperty( "Y1sy", ElementaryMaterialPropertyDouble( "Y1SY" , false ) );
            this->addDoubleProperty( "Tau1", ElementaryMaterialPropertyDouble( "TAU1" , false ) );
            this->addDoubleProperty( "Tau2", ElementaryMaterialPropertyDouble( "TAU2" , false ) );
            this->addDoubleProperty( "Ekfl", ElementaryMaterialPropertyDouble( "EKFL" , false ) );
            this->addDoubleProperty( "Dfmx", ElementaryMaterialPropertyDouble( "DFMX" , false ) );
            this->addDoubleProperty( "Gftl", ElementaryMaterialPropertyDouble( "GFTL" , false ) );
            this->addDoubleProperty( "Gfcl", ElementaryMaterialPropertyDouble( "GFCL" , false ) );
            this->addDoubleProperty( "Wref", ElementaryMaterialPropertyDouble( "WREF" , false ) );
            this->addDoubleProperty( "Tphi", ElementaryMaterialPropertyDouble( "TPHI" , false ) );
            this->addDoubleProperty( "Ang_crit", ElementaryMaterialPropertyDouble( "ANG_CRIT" , false ) );
            this->addDoubleProperty( "Sref", ElementaryMaterialPropertyDouble( "SREF" , false ) );
            this->addDoubleProperty( "Vref", ElementaryMaterialPropertyDouble( "VREF" , false ) );
            this->addDoubleProperty( "Vmax", ElementaryMaterialPropertyDouble( "VMAX" , false ) );
            this->addDoubleProperty( "Kwb", ElementaryMaterialPropertyDouble( "KWB" , false ) );
            this->addDoubleProperty( "Covs", ElementaryMaterialPropertyDouble( "COVS" , false ) );
            this->addDoubleProperty( "Aluc", ElementaryMaterialPropertyDouble( "ALUC" , false ) );
            this->addDoubleProperty( "Sulc", ElementaryMaterialPropertyDouble( "SULC" , false ) );
            this->addDoubleProperty( "Silc", ElementaryMaterialPropertyDouble( "SILC" , false ) );
            this->addDoubleProperty( "Tdef", ElementaryMaterialPropertyDouble( "TDEF" , false ) );
            this->addDoubleProperty( "Taar", ElementaryMaterialPropertyDouble( "TAAR" , false ) );
            this->addDoubleProperty( "Ssar", ElementaryMaterialPropertyDouble( "SSAR" , false ) );
            this->addDoubleProperty( "Ssde", ElementaryMaterialPropertyDouble( "SSDE" , false ) );
            this->addDoubleProperty( "Vaar", ElementaryMaterialPropertyDouble( "VAAR" , false ) );
            this->addDoubleProperty( "Vett", ElementaryMaterialPropertyDouble( "VETT" , false ) );
            this->addDoubleProperty( "Vvar", ElementaryMaterialPropertyDouble( "VVAR" , false ) );
            this->addDoubleProperty( "Vvde", ElementaryMaterialPropertyDouble( "VVDE" , false ) );
            this->addDoubleProperty( "Baar", ElementaryMaterialPropertyDouble( "BAAR" , false ) );
            this->addDoubleProperty( "Bdef", ElementaryMaterialPropertyDouble( "BDEF" , false ) );
            this->addDoubleProperty( "Maar", ElementaryMaterialPropertyDouble( "MAAR" , false ) );
            this->addDoubleProperty( "Mdef", ElementaryMaterialPropertyDouble( "MDEF" , false ) );
            this->addDoubleProperty( "Coth", ElementaryMaterialPropertyDouble( "COTH" , false ) );
            this->addDoubleProperty( "Corg", ElementaryMaterialPropertyDouble( "CORG" , false ) );
            this->addDoubleProperty( "Id0", ElementaryMaterialPropertyDouble( "ID0" , false ) );
            this->addDoubleProperty( "Id1", ElementaryMaterialPropertyDouble( "ID1" , false ) );
            this->addDoubleProperty( "Id2", ElementaryMaterialPropertyDouble( "ID2" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau PoroBeton */
typedef boost::shared_ptr< PoroBetonMaterialBehaviourInstance > PoroBetonMaterialBehaviourPtr;


/**
 * @class GlrcDmMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau GlrcDm
 * @author Jean-Pierre Lefebvre
 */
class GlrcDmMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        GlrcDmMaterialBehaviourInstance()
        {
            // Mot cle "GLRC_DM" dans Aster
            _asterName = "GLRC_DM";

            // Parametres matériau
            this->addDoubleProperty( "Gamma_t", ElementaryMaterialPropertyDouble( "GAMMA_T" , true ) );
            this->addDoubleProperty( "Gamma_c", ElementaryMaterialPropertyDouble( "GAMMA_C" , false ) );
            this->addDoubleProperty( "Gamma_f", ElementaryMaterialPropertyDouble( "GAMMA_F" , true ) );
            this->addDoubleProperty( "Nyt", ElementaryMaterialPropertyDouble( "NYT" , true ) );
            this->addDoubleProperty( "Nyc", ElementaryMaterialPropertyDouble( "NYC" , false ) );
            this->addDoubleProperty( "Myf", ElementaryMaterialPropertyDouble( "MYF" , true ) );
            this->addDoubleProperty( "Alpha_c", ElementaryMaterialPropertyDouble( "ALPHA_C" , 1.E+0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau GlrcDm */
typedef boost::shared_ptr< GlrcDmMaterialBehaviourInstance > GlrcDmMaterialBehaviourPtr;


/**
 * @class DhrcMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Dhrc
 * @author Jean-Pierre Lefebvre
 */
class DhrcMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        DhrcMaterialBehaviourInstance()
        {
            // Mot cle "DHRC" dans Aster
            _asterName = "DHRC";

            // Parametres matériau
            this->addDoubleProperty( "Syd", ElementaryMaterialPropertyDouble( "SYD" , true ) );
            this->addDoubleProperty( "Scrit", ElementaryMaterialPropertyDouble( "SCRIT" , true ) );
            this->addDoubleProperty( "K0micr", ElementaryMaterialPropertyDouble( "K0MICR" , true ) );
            this->addDoubleProperty( "Aac111", ElementaryMaterialPropertyDouble( "AAC111" , true ) );
            this->addDoubleProperty( "Aac121", ElementaryMaterialPropertyDouble( "AAC121" , true ) );
            this->addDoubleProperty( "Aac131", ElementaryMaterialPropertyDouble( "AAC131" , true ) );
            this->addDoubleProperty( "Aac141", ElementaryMaterialPropertyDouble( "AAC141" , true ) );
            this->addDoubleProperty( "Aac151", ElementaryMaterialPropertyDouble( "AAC151" , true ) );
            this->addDoubleProperty( "Aac161", ElementaryMaterialPropertyDouble( "AAC161" , true ) );
            this->addDoubleProperty( "Aac221", ElementaryMaterialPropertyDouble( "AAC221" , true ) );
            this->addDoubleProperty( "Aac231", ElementaryMaterialPropertyDouble( "AAC231" , true ) );
            this->addDoubleProperty( "Aac241", ElementaryMaterialPropertyDouble( "AAC241" , true ) );
            this->addDoubleProperty( "Aac251", ElementaryMaterialPropertyDouble( "AAC251" , true ) );
            this->addDoubleProperty( "Aac261", ElementaryMaterialPropertyDouble( "AAC261" , true ) );
            this->addDoubleProperty( "Aac331", ElementaryMaterialPropertyDouble( "AAC331" , true ) );
            this->addDoubleProperty( "Aac341", ElementaryMaterialPropertyDouble( "AAC341" , true ) );
            this->addDoubleProperty( "Aac351", ElementaryMaterialPropertyDouble( "AAC351" , true ) );
            this->addDoubleProperty( "Aac361", ElementaryMaterialPropertyDouble( "AAC361" , true ) );
            this->addDoubleProperty( "Aac441", ElementaryMaterialPropertyDouble( "AAC441" , true ) );
            this->addDoubleProperty( "Aac451", ElementaryMaterialPropertyDouble( "AAC451" , true ) );
            this->addDoubleProperty( "Aac461", ElementaryMaterialPropertyDouble( "AAC461" , true ) );
            this->addDoubleProperty( "Aac551", ElementaryMaterialPropertyDouble( "AAC551" , true ) );
            this->addDoubleProperty( "Aac561", ElementaryMaterialPropertyDouble( "AAC561" , true ) );
            this->addDoubleProperty( "Aac661", ElementaryMaterialPropertyDouble( "AAC661" , true ) );
            this->addDoubleProperty( "Aac112", ElementaryMaterialPropertyDouble( "AAC112" , true ) );
            this->addDoubleProperty( "Aac122", ElementaryMaterialPropertyDouble( "AAC122" , true ) );
            this->addDoubleProperty( "Aac132", ElementaryMaterialPropertyDouble( "AAC132" , true ) );
            this->addDoubleProperty( "Aac142", ElementaryMaterialPropertyDouble( "AAC142" , true ) );
            this->addDoubleProperty( "Aac152", ElementaryMaterialPropertyDouble( "AAC152" , true ) );
            this->addDoubleProperty( "Aac162", ElementaryMaterialPropertyDouble( "AAC162" , true ) );
            this->addDoubleProperty( "Aac222", ElementaryMaterialPropertyDouble( "AAC222" , true ) );
            this->addDoubleProperty( "Aac232", ElementaryMaterialPropertyDouble( "AAC232" , true ) );
            this->addDoubleProperty( "Aac242", ElementaryMaterialPropertyDouble( "AAC242" , true ) );
            this->addDoubleProperty( "Aac252", ElementaryMaterialPropertyDouble( "AAC252" , true ) );
            this->addDoubleProperty( "Aac262", ElementaryMaterialPropertyDouble( "AAC262" , true ) );
            this->addDoubleProperty( "Aac332", ElementaryMaterialPropertyDouble( "AAC332" , true ) );
            this->addDoubleProperty( "Aac342", ElementaryMaterialPropertyDouble( "AAC342" , true ) );
            this->addDoubleProperty( "Aac352", ElementaryMaterialPropertyDouble( "AAC352" , true ) );
            this->addDoubleProperty( "Aac362", ElementaryMaterialPropertyDouble( "AAC362" , true ) );
            this->addDoubleProperty( "Aac442", ElementaryMaterialPropertyDouble( "AAC442" , true ) );
            this->addDoubleProperty( "Aac452", ElementaryMaterialPropertyDouble( "AAC452" , true ) );
            this->addDoubleProperty( "Aac462", ElementaryMaterialPropertyDouble( "AAC462" , true ) );
            this->addDoubleProperty( "Aac552", ElementaryMaterialPropertyDouble( "AAC552" , true ) );
            this->addDoubleProperty( "Aac562", ElementaryMaterialPropertyDouble( "AAC562" , true ) );
            this->addDoubleProperty( "Aac662", ElementaryMaterialPropertyDouble( "AAC662" , true ) );
            this->addDoubleProperty( "Aat111", ElementaryMaterialPropertyDouble( "AAT111" , true ) );
            this->addDoubleProperty( "Aat121", ElementaryMaterialPropertyDouble( "AAT121" , true ) );
            this->addDoubleProperty( "Aat131", ElementaryMaterialPropertyDouble( "AAT131" , true ) );
            this->addDoubleProperty( "Aat141", ElementaryMaterialPropertyDouble( "AAT141" , true ) );
            this->addDoubleProperty( "Aat151", ElementaryMaterialPropertyDouble( "AAT151" , true ) );
            this->addDoubleProperty( "Aat161", ElementaryMaterialPropertyDouble( "AAT161" , true ) );
            this->addDoubleProperty( "Aat221", ElementaryMaterialPropertyDouble( "AAT221" , true ) );
            this->addDoubleProperty( "Aat231", ElementaryMaterialPropertyDouble( "AAT231" , true ) );
            this->addDoubleProperty( "Aat241", ElementaryMaterialPropertyDouble( "AAT241" , true ) );
            this->addDoubleProperty( "Aat251", ElementaryMaterialPropertyDouble( "AAT251" , true ) );
            this->addDoubleProperty( "Aat261", ElementaryMaterialPropertyDouble( "AAT261" , true ) );
            this->addDoubleProperty( "Aat331", ElementaryMaterialPropertyDouble( "AAT331" , true ) );
            this->addDoubleProperty( "Aat341", ElementaryMaterialPropertyDouble( "AAT341" , true ) );
            this->addDoubleProperty( "Aat351", ElementaryMaterialPropertyDouble( "AAT351" , true ) );
            this->addDoubleProperty( "Aat361", ElementaryMaterialPropertyDouble( "AAT361" , true ) );
            this->addDoubleProperty( "Aat441", ElementaryMaterialPropertyDouble( "AAT441" , true ) );
            this->addDoubleProperty( "Aat451", ElementaryMaterialPropertyDouble( "AAT451" , true ) );
            this->addDoubleProperty( "Aat461", ElementaryMaterialPropertyDouble( "AAT461" , true ) );
            this->addDoubleProperty( "Aat551", ElementaryMaterialPropertyDouble( "AAT551" , true ) );
            this->addDoubleProperty( "Aat561", ElementaryMaterialPropertyDouble( "AAT561" , true ) );
            this->addDoubleProperty( "Aat661", ElementaryMaterialPropertyDouble( "AAT661" , true ) );
            this->addDoubleProperty( "Aat112", ElementaryMaterialPropertyDouble( "AAT112" , true ) );
            this->addDoubleProperty( "Aat122", ElementaryMaterialPropertyDouble( "AAT122" , true ) );
            this->addDoubleProperty( "Aat132", ElementaryMaterialPropertyDouble( "AAT132" , true ) );
            this->addDoubleProperty( "Aat142", ElementaryMaterialPropertyDouble( "AAT142" , true ) );
            this->addDoubleProperty( "Aat152", ElementaryMaterialPropertyDouble( "AAT152" , true ) );
            this->addDoubleProperty( "Aat162", ElementaryMaterialPropertyDouble( "AAT162" , true ) );
            this->addDoubleProperty( "Aat222", ElementaryMaterialPropertyDouble( "AAT222" , true ) );
            this->addDoubleProperty( "Aat232", ElementaryMaterialPropertyDouble( "AAT232" , true ) );
            this->addDoubleProperty( "Aat242", ElementaryMaterialPropertyDouble( "AAT242" , true ) );
            this->addDoubleProperty( "Aat252", ElementaryMaterialPropertyDouble( "AAT252" , true ) );
            this->addDoubleProperty( "Aat262", ElementaryMaterialPropertyDouble( "AAT262" , true ) );
            this->addDoubleProperty( "Aat332", ElementaryMaterialPropertyDouble( "AAT332" , true ) );
            this->addDoubleProperty( "Aat342", ElementaryMaterialPropertyDouble( "AAT342" , true ) );
            this->addDoubleProperty( "Aat352", ElementaryMaterialPropertyDouble( "AAT352" , true ) );
            this->addDoubleProperty( "Aat362", ElementaryMaterialPropertyDouble( "AAT362" , true ) );
            this->addDoubleProperty( "Aat442", ElementaryMaterialPropertyDouble( "AAT442" , true ) );
            this->addDoubleProperty( "Aat452", ElementaryMaterialPropertyDouble( "AAT452" , true ) );
            this->addDoubleProperty( "Aat462", ElementaryMaterialPropertyDouble( "AAT462" , true ) );
            this->addDoubleProperty( "Aat552", ElementaryMaterialPropertyDouble( "AAT552" , true ) );
            this->addDoubleProperty( "Aat562", ElementaryMaterialPropertyDouble( "AAT562" , true ) );
            this->addDoubleProperty( "Aat662", ElementaryMaterialPropertyDouble( "AAT662" , true ) );
            this->addDoubleProperty( "Gac111", ElementaryMaterialPropertyDouble( "GAC111" , true ) );
            this->addDoubleProperty( "Gac121", ElementaryMaterialPropertyDouble( "GAC121" , true ) );
            this->addDoubleProperty( "Gac131", ElementaryMaterialPropertyDouble( "GAC131" , true ) );
            this->addDoubleProperty( "Gac141", ElementaryMaterialPropertyDouble( "GAC141" , true ) );
            this->addDoubleProperty( "Gac151", ElementaryMaterialPropertyDouble( "GAC151" , true ) );
            this->addDoubleProperty( "Gac161", ElementaryMaterialPropertyDouble( "GAC161" , true ) );
            this->addDoubleProperty( "Gac221", ElementaryMaterialPropertyDouble( "GAC221" , true ) );
            this->addDoubleProperty( "Gac231", ElementaryMaterialPropertyDouble( "GAC231" , true ) );
            this->addDoubleProperty( "Gac241", ElementaryMaterialPropertyDouble( "GAC241" , true ) );
            this->addDoubleProperty( "Gac251", ElementaryMaterialPropertyDouble( "GAC251" , true ) );
            this->addDoubleProperty( "Gac261", ElementaryMaterialPropertyDouble( "GAC261" , true ) );
            this->addDoubleProperty( "Gac331", ElementaryMaterialPropertyDouble( "GAC331" , true ) );
            this->addDoubleProperty( "Gac341", ElementaryMaterialPropertyDouble( "GAC341" , true ) );
            this->addDoubleProperty( "Gac351", ElementaryMaterialPropertyDouble( "GAC351" , true ) );
            this->addDoubleProperty( "Gac361", ElementaryMaterialPropertyDouble( "GAC361" , true ) );
            this->addDoubleProperty( "Gac441", ElementaryMaterialPropertyDouble( "GAC441" , true ) );
            this->addDoubleProperty( "Gac451", ElementaryMaterialPropertyDouble( "GAC451" , true ) );
            this->addDoubleProperty( "Gac461", ElementaryMaterialPropertyDouble( "GAC461" , true ) );
            this->addDoubleProperty( "Gac551", ElementaryMaterialPropertyDouble( "GAC551" , true ) );
            this->addDoubleProperty( "Gac561", ElementaryMaterialPropertyDouble( "GAC561" , true ) );
            this->addDoubleProperty( "Gac661", ElementaryMaterialPropertyDouble( "GAC661" , true ) );
            this->addDoubleProperty( "Gac112", ElementaryMaterialPropertyDouble( "GAC112" , true ) );
            this->addDoubleProperty( "Gac122", ElementaryMaterialPropertyDouble( "GAC122" , true ) );
            this->addDoubleProperty( "Gac132", ElementaryMaterialPropertyDouble( "GAC132" , true ) );
            this->addDoubleProperty( "Gac142", ElementaryMaterialPropertyDouble( "GAC142" , true ) );
            this->addDoubleProperty( "Gac152", ElementaryMaterialPropertyDouble( "GAC152" , true ) );
            this->addDoubleProperty( "Gac162", ElementaryMaterialPropertyDouble( "GAC162" , true ) );
            this->addDoubleProperty( "Gac222", ElementaryMaterialPropertyDouble( "GAC222" , true ) );
            this->addDoubleProperty( "Gac232", ElementaryMaterialPropertyDouble( "GAC232" , true ) );
            this->addDoubleProperty( "Gac242", ElementaryMaterialPropertyDouble( "GAC242" , true ) );
            this->addDoubleProperty( "Gac252", ElementaryMaterialPropertyDouble( "GAC252" , true ) );
            this->addDoubleProperty( "Gac262", ElementaryMaterialPropertyDouble( "GAC262" , true ) );
            this->addDoubleProperty( "Gac332", ElementaryMaterialPropertyDouble( "GAC332" , true ) );
            this->addDoubleProperty( "Gac342", ElementaryMaterialPropertyDouble( "GAC342" , true ) );
            this->addDoubleProperty( "Gac352", ElementaryMaterialPropertyDouble( "GAC352" , true ) );
            this->addDoubleProperty( "Gac362", ElementaryMaterialPropertyDouble( "GAC362" , true ) );
            this->addDoubleProperty( "Gac442", ElementaryMaterialPropertyDouble( "GAC442" , true ) );
            this->addDoubleProperty( "Gac452", ElementaryMaterialPropertyDouble( "GAC452" , true ) );
            this->addDoubleProperty( "Gac462", ElementaryMaterialPropertyDouble( "GAC462" , true ) );
            this->addDoubleProperty( "Gac552", ElementaryMaterialPropertyDouble( "GAC552" , true ) );
            this->addDoubleProperty( "Gac562", ElementaryMaterialPropertyDouble( "GAC562" , true ) );
            this->addDoubleProperty( "Gac662", ElementaryMaterialPropertyDouble( "GAC662" , true ) );
            this->addDoubleProperty( "Gat111", ElementaryMaterialPropertyDouble( "GAT111" , true ) );
            this->addDoubleProperty( "Gat121", ElementaryMaterialPropertyDouble( "GAT121" , true ) );
            this->addDoubleProperty( "Gat131", ElementaryMaterialPropertyDouble( "GAT131" , true ) );
            this->addDoubleProperty( "Gat141", ElementaryMaterialPropertyDouble( "GAT141" , true ) );
            this->addDoubleProperty( "Gat151", ElementaryMaterialPropertyDouble( "GAT151" , true ) );
            this->addDoubleProperty( "Gat161", ElementaryMaterialPropertyDouble( "GAT161" , true ) );
            this->addDoubleProperty( "Gat221", ElementaryMaterialPropertyDouble( "GAT221" , true ) );
            this->addDoubleProperty( "Gat231", ElementaryMaterialPropertyDouble( "GAT231" , true ) );
            this->addDoubleProperty( "Gat241", ElementaryMaterialPropertyDouble( "GAT241" , true ) );
            this->addDoubleProperty( "Gat251", ElementaryMaterialPropertyDouble( "GAT251" , true ) );
            this->addDoubleProperty( "Gat261", ElementaryMaterialPropertyDouble( "GAT261" , true ) );
            this->addDoubleProperty( "Gat331", ElementaryMaterialPropertyDouble( "GAT331" , true ) );
            this->addDoubleProperty( "Gat341", ElementaryMaterialPropertyDouble( "GAT341" , true ) );
            this->addDoubleProperty( "Gat351", ElementaryMaterialPropertyDouble( "GAT351" , true ) );
            this->addDoubleProperty( "Gat361", ElementaryMaterialPropertyDouble( "GAT361" , true ) );
            this->addDoubleProperty( "Gat441", ElementaryMaterialPropertyDouble( "GAT441" , true ) );
            this->addDoubleProperty( "Gat451", ElementaryMaterialPropertyDouble( "GAT451" , true ) );
            this->addDoubleProperty( "Gat461", ElementaryMaterialPropertyDouble( "GAT461" , true ) );
            this->addDoubleProperty( "Gat551", ElementaryMaterialPropertyDouble( "GAT551" , true ) );
            this->addDoubleProperty( "Gat561", ElementaryMaterialPropertyDouble( "GAT561" , true ) );
            this->addDoubleProperty( "Gat661", ElementaryMaterialPropertyDouble( "GAT661" , true ) );
            this->addDoubleProperty( "Gat112", ElementaryMaterialPropertyDouble( "GAT112" , true ) );
            this->addDoubleProperty( "Gat122", ElementaryMaterialPropertyDouble( "GAT122" , true ) );
            this->addDoubleProperty( "Gat132", ElementaryMaterialPropertyDouble( "GAT132" , true ) );
            this->addDoubleProperty( "Gat142", ElementaryMaterialPropertyDouble( "GAT142" , true ) );
            this->addDoubleProperty( "Gat152", ElementaryMaterialPropertyDouble( "GAT152" , true ) );
            this->addDoubleProperty( "Gat162", ElementaryMaterialPropertyDouble( "GAT162" , true ) );
            this->addDoubleProperty( "Gat222", ElementaryMaterialPropertyDouble( "GAT222" , true ) );
            this->addDoubleProperty( "Gat232", ElementaryMaterialPropertyDouble( "GAT232" , true ) );
            this->addDoubleProperty( "Gat242", ElementaryMaterialPropertyDouble( "GAT242" , true ) );
            this->addDoubleProperty( "Gat252", ElementaryMaterialPropertyDouble( "GAT252" , true ) );
            this->addDoubleProperty( "Gat262", ElementaryMaterialPropertyDouble( "GAT262" , true ) );
            this->addDoubleProperty( "Gat332", ElementaryMaterialPropertyDouble( "GAT332" , true ) );
            this->addDoubleProperty( "Gat342", ElementaryMaterialPropertyDouble( "GAT342" , true ) );
            this->addDoubleProperty( "Gat352", ElementaryMaterialPropertyDouble( "GAT352" , true ) );
            this->addDoubleProperty( "Gat362", ElementaryMaterialPropertyDouble( "GAT362" , true ) );
            this->addDoubleProperty( "Gat442", ElementaryMaterialPropertyDouble( "GAT442" , true ) );
            this->addDoubleProperty( "Gat452", ElementaryMaterialPropertyDouble( "GAT452" , true ) );
            this->addDoubleProperty( "Gat462", ElementaryMaterialPropertyDouble( "GAT462" , true ) );
            this->addDoubleProperty( "Gat552", ElementaryMaterialPropertyDouble( "GAT552" , true ) );
            this->addDoubleProperty( "Gat562", ElementaryMaterialPropertyDouble( "GAT562" , true ) );
            this->addDoubleProperty( "Gat662", ElementaryMaterialPropertyDouble( "GAT662" , true ) );
            this->addDoubleProperty( "Ab111", ElementaryMaterialPropertyDouble( "AB111" , true ) );
            this->addDoubleProperty( "Ab121", ElementaryMaterialPropertyDouble( "AB121" , true ) );
            this->addDoubleProperty( "Ab211", ElementaryMaterialPropertyDouble( "AB211" , true ) );
            this->addDoubleProperty( "Ab221", ElementaryMaterialPropertyDouble( "AB221" , true ) );
            this->addDoubleProperty( "Ab311", ElementaryMaterialPropertyDouble( "AB311" , true ) );
            this->addDoubleProperty( "Ab321", ElementaryMaterialPropertyDouble( "AB321" , true ) );
            this->addDoubleProperty( "Ab411", ElementaryMaterialPropertyDouble( "AB411" , true ) );
            this->addDoubleProperty( "Ab421", ElementaryMaterialPropertyDouble( "AB421" , true ) );
            this->addDoubleProperty( "Ab511", ElementaryMaterialPropertyDouble( "AB511" , true ) );
            this->addDoubleProperty( "Ab521", ElementaryMaterialPropertyDouble( "AB521" , true ) );
            this->addDoubleProperty( "Ab611", ElementaryMaterialPropertyDouble( "AB611" , true ) );
            this->addDoubleProperty( "Ab621", ElementaryMaterialPropertyDouble( "AB621" , true ) );
            this->addDoubleProperty( "Ab112", ElementaryMaterialPropertyDouble( "AB112" , true ) );
            this->addDoubleProperty( "Ab122", ElementaryMaterialPropertyDouble( "AB122" , true ) );
            this->addDoubleProperty( "Ab212", ElementaryMaterialPropertyDouble( "AB212" , true ) );
            this->addDoubleProperty( "Ab222", ElementaryMaterialPropertyDouble( "AB222" , true ) );
            this->addDoubleProperty( "Ab312", ElementaryMaterialPropertyDouble( "AB312" , true ) );
            this->addDoubleProperty( "Ab322", ElementaryMaterialPropertyDouble( "AB322" , true ) );
            this->addDoubleProperty( "Ab412", ElementaryMaterialPropertyDouble( "AB412" , true ) );
            this->addDoubleProperty( "Ab422", ElementaryMaterialPropertyDouble( "AB422" , true ) );
            this->addDoubleProperty( "Ab512", ElementaryMaterialPropertyDouble( "AB512" , true ) );
            this->addDoubleProperty( "Ab522", ElementaryMaterialPropertyDouble( "AB522" , true ) );
            this->addDoubleProperty( "Ab612", ElementaryMaterialPropertyDouble( "AB612" , true ) );
            this->addDoubleProperty( "Ab622", ElementaryMaterialPropertyDouble( "AB622" , true ) );
            this->addDoubleProperty( "Gb111", ElementaryMaterialPropertyDouble( "GB111" , true ) );
            this->addDoubleProperty( "Gb121", ElementaryMaterialPropertyDouble( "GB121" , true ) );
            this->addDoubleProperty( "Gb211", ElementaryMaterialPropertyDouble( "GB211" , true ) );
            this->addDoubleProperty( "Gb221", ElementaryMaterialPropertyDouble( "GB221" , true ) );
            this->addDoubleProperty( "Gb311", ElementaryMaterialPropertyDouble( "GB311" , true ) );
            this->addDoubleProperty( "Gb321", ElementaryMaterialPropertyDouble( "GB321" , true ) );
            this->addDoubleProperty( "Gb411", ElementaryMaterialPropertyDouble( "GB411" , true ) );
            this->addDoubleProperty( "Gb421", ElementaryMaterialPropertyDouble( "GB421" , true ) );
            this->addDoubleProperty( "Gb511", ElementaryMaterialPropertyDouble( "GB511" , true ) );
            this->addDoubleProperty( "Gb521", ElementaryMaterialPropertyDouble( "GB521" , true ) );
            this->addDoubleProperty( "Gb611", ElementaryMaterialPropertyDouble( "GB611" , true ) );
            this->addDoubleProperty( "Gb621", ElementaryMaterialPropertyDouble( "GB621" , true ) );
            this->addDoubleProperty( "Gb112", ElementaryMaterialPropertyDouble( "GB112" , true ) );
            this->addDoubleProperty( "Gb122", ElementaryMaterialPropertyDouble( "GB122" , true ) );
            this->addDoubleProperty( "Gb212", ElementaryMaterialPropertyDouble( "GB212" , true ) );
            this->addDoubleProperty( "Gb222", ElementaryMaterialPropertyDouble( "GB222" , true ) );
            this->addDoubleProperty( "Gb312", ElementaryMaterialPropertyDouble( "GB312" , true ) );
            this->addDoubleProperty( "Gb322", ElementaryMaterialPropertyDouble( "GB322" , true ) );
            this->addDoubleProperty( "Gb412", ElementaryMaterialPropertyDouble( "GB412" , true ) );
            this->addDoubleProperty( "Gb422", ElementaryMaterialPropertyDouble( "GB422" , true ) );
            this->addDoubleProperty( "Gb512", ElementaryMaterialPropertyDouble( "GB512" , true ) );
            this->addDoubleProperty( "Gb522", ElementaryMaterialPropertyDouble( "GB522" , true ) );
            this->addDoubleProperty( "Gb612", ElementaryMaterialPropertyDouble( "GB612" , true ) );
            this->addDoubleProperty( "Gb622", ElementaryMaterialPropertyDouble( "GB622" , true ) );
            this->addDoubleProperty( "C0111", ElementaryMaterialPropertyDouble( "C0111" , true ) );
            this->addDoubleProperty( "C0211", ElementaryMaterialPropertyDouble( "C0211" , true ) );
            this->addDoubleProperty( "C0221", ElementaryMaterialPropertyDouble( "C0221" , true ) );
            this->addDoubleProperty( "C0212", ElementaryMaterialPropertyDouble( "C0212" , true ) );
            this->addDoubleProperty( "C0112", ElementaryMaterialPropertyDouble( "C0112" , true ) );
            this->addDoubleProperty( "C0222", ElementaryMaterialPropertyDouble( "C0222" , true ) );
            this->addDoubleProperty( "Ac111", ElementaryMaterialPropertyDouble( "AC111" , true ) );
            this->addDoubleProperty( "Ac211", ElementaryMaterialPropertyDouble( "AC211" , true ) );
            this->addDoubleProperty( "Ac221", ElementaryMaterialPropertyDouble( "AC221" , true ) );
            this->addDoubleProperty( "Ac112", ElementaryMaterialPropertyDouble( "AC112" , true ) );
            this->addDoubleProperty( "Ac212", ElementaryMaterialPropertyDouble( "AC212" , true ) );
            this->addDoubleProperty( "Ac222", ElementaryMaterialPropertyDouble( "AC222" , true ) );
            this->addDoubleProperty( "Gc111", ElementaryMaterialPropertyDouble( "GC111" , true ) );
            this->addDoubleProperty( "Gc211", ElementaryMaterialPropertyDouble( "GC211" , true ) );
            this->addDoubleProperty( "Gc221", ElementaryMaterialPropertyDouble( "GC221" , true ) );
            this->addDoubleProperty( "Gc112", ElementaryMaterialPropertyDouble( "GC112" , true ) );
            this->addDoubleProperty( "Gc212", ElementaryMaterialPropertyDouble( "GC212" , true ) );
            this->addDoubleProperty( "Gc222", ElementaryMaterialPropertyDouble( "GC222" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Dhrc */
typedef boost::shared_ptr< DhrcMaterialBehaviourInstance > DhrcMaterialBehaviourPtr;


/**
 * @class GattMonerieMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau GattMonerie
 * @author Jean-Pierre Lefebvre
 */
class GattMonerieMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        GattMonerieMaterialBehaviourInstance()
        {
            // Mot cle "GATT_MONERIE" dans Aster
            _asterName = "GATT_MONERIE";

            // Parametres matériau
            this->addDoubleProperty( "D_grain", ElementaryMaterialPropertyDouble( "D_GRAIN" , true ) );
            this->addDoubleProperty( "Poro_init", ElementaryMaterialPropertyDouble( "PORO_INIT" , true ) );
            this->addDoubleProperty( "Epsi_01", ElementaryMaterialPropertyDouble( "EPSI_01" , 2.7252E-10 , true ) );
            this->addDoubleProperty( "Epsi_02", ElementaryMaterialPropertyDouble( "EPSI_02" , 9.1440E-41 , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau GattMonerie */
typedef boost::shared_ptr< GattMonerieMaterialBehaviourInstance > GattMonerieMaterialBehaviourPtr;


/**
 * @class CorrAcierMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau CorrAcier
 * @author Jean-Pierre Lefebvre
 */
class CorrAcierMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        CorrAcierMaterialBehaviourInstance()
        {
            // Mot cle "CORR_ACIER" dans Aster
            _asterName = "CORR_ACIER";

            // Parametres matériau
            this->addDoubleProperty( "D_corr", ElementaryMaterialPropertyDouble( "D_CORR" , true ) );
            this->addDoubleProperty( "Ecro_k", ElementaryMaterialPropertyDouble( "ECRO_K" , true ) );
            this->addDoubleProperty( "Ecro_m", ElementaryMaterialPropertyDouble( "ECRO_M" , true ) );
            this->addDoubleProperty( "Sy", ElementaryMaterialPropertyDouble( "SY" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau CorrAcier */
typedef boost::shared_ptr< CorrAcierMaterialBehaviourInstance > CorrAcierMaterialBehaviourPtr;


/**
 * @class CableGaineFrotMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau CableGaineFrot
 * @author Jean-Pierre Lefebvre
 */
class CableGaineFrotMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        CableGaineFrotMaterialBehaviourInstance()
        {
            // Mot cle "CABLE_GAINE_FROT" dans Aster
            _asterName = "CABLE_GAINE_FROT";

            // Parametres matériau
            this->addDoubleProperty( "Type", ElementaryMaterialPropertyDouble( "TYPE" , true ) );
            this->addDoubleProperty( "Frot_line", ElementaryMaterialPropertyDouble( "FROT_LINE" , 0.0 , false ) );
            this->addDoubleProperty( "Frot_courb", ElementaryMaterialPropertyDouble( "FROT_COURB" , 0.0 , false ) );
            this->addDoubleProperty( "Frot_line", ElementaryMaterialPropertyDouble( "FROT_LINE" , -1.0 , false ) );
            this->addDoubleProperty( "Frot_courb", ElementaryMaterialPropertyDouble( "FROT_COURB" , 0.0 , false ) );
            this->addDoubleProperty( "Frot_line", ElementaryMaterialPropertyDouble( "FROT_LINE" , 0.0 , true ) );
            this->addDoubleProperty( "Frot_courb", ElementaryMaterialPropertyDouble( "FROT_COURB" , 0.0 , true ) );
            this->addDoubleProperty( "Pena_lagr", ElementaryMaterialPropertyDouble( "PENA_LAGR" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau CableGaineFrot */
typedef boost::shared_ptr< CableGaineFrotMaterialBehaviourInstance > CableGaineFrotMaterialBehaviourPtr;


/**
 * @class DisEcroCineMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau DisEcroCine
 * @author Jean-Pierre Lefebvre
 */
class DisEcroCineMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        DisEcroCineMaterialBehaviourInstance()
        {
            // Mot cle "DIS_ECRO_CINE" dans Aster
            _asterName = "DIS_ECRO_CINE";

            // Parametres matériau
            this->addDoubleProperty( "Limy_dx", ElementaryMaterialPropertyDouble( "LIMY_DX" , false ) );
            this->addDoubleProperty( "Limy_dy", ElementaryMaterialPropertyDouble( "LIMY_DY" , false ) );
            this->addDoubleProperty( "Limy_dz", ElementaryMaterialPropertyDouble( "LIMY_DZ" , false ) );
            this->addDoubleProperty( "Limy_rx", ElementaryMaterialPropertyDouble( "LIMY_RX" , false ) );
            this->addDoubleProperty( "Limy_ry", ElementaryMaterialPropertyDouble( "LIMY_RY" , false ) );
            this->addDoubleProperty( "Limy_rz", ElementaryMaterialPropertyDouble( "LIMY_RZ" , false ) );
            this->addDoubleProperty( "Kcin_dx", ElementaryMaterialPropertyDouble( "KCIN_DX" , false ) );
            this->addDoubleProperty( "Kcin_dy", ElementaryMaterialPropertyDouble( "KCIN_DY" , false ) );
            this->addDoubleProperty( "Kcin_dz", ElementaryMaterialPropertyDouble( "KCIN_DZ" , false ) );
            this->addDoubleProperty( "Kcin_rx", ElementaryMaterialPropertyDouble( "KCIN_RX" , false ) );
            this->addDoubleProperty( "Kcin_ry", ElementaryMaterialPropertyDouble( "KCIN_RY" , false ) );
            this->addDoubleProperty( "Kcin_rz", ElementaryMaterialPropertyDouble( "KCIN_RZ" , false ) );
            this->addDoubleProperty( "Limu_dx", ElementaryMaterialPropertyDouble( "LIMU_DX" , false ) );
            this->addDoubleProperty( "Limu_dy", ElementaryMaterialPropertyDouble( "LIMU_DY" , false ) );
            this->addDoubleProperty( "Limu_dz", ElementaryMaterialPropertyDouble( "LIMU_DZ" , false ) );
            this->addDoubleProperty( "Limu_rx", ElementaryMaterialPropertyDouble( "LIMU_RX" , false ) );
            this->addDoubleProperty( "Limu_ry", ElementaryMaterialPropertyDouble( "LIMU_RY" , false ) );
            this->addDoubleProperty( "Limu_rz", ElementaryMaterialPropertyDouble( "LIMU_RZ" , false ) );
            this->addDoubleProperty( "Puis_dx", ElementaryMaterialPropertyDouble( "PUIS_DX" , false ) );
            this->addDoubleProperty( "Puis_dy", ElementaryMaterialPropertyDouble( "PUIS_DY" , false ) );
            this->addDoubleProperty( "Puis_dz", ElementaryMaterialPropertyDouble( "PUIS_DZ" , false ) );
            this->addDoubleProperty( "Puis_rx", ElementaryMaterialPropertyDouble( "PUIS_RX" , false ) );
            this->addDoubleProperty( "Puis_ry", ElementaryMaterialPropertyDouble( "PUIS_RY" , false ) );
            this->addDoubleProperty( "Puis_rz", ElementaryMaterialPropertyDouble( "PUIS_RZ" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau DisEcroCine */
typedef boost::shared_ptr< DisEcroCineMaterialBehaviourInstance > DisEcroCineMaterialBehaviourPtr;


/**
 * @class DisViscMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau DisVisc
 * @author Jean-Pierre Lefebvre
 */
class DisViscMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        DisViscMaterialBehaviourInstance()
        {
            // Mot cle "DIS_VISC" dans Aster
            _asterName = "DIS_VISC";

            // Parametres matériau
            this->addDoubleProperty( "K1", ElementaryMaterialPropertyDouble( "K1" , false ) );
            this->addDoubleProperty( "K2", ElementaryMaterialPropertyDouble( "K2" , false ) );
            this->addDoubleProperty( "K3", ElementaryMaterialPropertyDouble( "K3" , false ) );
            this->addDoubleProperty( "Unsur_k1", ElementaryMaterialPropertyDouble( "UNSUR_K1" , false ) );
            this->addDoubleProperty( "Unsur_k2", ElementaryMaterialPropertyDouble( "UNSUR_K2" , false ) );
            this->addDoubleProperty( "Unsur_k3", ElementaryMaterialPropertyDouble( "UNSUR_K3" , false ) );
            this->addDoubleProperty( "C", ElementaryMaterialPropertyDouble( "C" , true ) );
            this->addDoubleProperty( "Puis_alpha", ElementaryMaterialPropertyDouble( "PUIS_ALPHA" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau DisVisc */
typedef boost::shared_ptr< DisViscMaterialBehaviourInstance > DisViscMaterialBehaviourPtr;


/**
 * @class DisBiliElasMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau DisBiliElas
 * @author Jean-Pierre Lefebvre
 */
class DisBiliElasMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        DisBiliElasMaterialBehaviourInstance()
        {
            // Mot cle "DIS_BILI_ELAS" dans Aster
            _asterName = "DIS_BILI_ELAS";

            // Parametres matériau
            this->addFunctionProperty( "Kdeb_dx", ElementaryMaterialPropertyFunction( "KDEB_DX" , false ) );
            this->addFunctionProperty( "Kdeb_dy", ElementaryMaterialPropertyFunction( "KDEB_DY" , false ) );
            this->addFunctionProperty( "Kdeb_dz", ElementaryMaterialPropertyFunction( "KDEB_DZ" , false ) );
            this->addFunctionProperty( "Kfin_dx", ElementaryMaterialPropertyFunction( "KFIN_DX" , false ) );
            this->addFunctionProperty( "Kfin_dy", ElementaryMaterialPropertyFunction( "KFIN_DY" , false ) );
            this->addFunctionProperty( "Kfin_dz", ElementaryMaterialPropertyFunction( "KFIN_DZ" , false ) );
            this->addDoubleProperty( "Fpre_dx", ElementaryMaterialPropertyDouble( "FPRE_DX" , false ) );
            this->addDoubleProperty( "Fpre_dy", ElementaryMaterialPropertyDouble( "FPRE_DY" , false ) );
            this->addDoubleProperty( "Fpre_dz", ElementaryMaterialPropertyDouble( "FPRE_DZ" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau DisBiliElas */
typedef boost::shared_ptr< DisBiliElasMaterialBehaviourInstance > DisBiliElasMaterialBehaviourPtr;


/**
 * @class TherNlMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau TherNl
 * @author Jean-Pierre Lefebvre
 */
class TherNlMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        TherNlMaterialBehaviourInstance()
        {
            // Mot cle "THER_NL" dans Aster
            _asterName = "THER_NL";

            // Parametres matériau
            this->addFunctionProperty( "Lambda", ElementaryMaterialPropertyFunction( "LAMBDA" , true ) );
            this->addFunctionProperty( "Beta", ElementaryMaterialPropertyFunction( "BETA" , false ) );
            this->addFunctionProperty( "Rho_cp", ElementaryMaterialPropertyFunction( "RHO_CP" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau TherNl */
typedef boost::shared_ptr< TherNlMaterialBehaviourInstance > TherNlMaterialBehaviourPtr;


/**
 * @class TherHydrMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau TherHydr
 * @author Jean-Pierre Lefebvre
 */
class TherHydrMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        TherHydrMaterialBehaviourInstance()
        {
            // Mot cle "THER_HYDR" dans Aster
            _asterName = "THER_HYDR";

            // Parametres matériau
            this->addFunctionProperty( "Lambda", ElementaryMaterialPropertyFunction( "LAMBDA" , true ) );
            this->addFunctionProperty( "Beta", ElementaryMaterialPropertyFunction( "BETA" , false ) );
            this->addFunctionProperty( "Affinite", ElementaryMaterialPropertyFunction( "AFFINITE" , true ) );
            this->addDoubleProperty( "Chalhydr", ElementaryMaterialPropertyDouble( "CHALHYDR" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau TherHydr */
typedef boost::shared_ptr< TherHydrMaterialBehaviourInstance > TherHydrMaterialBehaviourPtr;


/**
 * @class TherMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Ther
 * @author Jean-Pierre Lefebvre
 */
class TherMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        TherMaterialBehaviourInstance()
        {
            // Mot cle "THER" dans Aster
            _asterName = "THER";

            // Parametres matériau
            this->addDoubleProperty( "Lambda", ElementaryMaterialPropertyDouble( "LAMBDA" , true ) );
            this->addDoubleProperty( "Rho_cp", ElementaryMaterialPropertyDouble( "RHO_CP" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Ther */
typedef boost::shared_ptr< TherMaterialBehaviourInstance > TherMaterialBehaviourPtr;


/**
 * @class TherFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau TherFo
 * @author Jean-Pierre Lefebvre
 */
class TherFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        TherFoMaterialBehaviourInstance()
        {
            // Mot cle "THER_FO" dans Aster
            _asterName = "THER_FO";

            // Parametres matériau
            this->addFunctionProperty( "Lambda", ElementaryMaterialPropertyFunction( "LAMBDA" , true ) );
            this->addFunctionProperty( "Rho_cp", ElementaryMaterialPropertyFunction( "RHO_CP" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau TherFo */
typedef boost::shared_ptr< TherFoMaterialBehaviourInstance > TherFoMaterialBehaviourPtr;


/**
 * @class TherOrthMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau TherOrth
 * @author Jean-Pierre Lefebvre
 */
class TherOrthMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        TherOrthMaterialBehaviourInstance()
        {
            // Mot cle "THER_ORTH" dans Aster
            _asterName = "THER_ORTH";

            // Parametres matériau
            this->addDoubleProperty( "Lambda_l", ElementaryMaterialPropertyDouble( "LAMBDA_L" , true ) );
            this->addDoubleProperty( "Lambda_t", ElementaryMaterialPropertyDouble( "LAMBDA_T" , true ) );
            this->addDoubleProperty( "Lambda_n", ElementaryMaterialPropertyDouble( "LAMBDA_N" , false ) );
            this->addDoubleProperty( "Rho_cp", ElementaryMaterialPropertyDouble( "RHO_CP" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau TherOrth */
typedef boost::shared_ptr< TherOrthMaterialBehaviourInstance > TherOrthMaterialBehaviourPtr;


/**
 * @class TherCoqueMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau TherCoque
 * @author Jean-Pierre Lefebvre
 */
class TherCoqueMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        TherCoqueMaterialBehaviourInstance()
        {
            // Mot cle "THER_COQUE" dans Aster
            _asterName = "THER_COQUE";

            // Parametres matériau
            this->addDoubleProperty( "Cond_lmm", ElementaryMaterialPropertyDouble( "COND_LMM" , true ) );
            this->addDoubleProperty( "Cond_tmm", ElementaryMaterialPropertyDouble( "COND_TMM" , true ) );
            this->addDoubleProperty( "Cond_lmp", ElementaryMaterialPropertyDouble( "COND_LMP" , true ) );
            this->addDoubleProperty( "Cond_tmp", ElementaryMaterialPropertyDouble( "COND_TMP" , true ) );
            this->addDoubleProperty( "Cond_lpp", ElementaryMaterialPropertyDouble( "COND_LPP" , true ) );
            this->addDoubleProperty( "Cond_tpp", ElementaryMaterialPropertyDouble( "COND_TPP" , true ) );
            this->addDoubleProperty( "Cond_lsi", ElementaryMaterialPropertyDouble( "COND_LSI" , true ) );
            this->addDoubleProperty( "Cond_tsi", ElementaryMaterialPropertyDouble( "COND_TSI" , true ) );
            this->addDoubleProperty( "Cond_nmm", ElementaryMaterialPropertyDouble( "COND_NMM" , true ) );
            this->addDoubleProperty( "Cond_nmp", ElementaryMaterialPropertyDouble( "COND_NMP" , true ) );
            this->addDoubleProperty( "Cond_npp", ElementaryMaterialPropertyDouble( "COND_NPP" , true ) );
            this->addDoubleProperty( "Cond_nsi", ElementaryMaterialPropertyDouble( "COND_NSI" , true ) );
            this->addDoubleProperty( "Cmas_mm", ElementaryMaterialPropertyDouble( "CMAS_MM" , false ) );
            this->addDoubleProperty( "Cmas_mp", ElementaryMaterialPropertyDouble( "CMAS_MP" , false ) );
            this->addDoubleProperty( "Cmas_pp", ElementaryMaterialPropertyDouble( "CMAS_PP" , false ) );
            this->addDoubleProperty( "Cmas_si", ElementaryMaterialPropertyDouble( "CMAS_SI" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau TherCoque */
typedef boost::shared_ptr< TherCoqueMaterialBehaviourInstance > TherCoqueMaterialBehaviourPtr;


/**
 * @class TherCoqueFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau TherCoqueFo
 * @author Jean-Pierre Lefebvre
 */
class TherCoqueFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        TherCoqueFoMaterialBehaviourInstance()
        {
            // Mot cle "THER_COQUE_FO" dans Aster
            _asterName = "THER_COQUE_FO";

            // Parametres matériau
            this->addFunctionProperty( "Cond_lmm", ElementaryMaterialPropertyFunction( "COND_LMM" , true ) );
            this->addFunctionProperty( "Cond_tmm", ElementaryMaterialPropertyFunction( "COND_TMM" , true ) );
            this->addFunctionProperty( "Cond_lmp", ElementaryMaterialPropertyFunction( "COND_LMP" , true ) );
            this->addFunctionProperty( "Cond_tmp", ElementaryMaterialPropertyFunction( "COND_TMP" , true ) );
            this->addFunctionProperty( "Cond_lpp", ElementaryMaterialPropertyFunction( "COND_LPP" , true ) );
            this->addFunctionProperty( "Cond_tpp", ElementaryMaterialPropertyFunction( "COND_TPP" , true ) );
            this->addFunctionProperty( "Cond_lsi", ElementaryMaterialPropertyFunction( "COND_LSI" , true ) );
            this->addFunctionProperty( "Cond_tsi", ElementaryMaterialPropertyFunction( "COND_TSI" , true ) );
            this->addFunctionProperty( "Cond_nmm", ElementaryMaterialPropertyFunction( "COND_NMM" , true ) );
            this->addFunctionProperty( "Cond_nmp", ElementaryMaterialPropertyFunction( "COND_NMP" , true ) );
            this->addFunctionProperty( "Cond_npp", ElementaryMaterialPropertyFunction( "COND_NPP" , true ) );
            this->addFunctionProperty( "Cond_nsi", ElementaryMaterialPropertyFunction( "COND_NSI" , true ) );
            this->addFunctionProperty( "Cmas_mm", ElementaryMaterialPropertyFunction( "CMAS_MM" , false ) );
            this->addFunctionProperty( "Cmas_mp", ElementaryMaterialPropertyFunction( "CMAS_MP" , false ) );
            this->addFunctionProperty( "Cmas_pp", ElementaryMaterialPropertyFunction( "CMAS_PP" , false ) );
            this->addFunctionProperty( "Cmas_si", ElementaryMaterialPropertyFunction( "CMAS_SI" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau TherCoqueFo */
typedef boost::shared_ptr< TherCoqueFoMaterialBehaviourInstance > TherCoqueFoMaterialBehaviourPtr;


/**
 * @class SechGrangerMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau SechGranger
 * @author Jean-Pierre Lefebvre
 */
class SechGrangerMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        SechGrangerMaterialBehaviourInstance()
        {
            // Mot cle "SECH_GRANGER" dans Aster
            _asterName = "SECH_GRANGER";

            // Parametres matériau
            this->addDoubleProperty( "A", ElementaryMaterialPropertyDouble( "A" , true ) );
            this->addDoubleProperty( "B", ElementaryMaterialPropertyDouble( "B" , true ) );
            this->addDoubleProperty( "Qsr_k", ElementaryMaterialPropertyDouble( "QSR_K" , true ) );
            this->addDoubleProperty( "Temp_0_c", ElementaryMaterialPropertyDouble( "TEMP_0_C" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau SechGranger */
typedef boost::shared_ptr< SechGrangerMaterialBehaviourInstance > SechGrangerMaterialBehaviourPtr;


/**
 * @class SechMensiMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau SechMensi
 * @author Jean-Pierre Lefebvre
 */
class SechMensiMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        SechMensiMaterialBehaviourInstance()
        {
            // Mot cle "SECH_MENSI" dans Aster
            _asterName = "SECH_MENSI";

            // Parametres matériau
            this->addDoubleProperty( "A", ElementaryMaterialPropertyDouble( "A" , true ) );
            this->addDoubleProperty( "B", ElementaryMaterialPropertyDouble( "B" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau SechMensi */
typedef boost::shared_ptr< SechMensiMaterialBehaviourInstance > SechMensiMaterialBehaviourPtr;


/**
 * @class SechBazantMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau SechBazant
 * @author Jean-Pierre Lefebvre
 */
class SechBazantMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        SechBazantMaterialBehaviourInstance()
        {
            // Mot cle "SECH_BAZANT" dans Aster
            _asterName = "SECH_BAZANT";

            // Parametres matériau
            this->addDoubleProperty( "D1", ElementaryMaterialPropertyDouble( "D1" , true ) );
            this->addDoubleProperty( "Alpha_bazant", ElementaryMaterialPropertyDouble( "ALPHA_BAZANT" , true ) );
            this->addDoubleProperty( "N", ElementaryMaterialPropertyDouble( "N" , true ) );
            this->addFunctionProperty( "Fonc_desorp", ElementaryMaterialPropertyFunction( "FONC_DESORP" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau SechBazant */
typedef boost::shared_ptr< SechBazantMaterialBehaviourInstance > SechBazantMaterialBehaviourPtr;


/**
 * @class SechNappeMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau SechNappe
 * @author Jean-Pierre Lefebvre
 */
class SechNappeMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        SechNappeMaterialBehaviourInstance()
        {
            // Mot cle "SECH_NAPPE" dans Aster
            _asterName = "SECH_NAPPE";

            // Parametres matériau
            this->addDoubleProperty( "Fonction", ElementaryMaterialPropertyDouble( "FONCTION" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau SechNappe */
typedef boost::shared_ptr< SechNappeMaterialBehaviourInstance > SechNappeMaterialBehaviourPtr;


/**
 * @class MetaAcierMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MetaAcier
 * @author Jean-Pierre Lefebvre
 */
class MetaAcierMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MetaAcierMaterialBehaviourInstance()
        {
            // Mot cle "META_ACIER" dans Aster
            _asterName = "META_ACIER";

            // Parametres matériau
            this->addDoubleProperty( "Trc", ElementaryMaterialPropertyDouble( "TRC" , true ) );
            this->addDoubleProperty( "Ar3", ElementaryMaterialPropertyDouble( "AR3" , true ) );
            this->addDoubleProperty( "Alpha", ElementaryMaterialPropertyDouble( "ALPHA" , true ) );
            this->addDoubleProperty( "Ms0", ElementaryMaterialPropertyDouble( "MS0" , true ) );
            this->addDoubleProperty( "Ac1", ElementaryMaterialPropertyDouble( "AC1" , true ) );
            this->addDoubleProperty( "Ac3", ElementaryMaterialPropertyDouble( "AC3" , true ) );
            this->addDoubleProperty( "Taux_1", ElementaryMaterialPropertyDouble( "TAUX_1" , true ) );
            this->addDoubleProperty( "Taux_3", ElementaryMaterialPropertyDouble( "TAUX_3" , true ) );
            this->addDoubleProperty( "Lambda0", ElementaryMaterialPropertyDouble( "LAMBDA0" , false ) );
            this->addDoubleProperty( "Qsr_k", ElementaryMaterialPropertyDouble( "QSR_K" , false ) );
            this->addDoubleProperty( "D10", ElementaryMaterialPropertyDouble( "D10" , false ) );
            this->addDoubleProperty( "Wsr_k", ElementaryMaterialPropertyDouble( "WSR_K" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MetaAcier */
typedef boost::shared_ptr< MetaAcierMaterialBehaviourInstance > MetaAcierMaterialBehaviourPtr;


/**
 * @class MetaZircMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MetaZirc
 * @author Jean-Pierre Lefebvre
 */
class MetaZircMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MetaZircMaterialBehaviourInstance()
        {
            // Mot cle "META_ZIRC" dans Aster
            _asterName = "META_ZIRC";

            // Parametres matériau
            this->addDoubleProperty( "Tdeq", ElementaryMaterialPropertyDouble( "TDEQ" , true ) );
            this->addDoubleProperty( "N", ElementaryMaterialPropertyDouble( "N" , true ) );
            this->addDoubleProperty( "K", ElementaryMaterialPropertyDouble( "K" , true ) );
            this->addDoubleProperty( "T1c", ElementaryMaterialPropertyDouble( "T1C" , true ) );
            this->addDoubleProperty( "T2c", ElementaryMaterialPropertyDouble( "T2C" , true ) );
            this->addDoubleProperty( "Ac", ElementaryMaterialPropertyDouble( "AC" , true ) );
            this->addDoubleProperty( "M", ElementaryMaterialPropertyDouble( "M" , true ) );
            this->addDoubleProperty( "Qsr_k", ElementaryMaterialPropertyDouble( "QSR_K" , true ) );
            this->addDoubleProperty( "T1r", ElementaryMaterialPropertyDouble( "T1R" , true ) );
            this->addDoubleProperty( "T2r", ElementaryMaterialPropertyDouble( "T2R" , true ) );
            this->addDoubleProperty( "Ar", ElementaryMaterialPropertyDouble( "AR" , true ) );
            this->addDoubleProperty( "Br", ElementaryMaterialPropertyDouble( "BR" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MetaZirc */
typedef boost::shared_ptr< MetaZircMaterialBehaviourInstance > MetaZircMaterialBehaviourPtr;


/**
 * @class DurtMetaMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau DurtMeta
 * @author Jean-Pierre Lefebvre
 */
class DurtMetaMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        DurtMetaMaterialBehaviourInstance()
        {
            // Mot cle "DURT_META" dans Aster
            _asterName = "DURT_META";

            // Parametres matériau
            this->addDoubleProperty( "F1_durt", ElementaryMaterialPropertyDouble( "F1_DURT" , true ) );
            this->addDoubleProperty( "F2_durt", ElementaryMaterialPropertyDouble( "F2_DURT" , true ) );
            this->addDoubleProperty( "F3_durt", ElementaryMaterialPropertyDouble( "F3_DURT" , true ) );
            this->addDoubleProperty( "F4_durt", ElementaryMaterialPropertyDouble( "F4_DURT" , true ) );
            this->addDoubleProperty( "C_durt", ElementaryMaterialPropertyDouble( "C_DURT" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau DurtMeta */
typedef boost::shared_ptr< DurtMetaMaterialBehaviourInstance > DurtMetaMaterialBehaviourPtr;


/**
 * @class ElasMetaMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ElasMeta
 * @author Jean-Pierre Lefebvre
 */
class ElasMetaMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasMetaMaterialBehaviourInstance()
        {
            // Mot cle "ELAS_META" dans Aster
            _asterName = "ELAS_META";

            // Parametres matériau
            this->addDoubleProperty( "E", ElementaryMaterialPropertyDouble( "E" , true ) );
            this->addDoubleProperty( "Nu", ElementaryMaterialPropertyDouble( "NU" , true ) );
            this->addDoubleProperty( "F_alpha", ElementaryMaterialPropertyDouble( "F_ALPHA" , true ) );
            this->addDoubleProperty( "C_alpha", ElementaryMaterialPropertyDouble( "C_ALPHA" , true ) );
            this->addDoubleProperty( "Phase_refe", ElementaryMaterialPropertyDouble( "PHASE_REFE" , true ) );
            this->addDoubleProperty( "Epsf_epsc_tref", ElementaryMaterialPropertyDouble( "EPSF_EPSC_TREF" , true ) );
            this->addDoubleProperty( "Precision", ElementaryMaterialPropertyDouble( "PRECISION" , 1.0E+0 , false ) );
            this->addDoubleProperty( "F1_sy", ElementaryMaterialPropertyDouble( "F1_SY" , false ) );
            this->addDoubleProperty( "F2_sy", ElementaryMaterialPropertyDouble( "F2_SY" , false ) );
            this->addDoubleProperty( "F3_sy", ElementaryMaterialPropertyDouble( "F3_SY" , false ) );
            this->addDoubleProperty( "F4_sy", ElementaryMaterialPropertyDouble( "F4_SY" , false ) );
            this->addDoubleProperty( "C_sy", ElementaryMaterialPropertyDouble( "C_SY" , false ) );
            this->addFunctionProperty( "Sy_melange", ElementaryMaterialPropertyFunction( "SY_MELANGE" , false ) );
            this->addDoubleProperty( "F1_s_vp", ElementaryMaterialPropertyDouble( "F1_S_VP" , false ) );
            this->addDoubleProperty( "F2_s_vp", ElementaryMaterialPropertyDouble( "F2_S_VP" , false ) );
            this->addDoubleProperty( "F3_s_vp", ElementaryMaterialPropertyDouble( "F3_S_VP" , false ) );
            this->addDoubleProperty( "F4_s_vp", ElementaryMaterialPropertyDouble( "F4_S_VP" , false ) );
            this->addDoubleProperty( "C_s_vp", ElementaryMaterialPropertyDouble( "C_S_VP" , false ) );
            this->addFunctionProperty( "S_vp_melange", ElementaryMaterialPropertyFunction( "S_VP_MELANGE" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasMeta */
typedef boost::shared_ptr< ElasMetaMaterialBehaviourInstance > ElasMetaMaterialBehaviourPtr;


/**
 * @class ElasMetaFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ElasMetaFo
 * @author Jean-Pierre Lefebvre
 */
class ElasMetaFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasMetaFoMaterialBehaviourInstance()
        {
            // Mot cle "ELAS_META_FO" dans Aster
            _asterName = "ELAS_META_FO";

            // Parametres matériau
            this->addFunctionProperty( "E", ElementaryMaterialPropertyFunction( "E" , true ) );
            this->addFunctionProperty( "Nu", ElementaryMaterialPropertyFunction( "NU" , true ) );
            this->addFunctionProperty( "F_alpha", ElementaryMaterialPropertyFunction( "F_ALPHA" , true ) );
            this->addFunctionProperty( "C_alpha", ElementaryMaterialPropertyFunction( "C_ALPHA" , true ) );
            this->addDoubleProperty( "Phase_refe", ElementaryMaterialPropertyDouble( "PHASE_REFE" , true ) );
            this->addDoubleProperty( "Epsf_epsc_tref", ElementaryMaterialPropertyDouble( "EPSF_EPSC_TREF" , true ) );
            this->addDoubleProperty( "Temp_def_alpha", ElementaryMaterialPropertyDouble( "TEMP_DEF_ALPHA" , false ) );
            this->addDoubleProperty( "Precision", ElementaryMaterialPropertyDouble( "PRECISION" , 1.0E+0 , false ) );
            this->addFunctionProperty( "F1_sy", ElementaryMaterialPropertyFunction( "F1_SY" , false ) );
            this->addFunctionProperty( "F2_sy", ElementaryMaterialPropertyFunction( "F2_SY" , false ) );
            this->addFunctionProperty( "F3_sy", ElementaryMaterialPropertyFunction( "F3_SY" , false ) );
            this->addFunctionProperty( "F4_sy", ElementaryMaterialPropertyFunction( "F4_SY" , false ) );
            this->addFunctionProperty( "C_sy", ElementaryMaterialPropertyFunction( "C_SY" , false ) );
            this->addFunctionProperty( "Sy_melange", ElementaryMaterialPropertyFunction( "SY_MELANGE" , false ) );
            this->addFunctionProperty( "F1_s_vp", ElementaryMaterialPropertyFunction( "F1_S_VP" , false ) );
            this->addFunctionProperty( "F2_s_vp", ElementaryMaterialPropertyFunction( "F2_S_VP" , false ) );
            this->addFunctionProperty( "F3_s_vp", ElementaryMaterialPropertyFunction( "F3_S_VP" , false ) );
            this->addFunctionProperty( "F4_s_vp", ElementaryMaterialPropertyFunction( "F4_S_VP" , false ) );
            this->addFunctionProperty( "C_s_vp", ElementaryMaterialPropertyFunction( "C_S_VP" , false ) );
            this->addFunctionProperty( "S_vp_melange", ElementaryMaterialPropertyFunction( "S_VP_MELANGE" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasMetaFo */
typedef boost::shared_ptr< ElasMetaFoMaterialBehaviourInstance > ElasMetaFoMaterialBehaviourPtr;


/**
 * @class MetaEcroLineMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MetaEcroLine
 * @author Jean-Pierre Lefebvre
 */
class MetaEcroLineMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MetaEcroLineMaterialBehaviourInstance()
        {
            // Mot cle "META_ECRO_LINE" dans Aster
            _asterName = "META_ECRO_LINE";

            // Parametres matériau
            this->addFunctionProperty( "F1_d_sigm_epsi", ElementaryMaterialPropertyFunction( "F1_D_SIGM_EPSI" , false ) );
            this->addFunctionProperty( "F2_d_sigm_epsi", ElementaryMaterialPropertyFunction( "F2_D_SIGM_EPSI" , false ) );
            this->addFunctionProperty( "F3_d_sigm_epsi", ElementaryMaterialPropertyFunction( "F3_D_SIGM_EPSI" , false ) );
            this->addFunctionProperty( "F4_d_sigm_epsi", ElementaryMaterialPropertyFunction( "F4_D_SIGM_EPSI" , false ) );
            this->addFunctionProperty( "C_d_sigm_epsi", ElementaryMaterialPropertyFunction( "C_D_SIGM_EPSI" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MetaEcroLine */
typedef boost::shared_ptr< MetaEcroLineMaterialBehaviourInstance > MetaEcroLineMaterialBehaviourPtr;


/**
 * @class MetaTractionMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MetaTraction
 * @author Jean-Pierre Lefebvre
 */
class MetaTractionMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MetaTractionMaterialBehaviourInstance()
        {
            // Mot cle "META_TRACTION" dans Aster
            _asterName = "META_TRACTION";

            // Parametres matériau
            this->addFunctionProperty( "Sigm_f1", ElementaryMaterialPropertyFunction( "SIGM_F1" , false ) );
            this->addFunctionProperty( "Sigm_f2", ElementaryMaterialPropertyFunction( "SIGM_F2" , false ) );
            this->addFunctionProperty( "Sigm_f3", ElementaryMaterialPropertyFunction( "SIGM_F3" , false ) );
            this->addFunctionProperty( "Sigm_f4", ElementaryMaterialPropertyFunction( "SIGM_F4" , false ) );
            this->addFunctionProperty( "Sigm_c", ElementaryMaterialPropertyFunction( "SIGM_C" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MetaTraction */
typedef boost::shared_ptr< MetaTractionMaterialBehaviourInstance > MetaTractionMaterialBehaviourPtr;


/**
 * @class MetaViscFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MetaViscFo
 * @author Jean-Pierre Lefebvre
 */
class MetaViscFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MetaViscFoMaterialBehaviourInstance()
        {
            // Mot cle "META_VISC_FO" dans Aster
            _asterName = "META_VISC_FO";

            // Parametres matériau
            this->addFunctionProperty( "F1_eta", ElementaryMaterialPropertyFunction( "F1_ETA" , false ) );
            this->addFunctionProperty( "F1_n", ElementaryMaterialPropertyFunction( "F1_N" , false ) );
            this->addFunctionProperty( "F1_c", ElementaryMaterialPropertyFunction( "F1_C" , false ) );
            this->addFunctionProperty( "F1_m", ElementaryMaterialPropertyFunction( "F1_M" , false ) );
            this->addFunctionProperty( "F2_eta", ElementaryMaterialPropertyFunction( "F2_ETA" , false ) );
            this->addFunctionProperty( "F2_n", ElementaryMaterialPropertyFunction( "F2_N" , false ) );
            this->addFunctionProperty( "F2_c", ElementaryMaterialPropertyFunction( "F2_C" , false ) );
            this->addFunctionProperty( "F2_m", ElementaryMaterialPropertyFunction( "F2_M" , false ) );
            this->addFunctionProperty( "F3_eta", ElementaryMaterialPropertyFunction( "F3_ETA" , false ) );
            this->addFunctionProperty( "F3_n", ElementaryMaterialPropertyFunction( "F3_N" , false ) );
            this->addFunctionProperty( "F3_c", ElementaryMaterialPropertyFunction( "F3_C" , false ) );
            this->addFunctionProperty( "F3_m", ElementaryMaterialPropertyFunction( "F3_M" , false ) );
            this->addFunctionProperty( "F4_eta", ElementaryMaterialPropertyFunction( "F4_ETA" , false ) );
            this->addFunctionProperty( "F4_n", ElementaryMaterialPropertyFunction( "F4_N" , false ) );
            this->addFunctionProperty( "F4_c", ElementaryMaterialPropertyFunction( "F4_C" , false ) );
            this->addFunctionProperty( "F4_m", ElementaryMaterialPropertyFunction( "F4_M" , false ) );
            this->addFunctionProperty( "C_eta", ElementaryMaterialPropertyFunction( "C_ETA" , false ) );
            this->addFunctionProperty( "C_n", ElementaryMaterialPropertyFunction( "C_N" , false ) );
            this->addFunctionProperty( "C_c", ElementaryMaterialPropertyFunction( "C_C" , false ) );
            this->addFunctionProperty( "C_m", ElementaryMaterialPropertyFunction( "C_M" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MetaViscFo */
typedef boost::shared_ptr< MetaViscFoMaterialBehaviourInstance > MetaViscFoMaterialBehaviourPtr;


/**
 * @class MetaPtMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MetaPt
 * @author Jean-Pierre Lefebvre
 */
class MetaPtMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MetaPtMaterialBehaviourInstance()
        {
            // Mot cle "META_PT" dans Aster
            _asterName = "META_PT";

            // Parametres matériau
            this->addDoubleProperty( "F1_k", ElementaryMaterialPropertyDouble( "F1_K" , false ) );
            this->addDoubleProperty( "F2_k", ElementaryMaterialPropertyDouble( "F2_K" , false ) );
            this->addDoubleProperty( "F3_k", ElementaryMaterialPropertyDouble( "F3_K" , false ) );
            this->addDoubleProperty( "F4_k", ElementaryMaterialPropertyDouble( "F4_K" , false ) );
            this->addFunctionProperty( "F1_d_f_meta", ElementaryMaterialPropertyFunction( "F1_D_F_META" , false ) );
            this->addFunctionProperty( "F2_d_f_meta", ElementaryMaterialPropertyFunction( "F2_D_F_META" , false ) );
            this->addFunctionProperty( "F3_d_f_meta", ElementaryMaterialPropertyFunction( "F3_D_F_META" , false ) );
            this->addFunctionProperty( "F4_d_f_meta", ElementaryMaterialPropertyFunction( "F4_D_F_META" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MetaPt */
typedef boost::shared_ptr< MetaPtMaterialBehaviourInstance > MetaPtMaterialBehaviourPtr;


/**
 * @class MetaReMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MetaRe
 * @author Jean-Pierre Lefebvre
 */
class MetaReMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MetaReMaterialBehaviourInstance()
        {
            // Mot cle "META_RE" dans Aster
            _asterName = "META_RE";

            // Parametres matériau
            this->addDoubleProperty( "C_f1_theta", ElementaryMaterialPropertyDouble( "C_F1_THETA" , false ) );
            this->addDoubleProperty( "C_f2_theta", ElementaryMaterialPropertyDouble( "C_F2_THETA" , false ) );
            this->addDoubleProperty( "C_f3_theta", ElementaryMaterialPropertyDouble( "C_F3_THETA" , false ) );
            this->addDoubleProperty( "C_f4_theta", ElementaryMaterialPropertyDouble( "C_F4_THETA" , false ) );
            this->addDoubleProperty( "F1_c_theta", ElementaryMaterialPropertyDouble( "F1_C_THETA" , false ) );
            this->addDoubleProperty( "F2_c_theta", ElementaryMaterialPropertyDouble( "F2_C_THETA" , false ) );
            this->addDoubleProperty( "F3_c_theta", ElementaryMaterialPropertyDouble( "F3_C_THETA" , false ) );
            this->addDoubleProperty( "F4_c_theta", ElementaryMaterialPropertyDouble( "F4_C_THETA" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MetaRe */
typedef boost::shared_ptr< MetaReMaterialBehaviourInstance > MetaReMaterialBehaviourPtr;


/**
 * @class FluideMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Fluide
 * @author Jean-Pierre Lefebvre
 */
class FluideMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        FluideMaterialBehaviourInstance()
        {
            // Mot cle "FLUIDE" dans Aster
            _asterName = "FLUIDE";

            // Parametres matériau
            this->addDoubleProperty( "Rho", ElementaryMaterialPropertyDouble( "RHO" , true ) );
            this->addDoubleProperty( "Pesa_z", ElementaryMaterialPropertyDouble( "PESA_Z" , false ) );
            this->addDoubleProperty( "Cele_c", ElementaryMaterialPropertyDouble( "CELE_C" , false ) );
            this->addDoubleProperty( "Cele_r", ElementaryMaterialPropertyDouble( "CELE_R" , false ) );
            this->addDoubleProperty( "Comp_thm", ElementaryMaterialPropertyDouble( "COMP_THM" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Fluide */
typedef boost::shared_ptr< FluideMaterialBehaviourInstance > FluideMaterialBehaviourPtr;


/**
 * @class ThmInitMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ThmInit
 * @author Jean-Pierre Lefebvre
 */
class ThmInitMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ThmInitMaterialBehaviourInstance()
        {
            // Mot cle "THM_INIT" dans Aster
            _asterName = "THM_INIT";

            // Parametres matériau
            this->addDoubleProperty( "Pre1", ElementaryMaterialPropertyDouble( "PRE1" , true ) );
            this->addDoubleProperty( "Poro", ElementaryMaterialPropertyDouble( "PORO" , true ) );
            this->addDoubleProperty( "Temp", ElementaryMaterialPropertyDouble( "TEMP" , false ) );
            this->addDoubleProperty( "Pre2", ElementaryMaterialPropertyDouble( "PRE2" , false ) );
            this->addDoubleProperty( "Pres_vape", ElementaryMaterialPropertyDouble( "PRES_VAPE" , false ) );
            this->addDoubleProperty( "Degr_satu", ElementaryMaterialPropertyDouble( "DEGR_SATU" , false ) );
            this->addDoubleProperty( "Comp_thm", ElementaryMaterialPropertyDouble( "COMP_THM" , 1.0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ThmInit */
typedef boost::shared_ptr< ThmInitMaterialBehaviourInstance > ThmInitMaterialBehaviourPtr;


/**
 * @class ThmAirDissMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ThmAirDiss
 * @author Jean-Pierre Lefebvre
 */
class ThmAirDissMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ThmAirDissMaterialBehaviourInstance()
        {
            // Mot cle "THM_AIR_DISS" dans Aster
            _asterName = "THM_AIR_DISS";

            // Parametres matériau
            this->addDoubleProperty( "Cp", ElementaryMaterialPropertyDouble( "CP" , true ) );
            this->addFunctionProperty( "Coef_henry", ElementaryMaterialPropertyFunction( "COEF_HENRY" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ThmAirDiss */
typedef boost::shared_ptr< ThmAirDissMaterialBehaviourInstance > ThmAirDissMaterialBehaviourPtr;



/**
 * @class ThmDiffuMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ThmDiffu
 * @author Jean-Pierre Lefebvre
 */
class ThmDiffuMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ThmDiffuMaterialBehaviourInstance()
        {
            // Mot cle "THM_DIFFU" dans Aster
            _asterName = "THM_DIFFU";

            // Parametres matériau
            this->addDoubleProperty( "Rho", ElementaryMaterialPropertyDouble( "RHO" , true ) );
            this->addDoubleProperty( "Biot_coef", ElementaryMaterialPropertyDouble( "BIOT_COEF" , false ) );
            this->addDoubleProperty( "Biot_l", ElementaryMaterialPropertyDouble( "BIOT_L" , false ) );
            this->addDoubleProperty( "Biot_n", ElementaryMaterialPropertyDouble( "BIOT_N" , false ) );
            this->addDoubleProperty( "Biot_t", ElementaryMaterialPropertyDouble( "BIOT_T" , false ) );
            this->addDoubleProperty( "Pesa_x", ElementaryMaterialPropertyDouble( "PESA_X" , true ) );
            this->addDoubleProperty( "Pesa_y", ElementaryMaterialPropertyDouble( "PESA_Y" , true ) );
            this->addDoubleProperty( "Pesa_z", ElementaryMaterialPropertyDouble( "PESA_Z" , true ) );
            this->addFunctionProperty( "Pesa_mult", ElementaryMaterialPropertyFunction( "PESA_MULT" , false ) );
            this->addDoubleProperty( "Cp", ElementaryMaterialPropertyDouble( "CP" , false ) );
            this->addFunctionProperty( "Perm_in", ElementaryMaterialPropertyFunction( "PERM_IN" , false ) );
            this->addFunctionProperty( "Permin_l", ElementaryMaterialPropertyFunction( "PERMIN_L" , false ) );
            this->addFunctionProperty( "Permin_n", ElementaryMaterialPropertyFunction( "PERMIN_N" , false ) );
            this->addFunctionProperty( "Permin_t", ElementaryMaterialPropertyFunction( "PERMIN_T" , false ) );
            this->addFunctionProperty( "Perm_end", ElementaryMaterialPropertyFunction( "PERM_END" , false ) );
            this->addFunctionProperty( "Lamb_phi", ElementaryMaterialPropertyFunction( "LAMB_PHI" , false ) );
            this->addFunctionProperty( "D_lb_phi", ElementaryMaterialPropertyFunction( "D_LB_PHI" , false ) );
            this->addFunctionProperty( "Lamb_t", ElementaryMaterialPropertyFunction( "LAMB_T" , false ) );
            this->addFunctionProperty( "Lamb_tl", ElementaryMaterialPropertyFunction( "LAMB_TL" , false ) );
            this->addFunctionProperty( "Lamb_tn", ElementaryMaterialPropertyFunction( "LAMB_TN" , false ) );
            this->addFunctionProperty( "Lamb_tt", ElementaryMaterialPropertyFunction( "LAMB_TT" , false ) );
            this->addFunctionProperty( "D_lb_t", ElementaryMaterialPropertyFunction( "D_LB_T" , false ) );
            this->addFunctionProperty( "D_lb_tl", ElementaryMaterialPropertyFunction( "D_LB_TL" , false ) );
            this->addFunctionProperty( "D_lb_tn", ElementaryMaterialPropertyFunction( "D_LB_TN" , false ) );
            this->addFunctionProperty( "D_lb_tt", ElementaryMaterialPropertyFunction( "D_LB_TT" , false ) );
            this->addFunctionProperty( "Lamb_s", ElementaryMaterialPropertyFunction( "LAMB_S" , false ) );
            this->addFunctionProperty( "D_lb_s", ElementaryMaterialPropertyFunction( "D_LB_S" , false ) );
            this->addDoubleProperty( "Lamb_ct", ElementaryMaterialPropertyDouble( "LAMB_CT" , false ) );
            this->addDoubleProperty( "Lamb_c_l", ElementaryMaterialPropertyDouble( "LAMB_C_L" , false ) );
            this->addDoubleProperty( "Lamb_c_n", ElementaryMaterialPropertyDouble( "LAMB_C_N" , false ) );
            this->addDoubleProperty( "Lamb_c_t", ElementaryMaterialPropertyDouble( "LAMB_C_T" , false ) );
            this->addDoubleProperty( "R_gaz", ElementaryMaterialPropertyDouble( "R_GAZ" , false ) );
            this->addDoubleProperty( "Emmag", ElementaryMaterialPropertyDouble( "EMMAG" , false ) );
            this->addFunctionProperty( "Satu_pres", ElementaryMaterialPropertyFunction( "SATU_PRES" , false ) );
            this->addFunctionProperty( "D_satu_pres", ElementaryMaterialPropertyFunction( "D_SATU_PRES" , false ) );
            this->addFunctionProperty( "Perm_liqu", ElementaryMaterialPropertyFunction( "PERM_LIQU" , false ) );
            this->addDoubleProperty( "D_perm_liqu_satu", ElementaryMaterialPropertyDouble( "D_PERM_LIQU_SATU" , false ) );
            this->addFunctionProperty( "Perm_gaz", ElementaryMaterialPropertyFunction( "PERM_GAZ" , false ) );
            this->addFunctionProperty( "D_perm_satu_gaz", ElementaryMaterialPropertyFunction( "D_PERM_SATU_GAZ" , false ) );
            this->addFunctionProperty( "D_perm_pres_gaz", ElementaryMaterialPropertyFunction( "D_PERM_PRES_GAZ" , false ) );
            this->addFunctionProperty( "Fickv_t", ElementaryMaterialPropertyFunction( "FICKV_T" , false ) );
            this->addFunctionProperty( "Fickv_pv", ElementaryMaterialPropertyFunction( "FICKV_PV" , false ) );
            this->addFunctionProperty( "Fickv_pg", ElementaryMaterialPropertyFunction( "FICKV_PG" , false ) );
            this->addFunctionProperty( "Fickv_s", ElementaryMaterialPropertyFunction( "FICKV_S" , false ) );
            this->addFunctionProperty( "D_fv_t", ElementaryMaterialPropertyFunction( "D_FV_T" , false ) );
            this->addFunctionProperty( "D_fv_pg", ElementaryMaterialPropertyFunction( "D_FV_PG" , false ) );
            this->addFunctionProperty( "Ficka_t", ElementaryMaterialPropertyFunction( "FICKA_T" , false ) );
            this->addFunctionProperty( "Ficka_pa", ElementaryMaterialPropertyFunction( "FICKA_PA" , false ) );
            this->addFunctionProperty( "Ficka_pl", ElementaryMaterialPropertyFunction( "FICKA_PL" , false ) );
            this->addFunctionProperty( "Ficka_s", ElementaryMaterialPropertyFunction( "FICKA_S" , false ) );
            this->addFunctionProperty( "D_fa_t", ElementaryMaterialPropertyFunction( "D_FA_T" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ThmDiffu */
typedef boost::shared_ptr< ThmDiffuMaterialBehaviourInstance > ThmDiffuMaterialBehaviourPtr;


/**
 * @class ThmLiquMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ThmLiqu
 * @author Jean-Pierre Lefebvre
 */
class ThmLiquMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ThmLiquMaterialBehaviourInstance()
        {
            // Mot cle "THM_LIQU" dans Aster
            _asterName = "THM_LIQU";

            // Parametres matériau
            this->addDoubleProperty( "Rho", ElementaryMaterialPropertyDouble( "RHO" , true ) );
            this->addDoubleProperty( "Un_sur_k", ElementaryMaterialPropertyDouble( "UN_SUR_K" , true ) );
            this->addFunctionProperty( "Visc", ElementaryMaterialPropertyFunction( "VISC" , true ) );
            this->addFunctionProperty( "D_visc_temp", ElementaryMaterialPropertyFunction( "D_VISC_TEMP" , true ) );
            this->addDoubleProperty( "Alpha", ElementaryMaterialPropertyDouble( "ALPHA" , false ) );
            this->addDoubleProperty( "Cp", ElementaryMaterialPropertyDouble( "CP" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ThmLiqu */
typedef boost::shared_ptr< ThmLiquMaterialBehaviourInstance > ThmLiquMaterialBehaviourPtr;


/**
 * @class ThmGazMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ThmGaz
 * @author Jean-Pierre Lefebvre
 */
class ThmGazMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ThmGazMaterialBehaviourInstance()
        {
            // Mot cle "THM_GAZ" dans Aster
            _asterName = "THM_GAZ";

            // Parametres matériau
            this->addDoubleProperty( "Mass_mol", ElementaryMaterialPropertyDouble( "MASS_MOL" , false ) );
            this->addDoubleProperty( "Cp", ElementaryMaterialPropertyDouble( "CP" , false ) );
            this->addFunctionProperty( "Visc", ElementaryMaterialPropertyFunction( "VISC" , false ) );
            this->addFunctionProperty( "D_visc_temp", ElementaryMaterialPropertyFunction( "D_VISC_TEMP" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ThmGaz */
typedef boost::shared_ptr< ThmGazMaterialBehaviourInstance > ThmGazMaterialBehaviourPtr;


/**
 * @class ThmVapeGazMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ThmVapeGaz
 * @author Jean-Pierre Lefebvre
 */
class ThmVapeGazMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ThmVapeGazMaterialBehaviourInstance()
        {
            // Mot cle "THM_VAPE_GAZ" dans Aster
            _asterName = "THM_VAPE_GAZ";

            // Parametres matériau
            this->addDoubleProperty( "Mass_mol", ElementaryMaterialPropertyDouble( "MASS_MOL" , false ) );
            this->addDoubleProperty( "Cp", ElementaryMaterialPropertyDouble( "CP" , false ) );
            this->addFunctionProperty( "Visc", ElementaryMaterialPropertyFunction( "VISC" , false ) );
            this->addFunctionProperty( "D_visc_temp", ElementaryMaterialPropertyFunction( "D_VISC_TEMP" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ThmVapeGaz */
typedef boost::shared_ptr< ThmVapeGazMaterialBehaviourInstance > ThmVapeGazMaterialBehaviourPtr;

/**
 * @class FatigueMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Fatigue
 * @author Jean-Pierre Lefebvre
 */
class FatigueMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        FatigueMaterialBehaviourInstance()
        {
            // Mot cle "FATIGUE" dans Aster
            _asterName = "FATIGUE";

            // Parametres matériau
            this->addFunctionProperty( "Wohler", ElementaryMaterialPropertyFunction( "WOHLER" , false ) );
            this->addDoubleProperty( "A_basquin", ElementaryMaterialPropertyDouble( "A_BASQUIN" , false ) );
            this->addDoubleProperty( "Beta_basquin", ElementaryMaterialPropertyDouble( "BETA_BASQUIN" , false ) );
            this->addDoubleProperty( "A0", ElementaryMaterialPropertyDouble( "A0" , false ) );
            this->addDoubleProperty( "A1", ElementaryMaterialPropertyDouble( "A1" , false ) );
            this->addDoubleProperty( "A2", ElementaryMaterialPropertyDouble( "A2" , false ) );
            this->addDoubleProperty( "A3", ElementaryMaterialPropertyDouble( "A3" , false ) );
            this->addDoubleProperty( "Sl", ElementaryMaterialPropertyDouble( "SL" , false ) );
            this->addFunctionProperty( "Manson_coffin", ElementaryMaterialPropertyFunction( "MANSON_COFFIN" , false ) );
            this->addDoubleProperty( "E_refe", ElementaryMaterialPropertyDouble( "E_REFE" , false ) );
            this->addDoubleProperty( "D0", ElementaryMaterialPropertyDouble( "D0" , false ) );
            this->addDoubleProperty( "Tau0", ElementaryMaterialPropertyDouble( "TAU0" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Fatigue */
typedef boost::shared_ptr< FatigueMaterialBehaviourInstance > FatigueMaterialBehaviourPtr;


/**
 * @class DommaLemaitreMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau DommaLemaitre
 * @author Jean-Pierre Lefebvre
 */
class DommaLemaitreMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        DommaLemaitreMaterialBehaviourInstance()
        {
            // Mot cle "DOMMA_LEMAITRE" dans Aster
            _asterName = "DOMMA_LEMAITRE";

            // Parametres matériau
            this->addFunctionProperty( "S", ElementaryMaterialPropertyFunction( "S" , true ) );
            this->addFunctionProperty( "Epsp_seuil", ElementaryMaterialPropertyFunction( "EPSP_SEUIL" , true ) );
            this->addDoubleProperty( "Exp_s", ElementaryMaterialPropertyDouble( "EXP_S" , 1.0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau DommaLemaitre */
typedef boost::shared_ptr< DommaLemaitreMaterialBehaviourInstance > DommaLemaitreMaterialBehaviourPtr;


/**
 * @class CisaPlanCritMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau CisaPlanCrit
 * @author Jean-Pierre Lefebvre
 */
class CisaPlanCritMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        CisaPlanCritMaterialBehaviourInstance()
        {
            // Mot cle "CISA_PLAN_CRIT" dans Aster
            _asterName = "CISA_PLAN_CRIT";

            // Parametres matériau
            this->addDoubleProperty( "Critere", ElementaryMaterialPropertyDouble( "CRITERE" , true ) );
            this->addDoubleProperty( "Matake_a", ElementaryMaterialPropertyDouble( "MATAKE_A" , true ) );
            this->addDoubleProperty( "Matake_b", ElementaryMaterialPropertyDouble( "MATAKE_B" , true ) );
            this->addDoubleProperty( "Coef_flex_tors", ElementaryMaterialPropertyDouble( "COEF_FLEX_TORS" , true ) );
            this->addDoubleProperty( "D_van_a", ElementaryMaterialPropertyDouble( "D_VAN_A" , true ) );
            this->addDoubleProperty( "D_van_b", ElementaryMaterialPropertyDouble( "D_VAN_B" , true ) );
            this->addDoubleProperty( "Coef_cisa_trac", ElementaryMaterialPropertyDouble( "COEF_CISA_TRAC" , true ) );
            this->addDoubleProperty( "Fatsoc_a", ElementaryMaterialPropertyDouble( "FATSOC_A" , true ) );
            this->addDoubleProperty( "Coef_cisa_trac", ElementaryMaterialPropertyDouble( "COEF_CISA_TRAC" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau CisaPlanCrit */
typedef boost::shared_ptr< CisaPlanCritMaterialBehaviourInstance > CisaPlanCritMaterialBehaviourPtr;


/**
 * @class ThmRuptMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ThmRupt
 * @author Jean-Pierre Lefebvre
 */
class ThmRuptMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ThmRuptMaterialBehaviourInstance()
        {
            // Mot cle "THM_RUPT" dans Aster
            _asterName = "THM_RUPT";

            // Parametres matériau
            this->addDoubleProperty( "Ouv_fict", ElementaryMaterialPropertyDouble( "OUV_FICT" , true ) );
            this->addDoubleProperty( "Un_sur_n", ElementaryMaterialPropertyDouble( "UN_SUR_N" , 0. , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ThmRupt */
typedef boost::shared_ptr< ThmRuptMaterialBehaviourInstance > ThmRuptMaterialBehaviourPtr;


/**
 * @class WeibullMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Weibull
 * @author Jean-Pierre Lefebvre
 */
class WeibullMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        WeibullMaterialBehaviourInstance()
        {
            // Mot cle "WEIBULL" dans Aster
            _asterName = "WEIBULL";

            // Parametres matériau
            this->addDoubleProperty( "M", ElementaryMaterialPropertyDouble( "M" , true ) );
            this->addDoubleProperty( "Volu_refe", ElementaryMaterialPropertyDouble( "VOLU_REFE" , true ) );
            this->addDoubleProperty( "Sigm_refe", ElementaryMaterialPropertyDouble( "SIGM_REFE" , true ) );
            this->addDoubleProperty( "Seuil_epsp_cumu", ElementaryMaterialPropertyDouble( "SEUIL_EPSP_CUMU" , 1.0E-6 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Weibull */
typedef boost::shared_ptr< WeibullMaterialBehaviourInstance > WeibullMaterialBehaviourPtr;


/**
 * @class WeibullFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau WeibullFo
 * @author Jean-Pierre Lefebvre
 */
class WeibullFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        WeibullFoMaterialBehaviourInstance()
        {
            // Mot cle "WEIBULL_FO" dans Aster
            _asterName = "WEIBULL_FO";

            // Parametres matériau
            this->addDoubleProperty( "M", ElementaryMaterialPropertyDouble( "M" , true ) );
            this->addDoubleProperty( "Volu_refe", ElementaryMaterialPropertyDouble( "VOLU_REFE" , true ) );
            this->addDoubleProperty( "Sigm_cnv", ElementaryMaterialPropertyDouble( "SIGM_CNV" , true ) );
            this->addFunctionProperty( "Sigm_refe", ElementaryMaterialPropertyFunction( "SIGM_REFE" , true ) );
            this->addDoubleProperty( "Seuil_epsp_cumu", ElementaryMaterialPropertyDouble( "SEUIL_EPSP_CUMU" , 1.0E-6 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau WeibullFo */
typedef boost::shared_ptr< WeibullFoMaterialBehaviourInstance > WeibullFoMaterialBehaviourPtr;


/**
 * @class NonLocalMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau NonLocal
 * @author Jean-Pierre Lefebvre
 */
class NonLocalMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        NonLocalMaterialBehaviourInstance()
        {
            // Mot cle "NON_LOCAL" dans Aster
            _asterName = "NON_LOCAL";

            // Parametres matériau
            this->addDoubleProperty( "Long_cara", ElementaryMaterialPropertyDouble( "LONG_CARA" , false ) );
            this->addDoubleProperty( "C_grad_vari", ElementaryMaterialPropertyDouble( "C_GRAD_VARI" , false ) );
            this->addDoubleProperty( "Pena_lagr", ElementaryMaterialPropertyDouble( "PENA_LAGR" , 1.0E3 , false ) );
            this->addDoubleProperty( "C_gonf", ElementaryMaterialPropertyDouble( "C_GONF" , false ) );
            this->addDoubleProperty( "Coef_rigi_mini", ElementaryMaterialPropertyDouble( "COEF_RIGI_MINI" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau NonLocal */
typedef boost::shared_ptr< NonLocalMaterialBehaviourInstance > NonLocalMaterialBehaviourPtr;


/**
 * @class RuptFragMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau RuptFrag
 * @author Jean-Pierre Lefebvre
 */
class RuptFragMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        RuptFragMaterialBehaviourInstance()
        {
            // Mot cle "RUPT_FRAG" dans Aster
            _asterName = "RUPT_FRAG";

            // Parametres matériau
            this->addDoubleProperty( "Gc", ElementaryMaterialPropertyDouble( "GC" , true ) );
            this->addDoubleProperty( "Sigm_c", ElementaryMaterialPropertyDouble( "SIGM_C" , false ) );
            this->addDoubleProperty( "Pena_adherence", ElementaryMaterialPropertyDouble( "PENA_ADHERENCE" , false ) );
            this->addDoubleProperty( "Pena_contact", ElementaryMaterialPropertyDouble( "PENA_CONTACT" , 1. , false ) );
            this->addDoubleProperty( "Pena_lagr", ElementaryMaterialPropertyDouble( "PENA_LAGR" , 1.0E2 , false ) );
            this->addDoubleProperty( "Rigi_glis", ElementaryMaterialPropertyDouble( "RIGI_GLIS" , 1.0E1 , false ) );
            this->addDoubleProperty( "Cinematique", ElementaryMaterialPropertyDouble( "CINEMATIQUE" , 0.0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau RuptFrag */
typedef boost::shared_ptr< RuptFragMaterialBehaviourInstance > RuptFragMaterialBehaviourPtr;


/**
 * @class RuptFragFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau RuptFragFo
 * @author Jean-Pierre Lefebvre
 */
class RuptFragFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        RuptFragFoMaterialBehaviourInstance()
        {
            // Mot cle "RUPT_FRAG_FO" dans Aster
            _asterName = "RUPT_FRAG_FO";

            // Parametres matériau
            this->addFunctionProperty( "Gc", ElementaryMaterialPropertyFunction( "GC" , true ) );
            this->addFunctionProperty( "Sigm_c", ElementaryMaterialPropertyFunction( "SIGM_C" , false ) );
            this->addFunctionProperty( "Pena_adherence", ElementaryMaterialPropertyFunction( "PENA_ADHERENCE" , false ) );
            this->addDoubleProperty( "Pena_contact", ElementaryMaterialPropertyDouble( "PENA_CONTACT" , 1. , false ) );
            this->addDoubleProperty( "Pena_lagr", ElementaryMaterialPropertyDouble( "PENA_LAGR" , 1.0E2 , false ) );
            this->addDoubleProperty( "Rigi_glis", ElementaryMaterialPropertyDouble( "RIGI_GLIS" , 1.0E1 , false ) );
            this->addDoubleProperty( "Cinematique", ElementaryMaterialPropertyDouble( "CINEMATIQUE" , 0.0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau RuptFragFo */
typedef boost::shared_ptr< RuptFragFoMaterialBehaviourInstance > RuptFragFoMaterialBehaviourPtr;


/**
 * @class CzmLabMixMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau CzmLabMix
 * @author Jean-Pierre Lefebvre
 */
class CzmLabMixMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        CzmLabMixMaterialBehaviourInstance()
        {
            // Mot cle "CZM_LAB_MIX" dans Aster
            _asterName = "CZM_LAB_MIX";

            // Parametres matériau
            this->addDoubleProperty( "Sigm_c", ElementaryMaterialPropertyDouble( "SIGM_C" , true ) );
            this->addDoubleProperty( "Glis_c", ElementaryMaterialPropertyDouble( "GLIS_C" , true ) );
            this->addDoubleProperty( "Alpha", ElementaryMaterialPropertyDouble( "ALPHA" , 0.5 , false ) );
            this->addDoubleProperty( "Beta", ElementaryMaterialPropertyDouble( "BETA" , 1. , false ) );
            this->addDoubleProperty( "Pena_lagr", ElementaryMaterialPropertyDouble( "PENA_LAGR" , 100. , false ) );
            this->addDoubleProperty( "Cinematique", ElementaryMaterialPropertyDouble( "CINEMATIQUE" , 0.0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau CzmLabMix */
typedef boost::shared_ptr< CzmLabMixMaterialBehaviourInstance > CzmLabMixMaterialBehaviourPtr;


/**
 * @class RuptDuctMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau RuptDuct
 * @author Jean-Pierre Lefebvre
 */
class RuptDuctMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        RuptDuctMaterialBehaviourInstance()
        {
            // Mot cle "RUPT_DUCT" dans Aster
            _asterName = "RUPT_DUCT";

            // Parametres matériau
            this->addDoubleProperty( "Gc", ElementaryMaterialPropertyDouble( "GC" , true ) );
            this->addDoubleProperty( "Sigm_c", ElementaryMaterialPropertyDouble( "SIGM_C" , true ) );
            this->addDoubleProperty( "Coef_extr", ElementaryMaterialPropertyDouble( "COEF_EXTR" , true ) );
            this->addDoubleProperty( "Coef_plas", ElementaryMaterialPropertyDouble( "COEF_PLAS" , true ) );
            this->addDoubleProperty( "Pena_lagr", ElementaryMaterialPropertyDouble( "PENA_LAGR" , 1.0E2 , false ) );
            this->addDoubleProperty( "Rigi_glis", ElementaryMaterialPropertyDouble( "RIGI_GLIS" , 1.0E1 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau RuptDuct */
typedef boost::shared_ptr< RuptDuctMaterialBehaviourInstance > RuptDuctMaterialBehaviourPtr;


/**
 * @class JointMecaRuptMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau JointMecaRupt
 * @author Jean-Pierre Lefebvre
 */
class JointMecaRuptMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        JointMecaRuptMaterialBehaviourInstance()
        {
            // Mot cle "JOINT_MECA_RUPT" dans Aster
            _asterName = "JOINT_MECA_RUPT";

            // Parametres matériau
            this->addDoubleProperty( "K_n", ElementaryMaterialPropertyDouble( "K_N" , true ) );
            this->addDoubleProperty( "K_t", ElementaryMaterialPropertyDouble( "K_T" , false ) );
            this->addDoubleProperty( "Sigm_max", ElementaryMaterialPropertyDouble( "SIGM_MAX" , true ) );
            this->addDoubleProperty( "Alpha", ElementaryMaterialPropertyDouble( "ALPHA" , 1. , false ) );
            this->addDoubleProperty( "Pena_rupture", ElementaryMaterialPropertyDouble( "PENA_RUPTURE" , false ) );
            this->addDoubleProperty( "Pena_contact", ElementaryMaterialPropertyDouble( "PENA_CONTACT" , 1. , false ) );
            this->addFunctionProperty( "Pres_fluide", ElementaryMaterialPropertyFunction( "PRES_FLUIDE" , false ) );
            this->addFunctionProperty( "Pres_clavage", ElementaryMaterialPropertyFunction( "PRES_CLAVAGE" , false ) );
            this->addFunctionProperty( "Sciage", ElementaryMaterialPropertyFunction( "SCIAGE" , false ) );
            this->addDoubleProperty( "Rho_fluide", ElementaryMaterialPropertyDouble( "RHO_FLUIDE" , false ) );
            this->addDoubleProperty( "Visc_fluide", ElementaryMaterialPropertyDouble( "VISC_FLUIDE" , false ) );
            this->addDoubleProperty( "Ouv_min", ElementaryMaterialPropertyDouble( "OUV_MIN" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau JointMecaRupt */
typedef boost::shared_ptr< JointMecaRuptMaterialBehaviourInstance > JointMecaRuptMaterialBehaviourPtr;


/**
 * @class JointMecaFrotMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau JointMecaFrot
 * @author Jean-Pierre Lefebvre
 */
class JointMecaFrotMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        JointMecaFrotMaterialBehaviourInstance()
        {
            // Mot cle "JOINT_MECA_FROT" dans Aster
            _asterName = "JOINT_MECA_FROT";

            // Parametres matériau
            this->addDoubleProperty( "K_n", ElementaryMaterialPropertyDouble( "K_N" , true ) );
            this->addDoubleProperty( "K_t", ElementaryMaterialPropertyDouble( "K_T" , false ) );
            this->addDoubleProperty( "Amor_nor", ElementaryMaterialPropertyDouble( "AMOR_NOR" , false ) );
            this->addDoubleProperty( "Amor_tan", ElementaryMaterialPropertyDouble( "AMOR_TAN" , false ) );
            this->addDoubleProperty( "Coef_amor", ElementaryMaterialPropertyDouble( "COEF_AMOR" , false ) );
            this->addDoubleProperty( "Mu", ElementaryMaterialPropertyDouble( "MU" , true ) );
            this->addDoubleProperty( "Pena_tang", ElementaryMaterialPropertyDouble( "PENA_TANG" , false ) );
            this->addDoubleProperty( "Adhesion", ElementaryMaterialPropertyDouble( "ADHESION" , 0. , false ) );
            this->addFunctionProperty( "Pres_fluide", ElementaryMaterialPropertyFunction( "PRES_FLUIDE" , false ) );
            this->addFunctionProperty( "Sciage", ElementaryMaterialPropertyFunction( "SCIAGE" , false ) );
            this->addDoubleProperty( "Rho_fluide", ElementaryMaterialPropertyDouble( "RHO_FLUIDE" , false ) );
            this->addDoubleProperty( "Visc_fluide", ElementaryMaterialPropertyDouble( "VISC_FLUIDE" , false ) );
            this->addDoubleProperty( "Ouv_min", ElementaryMaterialPropertyDouble( "OUV_MIN" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau JointMecaFrot */
typedef boost::shared_ptr< JointMecaFrotMaterialBehaviourInstance > JointMecaFrotMaterialBehaviourPtr;


/**
 * @class RccmMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Rccm
 * @author Jean-Pierre Lefebvre
 */
class RccmMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        RccmMaterialBehaviourInstance()
        {
            // Mot cle "RCCM" dans Aster
            _asterName = "RCCM";

            // Parametres matériau
            this->addDoubleProperty( "Sy_02", ElementaryMaterialPropertyDouble( "SY_02" , false ) );
            this->addDoubleProperty( "Sm", ElementaryMaterialPropertyDouble( "SM" , false ) );
            this->addDoubleProperty( "Su", ElementaryMaterialPropertyDouble( "SU" , false ) );
            this->addDoubleProperty( "Sc", ElementaryMaterialPropertyDouble( "SC" , false ) );
            this->addDoubleProperty( "Sh", ElementaryMaterialPropertyDouble( "SH" , false ) );
            this->addDoubleProperty( "N_ke", ElementaryMaterialPropertyDouble( "N_KE" , false ) );
            this->addDoubleProperty( "M_ke", ElementaryMaterialPropertyDouble( "M_KE" , false ) );
            this->addDoubleProperty( "A_amorc", ElementaryMaterialPropertyDouble( "A_AMORC" , false ) );
            this->addDoubleProperty( "B_amorc", ElementaryMaterialPropertyDouble( "B_AMORC" , false ) );
            this->addDoubleProperty( "D_amorc", ElementaryMaterialPropertyDouble( "D_AMORC" , false ) );
            this->addDoubleProperty( "R_amorc", ElementaryMaterialPropertyDouble( "R_AMORC" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Rccm */
typedef boost::shared_ptr< RccmMaterialBehaviourInstance > RccmMaterialBehaviourPtr;


/**
 * @class RccmFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau RccmFo
 * @author Jean-Pierre Lefebvre
 */
class RccmFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        RccmFoMaterialBehaviourInstance()
        {
            // Mot cle "RCCM_FO" dans Aster
            _asterName = "RCCM_FO";

            // Parametres matériau
            this->addFunctionProperty( "Sy_02", ElementaryMaterialPropertyFunction( "SY_02" , false ) );
            this->addFunctionProperty( "Sm", ElementaryMaterialPropertyFunction( "SM" , false ) );
            this->addFunctionProperty( "Su", ElementaryMaterialPropertyFunction( "SU" , false ) );
            this->addFunctionProperty( "S", ElementaryMaterialPropertyFunction( "S" , false ) );
            this->addFunctionProperty( "N_ke", ElementaryMaterialPropertyFunction( "N_KE" , false ) );
            this->addFunctionProperty( "M_ke", ElementaryMaterialPropertyFunction( "M_KE" , false ) );
            this->addFunctionProperty( "A_amorc", ElementaryMaterialPropertyFunction( "A_AMORC" , false ) );
            this->addFunctionProperty( "B_amorc", ElementaryMaterialPropertyFunction( "B_AMORC" , false ) );
            this->addDoubleProperty( "D_amorc", ElementaryMaterialPropertyDouble( "D_AMORC" , false ) );
            this->addFunctionProperty( "R_amorc", ElementaryMaterialPropertyFunction( "R_AMORC" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau RccmFo */
typedef boost::shared_ptr< RccmFoMaterialBehaviourInstance > RccmFoMaterialBehaviourPtr;


/**
 * @class LaigleMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Laigle
 * @author Jean-Pierre Lefebvre
 */
class LaigleMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        LaigleMaterialBehaviourInstance()
        {
            // Mot cle "LAIGLE" dans Aster
            _asterName = "LAIGLE";

            // Parametres matériau
            this->addDoubleProperty( "Gamma_ult", ElementaryMaterialPropertyDouble( "GAMMA_ULT" , true ) );
            this->addDoubleProperty( "Gamma_e", ElementaryMaterialPropertyDouble( "GAMMA_E" , true ) );
            this->addDoubleProperty( "M_ult", ElementaryMaterialPropertyDouble( "M_ULT" , true ) );
            this->addDoubleProperty( "M_e", ElementaryMaterialPropertyDouble( "M_E" , true ) );
            this->addDoubleProperty( "A_e", ElementaryMaterialPropertyDouble( "A_E" , true ) );
            this->addDoubleProperty( "M_pic", ElementaryMaterialPropertyDouble( "M_PIC" , true ) );
            this->addDoubleProperty( "A_pic", ElementaryMaterialPropertyDouble( "A_PIC" , true ) );
            this->addDoubleProperty( "Eta", ElementaryMaterialPropertyDouble( "ETA" , true ) );
            this->addDoubleProperty( "Sigma_c", ElementaryMaterialPropertyDouble( "SIGMA_C" , true ) );
            this->addDoubleProperty( "Gamma", ElementaryMaterialPropertyDouble( "GAMMA" , true ) );
            this->addDoubleProperty( "Ksi", ElementaryMaterialPropertyDouble( "KSI" , true ) );
            this->addDoubleProperty( "Gamma_cjs", ElementaryMaterialPropertyDouble( "GAMMA_CJS" , true ) );
            this->addDoubleProperty( "Sigma_p1", ElementaryMaterialPropertyDouble( "SIGMA_P1" , true ) );
            this->addDoubleProperty( "Pa", ElementaryMaterialPropertyDouble( "PA" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Laigle */
typedef boost::shared_ptr< LaigleMaterialBehaviourInstance > LaigleMaterialBehaviourPtr;


/**
 * @class LetkMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Letk
 * @author Jean-Pierre Lefebvre
 */
class LetkMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        LetkMaterialBehaviourInstance()
        {
            // Mot cle "LETK" dans Aster
            _asterName = "LETK";

            // Parametres matériau
            this->addDoubleProperty( "Pa", ElementaryMaterialPropertyDouble( "PA" , true ) );
            this->addDoubleProperty( "Nelas", ElementaryMaterialPropertyDouble( "NELAS" , true ) );
            this->addDoubleProperty( "Sigma_c", ElementaryMaterialPropertyDouble( "SIGMA_C" , true ) );
            this->addDoubleProperty( "H0_ext", ElementaryMaterialPropertyDouble( "H0_EXT" , true ) );
            this->addDoubleProperty( "Gamma_cjs", ElementaryMaterialPropertyDouble( "GAMMA_CJS" , true ) );
            this->addDoubleProperty( "Xams", ElementaryMaterialPropertyDouble( "XAMS" , true ) );
            this->addDoubleProperty( "Eta", ElementaryMaterialPropertyDouble( "ETA" , true ) );
            this->addDoubleProperty( "A_0", ElementaryMaterialPropertyDouble( "A_0" , true ) );
            this->addDoubleProperty( "A_e", ElementaryMaterialPropertyDouble( "A_E" , true ) );
            this->addDoubleProperty( "A_pic", ElementaryMaterialPropertyDouble( "A_PIC" , true ) );
            this->addDoubleProperty( "S_0", ElementaryMaterialPropertyDouble( "S_0" , true ) );
            this->addDoubleProperty( "M_0", ElementaryMaterialPropertyDouble( "M_0" , true ) );
            this->addDoubleProperty( "M_e", ElementaryMaterialPropertyDouble( "M_E" , true ) );
            this->addDoubleProperty( "M_pic", ElementaryMaterialPropertyDouble( "M_PIC" , true ) );
            this->addDoubleProperty( "M_ult", ElementaryMaterialPropertyDouble( "M_ULT" , true ) );
            this->addDoubleProperty( "Xi_ult", ElementaryMaterialPropertyDouble( "XI_ULT" , true ) );
            this->addDoubleProperty( "Xi_e", ElementaryMaterialPropertyDouble( "XI_E" , true ) );
            this->addDoubleProperty( "Xi_pic", ElementaryMaterialPropertyDouble( "XI_PIC" , true ) );
            this->addDoubleProperty( "Mv_max", ElementaryMaterialPropertyDouble( "MV_MAX" , true ) );
            this->addDoubleProperty( "Xiv_max", ElementaryMaterialPropertyDouble( "XIV_MAX" , true ) );
            this->addDoubleProperty( "A", ElementaryMaterialPropertyDouble( "A" , true ) );
            this->addDoubleProperty( "N", ElementaryMaterialPropertyDouble( "N" , true ) );
            this->addDoubleProperty( "Sigma_p1", ElementaryMaterialPropertyDouble( "SIGMA_P1" , true ) );
            this->addDoubleProperty( "Mu0_v", ElementaryMaterialPropertyDouble( "MU0_V" , true ) );
            this->addDoubleProperty( "Xi0_v", ElementaryMaterialPropertyDouble( "XI0_V" , true ) );
            this->addDoubleProperty( "Mu1", ElementaryMaterialPropertyDouble( "MU1" , true ) );
            this->addDoubleProperty( "Xi1", ElementaryMaterialPropertyDouble( "XI1" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Letk */
typedef boost::shared_ptr< LetkMaterialBehaviourInstance > LetkMaterialBehaviourPtr;


/**
 * @class DruckPragerMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau DruckPrager
 * @author Jean-Pierre Lefebvre
 */
class DruckPragerMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        DruckPragerMaterialBehaviourInstance()
        {
            // Mot cle "DRUCK_PRAGER" dans Aster
            _asterName = "DRUCK_PRAGER";

            // Parametres matériau
            this->addDoubleProperty( "Alpha", ElementaryMaterialPropertyDouble( "ALPHA" , true ) );
            this->addDoubleProperty( "Sy", ElementaryMaterialPropertyDouble( "SY" , true ) );
            this->addDoubleProperty( "P_ultm", ElementaryMaterialPropertyDouble( "P_ULTM" , true ) );
            this->addDoubleProperty( "Ecrouissage", ElementaryMaterialPropertyDouble( "ECROUISSAGE" , true ) );
            this->addDoubleProperty( "H", ElementaryMaterialPropertyDouble( "H" , true ) );
            this->addDoubleProperty( "Type_dp", ElementaryMaterialPropertyDouble( "TYPE_DP" , 1.0 , false ) );
            this->addDoubleProperty( "Sy_ultm", ElementaryMaterialPropertyDouble( "SY_ULTM" , true ) );
            this->addDoubleProperty( "Type_dp", ElementaryMaterialPropertyDouble( "TYPE_DP" , 2.0 , false ) );
            this->addDoubleProperty( "Dilat", ElementaryMaterialPropertyDouble( "DILAT" , 0.0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau DruckPrager */
typedef boost::shared_ptr< DruckPragerMaterialBehaviourInstance > DruckPragerMaterialBehaviourPtr;


/**
 * @class DruckPragerFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau DruckPragerFo
 * @author Jean-Pierre Lefebvre
 */
class DruckPragerFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        DruckPragerFoMaterialBehaviourInstance()
        {
            // Mot cle "DRUCK_PRAGER_FO" dans Aster
            _asterName = "DRUCK_PRAGER_FO";

            // Parametres matériau
            this->addFunctionProperty( "Alpha", ElementaryMaterialPropertyFunction( "ALPHA" , true ) );
            this->addFunctionProperty( "Sy", ElementaryMaterialPropertyFunction( "SY" , true ) );
            this->addFunctionProperty( "P_ultm", ElementaryMaterialPropertyFunction( "P_ULTM" , true ) );
            this->addDoubleProperty( "Ecrouissage", ElementaryMaterialPropertyDouble( "ECROUISSAGE" , true ) );
            this->addFunctionProperty( "H", ElementaryMaterialPropertyFunction( "H" , true ) );
            this->addDoubleProperty( "Type_dp", ElementaryMaterialPropertyDouble( "TYPE_DP" , 1.0 , false ) );
            this->addFunctionProperty( "Sy_ultm", ElementaryMaterialPropertyFunction( "SY_ULTM" , true ) );
            this->addDoubleProperty( "Type_dp", ElementaryMaterialPropertyDouble( "TYPE_DP" , 2.0 , false ) );
            this->addDoubleProperty( "Dilat", ElementaryMaterialPropertyDouble( "DILAT" , 0.0 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau DruckPragerFo */
typedef boost::shared_ptr< DruckPragerFoMaterialBehaviourInstance > DruckPragerFoMaterialBehaviourPtr;


/**
 * @class ViscDrucPragMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ViscDrucPrag
 * @author Jean-Pierre Lefebvre
 */
class ViscDrucPragMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ViscDrucPragMaterialBehaviourInstance()
        {
            // Mot cle "VISC_DRUC_PRAG" dans Aster
            _asterName = "VISC_DRUC_PRAG";

            // Parametres matériau
            this->addDoubleProperty( "Pref", ElementaryMaterialPropertyDouble( "PREF" , true ) );
            this->addDoubleProperty( "A", ElementaryMaterialPropertyDouble( "A" , true ) );
            this->addDoubleProperty( "N", ElementaryMaterialPropertyDouble( "N" , true ) );
            this->addDoubleProperty( "P_pic", ElementaryMaterialPropertyDouble( "P_PIC" , true ) );
            this->addDoubleProperty( "P_ult", ElementaryMaterialPropertyDouble( "P_ULT" , true ) );
            this->addDoubleProperty( "Alpha_0", ElementaryMaterialPropertyDouble( "ALPHA_0" , true ) );
            this->addDoubleProperty( "Alpha_pic", ElementaryMaterialPropertyDouble( "ALPHA_PIC" , true ) );
            this->addDoubleProperty( "Alpha_ult", ElementaryMaterialPropertyDouble( "ALPHA_ULT" , true ) );
            this->addDoubleProperty( "R_0", ElementaryMaterialPropertyDouble( "R_0" , true ) );
            this->addDoubleProperty( "R_pic", ElementaryMaterialPropertyDouble( "R_PIC" , true ) );
            this->addDoubleProperty( "R_ult", ElementaryMaterialPropertyDouble( "R_ULT" , true ) );
            this->addDoubleProperty( "Beta_0", ElementaryMaterialPropertyDouble( "BETA_0" , true ) );
            this->addDoubleProperty( "Beta_pic", ElementaryMaterialPropertyDouble( "BETA_PIC" , true ) );
            this->addDoubleProperty( "Beta_ult", ElementaryMaterialPropertyDouble( "BETA_ULT" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ViscDrucPrag */
typedef boost::shared_ptr< ViscDrucPragMaterialBehaviourInstance > ViscDrucPragMaterialBehaviourPtr;


/**
 * @class HoekBrownMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau HoekBrown
 * @author Jean-Pierre Lefebvre
 */
class HoekBrownMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        HoekBrownMaterialBehaviourInstance()
        {
            // Mot cle "HOEK_BROWN" dans Aster
            _asterName = "HOEK_BROWN";

            // Parametres matériau
            this->addDoubleProperty( "Gamma_rup", ElementaryMaterialPropertyDouble( "GAMMA_RUP" , true ) );
            this->addDoubleProperty( "Gamma_res", ElementaryMaterialPropertyDouble( "GAMMA_RES" , true ) );
            this->addDoubleProperty( "S_end", ElementaryMaterialPropertyDouble( "S_END" , true ) );
            this->addDoubleProperty( "S_rup", ElementaryMaterialPropertyDouble( "S_RUP" , true ) );
            this->addDoubleProperty( "M_end", ElementaryMaterialPropertyDouble( "M_END" , true ) );
            this->addDoubleProperty( "M_rup", ElementaryMaterialPropertyDouble( "M_RUP" , true ) );
            this->addDoubleProperty( "Beta", ElementaryMaterialPropertyDouble( "BETA" , true ) );
            this->addDoubleProperty( "Alphahb", ElementaryMaterialPropertyDouble( "ALPHAHB" , true ) );
            this->addDoubleProperty( "Phi_rup", ElementaryMaterialPropertyDouble( "PHI_RUP" , true ) );
            this->addDoubleProperty( "Phi_res", ElementaryMaterialPropertyDouble( "PHI_RES" , true ) );
            this->addDoubleProperty( "Phi_end", ElementaryMaterialPropertyDouble( "PHI_END" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau HoekBrown */
typedef boost::shared_ptr< HoekBrownMaterialBehaviourInstance > HoekBrownMaterialBehaviourPtr;


/**
 * @class ElasGonfMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau ElasGonf
 * @author Jean-Pierre Lefebvre
 */
class ElasGonfMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        ElasGonfMaterialBehaviourInstance()
        {
            // Mot cle "ELAS_GONF" dans Aster
            _asterName = "ELAS_GONF";

            // Parametres matériau
            this->addDoubleProperty( "Betam", ElementaryMaterialPropertyDouble( "BETAM" , true ) );
            this->addDoubleProperty( "Pref", ElementaryMaterialPropertyDouble( "PREF" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasGonf */
typedef boost::shared_ptr< ElasGonfMaterialBehaviourInstance > ElasGonfMaterialBehaviourPtr;


/**
 * @class JointBandisMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau JointBandis
 * @author Jean-Pierre Lefebvre
 */
class JointBandisMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        JointBandisMaterialBehaviourInstance()
        {
            // Mot cle "JOINT_BANDIS" dans Aster
            _asterName = "JOINT_BANDIS";

            // Parametres matériau
            this->addDoubleProperty( "K", ElementaryMaterialPropertyDouble( "K" , true ) );
            this->addDoubleProperty( "Dmax", ElementaryMaterialPropertyDouble( "DMAX" , true ) );
            this->addDoubleProperty( "Gamma", ElementaryMaterialPropertyDouble( "GAMMA" , true ) );
            this->addDoubleProperty( "Kt", ElementaryMaterialPropertyDouble( "KT" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau JointBandis */
typedef boost::shared_ptr< JointBandisMaterialBehaviourInstance > JointBandisMaterialBehaviourPtr;


/**
 * @class MonoVisc1MaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MonoVisc1
 * @author Jean-Pierre Lefebvre
 */
class MonoVisc1MaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MonoVisc1MaterialBehaviourInstance()
        {
            // Mot cle "MONO_VISC1" dans Aster
            _asterName = "MONO_VISC1";

            // Parametres matériau
            this->addDoubleProperty( "Type_para", ElementaryMaterialPropertyDouble( "TYPE_PARA" , false ) );
            this->addDoubleProperty( "N", ElementaryMaterialPropertyDouble( "N" , true ) );
            this->addDoubleProperty( "K", ElementaryMaterialPropertyDouble( "K" , true ) );
            this->addDoubleProperty( "C", ElementaryMaterialPropertyDouble( "C" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MonoVisc1 */
typedef boost::shared_ptr< MonoVisc1MaterialBehaviourInstance > MonoVisc1MaterialBehaviourPtr;


/**
 * @class MonoVisc2MaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MonoVisc2
 * @author Jean-Pierre Lefebvre
 */
class MonoVisc2MaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MonoVisc2MaterialBehaviourInstance()
        {
            // Mot cle "MONO_VISC2" dans Aster
            _asterName = "MONO_VISC2";

            // Parametres matériau
            this->addDoubleProperty( "Type_para", ElementaryMaterialPropertyDouble( "TYPE_PARA" , false ) );
            this->addDoubleProperty( "N", ElementaryMaterialPropertyDouble( "N" , true ) );
            this->addDoubleProperty( "K", ElementaryMaterialPropertyDouble( "K" , true ) );
            this->addDoubleProperty( "C", ElementaryMaterialPropertyDouble( "C" , true ) );
            this->addDoubleProperty( "D", ElementaryMaterialPropertyDouble( "D" , true ) );
            this->addDoubleProperty( "A", ElementaryMaterialPropertyDouble( "A" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MonoVisc2 */
typedef boost::shared_ptr< MonoVisc2MaterialBehaviourInstance > MonoVisc2MaterialBehaviourPtr;


/**
 * @class MonoIsot1MaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MonoIsot1
 * @author Jean-Pierre Lefebvre
 */
class MonoIsot1MaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MonoIsot1MaterialBehaviourInstance()
        {
            // Mot cle "MONO_ISOT1" dans Aster
            _asterName = "MONO_ISOT1";

            // Parametres matériau
            this->addDoubleProperty( "Type_para", ElementaryMaterialPropertyDouble( "TYPE_PARA" , false ) );
            this->addDoubleProperty( "R_0", ElementaryMaterialPropertyDouble( "R_0" , true ) );
            this->addDoubleProperty( "Q", ElementaryMaterialPropertyDouble( "Q" , true ) );
            this->addDoubleProperty( "B", ElementaryMaterialPropertyDouble( "B" , true ) );
            this->addDoubleProperty( "H", ElementaryMaterialPropertyDouble( "H" , false ) );
            this->addDoubleProperty( "H1", ElementaryMaterialPropertyDouble( "H1" , false ) );
            this->addDoubleProperty( "H2", ElementaryMaterialPropertyDouble( "H2" , false ) );
            this->addDoubleProperty( "H3", ElementaryMaterialPropertyDouble( "H3" , false ) );
            this->addDoubleProperty( "H4", ElementaryMaterialPropertyDouble( "H4" , false ) );
            this->addDoubleProperty( "H5", ElementaryMaterialPropertyDouble( "H5" , false ) );
            this->addDoubleProperty( "H6", ElementaryMaterialPropertyDouble( "H6" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MonoIsot1 */
typedef boost::shared_ptr< MonoIsot1MaterialBehaviourInstance > MonoIsot1MaterialBehaviourPtr;


/**
 * @class MonoIsot2MaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MonoIsot2
 * @author Jean-Pierre Lefebvre
 */
class MonoIsot2MaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MonoIsot2MaterialBehaviourInstance()
        {
            // Mot cle "MONO_ISOT2" dans Aster
            _asterName = "MONO_ISOT2";

            // Parametres matériau
            this->addDoubleProperty( "Type_para", ElementaryMaterialPropertyDouble( "TYPE_PARA" , false ) );
            this->addDoubleProperty( "R_0", ElementaryMaterialPropertyDouble( "R_0" , true ) );
            this->addDoubleProperty( "Q1", ElementaryMaterialPropertyDouble( "Q1" , true ) );
            this->addDoubleProperty( "B1", ElementaryMaterialPropertyDouble( "B1" , true ) );
            this->addDoubleProperty( "H", ElementaryMaterialPropertyDouble( "H" , false ) );
            this->addDoubleProperty( "H1", ElementaryMaterialPropertyDouble( "H1" , false ) );
            this->addDoubleProperty( "H2", ElementaryMaterialPropertyDouble( "H2" , false ) );
            this->addDoubleProperty( "H3", ElementaryMaterialPropertyDouble( "H3" , false ) );
            this->addDoubleProperty( "H4", ElementaryMaterialPropertyDouble( "H4" , false ) );
            this->addDoubleProperty( "H5", ElementaryMaterialPropertyDouble( "H5" , false ) );
            this->addDoubleProperty( "H6", ElementaryMaterialPropertyDouble( "H6" , false ) );
            this->addDoubleProperty( "Q2", ElementaryMaterialPropertyDouble( "Q2" , true ) );
            this->addDoubleProperty( "B2", ElementaryMaterialPropertyDouble( "B2" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MonoIsot2 */
typedef boost::shared_ptr< MonoIsot2MaterialBehaviourInstance > MonoIsot2MaterialBehaviourPtr;


/**
 * @class MonoCine1MaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MonoCine1
 * @author Jean-Pierre Lefebvre
 */
class MonoCine1MaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MonoCine1MaterialBehaviourInstance()
        {
            // Mot cle "MONO_CINE1" dans Aster
            _asterName = "MONO_CINE1";

            // Parametres matériau
            this->addDoubleProperty( "Type_para", ElementaryMaterialPropertyDouble( "TYPE_PARA" , false ) );
            this->addDoubleProperty( "D", ElementaryMaterialPropertyDouble( "D" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MonoCine1 */
typedef boost::shared_ptr< MonoCine1MaterialBehaviourInstance > MonoCine1MaterialBehaviourPtr;


/**
 * @class MonoCine2MaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MonoCine2
 * @author Jean-Pierre Lefebvre
 */
class MonoCine2MaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MonoCine2MaterialBehaviourInstance()
        {
            // Mot cle "MONO_CINE2" dans Aster
            _asterName = "MONO_CINE2";

            // Parametres matériau
            this->addDoubleProperty( "Type_para", ElementaryMaterialPropertyDouble( "TYPE_PARA" , false ) );
            this->addDoubleProperty( "D", ElementaryMaterialPropertyDouble( "D" , true ) );
            this->addDoubleProperty( "Gm", ElementaryMaterialPropertyDouble( "GM" , true ) );
            this->addDoubleProperty( "Pm", ElementaryMaterialPropertyDouble( "PM" , true ) );
            this->addDoubleProperty( "C", ElementaryMaterialPropertyDouble( "C" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MonoCine2 */
typedef boost::shared_ptr< MonoCine2MaterialBehaviourInstance > MonoCine2MaterialBehaviourPtr;


/**
 * @class MonoDdKrMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MonoDdKr
 * @author Jean-Pierre Lefebvre
 */
class MonoDdKrMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MonoDdKrMaterialBehaviourInstance()
        {
            // Mot cle "MONO_DD_KR" dans Aster
            _asterName = "MONO_DD_KR";

            // Parametres matériau
            this->addDoubleProperty( "K", ElementaryMaterialPropertyDouble( "K" , true ) );
            this->addDoubleProperty( "Taur", ElementaryMaterialPropertyDouble( "TAUR" , true ) );
            this->addDoubleProperty( "Tau0", ElementaryMaterialPropertyDouble( "TAU0" , true ) );
            this->addDoubleProperty( "Gamma0", ElementaryMaterialPropertyDouble( "GAMMA0" , true ) );
            this->addDoubleProperty( "Deltag0", ElementaryMaterialPropertyDouble( "DELTAG0" , true ) );
            this->addDoubleProperty( "Bsd", ElementaryMaterialPropertyDouble( "BSD" , true ) );
            this->addDoubleProperty( "Gcb", ElementaryMaterialPropertyDouble( "GCB" , true ) );
            this->addDoubleProperty( "Kdcs", ElementaryMaterialPropertyDouble( "KDCS" , true ) );
            this->addDoubleProperty( "P", ElementaryMaterialPropertyDouble( "P" , true ) );
            this->addDoubleProperty( "Q", ElementaryMaterialPropertyDouble( "Q" , true ) );
            this->addDoubleProperty( "H", ElementaryMaterialPropertyDouble( "H" , false ) );
            this->addDoubleProperty( "H1", ElementaryMaterialPropertyDouble( "H1" , false ) );
            this->addDoubleProperty( "H2", ElementaryMaterialPropertyDouble( "H2" , false ) );
            this->addDoubleProperty( "H3", ElementaryMaterialPropertyDouble( "H3" , false ) );
            this->addDoubleProperty( "H4", ElementaryMaterialPropertyDouble( "H4" , false ) );
            this->addDoubleProperty( "H5", ElementaryMaterialPropertyDouble( "H5" , false ) );
            this->addDoubleProperty( "H6", ElementaryMaterialPropertyDouble( "H6" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MonoDdKr */
typedef boost::shared_ptr< MonoDdKrMaterialBehaviourInstance > MonoDdKrMaterialBehaviourPtr;


/**
 * @class MonoDdCfcMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MonoDdCfc
 * @author Jean-Pierre Lefebvre
 */
class MonoDdCfcMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MonoDdCfcMaterialBehaviourInstance()
        {
            // Mot cle "MONO_DD_CFC" dans Aster
            _asterName = "MONO_DD_CFC";

            // Parametres matériau
            this->addDoubleProperty( "Gamma0", ElementaryMaterialPropertyDouble( "GAMMA0" , 0.001 , false ) );
            this->addDoubleProperty( "Tau_f", ElementaryMaterialPropertyDouble( "TAU_F" , true ) );
            this->addDoubleProperty( "A", ElementaryMaterialPropertyDouble( "A" , 0.13 , false ) );
            this->addDoubleProperty( "B", ElementaryMaterialPropertyDouble( "B" , 0.005 , false ) );
            this->addDoubleProperty( "N", ElementaryMaterialPropertyDouble( "N" , 200. , false ) );
            this->addDoubleProperty( "Y", ElementaryMaterialPropertyDouble( "Y" , true ) );
            this->addDoubleProperty( "Alpha", ElementaryMaterialPropertyDouble( "ALPHA" , 0.35 , false ) );
            this->addDoubleProperty( "Beta", ElementaryMaterialPropertyDouble( "BETA" , true ) );
            this->addDoubleProperty( "Rho_ref", ElementaryMaterialPropertyDouble( "RHO_REF" , true ) );
            this->addDoubleProperty( "H", ElementaryMaterialPropertyDouble( "H" , false ) );
            this->addDoubleProperty( "H1", ElementaryMaterialPropertyDouble( "H1" , 0.124 , false ) );
            this->addDoubleProperty( "H2", ElementaryMaterialPropertyDouble( "H2" , 0.625 , false ) );
            this->addDoubleProperty( "H3", ElementaryMaterialPropertyDouble( "H3" , 0.137 , false ) );
            this->addDoubleProperty( "H4", ElementaryMaterialPropertyDouble( "H4" , 0.122 , false ) );
            this->addDoubleProperty( "H5", ElementaryMaterialPropertyDouble( "H5" , 0.07 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MonoDdCfc */
typedef boost::shared_ptr< MonoDdCfcMaterialBehaviourInstance > MonoDdCfcMaterialBehaviourPtr;


/**
 * @class MonoDdCfcIrraMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MonoDdCfcIrra
 * @author Jean-Pierre Lefebvre
 */
class MonoDdCfcIrraMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MonoDdCfcIrraMaterialBehaviourInstance()
        {
            // Mot cle "MONO_DD_CFC_IRRA" dans Aster
            _asterName = "MONO_DD_CFC_IRRA";

            // Parametres matériau
            this->addDoubleProperty( "Gamma0", ElementaryMaterialPropertyDouble( "GAMMA0" , 0.001 , false ) );
            this->addDoubleProperty( "Tau_f", ElementaryMaterialPropertyDouble( "TAU_F" , true ) );
            this->addDoubleProperty( "A", ElementaryMaterialPropertyDouble( "A" , 0.13 , false ) );
            this->addDoubleProperty( "B", ElementaryMaterialPropertyDouble( "B" , 0.005 , false ) );
            this->addDoubleProperty( "N", ElementaryMaterialPropertyDouble( "N" , 200. , false ) );
            this->addDoubleProperty( "Y", ElementaryMaterialPropertyDouble( "Y" , true ) );
            this->addDoubleProperty( "Alpha", ElementaryMaterialPropertyDouble( "ALPHA" , 0.35 , false ) );
            this->addDoubleProperty( "Beta", ElementaryMaterialPropertyDouble( "BETA" , true ) );
            this->addDoubleProperty( "Rho_ref", ElementaryMaterialPropertyDouble( "RHO_REF" , true ) );
            this->addDoubleProperty( "H", ElementaryMaterialPropertyDouble( "H" , false ) );
            this->addDoubleProperty( "H1", ElementaryMaterialPropertyDouble( "H1" , 0.124 , false ) );
            this->addDoubleProperty( "H2", ElementaryMaterialPropertyDouble( "H2" , 0.625 , false ) );
            this->addDoubleProperty( "H3", ElementaryMaterialPropertyDouble( "H3" , 0.137 , false ) );
            this->addDoubleProperty( "H4", ElementaryMaterialPropertyDouble( "H4" , 0.122 , false ) );
            this->addDoubleProperty( "H5", ElementaryMaterialPropertyDouble( "H5" , 0.07 , false ) );
            this->addDoubleProperty( "Dz_irra", ElementaryMaterialPropertyDouble( "DZ_IRRA" , true ) );
            this->addDoubleProperty( "Xi_irra", ElementaryMaterialPropertyDouble( "XI_IRRA" , true ) );
            this->addDoubleProperty( "Rho_void", ElementaryMaterialPropertyDouble( "RHO_VOID" , true ) );
            this->addDoubleProperty( "Phi_loop", ElementaryMaterialPropertyDouble( "PHI_LOOP" , true ) );
            this->addDoubleProperty( "Alp_void", ElementaryMaterialPropertyDouble( "ALP_VOID" , true ) );
            this->addDoubleProperty( "Alp_loop", ElementaryMaterialPropertyDouble( "ALP_LOOP" , true ) );
            this->addDoubleProperty( "Rho_sat", ElementaryMaterialPropertyDouble( "RHO_SAT" , true ) );
            this->addDoubleProperty( "Phi_sat", ElementaryMaterialPropertyDouble( "PHI_SAT" , true ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MonoDdCfcIrra */
typedef boost::shared_ptr< MonoDdCfcIrraMaterialBehaviourInstance > MonoDdCfcIrraMaterialBehaviourPtr;


/**
 * @class MonoDdFatMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MonoDdFat
 * @author Jean-Pierre Lefebvre
 */
class MonoDdFatMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MonoDdFatMaterialBehaviourInstance()
        {
            // Mot cle "MONO_DD_FAT" dans Aster
            _asterName = "MONO_DD_FAT";

            // Parametres matériau
            this->addDoubleProperty( "Gamma0", ElementaryMaterialPropertyDouble( "GAMMA0" , true ) );
            this->addDoubleProperty( "Tau_f", ElementaryMaterialPropertyDouble( "TAU_F" , true ) );
            this->addDoubleProperty( "Beta", ElementaryMaterialPropertyDouble( "BETA" , true ) );
            this->addDoubleProperty( "N", ElementaryMaterialPropertyDouble( "N" , true ) );
            this->addDoubleProperty( "Un_sur_d", ElementaryMaterialPropertyDouble( "UN_SUR_D" , true ) );
            this->addDoubleProperty( "Gc0", ElementaryMaterialPropertyDouble( "GC0" , true ) );
            this->addDoubleProperty( "K", ElementaryMaterialPropertyDouble( "K" , true ) );
            this->addDoubleProperty( "H", ElementaryMaterialPropertyDouble( "H" , false ) );
            this->addDoubleProperty( "H1", ElementaryMaterialPropertyDouble( "H1" , 0.124 , false ) );
            this->addDoubleProperty( "H2", ElementaryMaterialPropertyDouble( "H2" , 0.625 , false ) );
            this->addDoubleProperty( "H3", ElementaryMaterialPropertyDouble( "H3" , 0.137 , false ) );
            this->addDoubleProperty( "H4", ElementaryMaterialPropertyDouble( "H4" , 0.122 , false ) );
            this->addDoubleProperty( "H5", ElementaryMaterialPropertyDouble( "H5" , 0.07 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MonoDdFat */
typedef boost::shared_ptr< MonoDdFatMaterialBehaviourInstance > MonoDdFatMaterialBehaviourPtr;


/**
 * @class MonoDdCcMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MonoDdCc
 * @author Jean-Pierre Lefebvre
 */
class MonoDdCcMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MonoDdCcMaterialBehaviourInstance()
        {
            // Mot cle "MONO_DD_CC" dans Aster
            _asterName = "MONO_DD_CC";

            // Parametres matériau
            this->addDoubleProperty( "B", ElementaryMaterialPropertyDouble( "B" , true ) );
            this->addDoubleProperty( "Gh", ElementaryMaterialPropertyDouble( "GH" , true ) );
            this->addDoubleProperty( "Deltag0", ElementaryMaterialPropertyDouble( "DELTAG0" , true ) );
            this->addDoubleProperty( "Tau_0", ElementaryMaterialPropertyDouble( "TAU_0" , true ) );
            this->addDoubleProperty( "Tau_f", ElementaryMaterialPropertyDouble( "TAU_F" , true ) );
            this->addDoubleProperty( "Gamma0", ElementaryMaterialPropertyDouble( "GAMMA0" , true ) );
            this->addDoubleProperty( "N", ElementaryMaterialPropertyDouble( "N" , true ) );
            this->addDoubleProperty( "Rho_mob", ElementaryMaterialPropertyDouble( "RHO_MOB" , true ) );
            this->addDoubleProperty( "D", ElementaryMaterialPropertyDouble( "D" , true ) );
            this->addDoubleProperty( "D_lat", ElementaryMaterialPropertyDouble( "D_LAT" , true ) );
            this->addDoubleProperty( "Y_at", ElementaryMaterialPropertyDouble( "Y_AT" , true ) );
            this->addDoubleProperty( "K_f", ElementaryMaterialPropertyDouble( "K_F" , true ) );
            this->addDoubleProperty( "K_self", ElementaryMaterialPropertyDouble( "K_SELF" , true ) );
            this->addDoubleProperty( "K_boltz", ElementaryMaterialPropertyDouble( "K_BOLTZ" , true ) );
            this->addDoubleProperty( "H1", ElementaryMaterialPropertyDouble( "H1" , true ) );
            this->addDoubleProperty( "H2", ElementaryMaterialPropertyDouble( "H2" , true ) );
            this->addDoubleProperty( "H3", ElementaryMaterialPropertyDouble( "H3" , true ) );
            this->addDoubleProperty( "H4", ElementaryMaterialPropertyDouble( "H4" , 0. , false ) );
            this->addDoubleProperty( "H5", ElementaryMaterialPropertyDouble( "H5" , 0. , false ) );
            this->addDoubleProperty( "H6", ElementaryMaterialPropertyDouble( "H6" , 0. , false ) );
            this->addDoubleProperty( "Depdt", ElementaryMaterialPropertyDouble( "DEPDT" , 0. , false ) );
            this->addDoubleProperty( "Mu_moy", ElementaryMaterialPropertyDouble( "MU_MOY" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MonoDdCc */
typedef boost::shared_ptr< MonoDdCcMaterialBehaviourInstance > MonoDdCcMaterialBehaviourPtr;


/**
 * @class MonoDdCcIrraMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau MonoDdCcIrra
 * @author Jean-Pierre Lefebvre
 */
class MonoDdCcIrraMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        MonoDdCcIrraMaterialBehaviourInstance()
        {
            // Mot cle "MONO_DD_CC_IRRA" dans Aster
            _asterName = "MONO_DD_CC_IRRA";

            // Parametres matériau
            this->addDoubleProperty( "B", ElementaryMaterialPropertyDouble( "B" , true ) );
            this->addDoubleProperty( "Gh", ElementaryMaterialPropertyDouble( "GH" , true ) );
            this->addDoubleProperty( "Deltag0", ElementaryMaterialPropertyDouble( "DELTAG0" , true ) );
            this->addDoubleProperty( "Tau_0", ElementaryMaterialPropertyDouble( "TAU_0" , true ) );
            this->addDoubleProperty( "Tau_f", ElementaryMaterialPropertyDouble( "TAU_F" , true ) );
            this->addDoubleProperty( "Gamma0", ElementaryMaterialPropertyDouble( "GAMMA0" , true ) );
            this->addDoubleProperty( "N", ElementaryMaterialPropertyDouble( "N" , true ) );
            this->addDoubleProperty( "Rho_mob", ElementaryMaterialPropertyDouble( "RHO_MOB" , true ) );
            this->addDoubleProperty( "D", ElementaryMaterialPropertyDouble( "D" , true ) );
            this->addDoubleProperty( "D_lat", ElementaryMaterialPropertyDouble( "D_LAT" , true ) );
            this->addDoubleProperty( "Y_at", ElementaryMaterialPropertyDouble( "Y_AT" , true ) );
            this->addDoubleProperty( "K_f", ElementaryMaterialPropertyDouble( "K_F" , true ) );
            this->addDoubleProperty( "K_self", ElementaryMaterialPropertyDouble( "K_SELF" , true ) );
            this->addDoubleProperty( "K_boltz", ElementaryMaterialPropertyDouble( "K_BOLTZ" , true ) );
            this->addDoubleProperty( "H1", ElementaryMaterialPropertyDouble( "H1" , true ) );
            this->addDoubleProperty( "H2", ElementaryMaterialPropertyDouble( "H2" , true ) );
            this->addDoubleProperty( "H3", ElementaryMaterialPropertyDouble( "H3" , true ) );
            this->addDoubleProperty( "H4", ElementaryMaterialPropertyDouble( "H4" , 0. , false ) );
            this->addDoubleProperty( "H5", ElementaryMaterialPropertyDouble( "H5" , 0. , false ) );
            this->addDoubleProperty( "H6", ElementaryMaterialPropertyDouble( "H6" , 0. , false ) );
            this->addDoubleProperty( "Depdt", ElementaryMaterialPropertyDouble( "DEPDT" , 0. , false ) );
            this->addDoubleProperty( "A_irra", ElementaryMaterialPropertyDouble( "A_IRRA" , true ) );
            this->addDoubleProperty( "Xi_irra", ElementaryMaterialPropertyDouble( "XI_IRRA" , true ) );
            this->addDoubleProperty( "Mu_moy", ElementaryMaterialPropertyDouble( "MU_MOY" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau MonoDdCcIrra */
typedef boost::shared_ptr< MonoDdCcIrraMaterialBehaviourInstance > MonoDdCcIrraMaterialBehaviourPtr;


/**
 * @class UmatMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau Umat
 * @author Jean-Pierre Lefebvre
 */
class UmatMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        UmatMaterialBehaviourInstance()
        {
            // Mot cle "UMAT" dans Aster
            _asterName = "UMAT";

            // Parametres matériau
            this->addDoubleProperty( "Nb_vale", ElementaryMaterialPropertyDouble( "NB_VALE" , false ) );
            this->addDoubleProperty( "C1", ElementaryMaterialPropertyDouble( "C1" , false ) );
            this->addDoubleProperty( "C2", ElementaryMaterialPropertyDouble( "C2" , false ) );
            this->addDoubleProperty( "C3", ElementaryMaterialPropertyDouble( "C3" , false ) );
            this->addDoubleProperty( "C4", ElementaryMaterialPropertyDouble( "C4" , false ) );
            this->addDoubleProperty( "C5", ElementaryMaterialPropertyDouble( "C5" , false ) );
            this->addDoubleProperty( "C6", ElementaryMaterialPropertyDouble( "C6" , false ) );
            this->addDoubleProperty( "C7", ElementaryMaterialPropertyDouble( "C7" , false ) );
            this->addDoubleProperty( "C8", ElementaryMaterialPropertyDouble( "C8" , false ) );
            this->addDoubleProperty( "C9", ElementaryMaterialPropertyDouble( "C9" , false ) );
            this->addDoubleProperty( "C10", ElementaryMaterialPropertyDouble( "C10" , false ) );
            this->addDoubleProperty( "C11", ElementaryMaterialPropertyDouble( "C11" , false ) );
            this->addDoubleProperty( "C12", ElementaryMaterialPropertyDouble( "C12" , false ) );
            this->addDoubleProperty( "C13", ElementaryMaterialPropertyDouble( "C13" , false ) );
            this->addDoubleProperty( "C14", ElementaryMaterialPropertyDouble( "C14" , false ) );
            this->addDoubleProperty( "C15", ElementaryMaterialPropertyDouble( "C15" , false ) );
            this->addDoubleProperty( "C16", ElementaryMaterialPropertyDouble( "C16" , false ) );
            this->addDoubleProperty( "C17", ElementaryMaterialPropertyDouble( "C17" , false ) );
            this->addDoubleProperty( "C18", ElementaryMaterialPropertyDouble( "C18" , false ) );
            this->addDoubleProperty( "C19", ElementaryMaterialPropertyDouble( "C19" , false ) );
            this->addDoubleProperty( "C20", ElementaryMaterialPropertyDouble( "C20" , false ) );
            this->addDoubleProperty( "C21", ElementaryMaterialPropertyDouble( "C21" , false ) );
            this->addDoubleProperty( "C22", ElementaryMaterialPropertyDouble( "C22" , false ) );
            this->addDoubleProperty( "C23", ElementaryMaterialPropertyDouble( "C23" , false ) );
            this->addDoubleProperty( "C24", ElementaryMaterialPropertyDouble( "C24" , false ) );
            this->addDoubleProperty( "C25", ElementaryMaterialPropertyDouble( "C25" , false ) );
            this->addDoubleProperty( "C26", ElementaryMaterialPropertyDouble( "C26" , false ) );
            this->addDoubleProperty( "C27", ElementaryMaterialPropertyDouble( "C27" , false ) );
            this->addDoubleProperty( "C28", ElementaryMaterialPropertyDouble( "C28" , false ) );
            this->addDoubleProperty( "C29", ElementaryMaterialPropertyDouble( "C29" , false ) );
            this->addDoubleProperty( "C30", ElementaryMaterialPropertyDouble( "C30" , false ) );
            this->addDoubleProperty( "C31", ElementaryMaterialPropertyDouble( "C31" , false ) );
            this->addDoubleProperty( "C32", ElementaryMaterialPropertyDouble( "C32" , false ) );
            this->addDoubleProperty( "C33", ElementaryMaterialPropertyDouble( "C33" , false ) );
            this->addDoubleProperty( "C34", ElementaryMaterialPropertyDouble( "C34" , false ) );
            this->addDoubleProperty( "C35", ElementaryMaterialPropertyDouble( "C35" , false ) );
            this->addDoubleProperty( "C36", ElementaryMaterialPropertyDouble( "C36" , false ) );
            this->addDoubleProperty( "C37", ElementaryMaterialPropertyDouble( "C37" , false ) );
            this->addDoubleProperty( "C38", ElementaryMaterialPropertyDouble( "C38" , false ) );
            this->addDoubleProperty( "C39", ElementaryMaterialPropertyDouble( "C39" , false ) );
            this->addDoubleProperty( "C40", ElementaryMaterialPropertyDouble( "C40" , false ) );
            this->addDoubleProperty( "C41", ElementaryMaterialPropertyDouble( "C41" , false ) );
            this->addDoubleProperty( "C42", ElementaryMaterialPropertyDouble( "C42" , false ) );
            this->addDoubleProperty( "C43", ElementaryMaterialPropertyDouble( "C43" , false ) );
            this->addDoubleProperty( "C44", ElementaryMaterialPropertyDouble( "C44" , false ) );
            this->addDoubleProperty( "C45", ElementaryMaterialPropertyDouble( "C45" , false ) );
            this->addDoubleProperty( "C46", ElementaryMaterialPropertyDouble( "C46" , false ) );
            this->addDoubleProperty( "C47", ElementaryMaterialPropertyDouble( "C47" , false ) );
            this->addDoubleProperty( "C48", ElementaryMaterialPropertyDouble( "C48" , false ) );
            this->addDoubleProperty( "C49", ElementaryMaterialPropertyDouble( "C49" , false ) );
            this->addDoubleProperty( "C50", ElementaryMaterialPropertyDouble( "C50" , false ) );
            this->addDoubleProperty( "C51", ElementaryMaterialPropertyDouble( "C51" , false ) );
            this->addDoubleProperty( "C52", ElementaryMaterialPropertyDouble( "C52" , false ) );
            this->addDoubleProperty( "C53", ElementaryMaterialPropertyDouble( "C53" , false ) );
            this->addDoubleProperty( "C54", ElementaryMaterialPropertyDouble( "C54" , false ) );
            this->addDoubleProperty( "C55", ElementaryMaterialPropertyDouble( "C55" , false ) );
            this->addDoubleProperty( "C56", ElementaryMaterialPropertyDouble( "C56" , false ) );
            this->addDoubleProperty( "C57", ElementaryMaterialPropertyDouble( "C57" , false ) );
            this->addDoubleProperty( "C58", ElementaryMaterialPropertyDouble( "C58" , false ) );
            this->addDoubleProperty( "C59", ElementaryMaterialPropertyDouble( "C59" , false ) );
            this->addDoubleProperty( "C60", ElementaryMaterialPropertyDouble( "C60" , false ) );
            this->addDoubleProperty( "C61", ElementaryMaterialPropertyDouble( "C61" , false ) );
            this->addDoubleProperty( "C62", ElementaryMaterialPropertyDouble( "C62" , false ) );
            this->addDoubleProperty( "C63", ElementaryMaterialPropertyDouble( "C63" , false ) );
            this->addDoubleProperty( "C64", ElementaryMaterialPropertyDouble( "C64" , false ) );
            this->addDoubleProperty( "C65", ElementaryMaterialPropertyDouble( "C65" , false ) );
            this->addDoubleProperty( "C66", ElementaryMaterialPropertyDouble( "C66" , false ) );
            this->addDoubleProperty( "C67", ElementaryMaterialPropertyDouble( "C67" , false ) );
            this->addDoubleProperty( "C68", ElementaryMaterialPropertyDouble( "C68" , false ) );
            this->addDoubleProperty( "C69", ElementaryMaterialPropertyDouble( "C69" , false ) );
            this->addDoubleProperty( "C70", ElementaryMaterialPropertyDouble( "C70" , false ) );
            this->addDoubleProperty( "C71", ElementaryMaterialPropertyDouble( "C71" , false ) );
            this->addDoubleProperty( "C72", ElementaryMaterialPropertyDouble( "C72" , false ) );
            this->addDoubleProperty( "C73", ElementaryMaterialPropertyDouble( "C73" , false ) );
            this->addDoubleProperty( "C74", ElementaryMaterialPropertyDouble( "C74" , false ) );
            this->addDoubleProperty( "C75", ElementaryMaterialPropertyDouble( "C75" , false ) );
            this->addDoubleProperty( "C76", ElementaryMaterialPropertyDouble( "C76" , false ) );
            this->addDoubleProperty( "C77", ElementaryMaterialPropertyDouble( "C77" , false ) );
            this->addDoubleProperty( "C78", ElementaryMaterialPropertyDouble( "C78" , false ) );
            this->addDoubleProperty( "C79", ElementaryMaterialPropertyDouble( "C79" , false ) );
            this->addDoubleProperty( "C80", ElementaryMaterialPropertyDouble( "C80" , false ) );
            this->addDoubleProperty( "C81", ElementaryMaterialPropertyDouble( "C81" , false ) );
            this->addDoubleProperty( "C82", ElementaryMaterialPropertyDouble( "C82" , false ) );
            this->addDoubleProperty( "C83", ElementaryMaterialPropertyDouble( "C83" , false ) );
            this->addDoubleProperty( "C84", ElementaryMaterialPropertyDouble( "C84" , false ) );
            this->addDoubleProperty( "C85", ElementaryMaterialPropertyDouble( "C85" , false ) );
            this->addDoubleProperty( "C86", ElementaryMaterialPropertyDouble( "C86" , false ) );
            this->addDoubleProperty( "C87", ElementaryMaterialPropertyDouble( "C87" , false ) );
            this->addDoubleProperty( "C88", ElementaryMaterialPropertyDouble( "C88" , false ) );
            this->addDoubleProperty( "C89", ElementaryMaterialPropertyDouble( "C89" , false ) );
            this->addDoubleProperty( "C90", ElementaryMaterialPropertyDouble( "C90" , false ) );
            this->addDoubleProperty( "C91", ElementaryMaterialPropertyDouble( "C91" , false ) );
            this->addDoubleProperty( "C92", ElementaryMaterialPropertyDouble( "C92" , false ) );
            this->addDoubleProperty( "C93", ElementaryMaterialPropertyDouble( "C93" , false ) );
            this->addDoubleProperty( "C94", ElementaryMaterialPropertyDouble( "C94" , false ) );
            this->addDoubleProperty( "C95", ElementaryMaterialPropertyDouble( "C95" , false ) );
            this->addDoubleProperty( "C96", ElementaryMaterialPropertyDouble( "C96" , false ) );
            this->addDoubleProperty( "C97", ElementaryMaterialPropertyDouble( "C97" , false ) );
            this->addDoubleProperty( "C98", ElementaryMaterialPropertyDouble( "C98" , false ) );
            this->addDoubleProperty( "C99", ElementaryMaterialPropertyDouble( "C99" , false ) );
            this->addDoubleProperty( "C100", ElementaryMaterialPropertyDouble( "C100" , false ) );
            this->addDoubleProperty( "C101", ElementaryMaterialPropertyDouble( "C101" , false ) );
            this->addDoubleProperty( "C102", ElementaryMaterialPropertyDouble( "C102" , false ) );
            this->addDoubleProperty( "C103", ElementaryMaterialPropertyDouble( "C103" , false ) );
            this->addDoubleProperty( "C104", ElementaryMaterialPropertyDouble( "C104" , false ) );
            this->addDoubleProperty( "C105", ElementaryMaterialPropertyDouble( "C105" , false ) );
            this->addDoubleProperty( "C106", ElementaryMaterialPropertyDouble( "C106" , false ) );
            this->addDoubleProperty( "C107", ElementaryMaterialPropertyDouble( "C107" , false ) );
            this->addDoubleProperty( "C108", ElementaryMaterialPropertyDouble( "C108" , false ) );
            this->addDoubleProperty( "C109", ElementaryMaterialPropertyDouble( "C109" , false ) );
            this->addDoubleProperty( "C110", ElementaryMaterialPropertyDouble( "C110" , false ) );
            this->addDoubleProperty( "C111", ElementaryMaterialPropertyDouble( "C111" , false ) );
            this->addDoubleProperty( "C112", ElementaryMaterialPropertyDouble( "C112" , false ) );
            this->addDoubleProperty( "C113", ElementaryMaterialPropertyDouble( "C113" , false ) );
            this->addDoubleProperty( "C114", ElementaryMaterialPropertyDouble( "C114" , false ) );
            this->addDoubleProperty( "C115", ElementaryMaterialPropertyDouble( "C115" , false ) );
            this->addDoubleProperty( "C116", ElementaryMaterialPropertyDouble( "C116" , false ) );
            this->addDoubleProperty( "C117", ElementaryMaterialPropertyDouble( "C117" , false ) );
            this->addDoubleProperty( "C118", ElementaryMaterialPropertyDouble( "C118" , false ) );
            this->addDoubleProperty( "C119", ElementaryMaterialPropertyDouble( "C119" , false ) );
            this->addDoubleProperty( "C120", ElementaryMaterialPropertyDouble( "C120" , false ) );
            this->addDoubleProperty( "C121", ElementaryMaterialPropertyDouble( "C121" , false ) );
            this->addDoubleProperty( "C122", ElementaryMaterialPropertyDouble( "C122" , false ) );
            this->addDoubleProperty( "C123", ElementaryMaterialPropertyDouble( "C123" , false ) );
            this->addDoubleProperty( "C124", ElementaryMaterialPropertyDouble( "C124" , false ) );
            this->addDoubleProperty( "C125", ElementaryMaterialPropertyDouble( "C125" , false ) );
            this->addDoubleProperty( "C126", ElementaryMaterialPropertyDouble( "C126" , false ) );
            this->addDoubleProperty( "C127", ElementaryMaterialPropertyDouble( "C127" , false ) );
            this->addDoubleProperty( "C128", ElementaryMaterialPropertyDouble( "C128" , false ) );
            this->addDoubleProperty( "C129", ElementaryMaterialPropertyDouble( "C129" , false ) );
            this->addDoubleProperty( "C130", ElementaryMaterialPropertyDouble( "C130" , false ) );
            this->addDoubleProperty( "C131", ElementaryMaterialPropertyDouble( "C131" , false ) );
            this->addDoubleProperty( "C132", ElementaryMaterialPropertyDouble( "C132" , false ) );
            this->addDoubleProperty( "C133", ElementaryMaterialPropertyDouble( "C133" , false ) );
            this->addDoubleProperty( "C134", ElementaryMaterialPropertyDouble( "C134" , false ) );
            this->addDoubleProperty( "C135", ElementaryMaterialPropertyDouble( "C135" , false ) );
            this->addDoubleProperty( "C136", ElementaryMaterialPropertyDouble( "C136" , false ) );
            this->addDoubleProperty( "C137", ElementaryMaterialPropertyDouble( "C137" , false ) );
            this->addDoubleProperty( "C138", ElementaryMaterialPropertyDouble( "C138" , false ) );
            this->addDoubleProperty( "C139", ElementaryMaterialPropertyDouble( "C139" , false ) );
            this->addDoubleProperty( "C140", ElementaryMaterialPropertyDouble( "C140" , false ) );
            this->addDoubleProperty( "C141", ElementaryMaterialPropertyDouble( "C141" , false ) );
            this->addDoubleProperty( "C142", ElementaryMaterialPropertyDouble( "C142" , false ) );
            this->addDoubleProperty( "C143", ElementaryMaterialPropertyDouble( "C143" , false ) );
            this->addDoubleProperty( "C144", ElementaryMaterialPropertyDouble( "C144" , false ) );
            this->addDoubleProperty( "C145", ElementaryMaterialPropertyDouble( "C145" , false ) );
            this->addDoubleProperty( "C146", ElementaryMaterialPropertyDouble( "C146" , false ) );
            this->addDoubleProperty( "C147", ElementaryMaterialPropertyDouble( "C147" , false ) );
            this->addDoubleProperty( "C148", ElementaryMaterialPropertyDouble( "C148" , false ) );
            this->addDoubleProperty( "C149", ElementaryMaterialPropertyDouble( "C149" , false ) );
            this->addDoubleProperty( "C150", ElementaryMaterialPropertyDouble( "C150" , false ) );
            this->addDoubleProperty( "C151", ElementaryMaterialPropertyDouble( "C151" , false ) );
            this->addDoubleProperty( "C152", ElementaryMaterialPropertyDouble( "C152" , false ) );
            this->addDoubleProperty( "C153", ElementaryMaterialPropertyDouble( "C153" , false ) );
            this->addDoubleProperty( "C154", ElementaryMaterialPropertyDouble( "C154" , false ) );
            this->addDoubleProperty( "C155", ElementaryMaterialPropertyDouble( "C155" , false ) );
            this->addDoubleProperty( "C156", ElementaryMaterialPropertyDouble( "C156" , false ) );
            this->addDoubleProperty( "C157", ElementaryMaterialPropertyDouble( "C157" , false ) );
            this->addDoubleProperty( "C158", ElementaryMaterialPropertyDouble( "C158" , false ) );
            this->addDoubleProperty( "C159", ElementaryMaterialPropertyDouble( "C159" , false ) );
            this->addDoubleProperty( "C160", ElementaryMaterialPropertyDouble( "C160" , false ) );
            this->addDoubleProperty( "C161", ElementaryMaterialPropertyDouble( "C161" , false ) );
            this->addDoubleProperty( "C162", ElementaryMaterialPropertyDouble( "C162" , false ) );
            this->addDoubleProperty( "C163", ElementaryMaterialPropertyDouble( "C163" , false ) );
            this->addDoubleProperty( "C164", ElementaryMaterialPropertyDouble( "C164" , false ) );
            this->addDoubleProperty( "C165", ElementaryMaterialPropertyDouble( "C165" , false ) );
            this->addDoubleProperty( "C166", ElementaryMaterialPropertyDouble( "C166" , false ) );
            this->addDoubleProperty( "C167", ElementaryMaterialPropertyDouble( "C167" , false ) );
            this->addDoubleProperty( "C168", ElementaryMaterialPropertyDouble( "C168" , false ) );
            this->addDoubleProperty( "C169", ElementaryMaterialPropertyDouble( "C169" , false ) );
            this->addDoubleProperty( "C170", ElementaryMaterialPropertyDouble( "C170" , false ) );
            this->addDoubleProperty( "C171", ElementaryMaterialPropertyDouble( "C171" , false ) );
            this->addDoubleProperty( "C172", ElementaryMaterialPropertyDouble( "C172" , false ) );
            this->addDoubleProperty( "C173", ElementaryMaterialPropertyDouble( "C173" , false ) );
            this->addDoubleProperty( "C174", ElementaryMaterialPropertyDouble( "C174" , false ) );
            this->addDoubleProperty( "C175", ElementaryMaterialPropertyDouble( "C175" , false ) );
            this->addDoubleProperty( "C176", ElementaryMaterialPropertyDouble( "C176" , false ) );
            this->addDoubleProperty( "C177", ElementaryMaterialPropertyDouble( "C177" , false ) );
            this->addDoubleProperty( "C178", ElementaryMaterialPropertyDouble( "C178" , false ) );
            this->addDoubleProperty( "C179", ElementaryMaterialPropertyDouble( "C179" , false ) );
            this->addDoubleProperty( "C180", ElementaryMaterialPropertyDouble( "C180" , false ) );
            this->addDoubleProperty( "C181", ElementaryMaterialPropertyDouble( "C181" , false ) );
            this->addDoubleProperty( "C182", ElementaryMaterialPropertyDouble( "C182" , false ) );
            this->addDoubleProperty( "C183", ElementaryMaterialPropertyDouble( "C183" , false ) );
            this->addDoubleProperty( "C184", ElementaryMaterialPropertyDouble( "C184" , false ) );
            this->addDoubleProperty( "C185", ElementaryMaterialPropertyDouble( "C185" , false ) );
            this->addDoubleProperty( "C186", ElementaryMaterialPropertyDouble( "C186" , false ) );
            this->addDoubleProperty( "C187", ElementaryMaterialPropertyDouble( "C187" , false ) );
            this->addDoubleProperty( "C188", ElementaryMaterialPropertyDouble( "C188" , false ) );
            this->addDoubleProperty( "C189", ElementaryMaterialPropertyDouble( "C189" , false ) );
            this->addDoubleProperty( "C190", ElementaryMaterialPropertyDouble( "C190" , false ) );
            this->addDoubleProperty( "C191", ElementaryMaterialPropertyDouble( "C191" , false ) );
            this->addDoubleProperty( "C192", ElementaryMaterialPropertyDouble( "C192" , false ) );
            this->addDoubleProperty( "C193", ElementaryMaterialPropertyDouble( "C193" , false ) );
            this->addDoubleProperty( "C194", ElementaryMaterialPropertyDouble( "C194" , false ) );
            this->addDoubleProperty( "C195", ElementaryMaterialPropertyDouble( "C195" , false ) );
            this->addDoubleProperty( "C196", ElementaryMaterialPropertyDouble( "C196" , false ) );
            this->addDoubleProperty( "C197", ElementaryMaterialPropertyDouble( "C197" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau Umat */
typedef boost::shared_ptr< UmatMaterialBehaviourInstance > UmatMaterialBehaviourPtr;


/**
 * @class UmatFoMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau UmatFo
 * @author Jean-Pierre Lefebvre
 */
class UmatFoMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        UmatFoMaterialBehaviourInstance()
        {
            // Mot cle "UMAT_FO" dans Aster
            _asterName = "UMAT_FO";

            // Parametres matériau
            this->addDoubleProperty( "Nb_vale", ElementaryMaterialPropertyDouble( "NB_VALE" , false ) );
            this->addFunctionProperty( "C1", ElementaryMaterialPropertyFunction( "C1" , false ) );
            this->addFunctionProperty( "C2", ElementaryMaterialPropertyFunction( "C2" , false ) );
            this->addFunctionProperty( "C3", ElementaryMaterialPropertyFunction( "C3" , false ) );
            this->addFunctionProperty( "C4", ElementaryMaterialPropertyFunction( "C4" , false ) );
            this->addFunctionProperty( "C5", ElementaryMaterialPropertyFunction( "C5" , false ) );
            this->addFunctionProperty( "C6", ElementaryMaterialPropertyFunction( "C6" , false ) );
            this->addFunctionProperty( "C7", ElementaryMaterialPropertyFunction( "C7" , false ) );
            this->addFunctionProperty( "C8", ElementaryMaterialPropertyFunction( "C8" , false ) );
            this->addFunctionProperty( "C9", ElementaryMaterialPropertyFunction( "C9" , false ) );
            this->addFunctionProperty( "C10", ElementaryMaterialPropertyFunction( "C10" , false ) );
            this->addFunctionProperty( "C11", ElementaryMaterialPropertyFunction( "C11" , false ) );
            this->addFunctionProperty( "C12", ElementaryMaterialPropertyFunction( "C12" , false ) );
            this->addFunctionProperty( "C13", ElementaryMaterialPropertyFunction( "C13" , false ) );
            this->addFunctionProperty( "C14", ElementaryMaterialPropertyFunction( "C14" , false ) );
            this->addFunctionProperty( "C15", ElementaryMaterialPropertyFunction( "C15" , false ) );
            this->addFunctionProperty( "C16", ElementaryMaterialPropertyFunction( "C16" , false ) );
            this->addFunctionProperty( "C17", ElementaryMaterialPropertyFunction( "C17" , false ) );
            this->addFunctionProperty( "C18", ElementaryMaterialPropertyFunction( "C18" , false ) );
            this->addFunctionProperty( "C19", ElementaryMaterialPropertyFunction( "C19" , false ) );
            this->addFunctionProperty( "C20", ElementaryMaterialPropertyFunction( "C20" , false ) );
            this->addFunctionProperty( "C21", ElementaryMaterialPropertyFunction( "C21" , false ) );
            this->addFunctionProperty( "C22", ElementaryMaterialPropertyFunction( "C22" , false ) );
            this->addFunctionProperty( "C23", ElementaryMaterialPropertyFunction( "C23" , false ) );
            this->addFunctionProperty( "C24", ElementaryMaterialPropertyFunction( "C24" , false ) );
            this->addFunctionProperty( "C25", ElementaryMaterialPropertyFunction( "C25" , false ) );
            this->addFunctionProperty( "C26", ElementaryMaterialPropertyFunction( "C26" , false ) );
            this->addFunctionProperty( "C27", ElementaryMaterialPropertyFunction( "C27" , false ) );
            this->addFunctionProperty( "C28", ElementaryMaterialPropertyFunction( "C28" , false ) );
            this->addFunctionProperty( "C29", ElementaryMaterialPropertyFunction( "C29" , false ) );
            this->addFunctionProperty( "C30", ElementaryMaterialPropertyFunction( "C30" , false ) );
            this->addFunctionProperty( "C31", ElementaryMaterialPropertyFunction( "C31" , false ) );
            this->addFunctionProperty( "C32", ElementaryMaterialPropertyFunction( "C32" , false ) );
            this->addFunctionProperty( "C33", ElementaryMaterialPropertyFunction( "C33" , false ) );
            this->addFunctionProperty( "C34", ElementaryMaterialPropertyFunction( "C34" , false ) );
            this->addFunctionProperty( "C35", ElementaryMaterialPropertyFunction( "C35" , false ) );
            this->addFunctionProperty( "C36", ElementaryMaterialPropertyFunction( "C36" , false ) );
            this->addFunctionProperty( "C37", ElementaryMaterialPropertyFunction( "C37" , false ) );
            this->addFunctionProperty( "C38", ElementaryMaterialPropertyFunction( "C38" , false ) );
            this->addFunctionProperty( "C39", ElementaryMaterialPropertyFunction( "C39" , false ) );
            this->addFunctionProperty( "C40", ElementaryMaterialPropertyFunction( "C40" , false ) );
            this->addFunctionProperty( "C41", ElementaryMaterialPropertyFunction( "C41" , false ) );
            this->addFunctionProperty( "C42", ElementaryMaterialPropertyFunction( "C42" , false ) );
            this->addFunctionProperty( "C43", ElementaryMaterialPropertyFunction( "C43" , false ) );
            this->addFunctionProperty( "C44", ElementaryMaterialPropertyFunction( "C44" , false ) );
            this->addFunctionProperty( "C45", ElementaryMaterialPropertyFunction( "C45" , false ) );
            this->addFunctionProperty( "C46", ElementaryMaterialPropertyFunction( "C46" , false ) );
            this->addFunctionProperty( "C47", ElementaryMaterialPropertyFunction( "C47" , false ) );
            this->addFunctionProperty( "C48", ElementaryMaterialPropertyFunction( "C48" , false ) );
            this->addFunctionProperty( "C49", ElementaryMaterialPropertyFunction( "C49" , false ) );
            this->addFunctionProperty( "C50", ElementaryMaterialPropertyFunction( "C50" , false ) );
            this->addFunctionProperty( "C51", ElementaryMaterialPropertyFunction( "C51" , false ) );
            this->addFunctionProperty( "C52", ElementaryMaterialPropertyFunction( "C52" , false ) );
            this->addFunctionProperty( "C53", ElementaryMaterialPropertyFunction( "C53" , false ) );
            this->addFunctionProperty( "C54", ElementaryMaterialPropertyFunction( "C54" , false ) );
            this->addFunctionProperty( "C55", ElementaryMaterialPropertyFunction( "C55" , false ) );
            this->addFunctionProperty( "C56", ElementaryMaterialPropertyFunction( "C56" , false ) );
            this->addFunctionProperty( "C57", ElementaryMaterialPropertyFunction( "C57" , false ) );
            this->addFunctionProperty( "C58", ElementaryMaterialPropertyFunction( "C58" , false ) );
            this->addFunctionProperty( "C59", ElementaryMaterialPropertyFunction( "C59" , false ) );
            this->addFunctionProperty( "C60", ElementaryMaterialPropertyFunction( "C60" , false ) );
            this->addFunctionProperty( "C61", ElementaryMaterialPropertyFunction( "C61" , false ) );
            this->addFunctionProperty( "C62", ElementaryMaterialPropertyFunction( "C62" , false ) );
            this->addFunctionProperty( "C63", ElementaryMaterialPropertyFunction( "C63" , false ) );
            this->addFunctionProperty( "C64", ElementaryMaterialPropertyFunction( "C64" , false ) );
            this->addFunctionProperty( "C65", ElementaryMaterialPropertyFunction( "C65" , false ) );
            this->addFunctionProperty( "C66", ElementaryMaterialPropertyFunction( "C66" , false ) );
            this->addFunctionProperty( "C67", ElementaryMaterialPropertyFunction( "C67" , false ) );
            this->addFunctionProperty( "C68", ElementaryMaterialPropertyFunction( "C68" , false ) );
            this->addFunctionProperty( "C69", ElementaryMaterialPropertyFunction( "C69" , false ) );
            this->addFunctionProperty( "C70", ElementaryMaterialPropertyFunction( "C70" , false ) );
            this->addFunctionProperty( "C71", ElementaryMaterialPropertyFunction( "C71" , false ) );
            this->addFunctionProperty( "C72", ElementaryMaterialPropertyFunction( "C72" , false ) );
            this->addFunctionProperty( "C73", ElementaryMaterialPropertyFunction( "C73" , false ) );
            this->addFunctionProperty( "C74", ElementaryMaterialPropertyFunction( "C74" , false ) );
            this->addFunctionProperty( "C75", ElementaryMaterialPropertyFunction( "C75" , false ) );
            this->addFunctionProperty( "C76", ElementaryMaterialPropertyFunction( "C76" , false ) );
            this->addFunctionProperty( "C77", ElementaryMaterialPropertyFunction( "C77" , false ) );
            this->addFunctionProperty( "C78", ElementaryMaterialPropertyFunction( "C78" , false ) );
            this->addFunctionProperty( "C79", ElementaryMaterialPropertyFunction( "C79" , false ) );
            this->addFunctionProperty( "C80", ElementaryMaterialPropertyFunction( "C80" , false ) );
            this->addFunctionProperty( "C81", ElementaryMaterialPropertyFunction( "C81" , false ) );
            this->addFunctionProperty( "C82", ElementaryMaterialPropertyFunction( "C82" , false ) );
            this->addFunctionProperty( "C83", ElementaryMaterialPropertyFunction( "C83" , false ) );
            this->addFunctionProperty( "C84", ElementaryMaterialPropertyFunction( "C84" , false ) );
            this->addFunctionProperty( "C85", ElementaryMaterialPropertyFunction( "C85" , false ) );
            this->addFunctionProperty( "C86", ElementaryMaterialPropertyFunction( "C86" , false ) );
            this->addFunctionProperty( "C87", ElementaryMaterialPropertyFunction( "C87" , false ) );
            this->addFunctionProperty( "C88", ElementaryMaterialPropertyFunction( "C88" , false ) );
            this->addFunctionProperty( "C89", ElementaryMaterialPropertyFunction( "C89" , false ) );
            this->addFunctionProperty( "C90", ElementaryMaterialPropertyFunction( "C90" , false ) );
            this->addFunctionProperty( "C91", ElementaryMaterialPropertyFunction( "C91" , false ) );
            this->addFunctionProperty( "C92", ElementaryMaterialPropertyFunction( "C92" , false ) );
            this->addFunctionProperty( "C93", ElementaryMaterialPropertyFunction( "C93" , false ) );
            this->addFunctionProperty( "C94", ElementaryMaterialPropertyFunction( "C94" , false ) );
            this->addFunctionProperty( "C95", ElementaryMaterialPropertyFunction( "C95" , false ) );
            this->addFunctionProperty( "C96", ElementaryMaterialPropertyFunction( "C96" , false ) );
            this->addFunctionProperty( "C97", ElementaryMaterialPropertyFunction( "C97" , false ) );
            this->addFunctionProperty( "C98", ElementaryMaterialPropertyFunction( "C98" , false ) );
            this->addFunctionProperty( "C99", ElementaryMaterialPropertyFunction( "C99" , false ) );
            this->addFunctionProperty( "C100", ElementaryMaterialPropertyFunction( "C100" , false ) );
            this->addFunctionProperty( "C101", ElementaryMaterialPropertyFunction( "C101" , false ) );
            this->addFunctionProperty( "C102", ElementaryMaterialPropertyFunction( "C102" , false ) );
            this->addFunctionProperty( "C103", ElementaryMaterialPropertyFunction( "C103" , false ) );
            this->addFunctionProperty( "C104", ElementaryMaterialPropertyFunction( "C104" , false ) );
            this->addFunctionProperty( "C105", ElementaryMaterialPropertyFunction( "C105" , false ) );
            this->addFunctionProperty( "C106", ElementaryMaterialPropertyFunction( "C106" , false ) );
            this->addFunctionProperty( "C107", ElementaryMaterialPropertyFunction( "C107" , false ) );
            this->addFunctionProperty( "C108", ElementaryMaterialPropertyFunction( "C108" , false ) );
            this->addFunctionProperty( "C109", ElementaryMaterialPropertyFunction( "C109" , false ) );
            this->addFunctionProperty( "C110", ElementaryMaterialPropertyFunction( "C110" , false ) );
            this->addFunctionProperty( "C111", ElementaryMaterialPropertyFunction( "C111" , false ) );
            this->addFunctionProperty( "C112", ElementaryMaterialPropertyFunction( "C112" , false ) );
            this->addFunctionProperty( "C113", ElementaryMaterialPropertyFunction( "C113" , false ) );
            this->addFunctionProperty( "C114", ElementaryMaterialPropertyFunction( "C114" , false ) );
            this->addFunctionProperty( "C115", ElementaryMaterialPropertyFunction( "C115" , false ) );
            this->addFunctionProperty( "C116", ElementaryMaterialPropertyFunction( "C116" , false ) );
            this->addFunctionProperty( "C117", ElementaryMaterialPropertyFunction( "C117" , false ) );
            this->addFunctionProperty( "C118", ElementaryMaterialPropertyFunction( "C118" , false ) );
            this->addFunctionProperty( "C119", ElementaryMaterialPropertyFunction( "C119" , false ) );
            this->addFunctionProperty( "C120", ElementaryMaterialPropertyFunction( "C120" , false ) );
            this->addFunctionProperty( "C121", ElementaryMaterialPropertyFunction( "C121" , false ) );
            this->addFunctionProperty( "C122", ElementaryMaterialPropertyFunction( "C122" , false ) );
            this->addFunctionProperty( "C123", ElementaryMaterialPropertyFunction( "C123" , false ) );
            this->addFunctionProperty( "C124", ElementaryMaterialPropertyFunction( "C124" , false ) );
            this->addFunctionProperty( "C125", ElementaryMaterialPropertyFunction( "C125" , false ) );
            this->addFunctionProperty( "C126", ElementaryMaterialPropertyFunction( "C126" , false ) );
            this->addFunctionProperty( "C127", ElementaryMaterialPropertyFunction( "C127" , false ) );
            this->addFunctionProperty( "C128", ElementaryMaterialPropertyFunction( "C128" , false ) );
            this->addFunctionProperty( "C129", ElementaryMaterialPropertyFunction( "C129" , false ) );
            this->addFunctionProperty( "C130", ElementaryMaterialPropertyFunction( "C130" , false ) );
            this->addFunctionProperty( "C131", ElementaryMaterialPropertyFunction( "C131" , false ) );
            this->addFunctionProperty( "C132", ElementaryMaterialPropertyFunction( "C132" , false ) );
            this->addFunctionProperty( "C133", ElementaryMaterialPropertyFunction( "C133" , false ) );
            this->addFunctionProperty( "C134", ElementaryMaterialPropertyFunction( "C134" , false ) );
            this->addFunctionProperty( "C135", ElementaryMaterialPropertyFunction( "C135" , false ) );
            this->addFunctionProperty( "C136", ElementaryMaterialPropertyFunction( "C136" , false ) );
            this->addFunctionProperty( "C137", ElementaryMaterialPropertyFunction( "C137" , false ) );
            this->addFunctionProperty( "C138", ElementaryMaterialPropertyFunction( "C138" , false ) );
            this->addFunctionProperty( "C139", ElementaryMaterialPropertyFunction( "C139" , false ) );
            this->addFunctionProperty( "C140", ElementaryMaterialPropertyFunction( "C140" , false ) );
            this->addFunctionProperty( "C141", ElementaryMaterialPropertyFunction( "C141" , false ) );
            this->addFunctionProperty( "C142", ElementaryMaterialPropertyFunction( "C142" , false ) );
            this->addFunctionProperty( "C143", ElementaryMaterialPropertyFunction( "C143" , false ) );
            this->addFunctionProperty( "C144", ElementaryMaterialPropertyFunction( "C144" , false ) );
            this->addFunctionProperty( "C145", ElementaryMaterialPropertyFunction( "C145" , false ) );
            this->addFunctionProperty( "C146", ElementaryMaterialPropertyFunction( "C146" , false ) );
            this->addFunctionProperty( "C147", ElementaryMaterialPropertyFunction( "C147" , false ) );
            this->addFunctionProperty( "C148", ElementaryMaterialPropertyFunction( "C148" , false ) );
            this->addFunctionProperty( "C149", ElementaryMaterialPropertyFunction( "C149" , false ) );
            this->addFunctionProperty( "C150", ElementaryMaterialPropertyFunction( "C150" , false ) );
            this->addFunctionProperty( "C151", ElementaryMaterialPropertyFunction( "C151" , false ) );
            this->addFunctionProperty( "C152", ElementaryMaterialPropertyFunction( "C152" , false ) );
            this->addFunctionProperty( "C153", ElementaryMaterialPropertyFunction( "C153" , false ) );
            this->addFunctionProperty( "C154", ElementaryMaterialPropertyFunction( "C154" , false ) );
            this->addFunctionProperty( "C155", ElementaryMaterialPropertyFunction( "C155" , false ) );
            this->addFunctionProperty( "C156", ElementaryMaterialPropertyFunction( "C156" , false ) );
            this->addFunctionProperty( "C157", ElementaryMaterialPropertyFunction( "C157" , false ) );
            this->addFunctionProperty( "C158", ElementaryMaterialPropertyFunction( "C158" , false ) );
            this->addFunctionProperty( "C159", ElementaryMaterialPropertyFunction( "C159" , false ) );
            this->addFunctionProperty( "C160", ElementaryMaterialPropertyFunction( "C160" , false ) );
            this->addFunctionProperty( "C161", ElementaryMaterialPropertyFunction( "C161" , false ) );
            this->addFunctionProperty( "C162", ElementaryMaterialPropertyFunction( "C162" , false ) );
            this->addFunctionProperty( "C163", ElementaryMaterialPropertyFunction( "C163" , false ) );
            this->addFunctionProperty( "C164", ElementaryMaterialPropertyFunction( "C164" , false ) );
            this->addFunctionProperty( "C165", ElementaryMaterialPropertyFunction( "C165" , false ) );
            this->addFunctionProperty( "C166", ElementaryMaterialPropertyFunction( "C166" , false ) );
            this->addFunctionProperty( "C167", ElementaryMaterialPropertyFunction( "C167" , false ) );
            this->addFunctionProperty( "C168", ElementaryMaterialPropertyFunction( "C168" , false ) );
            this->addFunctionProperty( "C169", ElementaryMaterialPropertyFunction( "C169" , false ) );
            this->addFunctionProperty( "C170", ElementaryMaterialPropertyFunction( "C170" , false ) );
            this->addFunctionProperty( "C171", ElementaryMaterialPropertyFunction( "C171" , false ) );
            this->addFunctionProperty( "C172", ElementaryMaterialPropertyFunction( "C172" , false ) );
            this->addFunctionProperty( "C173", ElementaryMaterialPropertyFunction( "C173" , false ) );
            this->addFunctionProperty( "C174", ElementaryMaterialPropertyFunction( "C174" , false ) );
            this->addFunctionProperty( "C175", ElementaryMaterialPropertyFunction( "C175" , false ) );
            this->addFunctionProperty( "C176", ElementaryMaterialPropertyFunction( "C176" , false ) );
            this->addFunctionProperty( "C177", ElementaryMaterialPropertyFunction( "C177" , false ) );
            this->addFunctionProperty( "C178", ElementaryMaterialPropertyFunction( "C178" , false ) );
            this->addFunctionProperty( "C179", ElementaryMaterialPropertyFunction( "C179" , false ) );
            this->addFunctionProperty( "C180", ElementaryMaterialPropertyFunction( "C180" , false ) );
            this->addFunctionProperty( "C181", ElementaryMaterialPropertyFunction( "C181" , false ) );
            this->addFunctionProperty( "C182", ElementaryMaterialPropertyFunction( "C182" , false ) );
            this->addFunctionProperty( "C183", ElementaryMaterialPropertyFunction( "C183" , false ) );
            this->addFunctionProperty( "C184", ElementaryMaterialPropertyFunction( "C184" , false ) );
            this->addFunctionProperty( "C185", ElementaryMaterialPropertyFunction( "C185" , false ) );
            this->addFunctionProperty( "C186", ElementaryMaterialPropertyFunction( "C186" , false ) );
            this->addFunctionProperty( "C187", ElementaryMaterialPropertyFunction( "C187" , false ) );
            this->addFunctionProperty( "C188", ElementaryMaterialPropertyFunction( "C188" , false ) );
            this->addFunctionProperty( "C189", ElementaryMaterialPropertyFunction( "C189" , false ) );
            this->addFunctionProperty( "C190", ElementaryMaterialPropertyFunction( "C190" , false ) );
            this->addFunctionProperty( "C191", ElementaryMaterialPropertyFunction( "C191" , false ) );
            this->addFunctionProperty( "C192", ElementaryMaterialPropertyFunction( "C192" , false ) );
            this->addFunctionProperty( "C193", ElementaryMaterialPropertyFunction( "C193" , false ) );
            this->addFunctionProperty( "C194", ElementaryMaterialPropertyFunction( "C194" , false ) );
            this->addFunctionProperty( "C195", ElementaryMaterialPropertyFunction( "C195" , false ) );
            this->addFunctionProperty( "C196", ElementaryMaterialPropertyFunction( "C196" , false ) );
            this->addFunctionProperty( "C197", ElementaryMaterialPropertyFunction( "C197" , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau UmatFo */
typedef boost::shared_ptr< UmatFoMaterialBehaviourInstance > UmatFoMaterialBehaviourPtr;


/**
 * @class CritRuptMaterialBehaviourInstance
 * @brief Classe fille de GeneralMaterialBehaviourInstance definissant un materiau CritRupt
 * @author Jean-Pierre Lefebvre
 */
class CritRuptMaterialBehaviourInstance: public GeneralMaterialBehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        CritRuptMaterialBehaviourInstance()
        {
            // Mot cle "CRIT_RUPT" dans Aster
            _asterName = "CRIT_RUPT";

            // Parametres matériau
            this->addDoubleProperty( "Sigm_c", ElementaryMaterialPropertyDouble( "SIGM_C" , true ) );
            this->addDoubleProperty( "Coef", ElementaryMaterialPropertyDouble( "COEF" , true ) );
            this->addDoubleProperty( "Info", ElementaryMaterialPropertyDouble( "INFO" , 1 , false ) );
        };
};

/** @typedef Pointeur intelligent vers un comportement materiau CritRupt */
typedef boost::shared_ptr< CritRuptMaterialBehaviourInstance > CritRuptMaterialBehaviourPtr;


/** @typedef Pointeur intellignet vers un comportement materiau quelconque */
typedef boost::shared_ptr< GeneralMaterialBehaviourInstance > GeneralMaterialBehaviourPtr;




#endif
