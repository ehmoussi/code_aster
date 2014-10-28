#ifndef COMMANDSYNTAX_H_
#define COMMANDSYNTAX_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#ifdef __cplusplus

#include <list>
#include <vector>
#include <string>
#include <map>
#include <iostream>
#include <sstream>
#include <set>
#include <string.h>

#include "DataStructure/DataStructure.h"

#include "definition.h"

extern "C"
{
    char* MakeBlankFStr( STRING_SIZE );
    void FreeStr( char * );
}

using namespace std;

/**
* class template SimpleKeyWord
*   Classe permettant d'emuler un mot cle simple dans une commande
* @author Nicolas Sellenet
*/
template<class ValueType>
class SimpleKeyWord
{
    public:
        typedef list< ValueType > listValue;
        typename list< ValueType >::iterator listValueIterator;
        typename list< ValueType >::value_type listValueValue;

    private:
        string    _simpleKeyWordName;
        bool      _isValueObject;
        listValue _valuesList;

    public:
        /**
        * Constructeur
        */
        SimpleKeyWord(): _simpleKeyWordName(""),
                         _isValueObject(false)
        {};

        /**
        * Constructeur
        * @param nom Chaine contenant le nom du mot-cle simple
        *   ex : pour le mot-cle simple MAILLAGE, nom sera egale a
        *        'MAILLAGE'
        */
        SimpleKeyWord(string nom, bool concept = false): _simpleKeyWordName(nom),
                                                         _isValueObject(concept)
        {};

        /**
        * Ajout d'une valeur au mot-cle simple
        * @param valeurAAjouter Valeur a ajouter
        *   ex : MAILLE = ('M1', 'M2')
        */
        void addValues(ValueType valeurAAjouter)
        {
            _valuesList.push_back(valeurAAjouter);
        };

        bool isValueObject()
        {
            return _isValueObject;
        };

        string& keywordName()
        {
            return _simpleKeyWordName;
        };

        list< ValueType >& getListOfValues()
        {
            return _valuesList;
        };
};

typedef list< string > ListString;
typedef list< double > ListDouble;
typedef list< int > ListInt;

typedef SimpleKeyWord< string > SimpleKeyWordStr;
typedef SimpleKeyWord< double > SimpleKeyWordDbl;
typedef SimpleKeyWord< int > SimpleKeyWordInt;

/**
* class FactorKeywordOccurence
*   Classe permettant d'emuler une occurence d'un mot cle facteur dans une commande
* @author Nicolas Sellenet
*/
class FactorKeywordOccurence
{
    private:
        list< SimpleKeyWordStr > _listSimpleKeywordsStr;
        list< SimpleKeyWordDbl > _listSimpleKeywordsDbl;
        list< SimpleKeyWordInt > _listSimpleKeywordsInt;
        set< string > _setKeywordNames;

    public:
        /**
        * Constructeur
        */
        FactorKeywordOccurence(): _listSimpleKeywordsStr( list< SimpleKeyWordStr >() ),
                                  _listSimpleKeywordsDbl( list< SimpleKeyWordDbl >() ),
                                  _listSimpleKeywordsInt( list< SimpleKeyWordInt >() )
        {};

        /**
        * Ajout d'un mot cle simple ayant comme valeur une chaine a la commande en cours
        *   ex : GROUP_MA = 'TOTO'
        * @param motCle mot cle simple
        */
        void addSimpleKeywordStr(SimpleKeyWordStr motCleAAjouter)
        {
            _listSimpleKeywordsStr.push_back(motCleAAjouter);
            _setKeywordNames.insert(motCleAAjouter.keywordName());
        };

        /**
        * Ajout d'un mot cle simple ayant comme valeur un double a la commande en cours
        *   ex : NU = 0.4
        * @param motCle mot cle simple
        */
        void addSimpleKeywordDouble(SimpleKeyWordDbl motCleAAjouter)
        {
            _listSimpleKeywordsDbl.push_back(motCleAAjouter);
            _setKeywordNames.insert(motCleAAjouter.keywordName());
        };

