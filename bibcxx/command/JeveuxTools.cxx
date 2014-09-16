
#include "command/JeveuxTools.h"

int jeveux_status = 0;

StarterJeveux* initAster = NULL;

StarterJeveux::StarterJeveux(): syntaxeDebut(CommandSyntax("DEBUT", false, "")), _numberOfAsterObjects(-1)
{
//     bool a = true;
//     int b = 5;
//     while ( a )
//     {
//         b = 6;
//     }
    argsLDCEntiers.insert(mapLDCEntierValue(string("suivi_batch"), 0));
    argsLDCEntiers.insert(mapLDCEntierValue(string("dbgjeveux"), 0));

    argsLDCDoubles.insert(mapLDCDoubleValue(string("memory"), 1000.));
    argsLDCDoubles.insert(mapLDCDoubleValue(string("maxbase"), 1000.));

    argsLDCStrings.insert(mapLDCStringValue(string("repdex"), "."));

    FactorKeyword motCleCODE = FactorKeyword("CODE", false);
    FactorKeywordOccurence occurCODE = FactorKeywordOccurence();
    SimpleKeyWordStr mCSNivPubWeb = SimpleKeyWordStr("NIV_PUB_WEB");
    mCSNivPubWeb.addValues("NON");
    occurCODE.addSimpleKeywordStr(mCSNivPubWeb);
    motCleCODE.addOccurence(occurCODE);

    syntaxeDebut.addFactorKeyword(motCleCODE);

    FactorKeyword motCleMEMOIRE = FactorKeyword("MEMOIRE", false);
    FactorKeywordOccurence occurMEMOIRE = FactorKeywordOccurence();

    SimpleKeyWordDbl mCSTailleBloc = SimpleKeyWordDbl("TAILLE_BLOC");
    mCSTailleBloc.addValues(800.);
    occurMEMOIRE.addSimpleKeywordDouble(mCSTailleBloc);
    SimpleKeyWordInt mCSGrpElem = SimpleKeyWordInt("TAILLE_GROUP_ELEM");
    mCSGrpElem.addValues(1000);
    occurMEMOIRE.addSimpleKeywordInteger(mCSGrpElem);

    motCleMEMOIRE.addOccurence(occurMEMOIRE);
    syntaxeDebut.addFactorKeyword(motCleMEMOIRE);

    commandeCourante = &syntaxeDebut;
}

int StarterJeveux::getIntLDC(char* chaineQuestion)
{
    mapLDCEntierIterator curIter = argsLDCEntiers.find(string(chaineQuestion));
    if ( curIter == argsLDCEntiers.end() ) return 0;

    return curIter->second;
};

double StarterJeveux::getDoubleLDC(char* chaineQuestion)
{
    mapLDCDoubleIterator curIter = argsLDCDoubles.find(string(chaineQuestion));
    if ( curIter == argsLDCDoubles.end() ) return 0.;

    return curIter->second;
};

char* StarterJeveux::getChaineLDC(char* chaineQuestion)
{
    mapLDCStringIterator curIter = argsLDCStrings.find(string(chaineQuestion));
    if ( curIter == argsLDCStrings.end() ) return NULL;

    // ATTENTION UTILISATION DU CONST_CAST
    return const_cast< char* >(curIter->second.c_str());
};

void StarterJeveux::startJeveux()
{
    INTEGER dbg = 0;
    CALL_IBMAIN(&dbg);
    jeveux_status = 1;
    CALL_DEBUT();
}

void startJeveux()
{
    initAsterModules();
    initAster = new StarterJeveux();
    initAster->startJeveux();
}

int getIntLDC(char* chaineQuestion)
{
    return initAster->getIntLDC(chaineQuestion);
}

double getDoubleLDC(char* chaineQuestion)
{
    return initAster->getDoubleLDC(chaineQuestion);
}

char* getChaineLDC(char* chaineQuestion)
{
    return initAster->getChaineLDC(chaineQuestion);
}
