#ifndef COMMANDSYNTAX_H_
#define COMMANDSYNTAX_H_

/**
 * @file CommandSyntax.h
 * @brief Fichier entete permettant de decrire un bout de fichier de commande Aster
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

#ifdef __cplusplus

#include <stdexcept>
#include <list>
#include <vector>
#include <string>
#include <map>
#include <iostream>
#include <sstream>
#include <set>
#include <string.h>

#include "astercxx.h"
#include "DataStructure/DataStructure.h"

#include "definition.h"

extern "C"
{
    char* MakeBlankFStr( STRING_SIZE );
    void FreeStr( char * );
}

/**
* @todo compléter gettco dans aster_module.c (le type du résultat est mis en dur à UNKNOWN)
*/

/**
 * @class template SimpleKeyWord
 * @brief Classe permettant d'emuler un mot cle simple dans une commande
 * @author Nicolas Sellenet
 */
template<class ValueType>
class SimpleKeyWord
{
    public:
        typedef std::list< ValueType > listValue;
        typename std::list< ValueType >::iterator listValueIterator;
        typename std::list< ValueType >::value_type listValueValue;

    private:
        std::string    _simpleKeyWordName;
        bool           _isValueObject;
        listValue      _valuesList;

    public:
        /**
         * @brief Constructeur
         */
        SimpleKeyWord(): _simpleKeyWordName(""),
                         _isValueObject(false)
        {};

        /**
         * @brief Constructeur
         * @param nom Chaine contenant le nom du mot-cle simple
         *   ex : pour le mot-cle simple MAILLAGE, nom sera egale a
         *        'MAILLAGE'
         */
        SimpleKeyWord(std::string nom, bool concept = false): _simpleKeyWordName(nom),
                                                         _isValueObject(concept)
        {};

        /**
         * @brief Ajout d'une valeur au mot-cle simple
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

        std::string& keywordName()
        {
            return _simpleKeyWordName;
        };

        std::list< ValueType >& getListOfValues()
        {
            return _valuesList;
        };
};

typedef std::list< std::string > ListString;
typedef std::list< double > ListDouble;
typedef std::list< int > ListInteger;

typedef SimpleKeyWord< std::string > SimpleKeyWordStr;
typedef SimpleKeyWord< double > SimpleKeyWordDbl;
typedef SimpleKeyWord< int > SimpleKeyWordInt;

/**
 * @class FactorKeywordOccurence
 * @brief Classe permettant d'emuler une occurence d'un mot cle facteur dans une commande
 * @author Nicolas Sellenet
 */
class FactorKeywordOccurence
{
    private:
        std::list< SimpleKeyWordStr > _listSimpleKeywordsStr;
        std::list< SimpleKeyWordDbl > _listSimpleKeywordsDbl;
        std::list< SimpleKeyWordInt > _listSimpleKeywordsInt;
        std::set< std::string >       _setKeywordNames;

    public:
        /**
         * @brief Constructeur
         */
        FactorKeywordOccurence(): _listSimpleKeywordsStr( std::list< SimpleKeyWordStr >() ),
                                  _listSimpleKeywordsDbl( std::list< SimpleKeyWordDbl >() ),
                                  _listSimpleKeywordsInt( std::list< SimpleKeyWordInt >() )
        {};

        /**
         * @brief Ajout d'un mot cle simple ayant comme valeur une chaine a la commande en cours
         *   ex : GROUP_MA = 'TOTO'
         * @param motCle mot cle simple
         */
        void addSimpleKeywordString(SimpleKeyWordStr motCleAAjouter)
        {
            _listSimpleKeywordsStr.push_back(motCleAAjouter);
            _setKeywordNames.insert(motCleAAjouter.keywordName());
        };

        /**
         * @brief Ajout d'un mot cle simple ayant comme valeur un double a la commande en cours
         *   ex : NU = 0.4
         * @param motCle mot cle simple
         */
        void addSimpleKeywordDouble(SimpleKeyWordDbl motCleAAjouter)
        {
            _listSimpleKeywordsDbl.push_back(motCleAAjouter);
            _setKeywordNames.insert(motCleAAjouter.keywordName());
        };

        /**
         * @brief Ajout d'un mot cle simple ayant comme valeur un entier a la commande en cours
         *   ex : REAC_PRECOND = 3
         * @param motCle mot cle simple
         */
        void addSimpleKeywordInteger(SimpleKeyWordInt motCleAAjouter)
        {
            _listSimpleKeywordsInt.push_back(motCleAAjouter);
            _setKeywordNames.insert(motCleAAjouter.keywordName());
        };

