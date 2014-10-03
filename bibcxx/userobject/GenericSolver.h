#ifndef GENERICSOLVER_H_
#define GENERICSOLVER_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "userobject/ResultsContainer.h"

class GenericSolver
{
    private:

    public:
        GenericSolver()
        {};

        virtual ResultsContainer execute() = 0;
};

#endif /* GENERICSOLVER_H_ */
