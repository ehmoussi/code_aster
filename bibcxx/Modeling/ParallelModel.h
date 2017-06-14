#ifndef PARALLELMODEL_H_
#define PARALLELMODEL_H_

/**
 * @file ParallelModel.h
 * @brief Fichier entete de la classe ParallelModel
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"
#include "Modeling/Model.h"
#include "Meshes/ParallelMesh.h"

/**
 * @class ParallelModelInstance
 * @brief Produit une sd identique a celle produite par AFFE_MODELE
 * @author Nicolas Sellenet
 */
class ParallelModelInstance: public BaseModelInstance
{
private:
    /** @brief Maillage sur lequel repose la modelisation */
    MeshPtr _supportMesh;

public:
    /**
     * @brief Forward declaration for the XFEM enrichment
     */
    typedef boost::shared_ptr< ParallelModelInstance > ParallelModelPtr;

    /**
     * @brief Construction (au sens Jeveux fortran) de la sd_modele
     * @return booleen indiquant que la construction s'est bien deroulee
     */
    bool build() throw ( std::runtime_error );

    /**
     * @brief Definition du maillage support
     * @param currentMesh objet MeshPtr sur lequel le modele reposera
     */
    bool setSupportMesh( ParallelMeshPtr& currentMesh ) throw ( std::runtime_error )
    {
        if ( currentMesh->isEmpty() )
            throw std::runtime_error( "Mesh is empty" );
        _supportMesh = currentMesh;
        _supportBaseMesh = currentMesh;
        return true;
    };
};


/**
 * @typedef ParallelModel
 * @brief Pointeur intelligent vers un ParallelModelInstance
 */
typedef boost::shared_ptr< ParallelModelInstance > ParallelModelPtr;

#endif /* PARALLELMODEL_H_ */
