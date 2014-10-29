#ifndef CATABUILDER_H_
#define CATABUILDER_H_

/* person_in_charge: mathieu.courtois at edf.fr */

#include <stdio.h>
#include <string.h>
#include <assert.h>

#include "definition.h"
#include "RunManager/CommandSyntax.h"
#include "RunManager/Initializer.h"


class CataBuilder
{
    public:
        CataBuilder()
        {};

        ~CataBuilder()
        {}

        void run();
};


#endif /* CATABUILDER_H_ */
