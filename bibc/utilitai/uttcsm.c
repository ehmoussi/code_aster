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

/* retourne 3 temps(sec) : consommes user et systeme pour ce processus
                           + temps elapsed (depuis epoch)
*/

#ifdef _POSIX
#include <sys/times.h>
#include <sys/time.h>
#include <unistd.h>
#endif

#include <time.h>


/*
   On trouve parfois ceci :
   "CLK_TCK is described as an obsolete name for CLOCKS_PER_SEC"

   Quand les deux sont définis, il y a un facteur 10000 entre
   les deux (CLOCKS_PER_SEC = 1e6, CLK_TCK = 100).
*/

#ifdef CLK_TCK
#define CLOCKS_PER_SEC_VALUE CLK_TCK
#else
#define CLOCKS_PER_SEC_VALUE sysconf(_SC_CLK_TCK)
#endif


static ASTERDOUBLE _cache_t0 = -1.;

void DEFP(UTTCSM, uttcsm, ASTERDOUBLE *t_csm)
{
    ASTERDOUBLE elaps;

#ifdef _POSIX
/* calcul de elaps avec gettimeofday  */
    struct timeval tv;
    struct timezone tz;
    gettimeofday(&tv,&tz);
    elaps=(ASTERDOUBLE) tv.tv_sec + (ASTERDOUBLE) tv.tv_usec / 1000000.;

#else
/* calcul de elaps : date depuis epoch en secondes
   ce nombre est stocké dans un double
   Parfois à la seconde près.
   Sous WIN, gettimeofday n'existe pas.
   Une implémentation : http://www.suacommunity.com/dictionary/gettimeofday-entry.php
*/
    time_t t1, t0, *pt1 ;
    t0 = 0;
    t1 = time(NULL);
    elaps = difftime(t1,t0);
#endif

    /* first call, store t0 */
    if ( _cache_t0 < 0. ) {
        _cache_t0 = elaps;
    }
    t_csm[2] = elaps - _cache_t0;


#ifdef _POSIX
   struct tms temps;
   times (&temps);
   t_csm[0]=(ASTERDOUBLE)temps.tms_utime/(ASTERDOUBLE)CLOCKS_PER_SEC_VALUE;
   t_csm[1]=(ASTERDOUBLE)temps.tms_stime/(ASTERDOUBLE)CLOCKS_PER_SEC_VALUE;

#else
   t_csm[0]=(ASTERDOUBLE)clock()/CLOCKS_PER_SEC_VALUE;
   t_csm[1]=(ASTERDOUBLE)0.;

#endif
}
