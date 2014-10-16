%module code_aster
%{
#include "DataFields/PCFieldOnMesh.h"
%}


template<class ValueType>
class PCFieldOnMesh
{
    public:
        PCFieldOnMesh(char* name);
        ~PCFieldOnMesh();
};

%template(PCFieldOnMeshDouble) PCFieldOnMesh<double>;

