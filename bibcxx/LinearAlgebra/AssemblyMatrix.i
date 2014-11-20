%module code_aster
%{
#include "LinearAlgebra/AssemblyMatrix.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "LinearAlgebra/DOFNumbering.h"
#include "LinearAlgebra/ElementaryMatrix.h"
#include "Loads/KinematicsLoad.h"

template<class ValueType>
class AssemblyMatrix
{
    public:
        AssemblyMatrix();
        ~AssemblyMatrix();
};

%template(AssemblyMatrixDouble) AssemblyMatrix< double >;

%extend AssemblyMatrix< double >
{
    void addKinematicsLoad( const KinematicsLoad& currentLoad )
    {
        return (*$self)->addKinematicsLoad( currentLoad );
    }

    bool build()
    {
        return (*$self)->build();
    }

    void debugPrint( const int logicalUnit )
    {
        return (*$self)->debugPrint( logicalUnit );
    }

    bool factorization()
    {
        return (*$self)->factorization();
    }

    void setDOFNumbering( const DOFNumbering& currentDOF )
    {
        return (*$self)->setDOFNumbering( currentDOF );
    }

    void setElementaryMatrix( const ElementaryMatrix& currentElemMatrix )
    {
        return (*$self)->setElementaryMatrix( currentElemMatrix );
    }
}
