#ifndef DEBUGPRINT_H_
#define DEBUGPRINT_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <string>
#include "RunManager/Initializer.h"
#include "DataStructure/DataStructure.h"

using namespace std;

void jeveuxDebugPrint( const DataStructure& dataSt, const int logicalUnit );

#endif /* DEBUGPRINT_H_ */
