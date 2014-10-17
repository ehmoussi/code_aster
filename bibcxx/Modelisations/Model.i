%module code_aster
%{
#include "Modelisations/Model.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

%include "Mesh/Mesh.i"
%include "Modelisations/ElementaryModelisation.i"

class Model
{
    public:
        Model();
        ~Model();
};

%extend Model
{
    bool setSupportMesh(Mesh& currentMesh)
    {
        return (*$self)->setSupportMesh(currentMesh);
    }

    void addModelisationOnAllMesh(Physics phys, Modelisations mod)
    {
        return (*$self)->addModelisationOnAllMesh(phys, mod);
    }

    void addModelisationOnGroupOfElements(Physics phys, Modelisations mod, char* nameOfGroup)
    {
        return (*$self)->addModelisationOnGroupOfElements(phys, mod, nameOfGroup);
    }

    void addModelisationOnGroupOfNodes(Physics phys, Modelisations mod, char* nameOfGroup)
    {
        return (*$self)->addModelisationOnGroupOfNodes(phys, mod, nameOfGroup);
    }

    bool build()
    {
        return (*$self)->build();
    }
}
