
#include "RunManager/CataBuilder.h"

/* person_in_charge: mathieu.courtois at edf.fr */

void CataBuilder::run()
{
    CommandSyntax syntaxeMajCata( "MAJ_CATA", false, "" );
    FactorKeyword motCleELEMENT = FactorKeyword( "ELEMENT", false );
    FactorKeywordOccurence occurELEMENT = FactorKeywordOccurence();
    motCleELEMENT.addOccurence( occurELEMENT );
    syntaxeMajCata.addFactorKeyword( motCleELEMENT );

    CALL_EXECOP(20);
}
