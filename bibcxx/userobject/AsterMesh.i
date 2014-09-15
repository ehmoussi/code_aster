%module libAster
%{
#include "userobject/AsterMesh.h"
%}

%include "baseobject/JeveuxCollection.i"
%include "userobject/FieldOnNodes.i"

class AsterGroupOfNodes
{
    public:
        AsterGroupOfNodes(char* name, JeveuxCollectionLong& grpOfNodes);
};

class AsterGroupOfElements
{
    public:
        AsterGroupOfElements(char* name, JeveuxCollectionLong& grpOfElements);
};

class AsterMeshInstance
{
    public:
        AsterMeshInstance();

        const FieldOnNodesDouble &getCoordinates() const;
        bool readMEDFile(char*);
};

class AsterMesh
{
    public:
        AsterMesh();
        ~AsterMesh();
};

%extend AsterMesh
{
    const FieldOnNodes< double > &getCoordinates()
    {
        return (*$self)->getCoordinates();
    }

    const AsterGroupOfNodes getGroupOfNodes(char* name)
    {
        return (*$self)->getGroupOfNodes(name);
    }

    bool readMEDFile(char* name)
    {
        return (*$self)->readMEDFile(name);
    }
}
