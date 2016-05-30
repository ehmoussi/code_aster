#ifndef UNITARYTHERMALLOAD_H_
#define UNITARYTHERMALLOAD_H_

/**
 * @file UnitaryThermalLoad.h
 * @brief Fichier entete de la classe UnitaryThermalLoad
 * @author Jean-Pierre Lefebvre
 * @section LICENCE
 *   Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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

#include <stdexcept>
#include <list>
#include <string>
#include "astercxx.h"
#include "Utilities/CapyConvertibleValue.h"

/**
 * @class UnitaryThermalLoadInstance
 * @brief Classe definissant une charge thermique (issue d'AFFE_CHAR_THER)
 * @author Jean-Pierre Lefebvre
 */
class UnitaryThermalLoadInstance: public DataStructure
{
private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
    typedef std::vector< MeshEntityPtr > VectorMeshEntity;

    VectorMeshEntity _entity;

public:
    /**
     * @brief Constructeur
     */
    UnitaryThermalLoadInstance();

    void addGroupOfNodes( const std::string& nameOfGroup )
    {
        _entity.push_back( MeshEntityPtr( new GroupOfNodes( nameOfGroup ) ) );
    };
};

/**
 * @typedef UnitaryThermalLoad
 * @brief Pointeur intelligent vers un UnitaryThermalLoadInstance
 */
typedef boost::shared_ptr< UnitaryThermalLoadInstance > UnitaryThermalLoadPtr;
/** @typedef std::list de UnitaryThermalLoad */
typedef std::list< UnitaryThermalLoadPtr > ListKineLoad;
/** @typedef Iterateur sur une std::list de UnitaryThermalLoad */
typedef ListKineLoad::iterator ListKineLoadIter;
/** @typedef Iterateur constant sur une std::list de UnitaryThermalLoad */
typedef ListKineLoad::const_iterator ListKineLoadCIter;

#endif /* UNITARYTHERMALLOAD_H_ */
