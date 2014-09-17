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

class AsterGroupOfNodes: MeshEntity
{
    public:
        AsterGroupOfNodes(string name, JeveuxCollectionLong& grpOfNodes):
            MeshEntity(name, grpOfNodes)
        {};
};

class AsterGroupOfElements: MeshEntity
{
    public:
        AsterGroupOfElements(string name, JeveuxCollectionLong& grpOfElements):
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

class Mesh
{
    public:
        typedef boost::shared_ptr< MeshInstance > MeshPtr;

    private:
        MeshPtr _MeshPtr;

    public:
        Mesh(bool initilisation = true): _MeshPtr()
        {
            if ( initilisation == true )
                _MeshPtr = MeshPtr( new MeshInstance() );
        };

        ~Mesh()
        {};

        Mesh& operator=(const Mesh& tmp)
        {
            _MeshPtr = tmp._MeshPtr;
        };

        const MeshPtr& operator->() const
        {
            return _MeshPtr;
        };

        bool isEmpty() const
        {
            if ( _MeshPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* MESH_H_ */