        /**
        * Ajout d'un mot cle simple ayant comme valeur un entier a la commande en cours
        *   ex : REAC_PRECOND = 3
        * @param motCle mot cle simple
        */
        void addSimpleKeywordInteger(SimpleKeyWordInt motCleAAjouter)
        {
            _listSimpleKeywordsInt.push_back(motCleAAjouter);
            _setKeywordNames.insert(motCleAAjouter.keywordName());
        };

        list< SimpleKeyWordStr >& getStringKeywordList()
        {
            return _listSimpleKeywordsStr;
        };

        list< SimpleKeyWordDbl >& getDoubleKeywordList()
        {
            return _listSimpleKeywordsDbl;
        };

        list< SimpleKeyWordInt >& getIntegerKeywordList()
        {
            return _listSimpleKeywordsInt;
        };

        bool isKeywordPresent(string motCle)
        {
            const set< string >::iterator retour = _setKeywordNames.find(motCle);
            if ( retour != _setKeywordNames.end() ) return true;
            return false;
        };

        bool isKeywordPresentDbl(string motCle)
        {
            list< SimpleKeyWordDbl >::iterator curIter;
            for ( curIter = _listSimpleKeywordsDbl.begin();
                  curIter != _listSimpleKeywordsDbl.end();
                  ++curIter )
            {
                if ( curIter->keywordName() == motCle ) return true;
            }
            return false;
        };

        bool isKeywordPresentInt(string motCle)
        {
            list< SimpleKeyWordInt >::iterator curIter;
            for ( curIter = _listSimpleKeywordsInt.begin();
                  curIter != _listSimpleKeywordsInt.end();
                  ++curIter )
            {
                if ( curIter->keywordName() == motCle ) return true;
            }
            return false;
        };

        bool isKeywordPresentStr(string motCle)
        {
            list< SimpleKeyWordStr >::iterator curIter;
            for ( curIter = _listSimpleKeywordsStr.begin();
                  curIter != _listSimpleKeywordsStr.end();
                  ++curIter )
            {
                if ( curIter->keywordName() == motCle ) return true;
            }
            return false;
        };

        ListString& stringValuesInKeyword(string motCle)
        {
            list< SimpleKeyWordStr >::iterator curIter;
            for ( curIter = _listSimpleKeywordsStr.begin();
                  curIter != _listSimpleKeywordsStr.end();
                  ++curIter )
            {
                if ( curIter->keywordName() == motCle ) break;
            }
            if ( curIter == _listSimpleKeywordsStr.end() )
                throw "Problem in CommandSyntax. " + motCle + "not found";
            return curIter->getListOfValues();
        };

        ListDouble& doubleValuesInKeyword(string motCle)
        {
            list< SimpleKeyWordDbl >::iterator curIter;
            for ( curIter = _listSimpleKeywordsDbl.begin();
                  curIter != _listSimpleKeywordsDbl.end();
                  ++curIter )
            {
                if ( curIter->keywordName() == motCle ) break;
            }
            if ( curIter == _listSimpleKeywordsDbl.end() )
                throw "Problem in CommandSyntax. " + motCle + "not found";
            return curIter->getListOfValues();
        };

        ListInt& intValuesInKeyword(string motCle)
        {
            list< SimpleKeyWordInt >::iterator curIter;
            for ( curIter = _listSimpleKeywordsInt.begin();
                  curIter != _listSimpleKeywordsInt.end();
                  ++curIter )
            {
                if ( curIter->keywordName() == motCle ) break;
            }
            if ( curIter == _listSimpleKeywordsInt.end() )
                throw "Problem in CommandSyntax. " + motCle + "not found";
            return curIter->getListOfValues();
        };
};

/**
* class FactorKeyword
*   Classe permettant d'emuler un mot cle facteur dans une commande
* @author Nicolas Sellenet
*/
class FactorKeyword
{
    private:
        const string _factorKeywordName;
        vector< FactorKeywordOccurence > _vectorOccurences;
        bool _repetition;

    public:
        /**
        * Constructeur
        * @param nom Chaine de caractere contenant le nom du mot cle facteur
        * @param repet booleen precisant si le mot cle facteur est repetable
        */
        FactorKeyword(string nom, bool repet = true): _factorKeywordName(nom), _repetition(repet)
        {};

