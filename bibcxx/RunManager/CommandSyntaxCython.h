#ifndef COMMANDSYNTAXCYTHON_H_
#define COMMANDSYNTAXCYTHON_H_

/**
 * @file CommandSyntaxCython.h
 * @brief Fichier entete permettant de decrire un bout de fichier de commande Aster
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

#include "Utilities/SyntaxDictionary.h"

/** @brief Déclarations des fonctions cython */
__PYX_EXTERN_C DL_IMPORT(void) newCommandSyntax(const char *);
__PYX_EXTERN_C DL_IMPORT(void) deleteCommandSyntax(void);
__PYX_EXTERN_C DL_IMPORT(void) setResultCommandSyntax(const char *, const char *);
__PYX_EXTERN_C DL_IMPORT(void) defineCommandSyntax(PyObject *);
__PYX_EXTERN_C DL_IMPORT(void) debugPrintCommandSyntax(void);

/**
 * @class CommandSyntaxCython
 * @brief This class is a miror of class CommandSyntax in cython
 * @author Nicolas Sellenet
 */
class CommandSyntaxCython
{
    private:
        /** @brief Nom de la commande */
        const std::string _commandName;
        /** @brief Dictionnaire python contenant la syntaxe de la commande */
        PyObject*         _dictCommand;

    public:
        /**
         * @brief Constructeur
         * @param name Nom de la commande
         */
        CommandSyntaxCython( const std::string name ): _commandName( name ), _dictCommand( NULL )
        {
            newCommandSyntax( name.c_str() );
        };

        /**
         * @brief Destructeur
         */
        ~CommandSyntaxCython()
        {
            if ( _dictCommand != NULL )
                Py_DECREF( _dictCommand );
            _dictCommand = NULL;
            deleteCommandSyntax();
        };

        /**
         * @brief Impression de debug
         */
        void debugPrint( void ) const
        {
            debugPrintCommandSyntax();
        };

        /**
         * @brief Fonction permettant de definir la syntax
         * @param syntax Objet de type SyntaxMapContainer
         */
        void define( SyntaxMapContainer& syntax )
        {
            _dictCommand = syntax.convertToPythonDictionnary();
            Py_INCREF( _dictCommand );
            defineCommandSyntax( _dictCommand );
        };

        /**
         * @brief Definit le nom du résultat ainsi que son type
         * @param resultName std::string contenant le nom du résultat
         * @param typeSd std::string contenant le nom de la commande
         */
        void setResult( const std::string resultName, const std::string typeSd ) const
        {
            setResultCommandSyntax( resultName.c_str(), typeSd.c_str() );
        };
};

#endif /* COMMANDSYNTAXCYTHON_H_ */
