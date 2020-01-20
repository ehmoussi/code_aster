#ifndef LOGICALUNITMANAGER_H_
#define LOGICALUNITMANAGER_H_

/**
 * @file LogicalUnitManager.h
 * @brief Fichier entete permettant de decrire un fichier sur unité logique
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
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

enum FileType { Ascii, Binary, Free };
enum FileAccess { New, Append, Old };

/**
 * @class LogicalUnitFile
 * @brief This class is a mirror of class LogicalUnitFile in Python.
 * @author Nicolas Sellenet
 */
class LogicalUnitFile {
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
    LogicalUnitFile() : _fileName( "" ), _isUsable( false ){};

    /**
     * @brief Constructeur
     * @param name Nom du fichier
     * @param type type du fichier
     * @param access Accés au fichier
     */
    LogicalUnitFile( const std::string name, const FileType type,
                           const FileAccess access )
        : _fileName( name ), _isUsable( true ) {
        _logicalUnit = openLogicalUnitFile( name.c_str(), type, access );
    };

    /**
     * @brief Destructeur
     */
    ~LogicalUnitFile() {
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
    ASTERINTEGER getLogicalUnit( void ) const {
        if ( !_isUsable )
            throw std::runtime_error( "File not initialized" );
        return _logicalUnit;
    };
};

#endif /* LOGICALUNITMANAGER_H_ */