        /**
        * Ajout d'une occurence du mot cle facteur
        * @param motCle mot cle facteur a ajouter
        */
        bool addOccurence(const FactorKeywordOccurence occur)
        {
            if ( _vectorOccurences.size() > 0 and _repetition == false ) return false;
            _vectorOccurences.push_back(occur);
            return true;
        };

        FactorKeywordOccurence& getOccurence(int numero)
        {
            return _vectorOccurences[numero];
        };

        bool isKeywordPresent(string motCle)
        {
            bool trouve = false;
            vector< FactorKeywordOccurence >::iterator curIter = _vectorOccurences.begin();
            for ( curIter = _vectorOccurences.begin();
                  curIter!= _vectorOccurences.end();
                  ++curIter )
            {
                if ( (*curIter).isKeywordPresent(motCle) )
                {
                    trouve = true;
                    break;
                }
            }
            return trouve;
        };

        bool isDoubleKeywordPresentInOccurence( string motCle, int num )
        {
            if ( num >= _vectorOccurences.size() ) return false;
            return _vectorOccurences[num].isKeywordPresentDbl( motCle );
        };

        bool isIntegerKeywordPresentInOccurence( string motCle, int num )
        {
            if ( num >= _vectorOccurences.size() ) return false;
            return _vectorOccurences[num].isKeywordPresentInt( motCle );
        };

        bool isStringKeywordPresentInOccurence( string motCle, int num )
        {
            if ( num >= _vectorOccurences.size() ) return false;
            return _vectorOccurences[num].isKeywordPresentStr( motCle );
        };

        bool isOccurencePresent(int num)
        {
            if ( num < _vectorOccurences.size() ) return true;
            return false;
        };

        int numberOfOccurences() const
        {
            return _vectorOccurences.size();
        };

        const string& nom() const
        {
            return _factorKeywordName;
        };

        ListString& stringValuesInKeyword(int occurence, string motCle)
        {
            return _vectorOccurences[occurence].stringValuesInKeyword(motCle);
        };

        ListDouble& doubleValuesInKeyword(int occurence, string motCle)
        {
            return _vectorOccurences[occurence].doubleValuesInKeyword(motCle);
        };

        ListInt& intValuesInKeyword(int occurence, string motCle)
        {
            return _vectorOccurences[occurence].intValuesInKeyword(motCle);
        };
};

/**
* class CommandSyntax
*   Classe permettant d'emuler des "bouts" de fichier de commande
*   afin de pouvoir appeler depuis le code fortran de Code_Aster
*   les routines GET*
* @author Nicolas Sellenet
*/
class CommandSyntax
{
    private:
        typedef map< string, FactorKeyword > mapStrMCF;
        typedef map< string, FactorKeyword >::iterator mapStrMCFIterator;
        typedef mapStrMCF::value_type mapStrMCFValue;

        const string _commandName;
        mapStrMCF    _factorKeywordsMap;
        bool         _isOperateur;
        const string _nomObjetJeveux;
        const string _typeSDAster;

    public:
        /**
        * Constructeur
        * @param nom Chaine correspondant au nom de la commande a emuler (ex : AFFE_MATERIAU)
        * @param operateur booleen indiquant sur la commande renvoit un objet
        *                  ex : LIRE_MAILLAGE : operateur = true
        *                  ex : IMPR_RESU     : operateur = false
        * @param nomObjet Chaine precisant le nom Jeveux de la sd produite
        *                 ex : MA = LIRE_MAILAGE : nomObjet = "MA      "
        */
        CommandSyntax(string nom, bool operateur,
                      string nomObjet = "", string typeObjet = ""): _commandName( nom ),
                                                                    _isOperateur( operateur ),
                                                                    _nomObjetJeveux( nomObjet ),
                                                                    _typeSDAster( typeObjet )
        {
            _factorKeywordsMap.insert( mapStrMCFValue( string(""), FactorKeyword(" ", false) ) );
            mapStrMCFIterator curIter = _factorKeywordsMap.find(string(""));
            (*curIter).second.addOccurence(FactorKeywordOccurence());
        };

        ~CommandSyntax()
        {};

