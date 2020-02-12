#ifndef COMMANDSYNTAX_H_
#define COMMANDSYNTAX_H_

/**
 * @file CommandSyntax.h
 * @brief Implementation of API to CommandSyntax Python object.
 * @section LICENCE
 * Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
 * This file is part of code_aster.
 *
 * code_aster is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * code_aster is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with code_aster.  If not, see <http://www.gnu.org/licenses/>.

 * person_in_charge: mathieu.courtois@edf.fr
 */

#include "Python.h"
#include "aster.h"

#include "Utilities/SyntaxDictionary.h"
#include "Utilities/CapyConvertibleValue.h"

extern "C" PyObject *GetJdcAttr( _IN char * );

/**
 * @class CommandSyntax
 * @brief Implementation of API to CommandSyntax Python object.
 */
class CommandSyntax {
  private:
    /** @brief The command name. */
    const std::string _commandName;
    /** @brief CommandSyntax Python object handling the command syntax. */
    PyObject *_pySyntax;

  public:
    /** @brief CommandSyntax Python class object, cached to be retreive
     *  only once.
     */
    static PyObject *pyClass;

    /**
     * @brief Constructeur
     * @param name Nom de la commande
     */
    CommandSyntax( const std::string name );

    /**
     * @brief Destructeur
     */
    ~CommandSyntax();

    /**
     * @brief Function to manually release the command currently executed.
     */
    void free();

    /**
     * @brief Impression de debug
     */
    void debugPrint() const;

    /**
     * @brief Fonction permettant de definir la syntax
     * @param syntax Objet de type SyntaxMapContainer
     */
    void define( SyntaxMapContainer &syntax );

    /**
     * @brief Fonction permettant de definir la syntax
     * @param syntax Objet de type CapyConvertibleSyntax
     */
    void define( const CapyConvertibleSyntax &syntax );

    /**
     * @brief Definit le nom du résultat ainsi que son type
     * @param resultName std::string contenant le nom du résultat
     * @param typeSd std::string contenant le nom de la commande
     */
    void setResult( const std::string resultName, const std::string typeSd ) const;
};

#endif /* COMMANDSYNTAX_H_ */
