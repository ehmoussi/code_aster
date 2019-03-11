/* -------------------------------------------------------------------- */
/* Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org             */
/* This file is part of code_aster.                                     */
/*                                                                      */
/* code_aster is free software: you can redistribute it and/or modify   */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation, either version 3 of the License, or    */
/* (at your option) any later version.                                  */
/*                                                                      */
/* code_aster is distributed in the hope that it will be useful,        */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of       */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        */
/* GNU General Public License for more details.                         */
/*                                                                      */
/* You should have received a copy of the GNU General Public License    */
/* along with code_aster.  If not, see <http://www.gnu.org/licenses/>.  */
/* -------------------------------------------------------------------- */
/* person_in_charge: mathieu.courtois@edf.fr */

#ifndef MEDFILE_UTILS_H_
#define MEDFILE_UTILS_H_

#ifdef __cplusplus

#include "aster.h"

extern "C" {
#endif // __cplusplus
void DEFS(WRITE33HEADER, write33header, const char *, STRING_SIZE );

#ifdef __cplusplus
}
#endif // __cplusplus

#endif // MEDFILE_UTILS_H_
