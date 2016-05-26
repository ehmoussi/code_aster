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
 * @brief Classe template permettant de définir un mot-clé simple
 * @author Nicolas Sellenet
 */
template< typename Type >
class GenericParameter
{
private:
    /** @brief Nom du mot-clé simple */
    std::string _name;
    /** @brief Nom du vecteur Jeveux */
    Type        _valeur;
    /** @brief Nom du vecteur Jeveux */
    bool        _isSet;
    /** @brief Nom du vecteur Jeveux */
    bool        _isMandatory;

public:
    /**
     * @brief Constructeur
     * @param name Nom du mot-clé simple (exemple : MODELE ou NB_PAS_MAXI, ...)
     * @param isMandatory Permet de dire si le mot-clé est obligatoire
     */
    GenericParameter( const std::string name,
                      const bool isMandatory ): _name( name ),
                                                _isSet( false ),
                                                _isMandatory( isMandatory )
    {};

    /**
     * @brief Constructeur
     * @param name Nom du mot-clé simple (exemple : MODELE ou NB_PAS_MAXI, ...)
     * @param val Valeur par défaut
     * @param isMandatory Permet de dire si le mot-clé est obligatoire
     */
    GenericParameter( const std::string name, const Type val,
                      const bool isMandatory ): _name( name ),
                                                _valeur( val ),
                                                _isSet( true ),
                                                _isMandatory( isMandatory )
    {};

    /**
     * @brief Fonction permettant de récupérer le nom du mot-clé
     * @return le nom du mot-clé simple
     */
    const std::string& getName() const
    {
        return _name;
    };

    /**
     * @brief Fonction permettant de récupérer la valeur du mot-clé
     * @return la valeur de type Type
     */
    const Type& getValue() const throw ( std::runtime_error )
    {
        if ( ! _isSet )
            throw std::runtime_error( "Value of parameter " + _name + " is not set" );
        return _valeur;
    };

    /**
     * @brief Fonction permettant de savoir si un mot-clé est obligatoire
     * @return true si obligatoire
     */
    const bool& isMandatory() const
    {
        return _isMandatory;
    };

    /**
     * @brief Fonction permettant de savoir si un mot-clé a été fixé
     * @return true si le mot-clé contient une valeur
     */
    const bool& isSet() const
    {
        return _isSet;
    };

    /**
     * @brief Fonction permettant de préciser si un mot-clé est obligatoire
     * @param isSet true s'il est obligatoire
     */
    void setMandatory( const bool& isSet )
    {
        _isMandatory = isSet;
    };

    /**
     * @brief Fonction permettant de préciser si un mot-clé a été fixé
     * @param isSet true s'il a été fixé
     */
    void setIsSet( const bool& isSet )
    {
        _isSet = isSet;
    };

    /**
     * @brief Fonction permettant de fixer la valeur
     * @param valeur Valeur de type Type
     */
    void setValue( const Type& valeur )
    {
        _valeur = valeur;
        _isSet = true;
    };

    /**
     * @brief Fonction permettant de fixer la valeur du paramètre si ça n'a pas déjà été fait
     * @param valeur Valeur de type Type
     */
    void setValueIfUnset( const Type& valeur )
    {
        if ( ! _isSet )
            _valeur = valeur;
        _isSet = true;
    };

    /**
     * @brief Surcharge de l'opérateur =
     */
    GenericParameter& operator=( const Type& valeur )
    {
        _valeur = valeur;
        _isSet = true;
    };
};

/** @typedef Definition d'un GenericParameter d'un type boost::variant */
typedef GenericParameter< boost::variant< double, int, std::string,
                                          std::vector< double >, std::vector< int >,
                                          std::vector< std::string > > > GenParam;

/** @typedef Definition d'une list de GenParam */
typedef std::list< GenParam* > ListGenParam;
/** @typedef Definition d'un itérateur sur ListGenParam */
typedef ListGenParam::iterator ListGenParamIter;
/** @typedef Definition d'un itérateur constant sur ListGenParam */
typedef ListGenParam::const_iterator ListGenParamCIter;


/**
 * @brief Fonction permettant de construire un SyntaxMapContainer à partir d'une liste ListGenParam
 * @param lParam Liste servant de base au remplissage du SyntaxMapContainer
 * @return SyntaxMapContainer rempli avec les mots-clés fixés
 */
SyntaxMapContainer buildSyntaxMapFromParamList( const ListGenParam& lParam ) throw ( std::runtime_error );

#endif /* GENERICPARAMETER_H_ */
