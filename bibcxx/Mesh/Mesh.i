%module code_aster
%{
#include "Mesh/Mesh.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

%include "MemoryManager/JeveuxCollection.i"
%include "DataFields/FieldOnNodes.i"

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

    bool readMEDFile(char* name)
    {
        return (*$self)->readMEDFile(name);
    }
}
