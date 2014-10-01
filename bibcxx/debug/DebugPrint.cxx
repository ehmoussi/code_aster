
#include "definition.h"
#include "debug/DebugPrint.h"
#include "command/CommandSyntax.h"

#define CALL_OP0017() CALL0(OP0017, op0017)
extern "C"
{
    void DEF0(OP0017, op0017);
}

void jeveuxDebugPrint(string nomJeveux, int logicalUnit)
{
    // Definition du bout de fichier de commande correspondant a AFFE_MODELE
    CommandSyntax syntaxeImprCo( "IMPR_CO", false, "" );
    // Ligne indispensable pour que les commandes GET* fonctionnent
    commandeCourante = &syntaxeImprCo;

    FactorKeyword motCleCONCEPT = FactorKeyword( "CONCEPT", false );

    SimpleKeyWordStr mCSNom( "NOM" );
    mCSNom.addValues( nomJeveux.c_str() );

    FactorKeywordOccurence occurCONCEPT = FactorKeywordOccurence();
    occurCONCEPT.addSimpleKeywordStr( mCSNom );
    motCleCONCEPT.addOccurence( occurCONCEPT );

    syntaxeImprCo.addFactorKeyword( motCleCONCEPT );

    SimpleKeyWordInt mCSUnite( "UNITE" );
    mCSUnite.addValues( logicalUnit );
    syntaxeImprCo.addSimpleKeywordInteger( mCSUnite );

    SimpleKeyWordStr mCSBase( "BASE" );
    mCSBase.addValues( "G" );
    syntaxeImprCo.addSimpleKeywordStr( mCSBase );

    SimpleKeyWordInt mCSNiveau( "NIVEAU" );
    mCSNiveau.addValues( 2 );
    syntaxeImprCo.addSimpleKeywordInteger( mCSNiveau );

    SimpleKeyWordStr mCSContenu( "CONTENU" );
    mCSContenu.addValues( "OUI" );
    syntaxeImprCo.addSimpleKeywordStr( mCSContenu );

    SimpleKeyWordStr mCSAttr( "ATTRIBUT" );
    mCSAttr.addValues( "NON" );
    syntaxeImprCo.addSimpleKeywordStr( mCSAttr );

    CALL_OP0017();
    commandeCourante = NULL;
};
