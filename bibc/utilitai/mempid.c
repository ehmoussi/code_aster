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

/* person_in_charge: j-pierre.lefebvre at edf.fr */
#include "aster.h"

#ifdef _POSIX
# ifdef __FreeBSD__
#   include <kvm.h>
#   include <sys/param.h>
#   include <sys/sysctl.h>
#   include <sys/user.h>
#   include <err.h>
# endif
#   include <fcntl.h>
#endif

/*
** Cette fonction permet de consulter le systeme de fichier /proc sous Unix
** et renvoie la memoire en octets consommee par le processus.
** Elle accede aux valeurs VmRSS et VmSize .
** La valeur retournee vaut VmStk.
**
** Le numero du processus est recupere par getpid
*/
ASTERINTEGER DEFP (MEMPID, mempid, ASTERINTEGER *val)
{
    static char filename[80];
    static char sbuf[1024];
    char* S;
    int fd, num_read;
    ASTERINTEGER iret;
    pid_t numpro;

#if defined _POSIX && defined ENABLE_PROC_STATUS

    pid_t getpid(void);
    numpro = getpid();

# if defined FREEBSD
/*
** FreeBSD and some others without /proc ?
*/

#define B2K(x) ((x) >> 10) /* bytes to kbytes */

    char errbuf[_POSIX2_LINE_MAX];
    struct kinfo_proc *kp;
    kvm_t *kd;
    int count;
    kd = kvm_openfiles(NULL, "/dev/null", NULL, O_RDONLY, errbuf);
    if (kd == NULL)
        errx(1, "kvm_openfiles: %s", errbuf);

    kp = kvm_getprocs(kd, KERN_PROC_PID, numpro, &count);
    if (kp == NULL) {
        (void)fprintf(stderr, "kvm_getprocs: %s", kvm_geterr(kd));
        kvm_close(kd);
        return -1;
    }

    kvm_close(kd);

    /* VmSize */
    val[0] = B2K((uintmax_t)kp->ki_size);
    /* VmPeak - not defined in /compat/linux/proc/pid/status */
    val[1] = -1;
    iret = 0;

# elif defined DARWIN

/*
OS X does not support retrieving memory consumptions through /proc or kvm library
*/

    val[0] = 0;
    val[1] = 0;
    iret = 0;

# else /* Linux */

    sprintf(filename, "/proc/%ld/status", (long)numpro);
    fd = open(filename, O_RDONLY, 0);
    if (fd==-1) return -1;
    num_read=read(fd,sbuf,(sizeof sbuf)-1);
/*  printf (" contenu du buffer = %s\n",sbuf); */
    close(fd);

    S=strstr(sbuf,"VmSize:")+8;
    val[0] = (ASTERINTEGER)atoi(S);

    if ( strstr(sbuf,"VmPeak:") != NULL ) {
        S=strstr(sbuf,"VmPeak:")+8;
        val[1] = atoi(S);
    } else {
        val[1] = -1;
    }

    iret = 0;
# endif

    return iret;

#else
/*
** Pour retourner des valeurs sous Windows
*/
    val[0] = 0;
    val[1] = 0;
    return 0;

#endif
}
