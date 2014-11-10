/* person_in_charge: mathieu.courtois@edf.fr */

%module code_aster
%include "std_string.i"
%include "std_vector.i"

%{
#include "Function/Function.h"
%}
%template( VectorDouble ) std::vector< double >;


class Function
{
    public:
        Function();
        ~Function();
};

%extend Function
{
    void setParameterName( std::string name )
    {
        return (*$self)->setParameterName( name );
    }

    void setResultName( std::string name )
    {
        return (*$self)->setResultName( name );
    }

    void setValues( std::vector< double > absc, std::vector< double > ord )
    {
        return (*$self)->setValues( absc, ord );
    }

    bool build()
    {
        return (*$self)->build();
    }

    void debugPrint( const int logicalUnit )
    {
        return (*$self)->debugPrint( logicalUnit );
    }
}
