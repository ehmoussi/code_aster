
#include "baseobject/JeveuxBidirectionalMap.h"

/* person_in_charge: nicolas.sellenet at edf.fr */

string JeveuxBidirectionalMapInstance::findStringOfElement(long elementNumber)
{
    char* charJeveuxObjName = MakeBlankFStr(32);
    char* charName = MakeBlankFStr(32);
    CALL_JEXNUM(charJeveuxObjName, _jeveuxName.c_str(), &elementNumber);
    CALL_JENUNO(charJeveuxObjName, charName);
    return string(charName);
};

long JeveuxBidirectionalMapInstance::findIntegerOfElement(string elementName)
{
    char* charJeveuxObjName = MakeBlankFStr(32);
    CALL_JEXNOM(charJeveuxObjName, _jeveuxName.c_str(), elementName.c_str());
    long resu = -1;
    CALL_JENONU(charJeveuxObjName, &resu);
    return resu;
};