        bool isFactorKeywordPresent(string keywordName)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(keywordName);
            if ( curIter != _factorKeywordsMap.end() ) return true;
            return false;
        };

        bool isFactorKeywordPresent(string keywordName, int num)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(keywordName);
            if ( curIter != _factorKeywordsMap.end() )
            {
                return (*curIter).second.isOccurencePresent(num);
            }
            return false;
        };

        bool isFactorKeywordPresentSimpleKeyWord(string mCFac, string mcSim)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(mCFac);
            if ( curIter == _factorKeywordsMap.end() ) return false;
            return (*curIter).second.isKeywordPresent(mcSim);
        };

        bool isDoubleKeywordPresentInOccurence( string mCFac, string motCle, int num )
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(mCFac);
            return (*curIter).second.isDoubleKeywordPresentInOccurence(motCle, num);
        };

        bool isIntegerKeywordPresentInOccurence( string mCFac, string motCle, int num )
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(mCFac);
            return (*curIter).second.isIntegerKeywordPresentInOccurence(motCle, num);
        };

        bool isStringKeywordPresentInOccurence( string mCFac, string motCle, int num )
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(mCFac);
            return (*curIter).second.isStringKeywordPresentInOccurence(motCle, num);
        };

        FactorKeyword& getFactorKeyword(string keywordName)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(keywordName);
            return curIter->second;
        };

        /**
        * Ajout d'un mot cle facteur a la commande en cours
        * @param motCle mot cle facteur a ajouter
        */
        bool addFactorKeyword(const FactorKeyword motCle)
        {
            _factorKeywordsMap.insert( mapStrMCFValue(motCle.nom(), motCle) );
            return true;
        };

        /**
        * Ajout d'un mot cle simple ayant comme valeur un double a la commande en cours
        *   ex : DX = 0.
        * @param motCle mot cle simple a ajouter
        */
        bool addSimpleKeywordDouble(const SimpleKeyWordDbl motCle)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(string(""));
            (*curIter).second.getOccurence(0).addSimpleKeywordDouble(motCle);
            return true;
        };

        /**
        * Ajout d'un mot cle simple ayant comme valeur un entier a la commande en cours
        * @param motCle mot cle simple a ajouter
        */
        bool addSimpleKeywordInteger(const SimpleKeyWordInt motCle)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(string(""));
            (*curIter).second.getOccurence(0).addSimpleKeywordInteger(motCle);
            return true;
        };

        /**
        * Ajout d'un mot cle simple ayant comme valeur une chaine a la commande en cours
        *   ex : GROUP_MA = 'TOTO'
        * @param motCle mot cle simple a ajouter
        */
        bool addSimpleKeywordStr(const SimpleKeyWordStr motCle)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(string(""));
            (*curIter).second.getOccurence(0).addSimpleKeywordStr(motCle);
            return true;
        };

        ListString& stringValuesOfKeyword(string mCFac, int occurence, string mcSim)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(mCFac);
            return (*curIter).second.stringValuesInKeyword(occurence, mcSim);
        };

        ListDouble& doubleValuesOfKeyword(string mCFac, int occurence, string mcSim)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(mCFac);
            return (*curIter).second.doubleValuesInKeyword(occurence, mcSim);
        };

        ListInt& intValuesOfKeyword(string mCFac, int occurence, string mcSim)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(mCFac);
            return (*curIter).second.intValuesInKeyword(occurence, mcSim);
        };

        const string& commandName()
        {
            return _commandName;
        };

        bool isOperateur()
        {
            return _isOperateur;
        };

        const string& getObjectName()
        {
            return _nomObjetJeveux;
        };

        const string& getTypeObjetResu()
        {
            return _typeSDAster;
        };
};

extern CommandSyntax* commandeCourante;

#else

extern void* commandeCourante;

#endif

#ifdef __cplusplus
extern "C" {
#endif

char* getNomCommande();

char* getNomObjetJeveux();

char* getTypeObjetResu();

char* getSDType(char*);

int isCommandeOperateur();

int listeMotCleSimpleFromMotCleFacteur(char *, int, int, int, char***, char***, int*);

int nombreOccurencesMotCleFacteur(char *);

int presenceMotCle(char *, char *);

int presenceMotCleFacteur(char *);

char** valeursMotCleChaine(char *, int, char *, int*);

double* valeursMotCleDouble(char*, int, char*, int*);

int* valeursMotCleInt(char*, int, char*, int*);

#ifdef __cplusplus
}
#endif

#endif /* COMMANDSYNTAX_H_ */