        std::list< SimpleKeyWordStr >& getStringKeywordList()
        {
            return _listSimpleKeywordsStr;
        };

        std::list< SimpleKeyWordDbl >& getDoubleKeywordList()
        {
            return _listSimpleKeywordsDbl;
        };

        std::list< SimpleKeyWordInt >& getIntegerKeywordList()
        {
            return _listSimpleKeywordsInt;
        };

        bool isKeywordPresent(std::string motCle)
        {
            const std::set< std::string >::iterator retour = _setKeywordNames.find(motCle);
            if ( retour != _setKeywordNames.end() ) return true;
            return false;
        };

        bool isKeywordPresentDbl(std::string motCle)
        {
            std::list< SimpleKeyWordDbl >::iterator curIter;
            for ( curIter = _listSimpleKeywordsDbl.begin();
                  curIter != _listSimpleKeywordsDbl.end();
                  ++curIter )
            {
                if ( curIter->keywordName() == motCle ) return true;
            }
            return false;
        };

        bool isKeywordPresentInt(std::string motCle)
        {
            std::list< SimpleKeyWordInt >::iterator curIter;
            for ( curIter = _listSimpleKeywordsInt.begin();
                  curIter != _listSimpleKeywordsInt.end();
                  ++curIter )
            {
                if ( curIter->keywordName() == motCle ) return true;
            }
            return false;
        };

        bool isKeywordPresentStr(std::string motCle)
        {
            std::list< SimpleKeyWordStr >::iterator curIter;
            for ( curIter = _listSimpleKeywordsStr.begin();
                  curIter != _listSimpleKeywordsStr.end();
                  ++curIter )
            {
                if ( curIter->keywordName() == motCle ) return true;
            }
            return false;
        };

        ListString& stringValuesInKeyword(std::string motCle) throw ( std::runtime_error )
        {
            std::list< SimpleKeyWordStr >::iterator curIter;
            for ( curIter = _listSimpleKeywordsStr.begin();
                  curIter != _listSimpleKeywordsStr.end();
                  ++curIter )
            {
                if ( curIter->keywordName() == motCle ) break;
            }
            if ( curIter == _listSimpleKeywordsStr.end() )
                throw std::runtime_error( "Problem in CommandSyntax. " + motCle + "not found" );
            return curIter->getListOfValues();
        };

        ListDouble& doubleValuesInKeyword(std::string motCle) throw ( std::runtime_error )
        {
            std::list< SimpleKeyWordDbl >::iterator curIter;
            for ( curIter = _listSimpleKeywordsDbl.begin();
                  curIter != _listSimpleKeywordsDbl.end();
                  ++curIter )
            {
                if ( curIter->keywordName() == motCle ) break;
            }
            if ( curIter == _listSimpleKeywordsDbl.end() )
                throw std::runtime_error( "Problem in CommandSyntax. " + motCle + "not found" );
            return curIter->getListOfValues();
        };

        ListInteger& intValuesInKeyword(std::string motCle) throw ( std::runtime_error )
        {
            std::list< SimpleKeyWordInt >::iterator curIter;
            for ( curIter = _listSimpleKeywordsInt.begin();
                  curIter != _listSimpleKeywordsInt.end();
                  ++curIter )
            {
                if ( curIter->keywordName() == motCle ) break;
            }
            if ( curIter == _listSimpleKeywordsInt.end() )
                throw std::runtime_error( "Problem in CommandSyntax. " + motCle + "not found" );
            return curIter->getListOfValues();
        };
};

/**
 * @class FactorKeyword
 * @brief Classe permettant d'emuler un mot cle facteur dans une commande
 * @author Nicolas Sellenet
 */
class FactorKeyword
{
    private:
        const std::string                     _factorKeywordName;
        std::vector< FactorKeywordOccurence > _vectorOccurences;
        bool                                  _repetition;

    public:
        /**
         * @brief Constructeur
         * @param nom Chaine de caractere contenant le nom du mot cle facteur
         * @param repet booleen precisant si le mot cle facteur est repetable
         */
        FactorKeyword(std::string nom, bool repet = true): _factorKeywordName(nom), _repetition(repet)
        {};

