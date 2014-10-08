%module code_aster
%{
#include "userobject/ResultsContainer.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

class ResultsContainerInstance
{
    public:
        ResultsContainerInstance();
};

class ResultsContainer
{
    public:
        ResultsContainer();
        ~ResultsContainer();
};
/*
%extend ResultsContainer
{
}*/
