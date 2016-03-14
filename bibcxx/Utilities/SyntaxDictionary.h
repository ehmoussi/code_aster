#ifndef SYNTAXDICTIONARY_H_
#define SYNTAXDICTIONARY_H_

/**
 * @file SyntaxDictionary.h
 * @brief Fichier entete de la struct SyntaxMapContainer
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

#include <map>
#include <string>
#include <vector>
#include <list>
#include "boost/variant.hpp"
#include <typeinfo>
#include <iostream>

#include "Python.h"

struct SyntaxMapContainer;

/**
 * @typedef ListSyntaxMapContainer
 * @brief Type permettant de definir les occurence des mots-cles facteurs
 */
typedef std::list< SyntaxMapContainer > ListSyntaxMapContainer;
typedef ListSyntaxMapContainer::iterator ListSyntaxMapContainerIter;

/**
 * @typedef VectorInt
 * @brief Vecteur STL d'entiers
 */
typedef std::vector< int > VectorInt;
typedef VectorInt::iterator VectorIntIter;

/**
 * @typedef VectorString
 * @brief Vecteur STL de chaines
 */
typedef std::vector< std::string > VectorString;
typedef VectorString::iterator VectorStringIter;

/**
 * @typedef VectorDouble
 * @brief Vecteur STL de doubles
 */
typedef std::vector< double > VectorDouble;
typedef VectorDouble::iterator VectorDoubleIter;

/**
 * @class SyntaxMapContainer
 * @brief Cette struct decrit un dictionnaire permettant de contenir la syntaxe des commandes Aster
 * @author Nicolas Sellenet
 */
class SyntaxMapContainer
{
public:
    /** @brief Typedef definissant un map associant une chaine a divers types */
    typedef std::map< std::string, boost::variant< int, std::string, double,
                                                   VectorInt, VectorString, VectorDouble,
                                                   ListSyntaxMapContainer > > SyntaxMap;
    typedef SyntaxMap::iterator SyntaxMapIter;

    /** @brief Conteneur a proprement parler */
    SyntaxMap container;

protected:
    /**
        * @brief Convertisseur du conteneur en dictionnaire python
        * @return un dict python contenant la syntaxe valorisable par l'objet CommandSyntax
        * @todo Probleme de refcounting : ajouter un objet wrapper qui se chargera de la destruction
        * @todo seul CommandSyntaxCython et le cython devrait pouvoir appeler cette fonction ?
        */
    PyObject* convertToPythonDictionnary( PyObject* returnDict = NULL );

private:
    friend class CommandSyntaxCython;
    friend class MaterialOnMeshInstance;
    friend SyntaxMapContainer operator+( const SyntaxMapContainer&, const SyntaxMapContainer& );
};


SyntaxMapContainer operator+( const SyntaxMapContainer& toAdd1, const SyntaxMapContainer& toAdd2 );

#endif /* SYNTAXDICTIONARY_H_ */