        /**
         * @brief Ajout d'une occurence du mot cle facteur
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

        bool isKeywordPresent(std::string motCle)
        {
            bool trouve = false;
            std::vector< FactorKeywordOccurence >::iterator curIter = _vectorOccurences.begin();
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

        bool isDoubleKeywordPresentInOccurence( std::string motCle, int num )
        {
            if ( (unsigned int)num >= _vectorOccurences.size() ) return false;
            return _vectorOccurences[num].isKeywordPresentDbl( motCle );
        };

        bool isIntegerKeywordPresentInOccurence( std::string motCle, int num )
        {
            if ( (unsigned int)num >= _vectorOccurences.size() ) return false;
            return _vectorOccurences[num].isKeywordPresentInt( motCle );
        };

        bool isStringKeywordPresentInOccurence( std::string motCle, int num )
        {
            if ( (unsigned int)num >= _vectorOccurences.size() ) return false;
            return _vectorOccurences[num].isKeywordPresentStr( motCle );
        };

        bool isOccurencePresent(int num)
        {
            if ( (unsigned int)num < _vectorOccurences.size() ) return true;
            return false;
        };

        int numberOfOccurences() const
        {
            return _vectorOccurences.size();
        };

        const std::string& nom() const
        {
            return _factorKeywordName;
        };

        ListString& stringValuesInKeyword(int occurence, std::string motCle)
        {
            return _vectorOccurences[occurence].stringValuesInKeyword(motCle);
        };

        ListDouble& doubleValuesInKeyword(int occurence, std::string motCle)
        {
            return _vectorOccurences[occurence].doubleValuesInKeyword(motCle);
        };

        ListInteger& intValuesInKeyword(int occurence, std::string motCle)
        {
            return _vectorOccurences[occurence].intValuesInKeyword(motCle);
        };
};

class CommandSyntax;

extern CommandSyntax* commandeCourante;

/**
 * @class CommandSyntax
 * @brief Classe permettant d'emuler des "bouts" de fichier de commande.
 *         Permet l'utilisation des fonction GET*
 * @author Nicolas Sellenet
 */
class CommandSyntax
{
    private:
        typedef std::map< std::string, FactorKeyword > mapStrMCF;
        typedef std::map< std::string, FactorKeyword >::iterator mapStrMCFIterator;
        typedef mapStrMCF::value_type mapStrMCFValue;

        const std::string _commandName;
        mapStrMCF         _factorKeywordsMap;
        bool              _isOperateur;
        const std::string _nomObjetJeveux;
        const std::string _typeSDAster;

    public:
        /**
         * @brief Constructeur
         * @param nom Chaine correspondant au nom de la commande a emuler (ex : AFFE_MATERIAU)
         * @param operateur booleen indiquant sur la commande renvoit un objet
         *                  ex : LIRE_MAILLAGE : operateur = true
         *                  ex : IMPR_RESU     : operateur = false
         * @param nomObjet Chaine precisant le nom Jeveux de la sd produite
         *                 ex : MA = LIRE_MAILAGE : nomObjet = "MA      "
         */
        CommandSyntax(std::string nom, bool operateur,
                      std::string nomObjet = "", std::string typeObjet = "") throw ( std::runtime_error ):
                                                                    _commandName( nom ),
                                                                    _isOperateur( operateur ),
                                                                    _nomObjetJeveux( nomObjet ),
                                                                    _typeSDAster( typeObjet )
        {
            if ( commandeCourante != NULL )
                throw std::runtime_error( "Two objects CommandSyntax are not allowed in the same time" );
            _factorKeywordsMap.insert( mapStrMCFValue( std::string(""), FactorKeyword(" ", false) ) );
            mapStrMCFIterator curIter = _factorKeywordsMap.find(std::string(""));
            (*curIter).second.addOccurence(FactorKeywordOccurence());
            commandeCourante = this;
        };

        ~CommandSyntax()
        {
            commandeCourante = NULL;
        };

        bool isFactorKeywordPresent(std::string keywordName)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(keywordName);
            if ( curIter != _factorKeywordsMap.end() ) return true;
            return false;
        };

        bool isFactorKeywordPresent(std::string keywordName, int num)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(keywordName);
            if ( curIter != _factorKeywordsMap.end() )
            {
                return (*curIter).second.isOccurencePresent(num);
            }
            return false;
        };

