#ifndef CATABUILDER_H_
#define CATABUILDER_H_

#include <stdio.h>
#include <string.h>
#include <assert.h>

#include "definition.h"
#include "command/CommandSyntax.h"


class CataBuilder
{
    private:
        CommandSyntax syntaxeMajCata;

    public:
        CataBuilder();

        ~CataBuilder()
        {
            cout << "Dtor CataBuilder" << endl;
        }

        void run();
};


#endif /* CATABUILDER_H_ */
