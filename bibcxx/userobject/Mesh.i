%module code_aster
%{
#include "userobject/Mesh.h"
%}

%include "baseobject/JeveuxCollection.i"
%include "userobject/FieldOnNodes.i"

class GroupOfNodes
{
    public:
        GroupOfNodes(char* name, JeveuxCollectionLong& grpOfNodes);
};

class GroupOfElements
{
    public:
        GroupOfElements(char* name, JeveuxCollectionLong& grpOfElements);
};

class MeshInstance
{
    public:
        MeshInstance();

        const FieldOnNodesDouble &getCoordinates() const;
        bool readMEDFile(char*);
};

class Mesh
{
    public:
        Mesh();
        ~Mesh();
};

%extend Mesh
{
    const FieldOnNodes< double > &getCoordinates()
    {
        return (*$self)->getCoordinates();
    }

    const GroupOfNodes getGroupOfNodes(char* name)
    {
        return (*$self)->getGroupOfNodes(name);
    }

    bool readMEDFile(char* name)
    {
        return (*$self)->readMEDFile(name);
    }
}
