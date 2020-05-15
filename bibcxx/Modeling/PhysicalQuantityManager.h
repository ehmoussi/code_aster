#ifndef PHYSICALQUANTITYMANAGER_H_
#define PHYSICALQUANTITYMANAGER_H_

/**
 * @file PhysicalQuantityManager.h
 * @brief Fichier entete de la classe PhysicalQuantityManager
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

#include "astercxx.h"
#include "MemoryManager/JeveuxCollection.h"

template < typename T > class Singleton {
  public:
    static T &Class() {
        static T theSingleClass;
        return theSingleClass;
    }
};

/**
 * @class PhysicalQuantityManager
 * @brief Class to manage "catalogue" interactions
 * @author Nicolas Sellenet
 */
class PhysicalQuantityManager : public Singleton< PhysicalQuantityManager > {
  private:
    const JeveuxCollectionChar8 _nameOfCmp;
    const NamesMapChar8 _nameOfPhysicalQuantity;

    PhysicalQuantityManager();

  public:
    friend class Singleton< PhysicalQuantityManager >;

    const JeveuxCollectionObjectChar8 &
    getComponentNames( const ASTERINTEGER &quantityNumber ) const;

    ASTERINTEGER getNumberOfEncodedInteger( const ASTERINTEGER &quantityNumber ) const;

    std::string getPhysicalQuantityName( const ASTERINTEGER &quantityNumber ) const
        ;
};

#endif /* PHYSICALQUANTITYMANAGER_H_ */
