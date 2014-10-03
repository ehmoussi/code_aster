%module code_aster
%{
#include "command/CataBuilder.h"
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
