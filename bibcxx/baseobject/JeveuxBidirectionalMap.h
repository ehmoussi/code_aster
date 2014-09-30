#ifndef JEVEUXBIDIRECTIONALMAP_H_
#define JEVEUXBIDIRECTIONALMAP_H_

#include "command/Initializer.h"

using namespace std;

class JeveuxBidirectionalMapInstance
{
    private:
        string _jeveuxName;

    public:
        JeveuxBidirectionalMapInstance(string name): _jeveuxName(name)
        {};

        string findStringOfElement(long elementNumber);

        long findIntegerOfElement(string elementName);
};

class JeveuxBidirectionalMap
{
    public:
        typedef boost::shared_ptr< JeveuxBidirectionalMapInstance > JeveuxBidirectionalMapPtr;

    private:
        JeveuxBidirectionalMapPtr _jeveuxBidirectionalMapPtr;

    public:
        JeveuxBidirectionalMap(string nom):
            _jeveuxBidirectionalMapPtr( new JeveuxBidirectionalMapInstance (nom) )
        {};

        ~JeveuxBidirectionalMap()
        {};

        JeveuxBidirectionalMap& operator=(const JeveuxBidirectionalMap& tmp)
        {
            _jeveuxBidirectionalMapPtr = tmp._jeveuxBidirectionalMapPtr;
            return *this;
        };

        const JeveuxBidirectionalMapPtr& operator->(void) const
        {
            return _jeveuxBidirectionalMapPtr;
        };

        bool isEmpty() const
        {
            if ( _jeveuxBidirectionalMapPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* JEVEUXBIDIRECTIONALMAP_H_ */
