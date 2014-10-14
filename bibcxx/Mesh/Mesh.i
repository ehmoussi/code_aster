%module code_aster
%{
#include "Mesh/Mesh.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

%include "MemoryManager/JeveuxCollection.i"
%include "DataFields/FieldOnNodes.i"

class GroupOfNodes: public MeshEntity
{
    public:
        GroupOfNodes(char* name, JeveuxCollectionLong& grpOfNodes);
};

class GroupOfElements: public MeshEntity
{
    public:
        GroupOfElements(char* name, JeveuxCollectionLong& grpOfElements);
};

class MeshInstance
{
    public:
        MeshInstance();

        const FieldOnNodesDouble getCoordinates() const;
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
    const FieldOnNodes< double > getCoordinates()
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
