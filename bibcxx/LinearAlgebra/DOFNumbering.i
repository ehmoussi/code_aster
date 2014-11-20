%module code_aster
%{
#include "LinearAlgebra/DOFNumbering.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "Modelisations/Model.h"
#include "LinearAlgebra/ElementaryMatrix.h"
#include "LinearAlgebra/LinearSolver.h"

class DOFNumbering
{
    public:
        DOFNumbering();
        ~DOFNumbering();
};

%extend DOFNumbering
{
    bool computeNumerotation()
    {
        return (*$self)->computeNumerotation();
    }

    void debugPrint( const int logicalUnit )
    {
        return (*$self)->debugPrint( logicalUnit );
    }

    void setElementaryMatrix( const ElementaryMatrix& currentMatrix )
    {
        return (*$self)->setElementaryMatrix( currentMatrix );
    }

    void setLinearSolver( const LinearSolver& currentSolver )
    {
        return (*$self)->setLinearSolver( currentSolver );
    }

    void setSupportModel( const Model& currentModel )
    {
        return (*$self)->setSupportModel( currentModel );
    }
}
