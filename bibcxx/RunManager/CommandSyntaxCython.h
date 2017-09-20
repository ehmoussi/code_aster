#ifndef COMMANDSYNTAXCYTHON_H_
#define COMMANDSYNTAXCYTHON_H_

/**
 * @file CommandSyntaxCython.h
 * @brief Fichier entete permettant de decrire un bout de fichier de commande Aster
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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

#include "Utilities/SyntaxDictionary.h"
#include "Utilities/CapyConvertibleValue.h"


/**
 * @class CommandSyntaxCython
 * @brief This class is a mirror of class CommandSyntax in cython
 * @author Nicolas Sellenet
 */
class CommandSyntaxCython
{
    private:
        /** @brief Nom de la commande */
        std::string _commandName;
        /** @brief Dictionnaire python contenant la syntaxe de la commande */
        PyObject*   _dictCommand;
        bool        _existCS;

    public:
        /**
         * @brief Constructeur
         * @param name Nom de la commande
         */
        CommandSyntaxCython( const std::string name );

        CommandSyntaxCython& operator=( const CommandSyntaxCython& toCopy );

        /**
         * @brief Destructeur
         */
        ~CommandSyntaxCython();

        /**
         * @brief Impression de debug
         */
        void debugPrint( void ) const;

        /**
         * @brief Fonction permettant de definir la syntax
         * @param syntax Objet de type SyntaxMapContainer
         */
        void define( SyntaxMapContainer& syntax ) throw( std::runtime_error );

        /**
         * @brief Fonction permettant de definir la syntax
         * @param syntax Objet de type CapyConvertibleSyntax
         */
        void define( const CapyConvertibleSyntax& syntax );

        const std::string& getName() const
        {
            return _commandName;
        };

        /**
         * @brief Definit le nom du résultat ainsi que son type
         * @param resultName std::string contenant le nom du résultat
         * @param typeSd std::string contenant le nom de la commande
         */
        void setResult( const std::string resultName, const std::string typeSd );
};

#endif /* COMMANDSYNTAXCYTHON_H_ */
