
#include "CommandSyntax.hpp"
#include <stdlib.h>

CommandSyntax* commandeCourante = NULL;

int presenceMotCleFacteur(char* motCle)
{
    if ( commandeCourante == NULL ) return false;
    bool retour = commandeCourante->isFactorKeywordPresent( string(motCle) );
    if ( retour ) return 1;
    return 0;
};

int presenceMotCle(char* motCleFacteur, char* motCleSimple)
{
    if ( commandeCourante == NULL ) return false;
    bool retour = commandeCourante->isFactorKeywordPresentSimpleKeyWord( string(motCleFacteur), string(motCleSimple) );
    if ( retour ) return 1;
    return 0;
};

char** valeursMotCleChaine(char* motCleFacteur, int occurence, char* motCleSimple, int* taille)
{
    if ( commandeCourante == NULL ) return NULL;
    int occBis = occurence - 1;
    if ( occurence == 0 ) occBis = occurence;
    ListString retour = commandeCourante->stringValuesOfKeyword(string(motCleFacteur), occBis, string(motCleSimple));
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
    ListDouble retour = commandeCourante->doubleValuesOfKeyword(string(motCleFacteur), occBis, string(motCleSimple));
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
    ListInt retour = commandeCourante->intValuesOfKeyword(string(motCleFacteur), occBis, string(motCleSimple));
    *taille = retour.size();
    if ( *taille == 0 ) return NULL;

    int* tabRetour = (int*)malloc(sizeof(int)*(*taille));
    ListInt::iterator iter;
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

int nombreOccurencesMotCleFacteur(char* motCle)
{
    if ( commandeCourante == NULL ) return false;
    bool retour = commandeCourante->isFactorKeywordPresent( string(motCle) );
    if ( not retour ) return 0;
    FactorKeyword retour2 = commandeCourante->getFactorKeyword( string(motCle) );
    int nbOccur = retour2.numberOfOccurences();
    return nbOccur;
};

char* getNomCommande()
{
    if ( commandeCourante == NULL ) return NULL;
    return const_cast< char* >( commandeCourante->commandName().c_str() );
};

int isCommandeOperateur()
{
    if ( commandeCourante == NULL ) return 0;
    if ( commandeCourante->isOperateur() ) return 1;
    return 0;
};

char* getNomObjetJeveux()
{
    if ( commandeCourante == NULL ) return NULL;
    return const_cast< char* >( commandeCourante->getObjectName().c_str() );
};
