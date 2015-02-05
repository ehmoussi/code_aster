/**
 * @file CommandSyntax.cxx
 * @brief Implementation des commandes d'interrogation du fichier de commandes emule
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

#include <stdexcept>
#include "RunManager/CommandSyntax.h"
#include <stdlib.h>

CommandSyntax* commandeCourante = NULL;

char* getNomCommande()
{
    if ( commandeCourante == NULL ) return NULL;
    return const_cast< char* >( commandeCourante->commandName().c_str() );
};

char* getNomObjetJeveux()
{
    if ( commandeCourante == NULL ) return NULL;
    return const_cast< char* >( commandeCourante->getObjectName().c_str() );
};

char* getTypeObjetResu()
{
    if ( commandeCourante == NULL ) return NULL;
    return const_cast< char* >( commandeCourante->getTypeObjetResu().c_str() );
};

char* getSDType(char* nom)
{
    mapStrSDIterator curIter = mapNameDataStructure.find( string( nom, 0, 8 ) );
    if ( curIter == mapNameDataStructure.end() )
        throw std::runtime_error( "Problem !!!" );
    return const_cast< char* >( curIter->second->getType().c_str() );
};

int isCommandeOperateur()
{
    if ( commandeCourante == NULL ) return 0;
    if ( commandeCourante->isOperateur() ) return 1;
    return 0;
};

int listeMotCleSimpleFromMotCleFacteur(char* motCleFacteur, int occurence,
                                        int sizeKeywordName, int sizeTypeName,
                                        char*** motsClesSimples, char*** typeMotsCles,
                                        int* nbMotsCles)
{
    if ( ! commandeCourante->isFactorKeywordPresent( motCleFacteur, occurence ) )
        return 1;

    FactorKeyword curFK = commandeCourante->getFactorKeyword( motCleFacteur );
    FactorKeywordOccurence curOccur = curFK.getOccurence( occurence );

    list< SimpleKeyWordStr > listeMCChaines = curOccur.getStringKeywordList();
    list< SimpleKeyWordDbl > listeMCDoubles = curOccur.getDoubleKeywordList();
    list< SimpleKeyWordInt > listeMCEntiers = curOccur.getIntegerKeywordList();

    *nbMotsCles = listeMCChaines.size() + listeMCDoubles.size() + listeMCEntiers.size();
    *motsClesSimples = (char**)malloc( sizeof(char*)*(*nbMotsCles) );
    *typeMotsCles = (char**)malloc( sizeof(char*)*(*nbMotsCles) );

    int compteur = 0;
    for ( list< SimpleKeyWordStr >::iterator curIter = listeMCChaines.begin();
          curIter != listeMCChaines.end();
          ++curIter )
    {
        (*motsClesSimples)[compteur] = MakeBlankFStr( sizeKeywordName );
        strncpy((*motsClesSimples)[compteur], curIter->keywordName().c_str(), curIter->keywordName().size());

        (*typeMotsCles)[compteur] = MakeBlankFStr( sizeTypeName );
        if ( curIter->isValueObject() )
        {
            (*typeMotsCles)[compteur][0] = 'C';
            (*typeMotsCles)[compteur][1] = 'O';
        }
        else
        {
            (*typeMotsCles)[compteur][0] = 'T';
            (*typeMotsCles)[compteur][1] = 'X';
        }
        ++compteur;
    }

    for ( list< SimpleKeyWordDbl >::iterator curIter = listeMCDoubles.begin();
          curIter != listeMCDoubles.end();
          ++curIter )
    {
        (*motsClesSimples)[compteur] = MakeBlankFStr( sizeKeywordName );
        strncpy((*motsClesSimples)[compteur], curIter->keywordName().c_str(), curIter->keywordName().size());

        (*typeMotsCles)[compteur] = MakeBlankFStr( sizeTypeName );
        if ( curIter->isValueObject() )
        {
            (*typeMotsCles)[compteur][0] = 'C';
            (*typeMotsCles)[compteur][1] = 'O';
        }
        else
        {
            (*typeMotsCles)[compteur][0] = 'R';
            (*typeMotsCles)[compteur][1] = '8';
        }
        ++compteur;
    }

    for ( list< SimpleKeyWordInt >::iterator curIter = listeMCEntiers.begin();
          curIter != listeMCEntiers.end();
          ++curIter )
    {
        (*motsClesSimples)[compteur] = MakeBlankFStr( sizeKeywordName );
        strncpy((*motsClesSimples)[compteur], curIter->keywordName().c_str(), curIter->keywordName().size());

        (*typeMotsCles)[compteur] = MakeBlankFStr( sizeTypeName );
        if ( curIter->isValueObject() )
        {
            (*typeMotsCles)[compteur][0] = 'C';
            (*typeMotsCles)[compteur][1] = 'O';
        }
        else
        {
            (*typeMotsCles)[compteur][0] = 'I';
            (*typeMotsCles)[compteur][1] = 'S';
        }
        ++compteur;
    }
    return 0;
}

int nombreOccurencesMotCleFacteur(char* motCle)
{
    if ( commandeCourante == NULL ) return false;
    bool retour = commandeCourante->isFactorKeywordPresent( string(motCle) );
    if ( not retour ) return 0;
    FactorKeyword retour2 = commandeCourante->getFactorKeyword( string(motCle) );
    int nbOccur = retour2.numberOfOccurences();
    return nbOccur;
};

int presenceMotCle(char* motCleFacteur, char* motCleSimple)
{
    if ( commandeCourante == NULL ) return false;
    bool retour = commandeCourante->isFactorKeywordPresentSimpleKeyWord( string(motCleFacteur), string(motCleSimple) );
    if ( retour ) return 1;
    return 0;
};

int presenceMotCleFacteur(char* motCle)
{
    if ( commandeCourante == NULL ) return false;
    bool retour = commandeCourante->isFactorKeywordPresent( string(motCle) );
    if ( retour ) return 1;
    return 0;
};

char** valeursMotCleChaine(char* motCleFacteur, int occurence, char* motCleSimple, int* taille)
{
    if ( commandeCourante == NULL ) return NULL;
    int occBis = occurence - 1;
    if ( occurence == 0 ) occBis = occurence;

    if ( ! commandeCourante->isStringKeywordPresentInOccurence(motCleFacteur, motCleSimple, occBis) )
    {
        *taille = 0;
        return NULL;
    }

    ListString& retour = commandeCourante->stringValuesOfKeyword(string(motCleFacteur), occBis, string(motCleSimple));
    *taille = retour.size();
    if ( *taille == 0 ) return NULL;

    char** tabRetour = (char**)malloc(sizeof(char*)*(*taille));
    ListString::iterator iter;
    int compteur = 0;
    for ( iter = retour.begin();
          iter != retour.end();
          ++iter )
    {
        tabRetour[compteur] = const_cast< char* >(iter->c_str());
        ++compteur;
    }
    return tabRetour;
};

double* valeursMotCleDouble(char* motCleFacteur, int occurence, char* motCleSimple, int* taille)
{
    if ( commandeCourante == NULL ) return NULL;
    int occBis = occurence - 1;
    if ( occurence == 0 ) occBis = occurence;

    if ( ! commandeCourante->isDoubleKeywordPresentInOccurence(motCleFacteur, motCleSimple, occBis) )
    {
        *taille = 0;
        return NULL;
    }

    ListDouble& retour = commandeCourante->doubleValuesOfKeyword( motCleFacteur, occBis, motCleSimple );
    *taille = retour.size();
    if ( *taille == 0 ) return NULL;

    double* tabRetour = (double*)malloc(sizeof(double)*(*taille));
    ListDouble::iterator iter;
    int compteur = 0;
    for ( iter = retour.begin();
          iter != retour.end();
          ++iter )
    {
        tabRetour[compteur] = *iter;
        ++compteur;
    }
    return tabRetour;
};

int* valeursMotCleInt(char* motCleFacteur, int occurence, char* motCleSimple, int* taille)
{
    if ( commandeCourante == NULL ) return NULL;
    int occBis = occurence - 1;
    if ( occurence == 0 ) occBis = occurence;

    if ( ! commandeCourante->isIntegerKeywordPresentInOccurence(motCleFacteur, motCleSimple, occBis) )
    {
        *taille = 0;
        return NULL;
    }

    ListInteger& retour = commandeCourante->intValuesOfKeyword(string(motCleFacteur), occBis, string(motCleSimple));
    *taille = retour.size();
    if ( *taille == 0 ) return NULL;

    int* tabRetour = (int*)malloc(sizeof(int)*(*taille));
    ListInteger::iterator iter;
    int compteur = 0;
    for ( iter = retour.begin();
          iter != retour.end();
          ++iter )
    {
        tabRetour[compteur] = *iter;
        ++compteur;
    }
    return tabRetour;
};
