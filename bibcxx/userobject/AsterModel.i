%module code_aster
%{
#include "userobject/AsterModel.h"
%}

%include "userobject/AsterMesh.i"

class AsterModel
{
    public:
        AsterModel();
        ~AsterModel();
};

%extend AsterModel
{
    bool setSupportMesh(AsterMesh& currentMesh)
    {
        return (*$self)->setSupportMesh(currentMesh);
    }

    void addModelisation(char* physics, char* modelisation)
    {
        return (*$self)->addModelisation(physics, modelisation);
    }

    void addModelisation(char* physics, char* modelisation, AsterMeshEntity& entity)
    {
        return (*$self)->addModelisation(physics, modelisation, entity);
    }

    bool build()
    {
        return (*$self)->build();
    }
}
