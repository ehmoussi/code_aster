%module code_aster
%{
#include "Loads/MechanicalLoad.h"
%}

%include "Modelisations/Model.i"

class MechanicalLoad
{
    public:
        MechanicalLoad();
        ~MechanicalLoad();
};

%extend MechanicalLoad
{
    void debugPrint( const int logicalUnit )
    {
        return (*$self)->debugPrint( logicalUnit );
    }

    bool setSupportModel(Model& currentModel)
    {
        return (*$self)->setSupportModel(currentModel);
    }

    void setDisplacementOnNodes(char* doFName, double doFValue, char* nameOfGroup)
    {
        return (*$self)->setDisplacementOnNodes(doFName, doFValue, nameOfGroup);
    }
    void setDisplacementOnElements(char* doFName, double doFValue, char* nameOfGroup)
    {
        return (*$self)->setDisplacementOnElements(doFName, doFValue, nameOfGroup);
    }
    void setPressureOnElements(double doFValue, char* nameOfGroup)
    {
        return (*$self)->setPressureOnElements(doFValue, nameOfGroup);
    }

    bool build()
    {
        return (*$self)->build();
    }
}
