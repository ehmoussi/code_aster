
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

    CALL_EXECOP(17);
};
