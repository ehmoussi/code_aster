%module code_aster
%{
#include "LinearAlgebra/ElementaryMatrix.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "Modelisations/Model.h"
#include "Materials/AllocatedMaterial.h"
#include "Loads/MechanicalLoad.h"

class ElementaryMatrix
{
    public:
        ElementaryMatrix();
        ~ElementaryMatrix();
};

%extend ElementaryMatrix
{
    void addMechanicalLoad( const MechanicalLoad& currentLoad )
    {
        return (*$self)->addMechanicalLoad( currentLoad );
    }

    bool computeMechanicalRigidity()
    {
        return (*$self)->computeMechanicalRigidity();
    }

    void debugPrint( const int logicalUnit )
    {
        return (*$self)->debugPrint( logicalUnit );
    }

    void setAllocatedMaterial( const AllocatedMaterial& currentMaterial )
    {
        return (*$self)->setAllocatedMaterial( currentMaterial );
    }

    void setSupportModel( const Model& currentModel )
    {
        return (*$self)->setSupportModel( currentModel );
    }
}
