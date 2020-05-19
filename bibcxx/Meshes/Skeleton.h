#ifndef SKELETON_H_
#define SKELETON_H_

/**
 * @file Skeleton.h
 * @brief Fichier entete de la classe Skeleton
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

#include "MemoryManager/JeveuxVector.h"
#include "Meshes/BaseMesh.h"

/**
 * @class SkeletonClass
 * @brief Cette classe correspond a une sd_squelette
 * @author Nicolas Sellenet
 */
class SkeletonClass : public BaseMeshClass {
  private:
    /** @brief Objet Jeveux '.INV.SKELETON' */
    JeveuxVectorLong _invSkeleton;
    /** @brief Objet Jeveux '.CORRES' */
    JeveuxVectorLong _corres;
    /** @brief Objet Jeveux '.NOMSST' */
    JeveuxVectorChar24 _nomSst;
    /** @brief Objet Jeveux '.ANGL_NAUT' */
    JeveuxVectorReal _anglNaut;
    /** @brief Objet Jeveux '.TRANS' */
    JeveuxVectorReal _trans;

  public:
    /**
     * @typedef SkeletonPtr
     * @brief Pointeur intelligent vers un SkeletonClass
     */
    typedef boost::shared_ptr< SkeletonClass > SkeletonPtr;

    /**
     * @brief Constructeur
     */
    SkeletonClass() : SkeletonClass( ResultNaming::getNewResultName() ){};

    /**
     * @brief Constructeur
     */
    SkeletonClass( const std::string &name )
        : BaseMeshClass( name, "SQUELETTE" ),
          _invSkeleton( JeveuxVectorLong( getName() + ".INV.SKELETON" ) ),
          _corres( JeveuxVectorLong( getName() + ".CORRES" ) ),
          _nomSst( JeveuxVectorChar24( getName() + ".NOMSST" ) ),
          _anglNaut( JeveuxVectorReal( getName() + ".ANGL_NAUT" ) ),
          _trans( JeveuxVectorReal( getName() + ".TRANS" ) ){};
};

/**
 * @typedef SkeletonPtr
 * @brief Pointeur intelligent vers un SkeletonClass
 */
typedef boost::shared_ptr< SkeletonClass > SkeletonPtr;

#endif /* SKELETON_H_ */
