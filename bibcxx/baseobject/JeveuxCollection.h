#ifndef JEVEUXCOLLECTION_HPP_
#define JEVEUXCOLLECTION_HPP_

#include "definition.h"
#include "baseobject/JeveuxTools.h"

#include <string>
#include <list>
#include <map>

using namespace std;

template<class ValueType>
class JeveuxCollectionObject
{
    private:
        //template<class ValueType> friend class JeveuxCollection;
        string     _collectionName;
        int        _numberInCollection;
        string     _nameOfObject;
        ValueType* _valuePtr;

    public:
        JeveuxCollectionObject(string collectionName, int number,
                               ValueType* ptr = NULL): _collectionName(collectionName),
                                                       _numberInCollection(number),
                                                       _nameOfObject(""),
                                                       _valuePtr(ptr)
        {};

        JeveuxCollectionObject(string collectionName, int number, string objectName,
                               ValueType* ptr = NULL): _collectionName(collectionName),
                                                       _numberInCollection(number),
                                                       _nameOfObject(objectName),
                                                       _valuePtr(ptr)
        {};
};

template<class ValueType>
class JeveuxCollectionInstance
{
    private:
        string _name;
        list< JeveuxCollectionObject<ValueType> > listObjects;
        typedef map< string, JeveuxCollectionObject<ValueType> > mapStrCollectionObject;

    public:
        JeveuxCollectionInstance(string name): _name(name)
        {};

        bool buildFromJeveux();

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

typedef JeveuxCollection<long> JeveuxCollectionLong;

#endif /* JEVEUXCOLLECTION_HPP_ */
