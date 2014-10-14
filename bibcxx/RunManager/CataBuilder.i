%module code_aster
%{
#include "RunManager/CataBuilder.h"
%}

/* person_in_charge: mathieu.courtois at edf.fr */

class CataBuilder
{
    public:
        CataBuilder();
        ~CataBuilder();
};

%extend CataBuilder
{
    void run()
    {
        return $self->run();
    }
}