        bool isFactorKeywordPresentSimpleKeyWord(std::string mCFac, std::string mcSim)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(mCFac);
            if ( curIter == _factorKeywordsMap.end() ) return false;
            return (*curIter).second.isKeywordPresent(mcSim);
        };

        bool isDoubleKeywordPresentInOccurence( std::string mCFac, std::string motCle, int num )
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(mCFac);
            return (*curIter).second.isDoubleKeywordPresentInOccurence(motCle, num);
        };

        bool isIntegerKeywordPresentInOccurence( std::string mCFac, std::string motCle, int num )
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(mCFac);
            return (*curIter).second.isIntegerKeywordPresentInOccurence(motCle, num);
        };

        bool isStringKeywordPresentInOccurence( std::string mCFac, std::string motCle, int num )
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(mCFac);
            return (*curIter).second.isStringKeywordPresentInOccurence(motCle, num);
        };

        FactorKeyword& getFactorKeyword(std::string keywordName)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(keywordName);
            return curIter->second;
        };

        /**
         * @brief Ajout d'un mot cle facteur a la commande en cours
         * @param motCle mot cle facteur a ajouter
         */
        bool addFactorKeyword(const FactorKeyword motCle)
        {
            _factorKeywordsMap.insert( mapStrMCFValue(motCle.nom(), motCle) );
            return true;
        };

        /**
         * @brief Ajout d'un mot cle simple ayant comme valeur un double a la commande en cours
         *   ex : DX = 0.
         * @param motCle mot cle simple a ajouter
         */
        bool addSimpleKeywordDouble(const SimpleKeyWordDbl motCle)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(std::string(""));
            (*curIter).second.getOccurence(0).addSimpleKeywordDouble(motCle);
            return true;
        };

        /**
         * @brief Ajout d'un mot cle simple ayant comme valeur un entier a la commande en cours
         * @param motCle mot cle simple a ajouter
         */
        bool addSimpleKeywordInteger(const SimpleKeyWordInt motCle)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(std::string(""));
            (*curIter).second.getOccurence(0).addSimpleKeywordInteger(motCle);
            return true;
        };

        /**
         * @brief Ajout d'un mot cle simple ayant comme valeur une chaine a la commande en cours
         *   ex : GROUP_MA = 'TOTO'
         * @param motCle mot cle simple a ajouter
         */
        bool addSimpleKeywordString(const SimpleKeyWordStr motCle)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(std::string(""));
            (*curIter).second.getOccurence(0).addSimpleKeywordString(motCle);
            return true;
        };

        ListString& stringValuesOfKeyword(std::string mCFac, int occurence, std::string mcSim)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(mCFac);
            return (*curIter).second.stringValuesInKeyword(occurence, mcSim);
        };

        ListDouble& doubleValuesOfKeyword(std::string mCFac, int occurence, std::string mcSim)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(mCFac);
            return (*curIter).second.doubleValuesInKeyword(occurence, mcSim);
        };

        ListInteger& intValuesOfKeyword(std::string mCFac, int occurence, std::string mcSim)
        {
            mapStrMCFIterator curIter = _factorKeywordsMap.find(mCFac);
            return (*curIter).second.intValuesInKeyword(occurence, mcSim);
        };

        const std::string& commandName()
        {
            return _commandName;
        };

        bool isOperateur()
        {
            return _isOperateur;
        };

        const std::string& getObjectName()
        {
            return _nomObjetJeveux;
        };

        const std::string& getTypeObjetResu()
        {
            return _typeSDAster;
        };
};

#else

extern void* commandeCourante;

#endif

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @fn getNomCommande
 * @brief Obtention du nom de la commande courante
 */
char* getNomCommande();

/**
 * @fn getNomObjetJeveux
 * @brief Obtention du nom Jeveux de l'objet produit par la commande
 */
char* getNomObjetJeveux();

/**
 * @fn getTypeObjetResu
 * @brief Obtention de type de sd produite par la commande
 */
char* getTypeObjetResu();

/**
 * @fn getSDType
 * @brief Obtention du type de la sd dont le nom est passe en argument
 */
char* getSDType(char*);

/**
 * @fn isCommandeOperateur
 * @brief Fonction permettant de savoir si une commande est un operateur
 */
int isCommandeOperateur();

/**
 * @fn nombreOccurencesMotCleFacteur
 */
int nombreOccurencesMotCleFacteur(char *);

/**
 * @fn presenceMotCle
 */
int presenceMotCle(char *, char *);

/**
 * @fn presenceMotCleFacteur
 */
int presenceMotCleFacteur(char *);

/**
 * @fn valeursMotCleChaine
 */
char** valeursMotCleChaine(char *, int, char *, int*);

/**
 * @fn valeursMotCleDouble
 */
double* valeursMotCleDouble(char*, int, char*, int*);

/**
 * @fn valeursMotCleInt
 */
int* valeursMotCleInt(char*, int, char*, int*);

#ifdef __cplusplus
}
#endif

#endif /* COMMANDSYNTAX_H_ */
