%module code_aster
%{
#include "LinearAlgebra/LinearSolver.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

%include "LinearAlgebra/AllowedLinearSolver.h"
#include "LinearAlgebra/AssemblyMatrix.h"
#include "DataFields/FieldOnNodes.h"

class LinearSolver
{
    public:
        LinearSolver(const LinearSolverEnum currentLinearSolver,
                     const Renumbering currentRenumber);
        ~LinearSolver();
};

%extend LinearSolver
{
    FieldOnNodes< double > solveDoubleLinearSystem( const AssemblyMatrix< double >& currentMatrix,
                                                    const FieldOnNodes< double >& currentRHS )
    {
        return (*$self)->solveDoubleLinearSystem( currentMatrix, currentRHS );
    }
}
