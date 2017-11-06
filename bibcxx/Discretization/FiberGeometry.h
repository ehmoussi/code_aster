#ifndef FIBERGEOMETRY_H_
#define FIBERGEOMETRY_H_

/**
 * @file FiberGeometry.h
 * @brief Fichier entete de la classe FiberGeometry
 * @author Nicolas Sellenet
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"
#include "definition.h"
#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxBidirectionalMap.h"

/**
 * @class FiberGeometryInstance
 * @brief Cette classe decrit la sd gfibre
 * @author Nicolas Sellenet
 */
class FiberGeometryInstance: public DataStructure
{
private:
    /** @brief Objet Jeveux '.NOMS_GROUPES' */
    JeveuxBidirectionalMapChar24 _nomsGroupes;
    /** @brief Objet Jeveux '.NB_FIBRE_GROUPE' */
    JeveuxVectorLong             _nbFibreGroupe;
    /** @brief Objet Jeveux '.POINTEUR' */
    JeveuxVectorLong             _pointeur;
    /** @brief Objet Jeveux '.TYPE_GROUPE' */
    JeveuxVectorLong             _typeGroupe;
    /** @brief Objet Jeveux '.CARFI' */
    JeveuxVectorDouble           _carfi;
    /** @brief Objet Jeveux '.GFMA' */
    JeveuxVectorChar8            _gfma;
    /** @brief Objet Jeveux '.CARACSD' */
    JeveuxVectorLong             _caracsd;

    /** @brief Booleen indiquant si le maillage est vide */
    bool                         _isEmpty;

public:
    /**
     * @typedef FiberGeometryPtr
     * @brief Pointeur intelligent vers un FiberGeometry
     */
    typedef boost::shared_ptr< FiberGeometryInstance > FiberGeometryPtr;

    /**
     * @brief Constructeur
     */
    static FiberGeometryPtr create()
    {
        return FiberGeometryPtr( new FiberGeometryInstance );
    };

    /**
     * @brief Constructeur
     */
    FiberGeometryInstance();

    /**
     * @brief Destructeur
     */
    ~FiberGeometryInstance()
    {};

    /**
     * @brief Fonction permettant de savoir si un maillage est vide (non relu par exemple)
     * @return retourne true si le maillage est vide
     */
    bool isEmpty() const
    {
        return _isEmpty;
    };
};



/**
 * @typedef FiberGeometryPtr
 * @brief Pointeur intelligent vers un FiberGeometryInstance
 */
typedef boost::shared_ptr< FiberGeometryInstance > FiberGeometryPtr;

#endif /* FIBERGEOMETRY_H_ */