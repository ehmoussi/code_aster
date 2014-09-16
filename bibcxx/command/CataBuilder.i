%module libAster
%{
#include "command/CataBuilder.h"
%}

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
