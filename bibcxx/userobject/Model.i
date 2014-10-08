%module code_aster
%{
#include "userobject/Model.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

%include "userobject/Mesh.i"
%include "userobject/ElementaryModelisation.i"

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

    void addElementaryModelisation(Physics phys, Modelisations mod)
    {
        return (*$self)->addElementaryModelisation(phys, mod);
    };

    void addElementaryModelisation(Physics phys, Modelisations mod, MeshEntity& entity)
    {
        return (*$self)->addElementaryModelisation(phys, mod, entity);
    }

    bool build()
    {
        return (*$self)->build();
    }
}
