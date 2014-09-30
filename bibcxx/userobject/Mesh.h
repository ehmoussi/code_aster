#ifndef MESH_H_
#define MESH_H_

#include "definition.h"
#include "command/Initializer.h"
#include "baseobject/JeveuxCollection.h"
#include "baseobject/JeveuxBidirectionalMap.h"
#include "userobject/FieldOnNodes.h"
#include <assert.h>

class MeshEntity
{
    private:
        const string            _name;
        JeveuxCollectionLong    _groupsOfEntities;

    public:
        MeshEntity(string name, JeveuxCollectionLong& grpOfEntities): _name(name),
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

class GroupOfNodes: MeshEntity
{
    public:
        GroupOfNodes(string name, JeveuxCollectionLong& grpOfNodes):
            MeshEntity(name, grpOfNodes)
        {};
};

class GroupOfElements: MeshEntity
{
    public:
        GroupOfElements(string name, JeveuxCollectionLong& grpOfElements):
            MeshEntity(name, grpOfElements)
        {};
};

class MeshInstance
{
    private:
        friend class MeshEntity;
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
        MeshInstance();

        ~MeshInstance()
        {};

        const string& getJeveuxName() const
        {
            return _jeveuxName;
        };

        const FieldOnNodesDouble &getCoordinates() const
        {
            return _coordinates;
        };

        const GroupOfElements getGroupOfElements(string name)
        {
            return GroupOfElements(name, this->_groupsOfElements);
        };

        const GroupOfNodes getGroupOfNodes(string name)
        {
            return GroupOfNodes(name, this->_groupsOfNodes);
        };

        bool isEmpty() const
        {
            return _isEmpty;
        };

        bool readMEDFile(char*);
};

class Mesh
{
    public:
        typedef boost::shared_ptr< MeshInstance > MeshPtr;

    private:
        MeshPtr _meshPtr;

    public:
        Mesh(bool initilisation = true): _meshPtr()
        {
            if ( initilisation == true )
                _meshPtr = MeshPtr( new MeshInstance() );
        };

        ~Mesh()
        {};

        Mesh& operator=(const Mesh& tmp)
        {
            _meshPtr = tmp._meshPtr;
            return *this;
        };

        const MeshPtr& operator->() const
        {
            return _meshPtr;
        };

        bool isEmpty() const
        {
            if ( _meshPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* MESH_H_ */
