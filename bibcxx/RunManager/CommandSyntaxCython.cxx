/**
 * @file CommandSyntaxCython.cxx
 * @brief Implementation de la classe CommandSyntaxCython
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

#include "RunManager/CommandSyntaxCython.h"

/** @brief Déclarations des fonctions cython */
__PYX_EXTERN_C DL_IMPORT(void) newCommandSyntax(const char *);
__PYX_EXTERN_C DL_IMPORT(void) deleteCommandSyntax(void);
__PYX_EXTERN_C DL_IMPORT(void) setResultCommandSyntax(const char *, const char *);
__PYX_EXTERN_C DL_IMPORT(void) defineCommandSyntax(PyObject *);
__PYX_EXTERN_C DL_IMPORT(void) debugPrintCommandSyntax(void);


CommandSyntaxCython::CommandSyntaxCython( const std::string name ): _commandName( name ),
                                                _dictCommand( NULL ),
                                                _existCS( false )
{};

CommandSyntaxCython& CommandSyntaxCython::operator=( const CommandSyntaxCython& toCopy )
{
    if( _dictCommand != NULL )
        Py_DECREF( _dictCommand );
    _dictCommand = NULL;

    if( _existCS )
        deleteCommandSyntax();

    _commandName = toCopy.getName();
    _existCS = false;
};

CommandSyntaxCython::~CommandSyntaxCython()
{
    if ( _dictCommand != NULL )
        Py_DECREF( _dictCommand );

    _dictCommand = NULL;
    if( _existCS )
        deleteCommandSyntax();
};

void CommandSyntaxCython::debugPrint( void ) const
{
    debugPrintCommandSyntax();
};

void CommandSyntaxCython::define( SyntaxMapContainer& syntax ) throw( std::runtime_error )
{
    if( ! _existCS )
    {
        newCommandSyntax( _commandName.c_str() );
        _existCS = true;
    }
    if( _dictCommand != NULL )
        throw std::runtime_error( "Syntax already defined" );
    _dictCommand = syntax.convertToPythonDictionnary();
    Py_INCREF( _dictCommand );
    defineCommandSyntax( _dictCommand );
};

void CommandSyntaxCython::define( const CapyConvertibleSyntax& syntax )
{
    if( ! _existCS )
    {
        newCommandSyntax( _commandName.c_str() );
        _existCS = true;
    }
    if( _dictCommand != NULL )
        throw std::runtime_error( "Syntax already defined" );
    SyntaxMapContainer test = syntax.toSyntaxMapContainer();
    _dictCommand = test.convertToPythonDictionnary();
    Py_INCREF( _dictCommand );
    defineCommandSyntax( _dictCommand );
};

void CommandSyntaxCython::setResult( const std::string resultName, const std::string typeSd )
{
    if( ! _existCS )
    {
        newCommandSyntax( _commandName.c_str() );
        _existCS = true;
    }
    setResultCommandSyntax( resultName.c_str(), typeSd.c_str() );
};
