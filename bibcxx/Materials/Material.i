%module code_aster
%{
#include "Materials/Material.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

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

    void debugPrint(const int logicalUnit)
    {
        return (*$self)->debugPrint( logicalUnit );
    }

    bool build()
    {
        return (*$self)->build();
    }
}
