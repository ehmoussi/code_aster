%module code_aster
%{
#include "LinearAlgebra/ElementaryVector.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "Loads/MechanicalLoad.h"
#include "Materials/AllocatedMaterial.h"
#include "DataFields/FieldOnNodes.h"
#include "LinearAlgebra/DOFNumbering.h"

class ElementaryVector
{
    public:
        ElementaryVector();
        ~ElementaryVector();
};

%extend ElementaryVector
{
    void addMechanicalLoad( const MechanicalLoad& currentLoad )
    {
        return (*$self)->addMechanicalLoad( currentLoad );
    }

    const FieldOnNodes< double > assembleVector( const DOFNumbering& currentNumerotation )
    {
        return (*$self)->assembleVector( currentNumerotation );
    }

    bool computeMechanicalLoads()
    {
        return (*$self)->computeMechanicalLoads();
    }

    void debugPrint( const int logicalUnit )
    {
        return (*$self)->debugPrint( logicalUnit );
    }

    void setAllocatedMaterial( const AllocatedMaterial& currentMaterial )
    {
        return (*$self)->setAllocatedMaterial( currentMaterial );
    }
}
