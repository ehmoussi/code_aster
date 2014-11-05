%module code_aster
%{
#include "DataFields/FieldOnNodes.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

template<class ValueType>
class FieldOnNodes
{
    public:
        FieldOnNodes(char* name);
        ~FieldOnNodes();
};

%template(FieldOnNodesDouble) FieldOnNodes<double>;

%extend FieldOnNodes<double>
{
    double __getitem__(int i) const
    {
        return (*self)->operator[](i);
    }

    void debugPrint( const int logicalUnit )
    {
        return (*$self)->debugPrint( logicalUnit );
    }

    bool printMEDFormat( char* pathFichier )
    {
        return (*$self)->printMEDFormat( pathFichier );
    }
}
