#ifndef MATCHINGMESHES_H_
#define MATCHINGMESHES_H_

/**
 * @file MatchingMeshes.h
 * @brief Fichier entete de la classe MatchingMeshes
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
#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "Supervis/ResultNaming.h"
#include "Meshes/Mesh.h"

/**
 * @class MatchingMeshesClass
 * @brief Cette classe decrit un corresp_2_mailla
 * @author Nicolas Sellenet
 */
class MatchingMeshesClass : public DataStructure {
  private:
    /** @brief Objet Jeveux '.PJXX_K1' */
    JeveuxVectorChar24 _pjxxK1;
    /** @brief Objet Jeveux '.PJEF_NB' */
    JeveuxVectorLong _pjefNb;
    /** @brief Objet Jeveux '.PJEF_NU' */
    JeveuxVectorLong _pjefNu;
    /** @brief Objet Jeveux '.PJEF_M1' */
    JeveuxVectorLong _pjefM1;
    /** @brief Objet Jeveux '.PJEF_CF' */
    JeveuxVectorDouble _pjefCf;
    /** @brief Objet Jeveux '.PJEF_TR' */
    JeveuxVectorLong _pjefTr;
    /** @brief Objet Jeveux '.PJEF_CO' */
    JeveuxVectorDouble _pjefCo;
    /** @brief Objet Jeveux '.PJEF_EL' */
    JeveuxVectorLong _pjefEl;
    /** @brief Objet Jeveux '.PJEF_MP' */
    JeveuxVectorChar8 _pjefMp;
    /** @brief Objet Jeveux '.PJNG_I1' */
    JeveuxVectorLong _pjngI1;
    /** @brief Objet Jeveux '.PJNG_I2' */
    JeveuxVectorLong _pjngI2;
    /** @brief Premier Maillage */
    BaseMeshPtr _firstBaseMesh;

  public:
    /**
     * @typedef MatchingMeshesPtr
     * @brief Pointeur intelligent vers un MatchingMeshesClass
     */
    typedef boost::shared_ptr< MatchingMeshesClass > MatchingMeshesPtr;

    /**
     * @brief Constructeur
     */
    MatchingMeshesClass( const std::string name = ResultNaming::getNewResultName() );

    bool setFirstMesh( MeshPtr &currentMesh ) {
        if ( currentMesh->isEmpty() )
            throw std::runtime_error( "Mesh is empty" );
        _firstBaseMesh = currentMesh;
        return true;
    };
};

/**
 * @typedef MatchingMeshesPtr
 * @brief Pointeur intelligent vers un MatchingMeshesClass
 */
typedef boost::shared_ptr< MatchingMeshesClass > MatchingMeshesPtr;

#endif /* MATCHINGMESHES_H_ */
