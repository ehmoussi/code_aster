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
#include "aster_utils.h"
#include "aster_fort.h"

#define MAX_FAC         256
#define LONG_NOM_FIC    513
#define OFF_INIT        ASTER_INT_SIZE

static FILE *fpfile[MAX_FAC];
static long   nenr[MAX_FAC];

static long nbFAC=0;
static char *nomFAC[MAX_FAC];


long ind_fac ( char *nom )
{
   long i;
   static long res;
   res=-1;
   i=0;
   while ((i < nbFAC) && (strcmp(nom,nomFAC[i]) != 0)) i++;
   if (i < nbFAC) res=i;

   return(res);
}

long  open_fac ( char *nom )
{
   long ifac;
   static long res;
   void *malloc(size_t size);
   res=-1;
   ifac=ind_fac(nom);
   if (ifac < 0) {
      /* Creation */
      if (nbFAC < MAX_FAC) {
         nomFAC[nbFAC]=(char *) malloc(LONG_NOM_FIC);
         strcpy(nomFAC[nbFAC],nom);
         fpfile[nbFAC]=NULL;
         nenr[nbFAC]=-1;
         res=nbFAC;
         nbFAC++;
         }
      }
   else {
      /* Reinitialisation */
      strcpy(nomFAC[ifac],nom);
      fpfile[ifac]=NULL;
      nenr[ifac]=-1;
      res=ifac;
      }
   return(res);
}


void DEFSPP(OPENDR, opendr, char *dfname, STRING_SIZE len_dfname,
                            ASTERINTEGER *mode, ASTERINTEGER *ierr)
{
    /*
        mode = 0 : ro read only
        mode = 1 : rw read + write
        mode = 2 : write
     */
    long iu, nbread;
    char *fname, smode[4], *valk;
    int imode;
    ASTERINTEGER n0=0, n1=1, ibid=0;
    ASTERDOUBLE rbid=0.;

    imode = (int)(*mode);
    *ierr = 0;
    fname = MakeCStrFromFStr(dfname, len_dfname);
    iu=open_fac(fname);
    if ( iu < 0 ) {
       *ierr = -1;
       FreeStr(fname);
       return;
    }
    if ( imode == 0 ) {
        strcpy(smode, "rb");
    } else if ( imode == 1 ) {
        strcpy(smode, "rb+");
    } else {
        strcpy(smode, "wb+");
    }
    DEBUG_IODR("trying open file '%s' using mode '%s'...\n", fname, smode);
    fpfile[iu] = fopen(fname, smode);
    if (fpfile[iu] != NULL  ) {
        valk = MakeTabFStr(1, VALK_SIZE);
        SetTabFStr(valk, 0, fname, VALK_SIZE);
        if ( imode == 2 ) {
            DEBUG_IODR("open in %s mode: %s\n", "write", fname);
            CALL_UTMESS_CORE("I", "JEVEUX_45", &n1, valk, &n0, &ibid, &n0, &rbid, " ");
            nenr[iu] = -1;
            *ierr = 0;
        } else {
            DEBUG_IODR("open in %s mode: %s\n", "read", fname);
            CALL_UTMESS_CORE("I", "JEVEUX_44", &n1, valk, &n0, &ibid, &n0, &rbid, " ");
            nbread=fread(&nenr[iu], OFF_INIT, 1, fpfile[iu]);
        }
        FreeStr(valk);
    }
    else {
        DEBUG_IODR("%s failed: %s\n", "open", fname);
        *ierr = -2;
    }
    FreeStr(fname);
}

void DEFSP(CLOSDR, closdr, char *dfname, STRING_SIZE len_dfname, ASTERINTEGER *ierr)
{
    long iu;
    char *fname;

    *ierr = 0;
    fname = MakeCStrFromFStr(dfname, len_dfname);
    iu=ind_fac(fname);
    if ( iu < 0 ) {
       *ierr = -1;
    }
    else {
        fclose(fpfile[iu]);
        fpfile[iu] = NULL;
        nenr[iu]=-1;
        *ierr = 0;
    }
    FreeStr(fname);
}

void DEFSPPPP(READDR, readdr, char *dfname, STRING_SIZE len_dfname, void *buf,
                              ASTERINTEGER *nbytes, ASTERINTEGER *irec, ASTERINTEGER *ierr)
{
    long offset;
    long iu,nbseek;
    ASTERINTEGER nbval;
    char *fname;

    *ierr = 0;
    fname = MakeCStrFromFStr(dfname, len_dfname);
    iu=ind_fac(fname);
    if ( iu < 0 ) {
       *ierr = -1;
       FreeStr(fname);
       return;
    }
    if ( nenr[iu] == -1 ) {
        *ierr = -2;
        FreeStr(fname);
        return;
    }
    if ( fpfile[iu] == NULL ) {
        *ierr = -3;
        FreeStr(fname);
        return;
    }
    offset = (*irec-1)*nenr[iu]+OFF_INIT;
    nbseek=fseek(fpfile[iu],offset, SEEK_SET);
    nbval=(ASTERINTEGER)fread(buf,1,(size_t)(*nbytes),fpfile[iu]);
    if ( nbval != *nbytes ) {
        *ierr = -4;
    }
    FreeStr(fname);
}

void DEFSPPPP(WRITDR, writdr, char *dfname, STRING_SIZE len_dfname, void *buf,
            ASTERINTEGER *nbytes, ASTERINTEGER *irec, ASTERINTEGER *ierr)
{
    long offset;
    long iu,nbseek,nbwrite;
    ASTERINTEGER nbval;
    char *fname;

    *ierr = 0;
    fname = MakeCStrFromFStr(dfname, len_dfname);
    iu=ind_fac(fname);
    if ( iu < 0 ) {
       *ierr = -1;
       FreeStr(fname);
       return;
    }
    if ( fpfile[iu] == NULL ) {
        *ierr = -3;
        FreeStr(fname);
        return;
    }
    if ( nenr[iu] == -1 ) {
       nenr[iu] = *nbytes;
       nbwrite=fwrite(&nenr[iu], OFF_INIT, 1, fpfile[iu]);
    }
    offset = (*irec-1)*(nenr[iu])+OFF_INIT;
    nbseek=fseek(fpfile[iu],offset, SEEK_SET);
    nbval=(ASTERINTEGER)fwrite(buf,1,(size_t)(*nbytes),fpfile[iu]);

    if ( nbval != *nbytes ) {
        *ierr = -4;
    }
    FreeStr(fname);
}
