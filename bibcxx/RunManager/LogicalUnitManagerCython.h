#ifndef LOGICALUNITMANAGERCYTHON_H_
#define LOGICALUNITMANAGERCYTHON_H_

/**
 * @file CommandSyntaxCython.h
 * @brief Fichier entete permettant de decrire un fichier sur unité logique
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

/** @brief Déclarations des fonctions cython */
__PYX_EXTERN_C DL_IMPORT(void) openLogicalUnitFile(const char *, const int, const int);
__PYX_EXTERN_C DL_IMPORT(void) releaseLogicalUnitFile(const char *);
__PYX_EXTERN_C DL_IMPORT(int) getNumberOfLogicalUnitFile(const char *);
__PYX_EXTERN_C DL_IMPORT(std::string) getTemporaryFileName(const char *);

enum FileTypeCython { Ascii, Binary, Free };
enum FileAccessCython { New, Append, Old };

/**
 * @class LogicalUnitFileCython
 * @brief This class is a mirror of class LogicalUnitFile in cython
 * @author Nicolas Sellenet
 */
class LogicalUnitFileCython
{
    private:
        /** @brief Nom de la commande */
        std::string _fileName;
        /** @brief Booleen pour savoir si un fichier est utilisable */
        bool _isUsable;

    public:
        /**
         * @brief Constructeur
         * @param name Nom du fichier
         * @param type type du fichier
         * @param access Accés au fichier
         */
        LogicalUnitFileCython():
            _fileName( "" ),
            _isUsable( false )
        {};

        /**
         * @brief Constructeur
         * @param name Nom du fichier
         * @param type type du fichier
         * @param access Accés au fichier
         */
        LogicalUnitFileCython( const std::string name, const FileTypeCython type,
                               const FileAccessCython access ):
            _fileName( name ),
            _isUsable( true )
        {
            openLogicalUnitFile( name.c_str(), type, access );
        };

        /**
         * @brief Destructeur
         */
        ~LogicalUnitFileCython()
        {
            if( _isUsable ) releaseLogicalUnitFile( _fileName.c_str() );
        };

        /**
         * @brief Recuperer le numéro d'unité logique correspondant
         * @return Unité logique
         */
        bool isUsable( void ) const
        {
            return _isUsable;
        };

        /**
         * @brief Recuperer le numéro d'unité logique correspondant
         * @return Unité logique
         */
        int getLogicalUnit( void ) const throw( std::runtime_error )
        {
            if( !_isUsable )
                throw std::runtime_error( "File not initialized" );
            return getNumberOfLogicalUnitFile( _fileName.c_str() );
        };
};

#endif /* LOGICALUNITMANAGERCYTHON_H_ */
