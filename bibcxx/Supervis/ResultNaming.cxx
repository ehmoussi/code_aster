#include <iostream>
#include <cmath>

#include "ResultNaming.h"

int ResultNaming::numberOfObjects = std::pow(2, 32) - 1;

int main()
{
    ResultNaming namer = ResultNaming();
    std::cout << "first: " << namer.getNewResultName() << std::endl;
    return 0;
}
