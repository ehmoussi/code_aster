/**
 * @file JeveuxBidirectionalMap.cxx
 * @brief Implementation de JeveuxBidirectionalMap
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   Code_Aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "MemoryManager/JeveuxBidirectionalMap.h"

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
