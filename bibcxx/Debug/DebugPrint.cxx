/**
 * @file DebugPrint.cxx
 * @brief Implementation de l'impression debug des sd Aster
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

#include "definition.h"
#include "Debug/DebugPrint.h"
#include "RunManager/CommandSyntax.h"

void jeveuxDebugPrint( const DataStructure& dataSt, const int logicalUnit )
{
    // Definition du bout de fichier de commande correspondant a AFFE_MODELE
    CommandSyntax syntaxeImprCo( "IMPR_CO", false, "" );

    FactorKeyword motCleCONCEPT = FactorKeyword( "CONCEPT", false );

    const string nomJeveux = dataSt.getName();
    SimpleKeyWordStr mCSNom( "NOM" );
    mCSNom.addValues( nomJeveux.c_str() );

    FactorKeywordOccurence occurCONCEPT = FactorKeywordOccurence();
    occurCONCEPT.addSimpleKeywordString( mCSNom );
    motCleCONCEPT.addOccurence( occurCONCEPT );

    syntaxeImprCo.addFactorKeyword( motCleCONCEPT );

    SimpleKeyWordInt mCSUnite( "UNITE" );
    mCSUnite.addValues( logicalUnit );
    syntaxeImprCo.addSimpleKeywordInteger( mCSUnite );

    SimpleKeyWordStr mCSBase( "BASE" );
    mCSBase.addValues( "G" );
    syntaxeImprCo.addSimpleKeywordString( mCSBase );

    SimpleKeyWordInt mCSNiveau( "NIVEAU" );
    mCSNiveau.addValues( 2 );
    syntaxeImprCo.addSimpleKeywordInteger( mCSNiveau );

    SimpleKeyWordStr mCSContenu( "CONTENU" );
    mCSContenu.addValues( "OUI" );
    syntaxeImprCo.addSimpleKeywordString( mCSContenu );

    SimpleKeyWordStr mCSAttr( "ATTRIBUT" );
    mCSAttr.addValues( "NON" );
    syntaxeImprCo.addSimpleKeywordString( mCSAttr );

    INTEGER op = 17;
    CALL_EXECOP( &op );
};
