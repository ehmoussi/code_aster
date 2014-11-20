/**
 * @file LogicalUnitManager.cxx
 * @brief Initialisation des tableaux necessaires a la gestion des unites logiques
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
#include "RunManager/LogicalUnitManager.h"

const int tabOfLogicalUnit[nbOfLogicalUnit] = { 19, 20, 21, 22, 23, 24, 25, 26, 27,
                                                28, 29, 30, 31, 32, 33, 34, 35, 36,
                                                37, 38, 39, 40, 41, 42, 43, 44, 45,
                                                46, 47, 48, 49, 50, 51, 52, 53, 54,
                                                55, 56, 57, 58, 59, 60, 61, 62, 63,
                                                64, 65, 66, 67, 68, 69, 70, 71, 72,
                                                73, 74, 75, 76, 77, 78, 79, 80, 81,
                                                82, 83, 84, 85, 86, 87, 88, 89, 90,
                                                91, 92, 93, 94, 95, 96, 97, 98, 99 };

list< int > LogicalUnitManager::_freeLogicalUnit( tabOfLogicalUnit,
                                                  tabOfLogicalUnit + nbOfLogicalUnit );

set< int >  LogicalUnitManager::_nonFreeLogicalUnit = set< int >();

const char* const NameFileType[3] = { "ASCII", "BINARY", "LIBRE" };

const char* const NameFileAccess[3] = { "NEW", "APPEND", "OLD" };
