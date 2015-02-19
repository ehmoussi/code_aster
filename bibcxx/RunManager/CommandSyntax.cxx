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
    mapStrSDIterator curIter = mapNameDataStructure.find( std::string( nom, 0, 8 ) );
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

int nombreOccurencesMotCleFacteur(char* motCle)
{
    if ( commandeCourante == NULL ) return false;
    bool retour = commandeCourante->isFactorKeywordPresent( std::string(motCle) );
    if ( not retour ) return 0;
    FactorKeyword retour2 = commandeCourante->getFactorKeyword( std::string(motCle) );
    int nbOccur = retour2.numberOfOccurences();
    return nbOccur;
};

int presenceMotCle(char* motCleFacteur, char* motCleSimple)
{
    if ( commandeCourante == NULL ) return false;
    bool retour = commandeCourante->isFactorKeywordPresentSimpleKeyWord( std::string(motCleFacteur),
                                                                         std::string(motCleSimple) );
    if ( retour ) return 1;
    return 0;
};

int presenceMotCleFacteur(char* motCle)
{
    if ( commandeCourante == NULL ) return false;
    bool retour = commandeCourante->isFactorKeywordPresent( std::string(motCle) );
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

    ListString& retour = commandeCourante->stringValuesOfKeyword( std::string(motCleFacteur), occBis,
                                                                  std::string(motCleSimple) );
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

    ListInteger& retour = commandeCourante->intValuesOfKeyword( std::string(motCleFacteur), occBis,
                                                                std::string(motCleSimple) );
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
