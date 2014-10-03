
#include "command/CataBuilder.h"

/* person_in_charge: mathieu.courtois at edf.fr */

//TODO call execop(20)
#define CALL_OP0020() CALL0(OP0020, op0020)
extern "C"
{
    void DEF0(OP0020, op0020);
}

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
    CALL_OP0020();
}
