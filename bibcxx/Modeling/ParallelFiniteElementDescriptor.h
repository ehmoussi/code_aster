
#include "astercxx.h"

#ifdef _USE_MPI

#ifndef PARALLELFINITEELEMENTDESCRIPTOR_H_
#define PARALLELFINITEELEMENTDESCRIPTOR_H_

/**
 * @file ParallelFiniteElementDescriptor.h
 * @brief Fichier entete de la classe ParallelFiniteElementDescriptor
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

#include "Modeling/Model.h"
#include "Modeling/FiniteElementDescriptor.h"
#include "Meshes/PartialMesh.h"
#include "ParallelUtilities/CommunicationGraph.h"

/**
 * @class ParallelFiniteElementDescriptorInstance
 * @brief Classe definissant un ligrel parallèle
 * @author Nicolas Sellenet
 */
class ParallelFiniteElementDescriptorInstance : public FiniteElementDescriptorInstance {
  protected:
    /** @brief Base FiniteElementDescriptor */
    const FiniteElementDescriptorPtr _BaseFEDesc;
    /** @brief Matching numbering between keeped delayed elements and base elements */
    VectorLong _delayedElemToKeep;
    /** @brief Join to send */
    std::vector< JeveuxVectorLong > _joinToSend;
    /** @brief Join to receive */
    std::vector< JeveuxVectorLong > _joinToReceive;
    /** @brief All joins */
    JeveuxVectorLong _joins;
    /** @brief Delayed nodes owner */
    JeveuxVectorLong _owner;
    /** @brief Number of elements in which a given node is located */
    JeveuxVectorLong _multiplicity;
    /** @brief Number of non local elements in which a given node is located */
    JeveuxVectorLong _outerMultiplicity;
    /** @brief Communication graph */
    CommunicationGraphPtr _commGraph;

  public:
    /**
     * @brief Constructeur
     */
    ParallelFiniteElementDescriptorInstance( const std::string &name,
                                             const FiniteElementDescriptorPtr &FEDesc,
                                             const PartialMeshPtr &mesh, const ModelPtr &model,
                                             const JeveuxMemory memType = Permanent );

    /**
     * @brief Get vector of delayed elements keeped from the base FiniteElementDescriptor
     * @return reference on VectorLong
     */
    const VectorLong &getDelayedElementsToKeep() const { return _delayedElemToKeep; };

    /**
     * @brief Get vector of joins between subdomains
     * @return reference on VectorLong
     */
    const JeveuxVectorLong &getJoins() const {
        _joins->updateValuePointer();
        return _joins;
    };

    /**
     * @typedef ParallelFiniteElementDescriptorPtr
     * @brief Pointeur intelligent vers un ParallelFiniteElementDescriptor
     */
    typedef boost::shared_ptr< ParallelFiniteElementDescriptorInstance >
        ParallelFiniteElementDescriptorPtr;
};

/**
 * @typedef ParallelFiniteElementDescriptorPtr
 * @brief Pointeur intelligent vers un ParallelFiniteElementDescriptorInstance
 */
typedef boost::shared_ptr< ParallelFiniteElementDescriptorInstance >
    ParallelFiniteElementDescriptorPtr;

#endif /* PARALLELFINITEELEMENTDESCRIPTOR_H_ */

#endif /* _USE_MPI */
