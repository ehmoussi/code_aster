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

/* ------------------------------------------------------------------ */
/*
** Initialisation de l'interception de certains signaux
** Actuellement sont traites les signaux :
**    CPULIM  : plus de temps CPU
**    FPE     : Floating point exception
*/

#include "aster.h"
#include "aster_fort.h"

#include <signal.h>

void abort();

void hancpu (int sig);

#if defined SOLARIS
#include <siginfo.h>
#include <ucontext.h>
  void hanfpe(int sig, siginfo_t *sip, ucontext_t *uap);

#elif defined _WINDOWS
#include <float.h>
  void hanfpe(int sig);
  void stptrap(int sig);

#elif defined _POSIX
  void hanfpe(int sig);
  void stptrap(int sig);
  void stpusr1(int sig);
#endif

#if defined GNU_LINUX
#   define _GNU_SOURCE 1
#   include <fenv.h>
#endif


void DEF0(INISIG, inisig)
{
#if defined _POSIX
    struct sigaction action_CPU_LIM;
#else
    unsigned int cw, cwOrig;
#endif

/*            */
/* CPU LIMITE */
/*            */
#if defined _POSIX
   action_CPU_LIM.sa_handler=hancpu;
   sigemptyset(&action_CPU_LIM.sa_mask);
   action_CPU_LIM.sa_flags=0;
   sigaction(SIGXCPU  ,&action_CPU_LIM,NULL);
#endif

/*                          */
/* Floating point exception */
/*                          */
#if defined SOLARIS
   ieee_handler("set","common",hanfpe);
   ieee_handler("clear","invalid",hanfpe);

#elif defined GNU_LINUX

   /* Enable some exceptions. At startup all exceptions are masked. */
   feenableexcept(FE_DIVBYZERO|FE_OVERFLOW|FE_INVALID);

   signal(SIGFPE,  hanfpe);

#elif defined _WINDOWS
    _clearfp();
    cw = _controlfp(0, 0);
    cw &=~( EM_OVERFLOW | EM_ZERODIVIDE );
    cwOrig = _controlfp(cw, MCW_EM);

    signal(SIGFPE, hanfpe);
#else
   signal(SIGFPE,  hanfpe);
#endif

/*                          */
/* Arret par CRTL C         */
/*                          */
   signal(SIGINT,  stptrap);

/*                          */
/* Arret par SIGUSR1        */
/*                          */
/* Note : l'arret par SIGUSR1 ne fonctionne pas sous MSVC,
   il faudra essayer de trouver autre chose... */
#if defined _POSIX
   signal(SIGUSR1,  stpusr1);
#endif
}


void stptrap (int sig)
{
  CALL_UTMESS("I", "SUPERVIS_97");
  exit(EXIT_FAILURE);
}


static ASTERINTEGER status_usr1 = 0;

ASTERINTEGER DEF0(ETAUSR, etausr)
{
    /* ETAt USR1 :
     * Retourne la variable status_usr1 */
    return status_usr1;
}

void stpusr1 (int sig)
{
    /* SToP USR1 :
     * callback appelé lors de la réception du signal USR1.
     */
    CALL_UTMESS("I", "SUPERVIS_96");
    status_usr1 = (ASTERINTEGER)1;
}

void DEF0(CLRUSR, clrusr)
{
    /* CLeaR USR1 :
     * Réinitialise la valeur de status_usr1
     * Utile pour éviter la récursivité.
     */
   status_usr1 = (ASTERINTEGER)0;
}
