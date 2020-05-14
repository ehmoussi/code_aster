/**
 * @file ParallelFiniteElementDescriptor.cxx
 * @brief Implementation de ParallelFiniteElementDescriptor
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

#include "Modeling/ParallelFiniteElementDescriptor.h"
#include "ParallelUtilities/MPIInfos.h"
#include <algorithm>

#ifdef _USE_MPI

ParallelFiniteElementDescriptorClass::ParallelFiniteElementDescriptorClass
    ( const std::string& name, const FiniteElementDescriptorPtr& FEDesc,
      const PartialMeshPtr& mesh, const ModelPtr& model, const JeveuxMemory memType ):
                    FiniteElementDescriptorClass( name, model->getMesh(), memType ),
                    _joins( JeveuxVectorLong( getName() + ".DOMJ" ) ),
                    _owner( JeveuxVectorLong( getName() + ".PNOE" ) ),
                    _multiplicity( JeveuxVectorLong( getName() + ".MULT" ) ),
                    _outerMultiplicity( JeveuxVectorLong( getName() + ".MUL2" ) )
{
    const int rank = getMPIRank();
    const int nbProcs = getMPINumberOfProcs();

    const auto& owner = *(mesh->getOwner());
    const auto& explorer = FEDesc->getDelayedElementsExplorer();

    VectorInt delayedElemToKeep;
    VectorInt meshNodesToKeep( owner.size(), -1 );
    ASTERINTEGER nbOldDelayedNodes = FEDesc->getNumberOfDelayedNodes();
    _delayedElemToKeep = VectorLong( explorer.size(), 1 );
    VectorInt delayedNodesToKeep( nbOldDelayedNodes, -1 );
    VectorInt delayedNodesNumbering( nbOldDelayedNodes, 0 );
    VectorInt delayedNodesMult( nbOldDelayedNodes, 0 );
    VectorInt delayedNodesOuterMult( nbOldDelayedNodes, 0 );
    VectorInt delayedNodesOwner( nbOldDelayedNodes, -1 );
    VectorInt nbOwnedDelayedNodes( nbProcs, 0 );
    std::vector< std::set< int > > sharedDelayedNodes( nbOldDelayedNodes );
    ASTERINTEGER nbDelayedNodes = 0, nbElemToKeep = 0, totalSizeToKeep = 0;
    // On commence par regarder les noeuds et elements qui doivent etre
    // gardes dans le nouveau ligrel
    for( const auto meshElem : explorer )
    {
        const auto& numElem = meshElem.getCellIndex();
        bool keepElem = false;
        int pos = 0, curOwner = -1;
        for( auto numNode : meshElem )
        {
            if( pos == 0 && numNode < 0 )
                throw std::runtime_error( "First node is assumed to be a physical node" );
            // Si on a un noeud physique...
            if( numNode > 0 )
            {
                const ASTERINTEGER num2 = numNode - 1;
                curOwner = owner[ num2 ];
                // ... et que le processeur courant le possede, on conserve ce noeud
                // et on conserve l'element
                if( curOwner == rank )
                {
                    keepElem = true;
                    meshNodesToKeep[ num2 ] = rank;
                    ++totalSizeToKeep;
                }
            }
            // Si on est sur un noeud tardif...
            if( numNode < 0 )
            {
                ++delayedNodesMult[ -numNode - 1 ];
                if( keepElem )
                {
                    // ... et qu'il faut conserver l'element
                    // Alors on conserve les noeuds tardifs aussi
                    if( delayedNodesToKeep[ -numNode - 1 ] == -1 )
                    {
                        delayedNodesNumbering[ -numNode - 1 ] = nbDelayedNodes;
                        ++nbDelayedNodes;
                    }
                    ++totalSizeToKeep;
                    delayedNodesToKeep[ -numNode - 1 ] = rank;
                }
                else
                    ++delayedNodesOuterMult[ -numNode - 1 ];
                // On cherche a equilibrer la charge des noeuds tardifs
                auto curOwner2 = delayedNodesOwner[ -numNode - 1 ];
                if( curOwner2 == -1 )
                {
                    delayedNodesOwner[ -numNode - 1 ] = curOwner;
                    ++nbOwnedDelayedNodes[ curOwner ];
                }
                else
                {
                    if( nbOwnedDelayedNodes[ curOwner2 ] > nbOwnedDelayedNodes[ curOwner ] )
                    {
                        delayedNodesOwner[ -numNode - 1 ] = curOwner;
                        ++nbOwnedDelayedNodes[ curOwner ];
                        --nbOwnedDelayedNodes[ curOwner2 ];
                    }
                }
                // On note tous les procs qui possèdent un noeud tardif
                sharedDelayedNodes[ -numNode - 1 ].insert( curOwner );
            }
            ++pos;
        }
        // Si l'element est a conserver, on le note
        if( keepElem )
        {
            delayedElemToKeep.push_back( numElem );
            _delayedElemToKeep[ numElem-1 ] = nbElemToKeep-1;
            --nbElemToKeep;
        }
    }

    auto nbPartialNodes = mesh->getNumberOfNodes();
    const auto& localNum = mesh->getLocalNumbering();
    const auto& pNodesComp = FEDesc->getPhysicalNodesComponentDescriptor();
    // Calcul du nombre d'entier code
    int nec = pNodesComp->size()/nbPartialNodes;
    // Si des noeuds tardifs sont a conserver, on peut creer le ligrel
    if( nbDelayedNodes > 0 )
    {
        _owner->allocate( Permanent, nbDelayedNodes );
        _multiplicity->allocate( Permanent, nbDelayedNodes );
        _outerMultiplicity->allocate( Permanent, nbDelayedNodes );
        int i = 0, nbJoins = 0, j = 0;
        std::vector< VectorLong > toSend( nbProcs );
        std::vector< VectorLong > toReceive( nbProcs );
        for( const auto& curSet : sharedDelayedNodes )
        {
            if( delayedNodesToKeep[i] == rank )
            {
                if( delayedNodesOwner[i] == rank )
                {
                    for( const auto& proc : curSet )
                        if( proc != rank )
                            toSend[proc].push_back(-delayedNodesNumbering[i]-1);
                }
                else
                {
                    toReceive[delayedNodesOwner[i]].push_back(-delayedNodesNumbering[i]-1);
                }
                (*_owner)[j] = delayedNodesOwner[i];
                (*_outerMultiplicity)[j] = delayedNodesOuterMult[i];
                (*_multiplicity)[j] = delayedNodesMult[i];
                ++j;
            }
            ++i;
        }
        if( j != nbDelayedNodes )
            throw std::runtime_error( "Out of bound error" );

        // Creation des raccords
        VectorLong joins;
        for( i = 0; i < nbProcs; ++i )
        {
            const auto& taille1 = toSend[i].size();
            if( taille1 != 0 )
            {
                auto vec = JeveuxVectorLong( getName() + ".E" + std::to_string( i ) );
                _joinToSend.push_back( vec );
                (*vec) = toSend[i];
                joins.push_back(i);
            }
            const auto& taille2 = toReceive[i].size();
            if( taille2 != 0 )
            {
                auto vec = JeveuxVectorLong( getName() + ".R" + std::to_string( i ) );
                _joinToReceive.push_back( vec );
                (*vec) = toReceive[i];
                joins.push_back(i);
            }
        }
        *(_joins) = joins;

        // Allocation du .NEMA
        _delayedNumberedConstraintElementsDescriptor->allocateContiguous
            ( memType, -nbElemToKeep, totalSizeToKeep-nbElemToKeep, Numbered );

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
            _delayedNumberedConstraintElementsDescriptor->getObject( posInCollection ).setValues(
                toCopy );
            ++posInCollection;
        }

        const auto& liel = FEDesc->getListOfGroupOfCells();
        int nbCollObj = 0, totalCollSize = 0;
        std::vector< VectorLong > toLiel( liel.size(), VectorLong() );
        ASTERINTEGER type = 0;
        nbCollObj = 1;
        for( const auto& colObj : liel )
        {
            const ASTERINTEGER numInColl = colObj.getCellIndex();
            bool addedElem = false;
            for( const auto& val : colObj )
            {
                if( _delayedElemToKeep[-val-1] != 1 )
                {
                    toLiel[nbCollObj-1].push_back(_delayedElemToKeep[-val-1]);
                    addedElem = true;
                    ++totalCollSize;
                }
            }
            if( addedElem )
            {
                type = colObj.getType();
                toLiel[nbCollObj-1].push_back(type);
                ++nbCollObj;
            }
        }

        _listOfGroupOfCells->allocateContiguous( memType, nbCollObj,
                                                    totalCollSize+nbCollObj, Numbered );
        posInCollection = 1;
        for( const auto& vec : toLiel )
        {
            if( vec.size() != 0 )
            {
                _listOfGroupOfCells->allocateObject( vec.size() );
                _listOfGroupOfCells->getObject( posInCollection ).setValues( vec );
                ++posInCollection;
            }
        }
    }
    else
        _listOfGroupOfCells->allocateContiguous( memType, 1, 1, Numbered );

    // Remplissage du .NBNO avec le nouveau nombre de noeuds tardifs
    _numberOfDelayedNumberedConstraintNodes->allocate( memType, 1 );
    (*_numberOfDelayedNumberedConstraintNodes)[0] = nbDelayedNodes;

    const auto param = FEDesc->getParameters();
    // Creation du .LGRF en y mettant les noms du maillage et modele d'origine
    _parameters->allocate( memType, 3 );
    const auto& pMesh = mesh->getParallelMesh();
    (*_parameters)[0] = pMesh->getName();
    (*_parameters)[1] = model->getName();
    (*_parameters)[2] = (*param)[2];
    auto docu = FEDesc->getParameters()->getInformationParameter();
    _parameters->setInformationParameter( docu );
    /** @todo ajouter un assert sur le maillage sous-jacent au modele */

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
    if( nbDelayedNodes > 0 )
    {
        // Creation des .LGNS et .PRNM
        // Recopie des valeurs sur les noeuds tardifs du nouveau ligrel
        _delayedNodesNumbering->allocate( memType, nbDelayedNodes+2 );
        _dofOfDelayedNumberedConstraintNodes->allocate( memType, nbDelayedNodes*nec );
        const auto& dNodesComp = FEDesc->getDelayedNodesComponentDescriptor();
        const auto& numbering = FEDesc->getDelayedNodesNumbering();
        for( ASTERINTEGER num = 0; num < nbOldDelayedNodes; ++num )
        {
            if( delayedNodesToKeep[ num ] == rank )
            {
                const ASTERINTEGER newNum = delayedNodesNumbering[ num ];
                for( int j = 0; j < nec; ++j )
                {
                    const int newPos = nec*newNum + j;
                    (*_dofOfDelayedNumberedConstraintNodes)[newPos] = (*dNodesComp)[num*nec+j];
                }
                (*_delayedNodesNumbering)[newNum] = (*numbering)[num];
            }
        }
    }
    _commGraph = CommunicationGraphPtr( new CommunicationGraph( getName(), getJoins() ) );
};

#endif /* _USE_MPI */
