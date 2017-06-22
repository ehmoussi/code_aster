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

#include "aster.h"

void DEFP(DATETOI, datetoi, ASTERINTEGER itab[6])
{
    time_t ltime;
    struct tm *today;

    time( &ltime );
    today = localtime(&ltime);

    itab[0] = today->tm_year;
    itab[1] = today->tm_mon + 1;
    itab[2] = today->tm_mday;

    itab[3] = today->tm_hour ;
    itab[4] = today->tm_min  ;
    itab[5] = today->tm_sec  ;

}
