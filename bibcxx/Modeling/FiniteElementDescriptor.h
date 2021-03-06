#ifndef FINITEELEMENTDESCRIPTOR_H_
#define FINITEELEMENTDESCRIPTOR_H_

/**
 * @file FiniteElementDescriptor.h
 * @brief Fichier entete de la classe FiniteElementDescriptor
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
#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxCollection.h"
#include "Meshes/MeshExplorer.h"
#include "Meshes/BaseMesh.h"

class FiniteElementDescriptorClass;

/**
 * @typedef FiniteElementDescriptor
 * @brief Pointeur intelligent vers un FiniteElementDescriptorClass
 */
typedef boost::shared_ptr< FiniteElementDescriptorClass > FiniteElementDescriptorPtr;

/**
 * @class FiniteElementDescriptorClass
 * @brief Class which describes the finite elements
 * @author Nicolas Sellenet
 */
class FiniteElementDescriptorClass: public DataStructure
{
public:
    typedef MeshExplorer< CellsIteratorFromFiniteElementDescriptor,
                          const JeveuxCollectionLong& > ConnectivityDelayedElementsExplorer;

protected:
    /** @brief Vecteur Jeveux '.NBNO' */
    JeveuxVectorLong                          _numberOfDelayedNumberedConstraintNodes;
    /** @brief Vecteur Jeveux '.LGRF' */
    JeveuxVectorChar8                         _parameters;
    /** @brief Vecteur Jeveux '.PRNM' */
    JeveuxVectorLong                          _dofDescriptor;
    /** @brief Collection '.LIEL' */
    JeveuxCollectionLong                      _listOfGroupOfCells;
    /** @brief Vecteur Jeveux '.REPE' */
    JeveuxVectorLong                          _groupsOfCellsNumberByElement;
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
    /** @brief Object to loop over connectivity of delayed numbered cells */
    const ConnectivityDelayedElementsExplorer _explorer;
    /** @brief Object to loop over list of group of cells */
    const ConnectivityDelayedElementsExplorer _explorer2;

public:
    /**
     * @brief Constructeur
     */
    FiniteElementDescriptorClass( const std::string& name,
                                     const BaseMeshPtr mesh,
                                     const JeveuxMemory memType = Permanent );

    /**
     * @brief Destructor
     */
    ~FiniteElementDescriptorClass()
    {};

    /**
     * @typedef FiniteElementDescriptorPtr
     * @brief Pointeur intelligent vers un FiniteElementDescriptor
     */
    typedef boost::shared_ptr< FiniteElementDescriptorClass > FiniteElementDescriptorPtr;

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

    const ConnectivityDelayedElementsExplorer& getListOfGroupOfCells() const
    {
        _listOfGroupOfCells->buildFromJeveux();
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
     * this should be associated to a ConnectionMesh,
     * other should be associated to the parallelMesh of the ConnectionMesh */
    void transferDofDescriptorFrom( FiniteElementDescriptorPtr& );
#endif /* _USE_MPI */
};

#endif /* FINITEELEMENTDESCRIPTOR_H_ */
