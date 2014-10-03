#ifndef JEVEUXCOLLECTION_H_
#define JEVEUXCOLLECTION_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "definition.h"
#include "baseobject/JeveuxAllowedTypes.h"

#include <string>
#include <list>
#include <map>

using namespace std;

/**
* class template JeveuxCollectionObject
*   Cette classe permet de definir un objet de collection Jeveux
* @author Nicolas Sellenet
*/
template<class ValueType>
class JeveuxCollectionObject: private AllowedJeveuxType< ValueType >
{
    private:
        // Nom Jeveux de la collection
        string     _collectionName;
        // Position dans la collection
        int        _numberInCollection;
        // Nom de l'objet de collection
        string     _nameOfObject;
        // Pointeur vers le vecteur Jeveux
        ValueType* _valuePtr;

    public:
        /**
        * Constructeur
        * @param collectionName Nom de collection
        * @param number Numero de l'objet dans la collection
        * @param ptr Pointeur vers le vecteur Jeveux
        */
        JeveuxCollectionObject(string collectionName, int number,
                               ValueType* ptr = NULL): _collectionName(collectionName),
                                                       _numberInCollection(number),
                                                       _nameOfObject(""),
                                                       _valuePtr(ptr)
        {};

        /**
        * Constructeur
        * @param collectionName Nom de collection
        * @param number Numero de l'objet dans la collection
        * @param objectName Nom de l'objet de collection
        * @param ptr Pointeur vers le vecteur Jeveux
        */
        JeveuxCollectionObject(string collectionName, int number, string objectName,
                               ValueType* ptr = NULL): _collectionName(collectionName),
                                                       _numberInCollection(number),
                                                       _nameOfObject(objectName),
                                                       _valuePtr(ptr)
        {};
};

/**
* class template JeveuxCollectionInstance
*   Cette classe permet de definir une collection Jeveux
* @author Nicolas Sellenet
*/
template<class ValueType>
class JeveuxCollectionInstance
{
    private:
        // Nom de la collection
        string _name;
        // Listes de objets de collection
        list< JeveuxCollectionObject<ValueType> > listObjects;
        typedef map< string, JeveuxCollectionObject<ValueType> > mapStrCollectionObject;

    public:
        /**
        * Constructeur
        * @param name Chaine representant le nom de la collection
        */
        JeveuxCollectionInstance(string name): _name(name)
        {};

        /**
        * Methode permettant de construire une collection a partir d'une collection
        *   existante en memoire Jeveux
        * @return Renvoit true si la construction s'est bien deroulee
        */
        bool buildFromJeveux();

        /**
        * Methode verifiant l'existance d'un objet de collection dans la collection
        * @param name Chaine contenant le nom de l'objet
        * @return Renvoit true si l'objet existe dans la collection
        */
        bool existsObject(string name);
};

template<class ValueType>
bool JeveuxCollectionInstance<ValueType>::buildFromJeveux()
{
    listObjects.clear();
    long nbColObj, valTmp;
    // Attention const_cast
    const char* charName = _name.c_str();
    char* param = "NMAXOC";
    char* charval = MakeBlankFStr(32);
    // Attention rajouter des verifications d'existance
    CALL_JELIRA(charName, param, &nbColObj, charval);

    param = "ACCES ";
    CALL_JELIRA(charName, param, &valTmp, charval);
    string resu = string(charval,2);
    FreeStr(charval);

    bool named = false;
    if ( resu == "NO" ) named = true;

    const char* tmp = "L";
    charval = MakeBlankFStr(32);
    char* collectionObjectName = MakeBlankFStr(32);
    for ( long i = 1; i <= nbColObj; ++i )
    {
        ValueType* valuePtr;
        CALL_JEXNUM(charval, charName, &i);
        if ( named )
            CALL_JENUNO(charval, collectionObjectName);
        CALL_JEVEUOC(charval, tmp, (void*)(&valuePtr));
        if ( named )
            listObjects.push_back(JeveuxCollectionObject<ValueType>(charName, i, collectionObjectName, valuePtr));
        else
            listObjects.push_back(JeveuxCollectionObject<ValueType>(charName, i, valuePtr));
    }
    FreeStr(charval);
    FreeStr(collectionObjectName);
    return true;
};

template<class ValueType>
bool JeveuxCollectionInstance<ValueType>::existsObject(string name)
{
    const char* collName = _name.c_str();
    char* charJeveuxName = MakeBlankFStr(32);
    long returnBool;
    CALL_JEXNOM(charJeveuxName, collName, name.c_str());
    CALL_JEEXIN(charJeveuxName, &returnBool);
    if ( returnBool == 0 ) return false;
    return true;
};

/**
* class template JeveuxCollection
*   Enveloppe d'un pointeur intelligent vers un JeveuxCollectionInstance
* @author Nicolas Sellenet
*/
template<class ValueType>
class JeveuxCollection
{
    public:
        typedef boost::shared_ptr< JeveuxCollectionInstance< ValueType > > JeveuxCollectionTypePtr;

    private:
        JeveuxCollectionTypePtr _jeveuxCollectionPtr;

    public:
        JeveuxCollection(string nom): _jeveuxCollectionPtr( new JeveuxCollectionInstance< ValueType > (nom) )
        {};

        ~JeveuxCollection()
        {};

        JeveuxCollection& operator=(const JeveuxCollection< ValueType >& tmp)
        {
            _jeveuxCollectionPtr = tmp._jeveuxCollectionPtr;
        };

        const JeveuxCollectionTypePtr& operator->(void) const
        {
            return _jeveuxCollectionPtr;
        };

        bool isEmpty() const
        {
            if ( _jeveuxCollectionPtr.use_count() == 0 ) return true;
            return false;
        };
};

typedef JeveuxCollection< long > JeveuxCollectionLong;
typedef JeveuxCollection< short int > JeveuxCollectionShort;
typedef JeveuxCollection< double > JeveuxCollectionDouble;
typedef JeveuxCollection< double complex > JeveuxCollectionComplex;
typedef JeveuxCollection< char[8] > JeveuxCollectionChar8;
typedef JeveuxCollection< char[16] > JeveuxCollectionChar16;
typedef JeveuxCollection< char[24] > JeveuxCollectionChar24;
typedef JeveuxCollection< char[32] > JeveuxCollectionChar32;
typedef JeveuxCollection< char[80] > JeveuxCollectionChar80;

#endif /* JEVEUXCOLLECTION_H_ */
