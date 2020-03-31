#ifndef JEVEUXOBJECT_H_
#define JEVEUXOBJECT_H_

/**
 * @file JeveuxObject.h
 * @brief Fichier entete de la classe JeveuxObject
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"
#include "shared_vars.h"
#include "aster_fort.h"

#include <string>

/**
 * @enum JeveuxMemory
 * @brief Fournit les types de memoire Jeveux
 */
enum JeveuxMemory { Permanent, Temporary };
/**
 * @def JeveuxTypesNames
 * @brief Fournit la lettre correspondant aux différentes base Jeveux
 */
static const std::string JeveuxMemoryTypesNames[2] = {"G", "V"};

/**
 * @class JeveuxObjectClass
 * @brief Cette classe permet de definir un objet Jeveux
 * @author Nicolas Sellenet
 */
class JeveuxObjectClass {
  protected:
    /** @brief Nom de l'objet Jeveux */
    std::string _name;
    /** @brief Mémoire d'allocation */
    JeveuxMemory _mem;

  public:
    /**
     * @brief Constructeur
     * @param name Nom jeveux du vecteur
     */
    JeveuxObjectClass( const std::string &nom, JeveuxMemory mem = Permanent )
        : _name( nom ), _mem( mem ){};

    /**
     * @brief Destructeur
     */
    ~JeveuxObjectClass() {
        if ( _name != "" && get_sh_jeveux_status() == 1 ) {
            CALLO_JEDETR( _name );
        }
    };

    bool exists() const {
        // Si on n'a pas de nom, on sort
        if ( _name == "" )
            return false;

        ASTERINTEGER boolRetour = 0;
        // Appel a jeexin pour verifier que le vecteur existe
        CALLO_JEEXIN( _name, &boolRetour );
        if ( boolRetour == 0 )
            return false;
        return true;
    };

    /**
     * @brief Return the name
     */
    std::string getName() const { return _name; };
};

#endif /* JEVEUXOBJECT_H_ */
