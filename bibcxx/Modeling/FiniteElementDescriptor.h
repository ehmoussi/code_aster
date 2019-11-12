#ifndef FINITEELEMENTDESCRIPTOR_H_
#define FINITEELEMENTDESCRIPTOR_H_

/**
 * @file FiniteElementDescriptor.h
 * @brief Fichier entete de la classe FiniteElementDescriptor
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

#include "astercxx.h"
#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxCollection.h"
#include "Meshes/MeshExplorer.h"
#include "Meshes/Mesh.h"

class FiniteElementDescriptorInstance;

/**
 * @typedef FiniteElementDescriptor
 * @brief Pointeur intelligent vers un FiniteElementDescriptorInstance
 */
typedef boost::shared_ptr< FiniteElementDescriptorInstance > FiniteElementDescriptorPtr;

/**
 * @class FiniteElementDescriptorInstance
 * @brief Class which describes the finite elements
 * @author Nicolas Sellenet
 */
class FiniteElementDescriptorInstance: public DataStructure
{
public:
    typedef MeshExplorer< ElementBuilderFromFiniteElementDescriptor,
                          const JeveuxCollectionLong& > ConnectivityDelayedElementsExplorer;

protected:
    /** @brief Vecteur Jeveux '.NBNO' */
    JeveuxVectorLong                          _numberOfDelayedNumberedConstraintNodes;
    /** @brief Vecteur Jeveux '.LGRF' */
    JeveuxVectorChar8                         _parameters;
    /** @brief Vecteur Jeveux '.PRNM' */
    JeveuxVectorLong                          _dofDescriptor;
    /** @brief Collection '.LIEL' */
    JeveuxCollectionLong                      _listOfGroupOfElements;
    /** @brief Vecteur Jeveux '.REPE' */
    JeveuxVectorLong                          _groupOfElementsNumberByElement;
    /** @brief Collection '.NEMA' */
    JeveuxCollectionLong                      _delayedNumberedConstraintElementsDescriptor;
    /** @brief Vecteur Jeveux '.PRNS' */
    JeveuxVectorLong                          _dofOfDelayedNumberedConstraintNodes;
    /** @brief Vecteur Jeveux '.LGNS' */
    JeveuxVectorLong                          _delayedNodesNumbering;
    /** @brief Vecteur Jeveux '.SSSA' */
    JeveuxVectorLong                          _superElementsDescriptor;
    /** @brief Vecteur Jeveux '.NVGE' */
    JeveuxVectorChar16                        _nameOfNeighborhoodStructure;
    /** @brief Base mesh */
    BaseMeshPtr                               _mesh;
    /** @brief Object to allow loop over connectivity of delayed numbered elements */
    const ConnectivityDelayedElementsExplorer _explorer;
    /** @brief Object to allow loop over list of group of elements */
    const ConnectivityDelayedElementsExplorer _explorer2;

public:
    /**
     * @brief Constructeur
     */
    FiniteElementDescriptorInstance( const std::string& name,
                                     const BaseMeshPtr mesh,
                                     const JeveuxMemory memType = Permanent );

    /**
     * @brief Destructor
     */
    ~FiniteElementDescriptorInstance()
    {};

    /**
     * @typedef FiniteElementDescriptorPtr
     * @brief Pointeur intelligent vers un FiniteElementDescriptor
     */
    typedef boost::shared_ptr< FiniteElementDescriptorInstance > FiniteElementDescriptorPtr;

    const ConnectivityDelayedElementsExplorer& getDelayedElementsExplorer() const
    {
        _delayedNumberedConstraintElementsDescriptor->buildFromJeveux();
        return _explorer;
    };

    const JeveuxVectorLong& getDelayedNodesComponentDescriptor() const
    {
        _dofOfDelayedNumberedConstraintNodes->updateValuePointer();
        return _dofOfDelayedNumberedConstraintNodes;
    };

    const JeveuxVectorLong& getDelayedNodesNumbering() const
    {
        _delayedNodesNumbering->updateValuePointer();
        return _delayedNodesNumbering;
    };

    const ConnectivityDelayedElementsExplorer& getListOfGroupOfElements() const
    {
        _listOfGroupOfElements->buildFromJeveux();
        return _explorer2;
    };

    ASTERINTEGER getNumberOfDelayedNodes() const
    {
        _numberOfDelayedNumberedConstraintNodes->updateValuePointer();
        return (*_numberOfDelayedNumberedConstraintNodes)[0];
    };

    JeveuxVectorChar8 getParameters() const
    {
        _parameters->updateValuePointer();
        return _parameters;
    };

    const JeveuxVectorLong& getPhysicalNodesComponentDescriptor() const
    {
        _dofDescriptor->updateValuePointer();
        return _dofDescriptor;
    };

    const BaseMeshPtr getMesh() const
    {
        return _mesh;
    };

    void setMesh( const BaseMeshPtr& currentMesh )
    {
        _mesh = currentMesh;
    };

#ifdef _USE_MPI
    /** @brief Transert .PRNM from other FiniteElementDescriptor.
     * this should be associated to a partialMesh,
     * other should be associated to the parallelMesh of the partialMesh */
    void transferDofDescriptorFrom( FiniteElementDescriptorPtr& );
#endif /* _USE_MPI */
};

#endif /* FINITEELEMENTDESCRIPTOR_H_ */
