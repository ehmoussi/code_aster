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

/*
**  Fonction C intermediaire pour appeler une routine FORTRAN
**  qui va faire appel a UTMESS('F',...)
**  Il n'y a pas de passage d'argument pour minimiser les problemes
**  d'interfacage FORTRAN/C et reciproquement
*/
#if defined _POSIX
#include <stdio.h>
#include <stdlib.h>
#endif

#if defined SOLARIS
#include <siginfo.h>
#include <ucontext.h>
   void hanfpe (int sig, siginfo_t *sip, ucontext_t *uap)
#else
   void hanfpe (int sig)
#endif
{
   void exit (int status);
   void DEF0(UTMFPE, utmfpe);
   
   CALL0(UTMFPE, utmfpe);
   exit(sig);
}
