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

// emulate_LIRE_MAILLAGE_MED.h is auto-generated and requires Mesh.h and Python.h
#include "Python.h"
#include "Mesh/Mesh.h"
#include "code_aster/Core/libEmulateForMesh.h"


MeshInstance::MeshInstance(): DataStructure( initAster->getNewResultObjectName(), "MAILLAGE" ),
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
    bool iret = emulateLIRE_MAILLAGE_MED( this );
    // Creation d'un bout de fichier commande correspondant a LIRE_MAILLAGE
    CommandSyntax syntaxeLireMaillage( "LIRE_MAILLAGE", true,
                                       initAster->getResultObjectName(), getType() );

    // Remplissage des mots cles simples FORMAT et PATHFICHIER
    SimpleKeyWordStr mCSFormat = SimpleKeyWordStr("FORMAT");
    mCSFormat.addValues("MED");
    // Ajout du premier mot cle simple
    syntaxeLireMaillage.addSimpleKeywordString(mCSFormat);

    LogicalUnitFile currentFile( pathFichier, Binary, Old );
    SimpleKeyWordInt mCSPath = SimpleKeyWordInt( "UNITE" );
    mCSPath.addValues( currentFile.getLogicalUnit() );
    syntaxeLireMaillage.addSimpleKeywordInteger( mCSPath );

    FactorKeyword motCleVeriMail = FactorKeyword( "VERI_MAIL", true );
    FactorKeywordOccurence occurVeriMail = FactorKeywordOccurence();
    SimpleKeyWordStr mCSVerif( "VERIF" );
    mCSVerif.addValues( "OUI" );
    occurVeriMail.addSimpleKeywordString( mCSVerif );
    SimpleKeyWordDbl mCSAplat( "APLAT" );
    mCSAplat.addValues( 1e-3 );
    occurVeriMail.addSimpleKeywordDouble( mCSAplat );
    motCleVeriMail.addOccurence( occurVeriMail );
    syntaxeLireMaillage.addFactorKeyword( motCleVeriMail );

    // Appel a l'operateur de LIRE_MAILLAGE
    CALL_EXECOP(1);

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
