
#include "RunManager/CataBuilder.h"

/* person_in_charge: mathieu.courtois at edf.fr */

CataBuilder::CataBuilder(): syntaxeMajCata(CommandSyntax("MAJ_CATA", false, ""))
{
    FactorKeyword motCleELEMENT = FactorKeyword("ELEMENT", false);
    FactorKeywordOccurence occurELEMENT = FactorKeywordOccurence();
    motCleELEMENT.addOccurence(occurELEMENT);
    syntaxeMajCata.addFactorKeyword(motCleELEMENT);

    commandeCourante = &syntaxeMajCata;
}


void CataBuilder::run()
{
    CALL_EXECOP(20);
}
