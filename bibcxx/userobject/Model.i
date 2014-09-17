%module code_aster
%{
#include "userobject/Model.h"
%}

%include "userobject/Mesh.i"

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

    void addModelisation(char* physics, char* modelisation)
    {
        return (*$self)->addModelisation(physics, modelisation);
    }

    void addModelisation(char* physics, char* modelisation, MeshEntity& entity)
    {
        return (*$self)->addModelisation(physics, modelisation, entity);
    }

    bool build()
    {
        return (*$self)->build();
    }
}
