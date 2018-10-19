#ifndef LOGICALUNITMANAGER_H_
#define LOGICALUNITMANAGER_H_

/**
 * @file LogicalUnitManagerCython.h
 * @brief Fichier entete permettant de decrire un fichier sur unité logique
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

// TODO: Refactor LogicalUnit.py in C++
#include "logical_unit.h"

enum FileTypeCython { Ascii, Binary, Free };
enum FileAccessCython { New, Append, Old };

/**
 * @class LogicalUnitFileCython
 * @brief This class is a mirror of class LogicalUnitFile in Python.
 * @author Nicolas Sellenet
 */
class LogicalUnitFileCython {
  private:
    /** @brief Nom du fichier */
    std::string _fileName;
    /** @brief Booleen pour savoir si un fichier est utilisable */
    bool _isUsable;
    /** @brief Associated logical unit */
    int _logicalUnit;

  public:
    /**
     * @brief Constructeur
     * @param name Nom du fichier
     * @param type type du fichier
     * @param access Accés au fichier
     */
    LogicalUnitFileCython() : _fileName( "" ), _isUsable( false ){};

    /**
     * @brief Constructeur
     * @param name Nom du fichier
     * @param type type du fichier
     * @param access Accés au fichier
     */
    LogicalUnitFileCython( const std::string name, const FileTypeCython type,
                           const FileAccessCython access )
        : _fileName( name ), _isUsable( true ) {
        _logicalUnit = openLogicalUnitFile( name.c_str(), type, access );
    };

    /**
     * @brief Destructeur
     */
    ~LogicalUnitFileCython() {
        if ( _isUsable )
            releaseLogicalUnitFile( _logicalUnit );
    };

    /**
     * @brief Recuperer le numéro d'unité logique correspondant
     * @return Unité logique
     */
    bool isUsable( void ) const { return _isUsable; };

    /**
     * @brief Recuperer le numéro d'unité logique correspondant
     * @return Unité logique
     */
    ASTERINTEGER getLogicalUnit( void ) const throw( std::runtime_error ) {
        if ( !_isUsable )
            throw std::runtime_error( "File not initialized" );
        return _logicalUnit;
    };
};

#endif /* LOGICALUNITMANAGER_H_ */
