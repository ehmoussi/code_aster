#ifndef ASTERMESH_H_
#define ASTERMESH_H_

#include "definition.h"
#include "baseobject/JeveuxTools.h"
#include "baseobject/JeveuxCollection.h"
#include "baseobject/JeveuxBidirectionalMap.h"
#include "userobject/FieldOnNodes.h"
#include <assert.h>

class AsterMeshEntity
{
    private:
        const string            _name;
        JeveuxCollectionLong    _groupsOfEntities;

    public:
        AsterMeshEntity(string name, JeveuxCollectionLong& grpOfEntities): _name(name),
                                                                           _groupsOfEntities(grpOfEntities)
        {
            if ( ! _groupsOfEntities->existsObject(name) )
                throw string("Group " + name + " not in mesh");
        };

        const string& getEntityName()
        {
            return _name;
        };
};

class AsterGroupOfNodes: AsterMeshEntity
{
    public:
        AsterGroupOfNodes(string name, JeveuxCollectionLong& grpOfNodes):
            AsterMeshEntity(name, grpOfNodes)
        {};
};

class AsterGroupOfElements: AsterMeshEntity
{
    public:
        AsterGroupOfElements(string name, JeveuxCollectionLong& grpOfElements):
            AsterMeshEntity(name, grpOfElements)
        {};
};

class AsterMeshInstance
{
    private:
        friend class AsterMeshEntity;
        const string           _jeveuxName;
        JeveuxVectorLong       _dimensionInformations;
        JeveuxBidirectionalMap _nameOfNodes;
        FieldOnNodesDouble     _coordinates;
        JeveuxCollectionLong   _groupsOfNodes;
        JeveuxCollectionLong   _connectivity;
        JeveuxBidirectionalMap _nameOfElements;
        JeveuxVectorLong       _elementsType;
        JeveuxCollectionLong   _groupsOfElements;
        bool                   _isEmpty;

    public:
        AsterMeshInstance();

        ~AsterMeshInstance()
        {};

        const string& getJeveuxName() const
        {
            return _jeveuxName;
        };

        const FieldOnNodesDouble &getCoordinates() const
        {
            return _coordinates;
        };

        const AsterGroupOfElements getGroupOfElements(string name)
        {
            return AsterGroupOfElements(name, this->_groupsOfElements);
        };

        const AsterGroupOfNodes getGroupOfNodes(string name)
        {
            return AsterGroupOfNodes(name, this->_groupsOfNodes);
        };

        bool isEmpty() const
        {
            return _isEmpty;
        };

        bool readMEDFile(char*);
};

class AsterMesh
{
    public:
        typedef boost::shared_ptr< AsterMeshInstance > AsterMeshPtr;

    private:
        AsterMeshPtr _asterMeshPtr;

    public:
        AsterMesh(bool initilisation = true): _asterMeshPtr()
        {
            if ( initilisation == true )
                _asterMeshPtr = AsterMeshPtr( new AsterMeshInstance() );
        };

        ~AsterMesh()
        {};

        AsterMesh& operator=(const AsterMesh& tmp)
        {
            _asterMeshPtr = tmp._asterMeshPtr;
        };

        const AsterMeshPtr& operator->() const
        {
            return _asterMeshPtr;
        };

        bool isEmpty() const
        {
            if ( _asterMeshPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* ASTERMESH_H_ */
