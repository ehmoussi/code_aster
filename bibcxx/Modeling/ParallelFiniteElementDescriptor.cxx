/**
 * @file ParallelFiniteElementDescriptor.cxx
 * @brief Implementation de ParallelFiniteElementDescriptor
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

#include "Modeling/ParallelFiniteElementDescriptor.h"
#include "ParallelUtilities/MPIInfos.h"
#include <algorithm>

#ifdef _USE_MPI

ParallelFiniteElementDescriptorInstance::ParallelFiniteElementDescriptorInstance
    ( const std::string& name, const FiniteElementDescriptorPtr& FEDesc,
      const PartialMeshPtr& mesh, const ModelPtr& model, const JeveuxMemory memType ):
                    FiniteElementDescriptorInstance( name, memType ),
                    _BaseFEDesc( FEDesc )
{
    const int rank = getMPIRank();

    const auto& owner = mesh->getOwner();
    const auto& explorer = FEDesc->getDelayedElementsExplorer();

    VectorInt delayedElemToKeep;
    VectorInt meshNodesToKeep( owner->size(), -1 );
    long nbOldDelayedNodes = FEDesc->getNumberOfDelayedNodes();
    VectorInt _delayedElemToKeep( nbOldDelayedNodes, -1 );
    VectorInt delayedNodesToKeep( nbOldDelayedNodes, -1 );
    VectorInt delayedNodesNumbering( nbOldDelayedNodes, 0 );
    long nbDelayedNodes = 0, nbElemToKeep = 0, totalSizeToKeep = 0;
    // On commence par regarder les noeuds et elements qui doivent etre
    // gardes dans le nouveau ligrel
    for( const auto meshElem : explorer )
    {
        const auto& numElem = meshElem.getElementNumber();
        bool keepElem = false;
        int pos = 0;
        for( auto numNode : meshElem )
        {
            if( pos == 0 && numNode < 0 )
                throw std::runtime_error( "First node is assumed to be a physical node" );
            // Si on a un noeud physique...
            if( numNode > 0 )
            {
                const long num2 = numNode - 1;
                // ... et que le processeur courant le possede, on conserve ce noeud
                // et on conserve l'element
                if( (*owner)[ num2 ] == rank )
                {
                    keepElem = true;
                    meshNodesToKeep[ num2 ] = rank;
                    ++totalSizeToKeep;
                }
            }
            // Si on est sur un noeud tardif et qu'il faut conserver l'element
            // Alors on conserve les noeuds tardifs aussi
            if( numNode < 0 && keepElem )
            {
                delayedNodesToKeep[ -numNode - 1 ] = rank;
                delayedNodesNumbering[ -numNode - 1 ] = nbDelayedNodes;
                ++nbDelayedNodes;
                ++totalSizeToKeep;
            }
            ++pos;
        }
        // Si l'element est a conserver, on le note
        if( keepElem )
        {
            delayedElemToKeep.push_back( numElem );
            _delayedElemToKeep[ numElem-1 ] = nbElemToKeep;
            ++nbElemToKeep;
        }
    }

    // Si des noeuds tardifs sont a conserver, on peut creer le ligrel
    if( nbDelayedNodes > 0 )
    {
        auto nbPartialNodes = mesh->getNumberOfNodes();
        const auto& localNum = mesh->getLocalNumbering();
        const auto& pNodesComp = FEDesc->getPhysicalNodesComponentDescriptor();
        // Calcul du nombre d'entier code
        int nec = pNodesComp->size()/nbPartialNodes;

        // Allocation du .NEMA
        _delayedNumberedConstraintElementsDescriptor->allocateContiguous
            ( memType, nbElemToKeep, totalSizeToKeep+nbElemToKeep, Numbered );

        // Remplissage du .NEMA avec les elements tardifs a conserver
        int posInCollection = 1;
        for( int numElem : delayedElemToKeep )
        {
            const auto curElem = explorer[numElem];
            VectorLong toCopy;
            for( const auto& numNode : curElem )
            {
                if( numNode > 0 )
                    toCopy.push_back( (*localNum)[numNode-1] );
                else
                    toCopy.push_back( -delayedNodesNumbering[-numNode-1] - 1 );
            }
            toCopy.push_back( explorer[numElem].getType() );
            _delayedNumberedConstraintElementsDescriptor->allocateObject( toCopy.size() );
            _delayedNumberedConstraintElementsDescriptor->getObject( posInCollection ).setValues( toCopy );
            ++posInCollection;
        }

        const auto& liel = FEDesc->getListOfGroupOfElements();
        std::vector< VectorLong > toLiel( liel.size(), VectorLong() );
        int nbCollObj = 0, totalCollSize = 0;
        for( const auto& colObj : liel )
        {
            const long numInColl = colObj.getElementNumber();
            bool addedElem = false;
            for( const auto& val : colObj )
            {
                if( _delayedElemToKeep[-val-1] != -1 )
                {
                    toLiel[numInColl-1].push_back(-_delayedElemToKeep[-val-1]-1);
                    addedElem = true;
                    ++totalCollSize;
                }
            }
            if( addedElem )
            {
                toLiel[numInColl-1].push_back(colObj.getType());
                ++nbCollObj;
            }
        }

        _listOfGroupOfElements->allocateContiguous( memType, nbCollObj,
                                                    totalCollSize+nbCollObj, Numbered );
        posInCollection = 1;
        for( const auto& vec : toLiel )
        {
            if( vec.size() != 0 )
            {
                _listOfGroupOfElements->allocateObject( vec.size() );
                _listOfGroupOfElements->getObject( posInCollection ).setValues( vec );
                ++posInCollection;
            }
        }

        // Remplissage du .NBNO avec le nouveau nombre de noeuds tardifs
        _numberOfDelayedNumberedConstraintNodes->allocate( memType, 1 );
        (*_numberOfDelayedNumberedConstraintNodes)[0] = nbDelayedNodes;

        // Creation du .LGRF en y mettant les noms du maillage et modele d'origine
        _parameters->allocate( memType, 2 );
        const auto& pMesh = mesh->getParallelMesh();
        (*_parameters)[0] = pMesh->getName();
        (*_parameters)[1] = model->getName();
        /** @todo ajouter un assert sur le maillage sous-jacent au modele */

        // Creation des .LGNS et .PRNM
        // Recopie des valeurs sur les noeuds tardifs du nouveau ligrel
        _delayedNodesNumbering->allocate( memType, nbDelayedNodes+2 );
        _dofOfDelayedNumberedConstraintNodes->allocate( memType, nbDelayedNodes*nec );
        const auto& dNodesComp = FEDesc->getDelayedNodesComponentDescriptor();
        const auto& numbering = FEDesc->getDelayedNodesNumbering();
        for( long num = 0; num < nbOldDelayedNodes; ++num )
        {
            if( delayedNodesToKeep[ num ] == rank )
            {
                const long newNum = delayedNodesNumbering[ num ];
                for( int j = 0; j < nec; ++j )
                {
                    const int newPos = nec*newNum + j;
                    (*_dofOfDelayedNumberedConstraintNodes)[newPos] = (*dNodesComp)[num*nec+j];
                }
                (*_delayedNodesNumbering)[newNum] = (*numbering)[num];
            }
        }

        // Creation du .PRNM sur les noeuds du getParallelMesh
        // Recopie en position locale
        _dofDescriptor->allocate( memType, (pMesh->getNumberOfNodes())*nec );
        for( int i = 0; i < nbPartialNodes; ++i )
        {
            if( meshNodesToKeep[i] == rank )
                for( int j = 0; j < nec; ++j )
                {
                    const int newPos = nec*((*localNum)[i]-1) + j;
                    (*_dofDescriptor)[newPos] = (*pNodesComp)[i*nec+j];
                }
        }
    }
};

#endif /* _USE_MPI */
