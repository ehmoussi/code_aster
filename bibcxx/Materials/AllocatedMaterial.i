%module code_aster
%{
#include "Materials/AllocatedMaterial.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

//%include "Materials/Material.i"

class AllocatedMaterial
{
    public:
        AllocatedMaterial();
        ~AllocatedMaterial();
};

%extend AllocatedMaterial
{
    bool setSupportMesh(Mesh& currentMesh)
    {
        return (*$self)->setSupportMesh(currentMesh);
    }

    void addMaterialOnAllMesh( Material& curMater )
    {
        return (*$self)->addMaterialOnAllMesh( curMater );
    }

    void addMaterialOnGroupOfElements( Material& curMater, char* nameOfGroup )
    {
        return (*$self)->addMaterialOnGroupOfElements( curMater, nameOfGroup );
    }

    bool build()
    {
        return (*$self)->build();
    }
}
