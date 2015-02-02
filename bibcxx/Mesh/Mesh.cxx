/**
 * @file Mesh.cxx
 * @brief Implementation de MeshInstance
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
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

// emulate_LIRE_MAILLAGE_MED.h is auto-generated and requires Mesh.h and Python.h
#include "Python.h"
#include "Mesh/Mesh.h"


MeshInstance::MeshInstance(): DataStructure( getNewResultObjectName(), "MAILLAGE" ),
                        _jeveuxName( getName() ),
                        _dimensionInformations( JeveuxVectorLong( string(_jeveuxName + ".DIME      ") ) ),
                        _nameOfNodes( JeveuxBidirectionalMap( string(_jeveuxName + ".NOMNOE    ") ) ),
                        _coordinates( FieldOnNodesPtrDouble(
                            new FieldOnNodesInstanceDouble( string(_jeveuxName + ".COORDO    ") ) ) ),
                        _groupsOfNodes( JeveuxCollectionLong( string(_jeveuxName + ".GROUPENO  ") ) ),
                        _connectivity( JeveuxCollectionLong( string(_jeveuxName + ".CONNEX    ") ) ),
                        _nameOfElements( JeveuxBidirectionalMap( string(_jeveuxName + ".NOMMAI    ") ) ),
                        _elementsType( JeveuxVectorLong( string(_jeveuxName + ".TYPMAIL   ") ) ),
                        _groupsOfElements( JeveuxCollectionLong( string(_jeveuxName + ".GROUPEMA  ") ) ),
                        _isEmpty( true )
{
    assert(_jeveuxName.size() == 8);
};

bool MeshInstance::readMEDFile( string pathFichier )
{
    INTEGER op = 1;
    CALL_EXECOP( &op );

    // Attention, la connection des objets a leur image JEVEUX n'est pas necessaire
    _dimensionInformations->updateValuePointer();
    _coordinates->updateValuePointers();
    _groupsOfNodes->buildFromJeveux();
    _connectivity->buildFromJeveux();
    _elementsType->updateValuePointer();
    _groupsOfElements->buildFromJeveux();
    _isEmpty = false;

    return true;
};
