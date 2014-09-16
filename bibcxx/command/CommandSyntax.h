#ifndef COMMANDSYNTAX_H_
#define COMMANDSYNTAX_H_

#ifdef __cplusplus

#include <list>
#include <vector>
#include <string>
#include <map>
#include <iostream>
#include <sstream>
#include <set>

using namespace std;

template<class ValueType>
class SimpleKeyWord
{
    public:
        typedef list< ValueType > listValue;
        typename list< ValueType >::iterator listValueIterator;
        typename list< ValueType >::value_type listValueValue;

    private:
        string _simpleKeyWordName;
        listValue _valuesList;

    public:
        SimpleKeyWord(string nom): _simpleKeyWordName(nom)
        {};

        void addValues(ValueType valeurAAjouter)
        {
            _valuesList.push_back(valeurAAjouter);
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

class FactorKeywordOccurence
{
    private:
        list< SimpleKeyWordStr > _listSimpleKeywordsStr;
        list< SimpleKeyWordDbl > _listSimpleKeywordsDbl;
        list< SimpleKeyWordInt > _listSimpleKeywordsInt;
        set< string > _setKeywordNames;

    public:
        FactorKeywordOccurence()
        {};

        void addSimpleKeywordStr(SimpleKeyWordStr motCleAAjouter)
        {
            _listSimpleKeywordsStr.push_back(motCleAAjouter);
            _setKeywordNames.insert(motCleAAjouter.keywordName());
        };

        void addSimpleKeywordDouble(SimpleKeyWordDbl motCleAAjouter)
        {
            _listSimpleKeywordsDbl.push_back(motCleAAjouter);
            _setKeywordNames.insert(motCleAAjouter.keywordName());
        };

        void addSimpleKeywordInteger(SimpleKeyWordInt motCleAAjouter)
        {
            _listSimpleKeywordsInt.push_back(motCleAAjouter);
            _setKeywordNames.insert(motCleAAjouter.keywordName());
        };

        bool isKeywordPresent(string motCle)
        {
            const set< string >::iterator retour = _setKeywordNames.find(motCle);
            if ( retour != _setKeywordNames.end() ) return true;
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
            return curIter->getListOfValues();
        };
};

class FactorKeyword
{
    private:
        const string _factorKeywordName;
        vector< FactorKeywordOccurence > _vectorOccurences;
        bool _repetition;

    public:
        FactorKeyword(string nom, bool repet = true): _factorKeywordName(nom), _repetition(repet)
        {};

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

class CommandSyntax
{
    private:
        typedef map< string, FactorKeyword > mapStrMCF;
        typedef map< string, FactorKeyword >::iterator mapStrMCFIterator;
        typedef mapStrMCF::value_type mapStrMCFValue;

        const string _commandName;
        mapStrMCF _FactorKeywordsMap;
        bool _isOperateur;
        const string _nomObjetJeveux;

    public:
        CommandSyntax(string nom, bool operateur, string nomObjet): _commandName(nom),
                                                                    _isOperateur(operateur),
                                                                    _nomObjetJeveux(nomObjet)
        {
            _FactorKeywordsMap.insert( mapStrMCFValue( string(""), FactorKeyword(" ", false) ) );
            mapStrMCFIterator curIter = _FactorKeywordsMap.find(string(""));
            (*curIter).second.addOccurence(FactorKeywordOccurence());
        };

        ~CommandSyntax()
        {
            cout << "Dtor CommandSyntax" << endl;
        };

        bool isFactorKeywordPresent(string keywordName)
        {
            mapStrMCFIterator curIter = _FactorKeywordsMap.find(keywordName);
            if ( curIter != _FactorKeywordsMap.end() ) return true;
            return false;
        };

        bool isFactorKeywordPresentSimpleKeyWord(string mCFac, string mcSim)
        {
            mapStrMCFIterator curIter = _FactorKeywordsMap.find(mCFac);
            if ( curIter == _FactorKeywordsMap.end() ) return false;
            return (*curIter).second.isKeywordPresent(mcSim);
        };

        const FactorKeyword& getFactorKeyword(string keywordName)
        {
            mapStrMCFIterator curIter = _FactorKeywordsMap.find(keywordName);
            return curIter->second;
        };

        bool addFactorKeyword(const FactorKeyword motCle)
        {
            _FactorKeywordsMap.insert( mapStrMCFValue(motCle.nom(), motCle) );
            return true;
        };

        bool addSimpleKeywordStr(const SimpleKeyWordStr motCle)
        {
            mapStrMCFIterator curIter = _FactorKeywordsMap.find(string(""));
            (*curIter).second.getOccurence(0).addSimpleKeywordStr(motCle);
            return true;
        };

        ListString& stringValuesOfKeyword(string mCFac, int occurence, string mcSim)
        {
            mapStrMCFIterator curIter = _FactorKeywordsMap.find(mCFac);
            return (*curIter).second.stringValuesInKeyword(occurence, mcSim);
        };

        ListDouble& doubleValuesOfKeyword(string mCFac, int occurence, string mcSim)
        {
            mapStrMCFIterator curIter = _FactorKeywordsMap.find(mCFac);
            return (*curIter).second.doubleValuesInKeyword(occurence, mcSim);
        };

        ListInt& intValuesOfKeyword(string mCFac, int occurence, string mcSim)
        {
            mapStrMCFIterator curIter = _FactorKeywordsMap.find(mCFac);
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
};

extern CommandSyntax* commandeCourante;

#else

extern void* commandeCourante;

#endif

#ifdef __cplusplus
extern "C" {
#endif

int presenceMotCleFacteur(char *);

int presenceMotCle(char *, char *);

char** valeursMotCleChaine(char *, int, char *, int*);

double* valeursMotCleDouble(char*, int, char*, int*);

int* valeursMotCleInt(char*, int, char*, int*);

int nombreOccurencesMotCleFacteur(char *);

char* getNomCommande();

int isCommandeOperateur();

char* getNomObjetJeveux();

#ifdef __cplusplus
}
#endif

#endif /* COMMANDSYNTAX_H_ */
