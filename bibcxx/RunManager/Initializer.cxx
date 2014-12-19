/**
 * @file Initializer.cxx
 * @brief Implementation de la class Initializer
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
/*

    Initializer object of a Code_Aster execution

    It allows to set global parameters for the execution (as time and memory limits).
    Its main method `run()` initialize the memory manager (Jeveux).

    Its interface is not available in the Python namespace (no `.i`) because only a
    singleton instance is created (and must be callable from the fortran operators).

 */
/* person_in_charge: nicolas.sellenet at edf.fr */

#include "RunManager/Initializer.h"

int jeveux_status = 0;

int numOP = 0;

Initializer* initAster = NULL;

Initializer::Initializer(): _numberOfAsterObjects(0)
{
    // Definition en "dur" de quelques arguments de la ligne de commande
    argsLDCEntiers.insert(mapLDCEntierValue(string("suivi_batch"), 0));
    argsLDCEntiers.insert(mapLDCEntierValue(string("dbgjeveux"), 0));

    argsLDCDoubles.insert(mapLDCDoubleValue(string("memory"), 1000.));
    argsLDCDoubles.insert(mapLDCDoubleValue(string("maxbase"), 1000.));

    argsLDCStrings.insert(mapLDCStringValue(string("repdex"), "."));
}

void Initializer::initForCataBuilder( CommandSyntax& syntaxeDebut )
{
    FactorKeyword factCata = FactorKeyword("CATALOGUE", false);
    FactorKeywordOccurence occurCata = FactorKeywordOccurence();
    SimpleKeyWordStr kwFichier = SimpleKeyWordStr("FICHIER");
    kwFichier.addValues("CATAELEM");
    occurCata.addSimpleKeywordString(kwFichier);
    SimpleKeyWordInt kwUnite = SimpleKeyWordInt("UNITE");
    kwUnite.addValues(4);
    occurCata.addSimpleKeywordInteger(kwUnite);
    factCata.addOccurence(occurCata);

    syntaxeDebut.addFactorKeyword(factCata);
}

int Initializer::getIntLDC(char* chaineQuestion)
{
    mapLDCEntierIterator curIter = argsLDCEntiers.find(string(chaineQuestion));
    if ( curIter == argsLDCEntiers.end() ) return 0;

    return curIter->second;
};

double Initializer::getDoubleLDC(char* chaineQuestion)
{
    mapLDCDoubleIterator curIter = argsLDCDoubles.find(string(chaineQuestion));
    if ( curIter == argsLDCDoubles.end() ) return 0.;

    return curIter->second;
};

char* Initializer::getChaineLDC(char* chaineQuestion)
{
    mapLDCStringIterator curIter = argsLDCStrings.find(string(chaineQuestion));
    if ( curIter == argsLDCStrings.end() ) return NULL;

    // ATTENTION UTILISATION DU CONST_CAST
    return const_cast< char* >(curIter->second.c_str());
};

void Initializer::run( int imode )
{
    // Definition de la syntaxe de la commande DEBUT qui va initialiser le code
    CommandSyntax syntaxeDebut( "DEBUT", false, "" );
    FactorKeyword motCleCODE = FactorKeyword("CODE", false);
    FactorKeywordOccurence occurCODE = FactorKeywordOccurence();
    SimpleKeyWordStr mCSNivPubWeb = SimpleKeyWordStr("NIV_PUB_WEB");
    mCSNivPubWeb.addValues("NON");
    occurCODE.addSimpleKeywordString(mCSNivPubWeb);
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

    if ( imode == 1 ) initForCataBuilder( syntaxeDebut );

    // Appel a ibmain et a debut
    INTEGER dbg = 0;
    CALL_IBMAIN(&dbg);
    jeveux_status = 1;
    CALL_DEBUT();
}

// We define a `_init` function to keep a global `Initializer` object
void asterInitialization( int imode )
{
    initAsterModules();
    initAster = new Initializer();

    initAster->run( imode );
}

void asterFinalization()
{
    CommandSyntax syntaxeFin( "FIN", false, "" );
    SimpleKeyWordInt mCSStatut = SimpleKeyWordInt( "STATUT" );
    mCSStatut.addValues( 0 );
    syntaxeFin.addSimpleKeywordInteger( mCSStatut );
    CALL_EXECOP(9999);
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
