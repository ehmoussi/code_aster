%module code_aster
%{
#include "userobject/Material.h"
%}

class GeneralMaterialBehaviour
{
    public:
        GeneralMaterialBehaviour();
        ~GeneralMaterialBehaviour();
};

%extend GeneralMaterialBehaviour
{
    bool setDoubleValue(char* nom, double value)
    {
        return (*$self)->setDoubleValue(nom, value);
    }
}

class ElasticMaterialBehaviour: public GeneralMaterialBehaviour
{
    public:
        ElasticMaterialBehaviour();
        ~ElasticMaterialBehaviour();
};

class Material
{
    public:
        Material();
        ~Material();
};

%extend Material
{
    void addMaterialBehaviour(GeneralMaterialBehaviour& curMaterBehav)
    {
        (*$self)->addMaterialBehaviour(curMaterBehav);
    }

    bool build()
    {
        return (*$self)->build();
    }
}
