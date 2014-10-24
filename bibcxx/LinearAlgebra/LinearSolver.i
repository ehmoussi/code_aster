%module code_aster
%{
#include "LinearAlgebra/LinearSolver.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

%include "LinearAlgebra/AllowedLinearSolver.h"

class LinearSolver
{
    public:
        LinearSolver(const LinearSolverEnum currentLinearSolver,
                     const Renumbering currentRenumber);
        ~LinearSolver();
};

/*%extend LinearSolver
{
    bool computeNumerotation()
    {
        return (*$self)->computeNumerotation();
    }

    void setElementaryMatrix( const ElementaryMatrix& currentMatrix )
    {
        return (*$self)->setElementaryMatrix( currentMatrix );
    }

    void setLinearSolver( const LinearSolverEnum currentEnumSolver, const Renumbering currentRenumbering )
    {
        return (*$self)->setLinearSolver( currentEnumSolver, currentRenumbering );
    }

    void setSupportModel( const Model& currentModel )
    {
        return (*$self)->setSupportModel( currentModel );
    }
}*/
