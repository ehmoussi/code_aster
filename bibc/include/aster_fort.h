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

#ifndef ASTER_FORT_H
#define ASTER_FORT_H

#include "aster.h"
#include "aster_mpi.h"
#ifdef _HAVE_PETSC
#include "petscmat.h"
#endif

/* *********************************************************************
 *
 * Définition des interfaces aux routines fortran appelées depuis le C.
 *
 * *********************************************************************/

#ifdef __cplusplus
extern "C" {
#endif

/* routines UTILITAIRES */
#define CALL_R8VIDE() CALL0(R8VIDE,r8vide)
extern ASTERDOUBLE DEF0(R8VIDE,r8vide);

#define CALL_R8PI() CALL0(R8PI,r8pi)
extern ASTERDOUBLE DEF0(R8PI,r8pi);

#define CALL_ISNNEM() CALL0(ISNNEM,isnnem)
extern ASTERINTEGER DEF0(ISNNEM,isnnem);

#define CALL_ULOPEN(a,b,c,d,e) CALLPSSSS(ULOPEN,ulopen,a,b,c,d,e)
extern void DEFPSSSS(ULOPEN,ulopen,ASTERINTEGER *,char *,STRING_SIZE,char *,STRING_SIZE,
                     char *,STRING_SIZE,char *,STRING_SIZE);

#define CALL_FCLOSE(a) CALLP(FCLOSE,fclose,a)
extern void DEFP(FCLOSE,fclose,ASTERINTEGER *);

#define CALL_DISMOI(a,b,c,d,e,f,g) CALLSSSPSSP(DISMOI,dismoi,a,b,c,d,e,f,g)
#define CALLO_DISMOI(a,b,c,d,e,f,g) CALLOOOPOOP(DISMOI,dismoi,a,b,c,d,e,f,g)
extern void DEFSSSPSSP(DISMOI, dismoi, const char *,STRING_SIZE,
                       const char *,STRING_SIZE, const char *,STRING_SIZE, ASTERINTEGER *,
                       const char *,STRING_SIZE, const char *,STRING_SIZE, ASTERINTEGER *);

#define CALL_POSTKUTIL(a,b,c,d) CALLSSSS(POSTKUTIL,postkutil,a,b,c,d)
extern void DEFSSSS(POSTKUTIL,postkutil,char *,STRING_SIZE,char *,STRING_SIZE,
                    char *,STRING_SIZE,char *,STRING_SIZE);

#define CALL_MATFPE(a) CALLP(MATFPE,matfpe,a)
extern void DEFP(MATFPE, matfpe, ASTERINTEGER *);

#define CALL_OPTDEP(a,b,c) CALLSSP(OPTDEP, optdep, a, b, c)
extern void DEFSSP(OPTDEP, optdep, char *,STRING_SIZE, char *,STRING_SIZE, ASTERINTEGER *);

#define CALL_UTTCSM(a) CALLP(UTTCSM,uttcsm,a)
extern void DEFP(UTTCSM, uttcsm, ASTERDOUBLE *);


/* routines SUPERVISEUR */
#define CALL_EXPASS(a)  CALLP(EXPASS,expass,a)
extern void DEFP(EXPASS,expass, ASTERINTEGER*);

#define CALL_EXECOP(a)  CALLP(EXECOP,execop,a)
extern void DEFP(EXECOP,execop, ASTERINTEGER*);

#define CALL_OPSEXE(a)  CALLP(OPSEXE,opsexe,a)
extern void DEFP(OPSEXE,opsexe, ASTERINTEGER*) ;

#define CALL_OP9999(a) CALLP(OP9999,op9999,a)
extern void DEFP(OP9999,op9999, ASTERINTEGER*);

#define CALL_IMPERS() CALL0(IMPERS,impers)
extern void DEF0(IMPERS,impers);

#define CALL_ONERRF(a,b,c) CALLSSP(ONERRF,onerrf,a,b,c)
extern void DEFSSP(ONERRF,onerrf,char *,STRING_SIZE, _OUT char *,STRING_SIZE, _OUT ASTERINTEGER *);

#define CALL_GCNCON(a,b) CALLSS(GCNCON,gcncon,a,b)
extern void DEFSS(GCNCON,gcncon,char *,STRING_SIZE,char *,STRING_SIZE);

#define CALL_DEBUT() CALL0(DEBUT,debut)
extern void DEF0(DEBUT,debut);

#define CALL_IBMAIN() CALL0(IBMAIN,ibmain)
extern void DEF0(IBMAIN,ibmain);

#define CALL_POURSU() CALL0(POURSU,poursu)
extern void DEF0(POURSU,poursu);

#define CALLO_JEIMPR(a,b,c) CALLPOO(JEIMPR,jeimpr,a,b,c)
extern void DEFPSS(JEIMPR, jeimpr, _IN ASTERINTEGER*, const char*, STRING_SIZE,
                                   const char *,STRING_SIZE);

#define CALL_ASABRT(a) CALLP(ASABRT,asabrt,a)
extern void DEFP(ASABRT, asabrt, _IN ASTERINTEGER *);

/* routines JEVEUX */
#define CALL_JEMARQ() CALL0(JEMARQ, jemarq)
extern void DEF0(JEMARQ,jemarq);

#define CALL_JEDEMA() CALL0(JEDEMA, jedema)
extern void DEF0(JEDEMA,jedema);

#define CALL_JEDETR(a) CALLS(JEDETR, jedetr, a)
#define CALLO_JEDETR(a) CALLO(JEDETR, jedetr, a)
extern void DEFS(JEDETR, jedetr, const char *, STRING_SIZE);

#define CALL_JELST3(a,b,c,d)  CALLSSPP(JELST3,jelst3,a,b,c,d)
extern void DEFSSPP(JELST3,jelst3, char*, STRING_SIZE, char*, STRING_SIZE, ASTERINTEGER*,
                    ASTERINTEGER*);

#define CALL_JELIRA(a,b,c,d)  CALLSSPS(JELIRA,jelira,a,b,c,d)
#define CALLO_JELIRA(a,b,c,d)  CALLOOPO(JELIRA,jelira,a,b,c,d)
extern void DEFSSPS(JELIRA,jelira, const char*, STRING_SIZE, const char*, STRING_SIZE,
                    ASTERINTEGER*, const char*, STRING_SIZE );

#define CALL_JEEXIN(a,b)  CALLSP(JEEXIN,jeexin,a,b)
#define CALLO_JEEXIN(a,b)  CALLOP(JEEXIN,jeexin,a,b)
extern void DEFSP(JEEXIN,jeexin, const char*, STRING_SIZE, ASTERINTEGER* );

/* char functions: the first two arguments is the result */
#define CALLO_JEXNUM(a,b,c) CALLVOP(JEXNUM,jexnum,a,b,c)
extern void DEFVSP(JEXNUM, jexnum, const char*, STRING_SIZE,
                   const char*, STRING_SIZE, ASTERINTEGER* );

#define CALLO_JEXNOM(a,b,c) CALLVOO(JEXNOM,jexnom,a,b,c)
extern void DEFVSS(JEXNOM,jexnom, const char*, STRING_SIZE, const char*, STRING_SIZE,
                   const char*, STRING_SIZE );

#define CALLO_JENUNO(a, b) CALLOO(JENUNO, jenuno, a, b)
extern void DEFSS(JENUNO,jenuno, const char*, STRING_SIZE, const char*, STRING_SIZE );

#define CALLO_JENONU(a, b) CALLOP(JENONU, jenonu, a, b)
extern void DEFSP(JENONU,jenonu, const char*, STRING_SIZE, ASTERINTEGER* );

#define CALLO_JECREO(a, b) CALLOO(JECREO, jecreo, a, b)
void DEFSS(JECREO, jecreo, const char *, STRING_SIZE, const char *, STRING_SIZE);

#define CALLO_JECREC(a, b, c, d, e, f) CALLOOOOOP(JECREC, jecrec, a, b, c, d, e, f)
void DEFSSSSSP(JECREC, jecrec, const char *, STRING_SIZE, const char *, STRING_SIZE,
                               const char *, STRING_SIZE, const char *, STRING_SIZE,
                               const char *, STRING_SIZE, ASTERINTEGER*);

#define CALLO_JUCROC_WRAP(a, b, c, d, e) CALLOOPPP(JUCROC_WRAP, jucroc_wrap, a, b, c, d, e)
void DEFSSPPP(JUCROC_WRAP, jucroc_wrap, const char *, STRING_SIZE, const char *, STRING_SIZE,
                              ASTERINTEGER*, ASTERINTEGER*, void* );

#define CALLO_JEECRA_WRAP(a, b, c) CALLOOP(JEECRA_WRAP, jeecra_wrap, a, b, c)
void DEFSSP(JEECRA_WRAP, jeecra_wrap, const char *, STRING_SIZE,
            const char *, STRING_SIZE, ASTERINTEGER*);

#define CALLO_JEECRA_STRING_WRAP(a, b, c) CALLOOO(JEECRA_STRING_WRAP, jeecra_string_wrap, a, b, c)
void DEFSSS(JEECRA_STRING_WRAP, jeecra_string_wrap, const char *, STRING_SIZE,
                                             const char *, STRING_SIZE,
                                             const char *, STRING_SIZE);

#define CALLO_JECROC(a) CALLO(JECROC, jecroc, a)
void DEFS(JECROC, jecroc, const char *, STRING_SIZE);

#define CALLO_JEVEUOC(a, b, c) CALLOOP(JEVEUOC, jeveuoc, a, b, c)
void DEFSSP(JEVEUOC, jeveuoc, const char *, STRING_SIZE, const char *, STRING_SIZE, void*);

#define CALLO_JELSTC(a, b, c, d, e, f) CALLOOPPOP(JELSTC, jelstc, a, b, c, d, e, f)
void DEFSSPPSP(JELSTC, jelstc, const char *, STRING_SIZE, const char *, STRING_SIZE, ASTERINTEGER*,
                               ASTERINTEGER*, const char *, STRING_SIZE, ASTERINTEGER* );

#define CALLO_WKVECTC(a, b, c, d) CALLOOPP(WKVECTC, wkvectc, a, b, c, d)
void DEFSSPP(WKVECTC, wkvectc, const char *, STRING_SIZE, const char *, STRING_SIZE,
             ASTERINTEGER*, void*);

#define CALLO_ALCART(a, b, c, d) CALLOOOO(ALCART, alcart, a, b, c, d)
void DEFSSSS(ALCART, alcart, const char *, STRING_SIZE, const char *, STRING_SIZE,
             const char *, STRING_SIZE, const char *, STRING_SIZE);

#define CALLO_NOCARTC(a, b, c, d, e, f, g, h, i) \
    CALLOPPOOPOPO(NOCART_C, nocart_c, a, b, c, d, e, f, g, h, i)
void DEFSPPSSPSPS(NOCART_C, nocart_c, const char *, STRING_SIZE, const ASTERINTEGER*,
                  const ASTERINTEGER*, const char *, STRING_SIZE, const char *, STRING_SIZE,
                  const ASTERINTEGER*, const char *, STRING_SIZE, const ASTERINTEGER*,
                  const char *, STRING_SIZE);

#define CALLO_RSEXCH(a, b, c, d, e, f) CALLOOOPOP(RSEXCH, rsexch, a, b, c, d, e, f)
void DEFSSSPSP(RSEXCH, rsexch, const char *, STRING_SIZE, const char *, STRING_SIZE,
               const char *, STRING_SIZE, const ASTERINTEGER*, const char *, STRING_SIZE,
               const ASTERINTEGER*);

#define CALLO_RSNOCH(a, b, c) CALLOOP(RSNOCH_FORWARD, rsnoch_forward, a, b, c)
void DEFSSP(RSNOCH_FORWARD, rsnoch_forward, const char *, STRING_SIZE, const char *, STRING_SIZE,
            const ASTERINTEGER*);

#define CALLO_RSCRSD(a, b, c, d) CALLOOOP(RSCRSD, rscrsd, a, b, c, d)
void DEFSSSP(RSCRSD, rscrsd, const char *, STRING_SIZE, const char *, STRING_SIZE,
                             const char *, STRING_SIZE, const ASTERINTEGER*);

#define CALLO_UTIMSD(a, b, c, d, e, f, g, h) CALLPPPPOPOO(UTIMSD, utimsd, a, b, c, d, e, f, g, h)
void DEFPPPPSPSS(UTIMSD,utimsd, ASTERINTEGER*, ASTERINTEGER*, ASTERINTEGER*, ASTERINTEGER*,
                                const char*, STRING_SIZE, ASTERINTEGER*, const char*,
                                STRING_SIZE, const char*, STRING_SIZE );

#define CALLO_MERIME_WRAP(a, b, c, d, e, f, g, h, i, j) \
    CALLOPOOOPOOPO(MERIME_WRAP, merime_wrap, a, b, c, d, e, f, g, h, i, j)
void DEFSPSSSPSSPS(MERIME_WRAP,merime_wrap, const char*, STRING_SIZE, ASTERINTEGER*,
                   const char*, STRING_SIZE, const char*, STRING_SIZE, const char*, STRING_SIZE,
                   ASTERDOUBLE *, const char*, STRING_SIZE, const char*, STRING_SIZE,
                   ASTERINTEGER*, const char*, STRING_SIZE );

#define CALLO_RCMFMC_WRAP(a, b, c, d, e, f) CALLOOPPOO(RCMFMC_WRAP, rcmfmc_wrap, a, b, c, d, e, f)
void DEFSSPPSS(RCMFMC_WRAP,rcmfmc_wrap, const char*, STRING_SIZE, const char*, STRING_SIZE,
                                        ASTERINTEGER*, ASTERINTEGER*, const char*, STRING_SIZE,
                                        const char*, STRING_SIZE);

#define CALLO_CRESOL_WRAP(a, b) CALLOO(CRESOL_WRAP, cresol_wrap, a, b)
void DEFSS(CRESOL_WRAP,cresol_wrap, const char*, STRING_SIZE, const char*, STRING_SIZE);

#define CALLO_NUMERO_WRAP(a, b, c, d, e, f) CALLOOOOOO(NUMERO_WRAP, numero_wrap, a, b, c, d, e, f)
void DEFSSSSSS(NUMERO_WRAP,numero_wrap, const char*, STRING_SIZE, const char*, STRING_SIZE,
                                        const char*, STRING_SIZE, const char*, STRING_SIZE,
                                        const char*, STRING_SIZE, const char*, STRING_SIZE);

#define CALLO_GNOMSD(a, b, c, d) CALLOOPP(GNOMSD, gnomsd, a, b, c, d)
void DEFSSPP(GNOMSD,gnomsd, const char*, STRING_SIZE, const char*, STRING_SIZE, ASTERINTEGER *,
             ASTERINTEGER *);

#define CALLO_NMDOCH_WRAP(a, b, c, d) CALLOPOO(NMDOCH_WRAP, nmdoch_wrap, a, b, c, d)
void DEFSPSS(NMDOCH_WRAP,nmdoch_wrap, const char*, STRING_SIZE, ASTERINTEGER *,
             const char*, STRING_SIZE, const char*, STRING_SIZE);

#define CALL_ASMATR(a, b, c, d, e, f, g, h, i) \
    CALLPSSSSSSPS(ASMATR, asmatr, a, b, c, d, e, f, g, h, i)
void DEFPSSSSSSPS(ASMATR,asmatr, ASTERINTEGER *, const char*, STRING_SIZE,
                                  const char*, STRING_SIZE, const char*, STRING_SIZE,
                                  const char*, STRING_SIZE, const char*, STRING_SIZE,
                                  const char*, STRING_SIZE, ASTERINTEGER *,
                                  const char*, STRING_SIZE);

#define CALLO_DELETE_MATRIX(a, b) CALLOO(DELETE_MATRIX, delete_matrix, a, b)
void DEFSS(DELETE_MATRIX,delete_matrix, const char*, STRING_SIZE, const char*, STRING_SIZE);

#ifdef _HAVE_PETSC
#define CALLO_MATASS2PETSC(a, b, c) \
    CALLOPP(MATASS2PETSC, matass2petsc, a, b, c )
#define CALL_MATASS2PETSC(a, b, c) \
    CALLSPP(MATASS2PETSC, matass2petsc, a, b, c )
void DEFSPP(MATASS2PETSC,matass2petsc, const char*, STRING_SIZE,
                                  Mat *, PetscErrorCode *);
#endif

#define CALLO_MATRIX_FACTOR(a, b, c, d, e, f, g) \
    CALLOOPOOPP(MATRIX_FACTOR, matrix_factor, a, b, c, d, e, f, g)
void DEFSSPSSPP(MATRIX_FACTOR,matrix_factor, const char*, STRING_SIZE, const char*, STRING_SIZE,
                                  ASTERINTEGER *, const char*, STRING_SIZE,
                                  const char*, STRING_SIZE,
                                  ASTERINTEGER *, ASTERINTEGER *);

#define CALLO_RESOUD_WRAP(a, b, c, d, e, f, g, h, i, j, k, l) \
    CALLOOOOPOOOOPPP(RESOUD_WRAP, resoud_wrap, a, b, c, d, e, f, g, h, i, j, k, l)
void DEFSSSSPSSSSPPP(RESOUD_WRAP,resoud_wrap, const char*, STRING_SIZE, const char*, STRING_SIZE,
                                              const char*, STRING_SIZE, const char*, STRING_SIZE,
                                              ASTERINTEGER*,
                                              const char*, STRING_SIZE, const char*, STRING_SIZE,
                                              const char*, STRING_SIZE, const char*, STRING_SIZE,
                                              ASTERINTEGER *, ASTERINTEGER *, ASTERINTEGER *);

#define CALLO_VEDIME(a, b, c, d, e, f) CALLOOOPOO(VEDIME, vedime, a, b, c, d, e, f)
void DEFSSSPSS(VEDIME,vedime, const char*, STRING_SIZE, const char*, STRING_SIZE,
                              const char*, STRING_SIZE, ASTERDOUBLE *, const char*, STRING_SIZE,
                              const char*, STRING_SIZE);

#define CALLO_VELAME(a, b, c, d, e) CALLOOOOO(VELAME, velame, a, b, c, d, e)
void DEFSSSSS(VELAME,velame, const char*, STRING_SIZE, const char*, STRING_SIZE,
                             const char*, STRING_SIZE, const char*, STRING_SIZE,
                             const char*, STRING_SIZE);

#define CALLO_VECHME_WRAP(a, b, c, d, e, f, g, h, i) \
    CALLOOOOPOOOO(VECHME_WRAP, vechme_wrap, a, b, c, d, e, f, g, h, i)
void DEFSSSSPSSSS(VECHME_WRAP,vechme_wrap, const char*, STRING_SIZE, const char*, STRING_SIZE,
                                            const char*, STRING_SIZE, const char*, STRING_SIZE,
                                            const ASTERDOUBLE*,
                                            const char*, STRING_SIZE, const char*, STRING_SIZE,
                                            const char*, STRING_SIZE, const char*, STRING_SIZE);

#define CALLO_VTCREB_WRAP(a, b, c, d) CALLOOOO(VTCREB_WRAP, vtcreb_wrap, a, b, c, d)
void DEFSSSS(VTCREB_WRAP,vtcreb_wrap, const char*, STRING_SIZE, const char*, STRING_SIZE,
                                      const char*, STRING_SIZE, const char*, STRING_SIZE);

#define CALLO_ASASVE(a, b, c, d) CALLOOOO(ASASVE, asasve, a, b, c, d)
void DEFSSSS(ASASVE,asasve, const char*, STRING_SIZE, const char*, STRING_SIZE,
                            const char*, STRING_SIZE, const char*, STRING_SIZE);

#define CALLO_ASCOVA(a, b, c, d, e, f, g) CALLOOOOPOO(ASCOVA, ascova, a, b, c, d, e, f, g)
void DEFSSSSPSS(ASCOVA,ascova, const char*, STRING_SIZE, const char*, STRING_SIZE,
                               const char*, STRING_SIZE, const char*, STRING_SIZE,
                               const ASTERDOUBLE*,
                               const char*, STRING_SIZE, const char*, STRING_SIZE );

#define CALLO_ASCAVC(a, b, c, d, e, f) CALLOOOOPO(ASCAVC, ascavc, a, b, c, d, e, f)
void DEFSSSSPS(ASCAVC,ascavc, const char*, STRING_SIZE, const char*, STRING_SIZE,
                              const char*, STRING_SIZE, const char*, STRING_SIZE,
                              const ASTERDOUBLE*, const char*, STRING_SIZE );

#define CALLO_CORICH(a, b, c, d) CALLOOPP(CORICH, corich, a, b, c, d)
void DEFSSPP(CORICH,corich, const char*, STRING_SIZE, const char*, STRING_SIZE,
                            ASTERINTEGER*, ASTERINTEGER*);

#define CALLO_CNOCNS(a, b, c) CALLOOO(CNOCNS, cnocns, a, b, c)
void DEFSSS(CNOCNS,cnocns, const char*, STRING_SIZE, const char*, STRING_SIZE,
                           const char*, STRING_SIZE);

#define CALLO_CELCES_WRAP(a, b, c) CALLOOO(CELCES_WRAP, celces_wrap, a, b, c)
void DEFSSS(CELCES_WRAP,celces_wrap, const char*, STRING_SIZE, const char*, STRING_SIZE,
                                     const char*, STRING_SIZE);

#define CALLO_LRMJOI_WRAP(a, b) CALLOO(LRMJOI_WRAP, lrmjoi_wrap, a, b)
void DEFSS(LRMJOI_WRAP,lrmjoi_wrap, const char*, STRING_SIZE, const char*, STRING_SIZE);

#define CALLO_CARGEO(a) CALLO(CARGEO, cargeo, a)
void DEFS(CARGEO,cargeo, const char*, STRING_SIZE);

#define CALL_NBEC(a) CALLP(NBEC, nbec, a)
ASTERINTEGER DEFP(NBEC,nbec, const ASTERINTEGER* const);

#define CALL_ISDECO(a, b, c) CALLPPP(ISDECO, isdeco, a, b, c)
void DEFPPP(ISDECO,isdeco, ASTERINTEGER*, ASTERINTEGER*, ASTERINTEGER*);

#define CALLO_VRCREF(a, b, c, d) CALLOOOO(VRCREF, vrcref, a, b, c, d)
void DEFSSSS(VRCREF,vrcref, const char*, STRING_SIZE, const char*, STRING_SIZE,
                            const char*, STRING_SIZE, const char*, STRING_SIZE);

#define CALLO_VRCINS_WRAP(a, b, c, d, e, f) CALLOOOPOO(VRCINS_WRAP, vrcins_wrap, a, b, c, d, e, f)
void DEFSSSPSS(VRCINS_WRAP,vrcins_wrap, const char*, STRING_SIZE, const char*, STRING_SIZE,
                                        const char*, STRING_SIZE, const ASTERDOUBLE*,
                                        const char*, STRING_SIZE, const char*, STRING_SIZE);

#define CALLO_CACHVC(a, b, c, d, e, f, g, h, i, j, k) CALLOOOOOOOPPPP(CACHVC, cachvc, a, b, c,\
                                                                      d, e, f, g, h, i, j, k)
void DEFSSSSSSSPPPP(CACHVC,cachvc, const char*, STRING_SIZE, const char*, STRING_SIZE,
                                   const char*, STRING_SIZE, const char*, STRING_SIZE,
                                   const char*, STRING_SIZE, const char*, STRING_SIZE,
                                   const char*, STRING_SIZE, ASTERINTEGER *, ASTERINTEGER *,
                                   ASTERINTEGER *, ASTERINTEGER *);

#define CALLO_FOCAIN(a, b, c, d, e) CALLOOPOO(FOCAIN, focain, a, b, c, d, e)
void DEFSSPSS(FOCAIN,focain, const char*, STRING_SIZE, const char*, STRING_SIZE,
                             ASTERDOUBLE*, const char*, STRING_SIZE, const char*, STRING_SIZE);

/* routines d'accès aux OBJETS JEVEUX (vecteurs, collections, champs) */
#define CALL_GETCON(nomsd,iob,ishf,ilng,ctype,lcon,iaddr,nomob) \
    CALLSPPPPPPS(GETCON,getcon,nomsd,iob,ishf,ilng,ctype,lcon,iaddr,nomob)
extern void DEFSPPPPPPS(GETCON,getcon,char *,STRING_SIZE,ASTERINTEGER *,ASTERINTEGER *,
                        ASTERINTEGER *,ASTERINTEGER *,ASTERINTEGER *,char **,char *,STRING_SIZE);

#define CALL_PUTCON(nomsd,nbind,ind,valr,valc,num,iret) \
    CALLSPPPPPP(PUTCON,putcon,nomsd,nbind,ind,valr,valc,num,iret)
extern void DEFSPPPPPP(PUTCON,putcon,char *,STRING_SIZE,ASTERINTEGER *,ASTERINTEGER *,ASTERDOUBLE *,
                       ASTERDOUBLE *,ASTERINTEGER *,ASTERINTEGER *);

#define CALL_TAILSD(nom, nomsd, val, nbval) CALLSSPP(TAILSD,tailsd,nom, nomsd, val, nbval)
extern void DEFSSPP(TAILSD,tailsd,char *,STRING_SIZE,char *,STRING_SIZE,
                    ASTERINTEGER *, ASTERINTEGER *);

#define CALL_PRCOCH(nomce,nomcs,nomcmp,ktype,itopo,nval,groups) \
    CALLSSSSPPS(PRCOCH,prcoch,nomce,nomcs,nomcmp,ktype,itopo,nval,groups)
extern void DEFSSSSPPS(PRCOCH,prcoch,char *,STRING_SIZE,char *,STRING_SIZE,char *,STRING_SIZE,
                       char *,STRING_SIZE,ASTERINTEGER *,ASTERINTEGER *,char *,STRING_SIZE);

/* routine d'acces aux parametres memoire */
#define CALL_UTGTME(a,b,c,d) CALLPSPP(UTGTME,utgtme,a,b,c,d)
extern void DEFPSPP(UTGTME, utgtme, ASTERINTEGER *, char *,  STRING_SIZE,
                                    ASTERDOUBLE *, ASTERINTEGER *);

#define CALL_UTPTME(a,b,c) CALLSPP(UTPTME,utptme,a,b,c)
extern void DEFSPP(UTPTME, utptme, char *,  STRING_SIZE,  ASTERDOUBLE *, ASTERINTEGER *);

#define CALLO_RSADPA_ZK8_WRAP(a,b,c,d) CALLOPOO(RSADPA_ZK8_WRAP,rsadpa_zk8_wrap,a,b,c,d)
extern void DEFSPSS(RSADPA_ZK8_WRAP, rsadpa_zk8_wrap, const char *, STRING_SIZE,
                    ASTERINTEGER *, const char *,  STRING_SIZE, const char *,  STRING_SIZE);

#define CALLO_RSADPA_ZR_WRAP(a,b,c,d) CALLOPPO(RSADPA_ZR_WRAP,rsadpa_zr_wrap,a,b,c,d)
extern void DEFSPPS(RSADPA_ZR_WRAP, rsadpa_zr_wrap, const char *, STRING_SIZE,
                    ASTERINTEGER *, ASTERDOUBLE *, const char *,  STRING_SIZE);

#define CALLO_RSADPA_ZK24_WRAP(a,b,c,d) CALLOPOO(RSADPA_ZK24_WRAP,rsadpa_zk24_wrap,a,b,c,d)
extern void DEFSPSS(RSADPA_ZK24_WRAP, rsadpa_zk24_wrap, const char *, STRING_SIZE,
                    ASTERINTEGER *, const char *,  STRING_SIZE, const char *,  STRING_SIZE);

/* routines de manipulation de la SD RESULTAT */
extern void DEFSPPSPPPSP(RSACPA,rsacpa,char *, STRING_SIZE, ASTERINTEGER *, ASTERINTEGER *,
          char *, STRING_SIZE, ASTERINTEGER *, ASTERINTEGER *, ASTERDOUBLE *,
          char *, STRING_SIZE, ASTERINTEGER *);
#define CALL_RSACPA(nomsd, numva, icode, nomva, ctype, ival, rval, kval, ier) \
    CALLSPPSPPPSP(RSACPA,rsacpa, nomsd, numva, icode, nomva, ctype, ival, rval, kval, ier)

#define CALLO_RCSTOC_VERIF(a,b,c,d) CALLOOOP(RCSTOC_VERIF,rcstoc_verif,a,b,c,d)
extern void DEFSSSP(RCSTOC_VERIF, rcstoc_verif, const char *, STRING_SIZE,
                    const char *,  STRING_SIZE, const char *,  STRING_SIZE, ASTERINTEGER *);

#define CALLO_DETRSD(a,b,c,d) CALLOO(DETRSD,detrsd,a,b)
extern void DEFSS(DETRSD, detrsd, const char *, STRING_SIZE,
                  const char *,  STRING_SIZE);

/* particulier car on passe les longueurs des chaines en dur */
extern void DEFSPSPPPS(RSACCH,rsacch,char *, STRING_SIZE, ASTERINTEGER *, char *,STRING_SIZE,
    ASTERINTEGER *, ASTERINTEGER *, ASTERINTEGER *, char *,STRING_SIZE);
#ifdef _STRLEN_AT_END
#define CALL_RSACCH(nomsd, numch, nomch, nbord, liord, nbcmp, liscmp) \
          F_FUNC(RSACCH,rsacch)(nomsd,numch,nomch,nbord,liord,nbcmp,liscmp, strlen(nomsd),16,8)
#else
#define CALL_RSACCH(nomsd, numch, nomch, nbord, liord, nbcmp, liscmp) \
          F_FUNC(RSACCH,rsacch)(nomsd,strlen(nomsd),numch, nomch,16,nbord, liord, nbcmp, liscmp,8)
#endif

/* routines interface MPI */
#define CALL_ASMPI_CHECK(a) CALLP(ASMPI_CHECK,asmpi_check,a)
extern void DEFP(ASMPI_CHECK,asmpi_check,ASTERINTEGER *);

#define CALL_ASMPI_WARN(a) CALLP(ASMPI_WARN,asmpi_warn,a)
extern void DEFP(ASMPI_WARN,asmpi_warn,ASTERINTEGER *);

/* routines intrinseques fortran */
#define CALL_ABORTF() CALL0(ABORTF,abortf)
extern void DEF0(ABORTF,abortf);

/* routines de manipulation de la SD MATERIAU */
#define CALL_RCVALE_WRAP(a,b,c,d,e,f,g,h,i,j) \
        CALLSSPSPPSPPP(RCVALE_WRAP,rcvale_wrap,a,b,c,d,e,f,g,h,i,j)
extern void DEFSSPSPPSPPP(RCVALE_WRAP, rcvale_wrap, char *,STRING_SIZE, char *,STRING_SIZE,
    ASTERINTEGER *, char *,STRING_SIZE, ASTERDOUBLE *, ASTERINTEGER *, char *,STRING_SIZE,
    ASTERDOUBLE *, ASTERINTEGER *, ASTERINTEGER *);


/* routines d'impression des MESSAGES */
#define CALL_AFFICH(a,b) CALLOO(AFFICH,affich,a,b)
extern void DEFSS(AFFICH,affich, const char *,STRING_SIZE, const char *,STRING_SIZE);

#define CALL_UTMESS(cod, idmess) CALLSS(UTMESS_CWRAP, utmess_cwrap, cod, idmess)
extern void DEFSS(UTMESS_CWRAP, utmess_cwrap, char *, STRING_SIZE, char *, STRING_SIZE);

/* particulier car on fixe les longueurs des chaines valk */
#define VALK_SIZE 128
extern void DEFSSPSPPPPS(UTMESS_CORE, utmess_core, char *, STRING_SIZE, char *, STRING_SIZE,
                         ASTERINTEGER *, char *, STRING_SIZE, ASTERINTEGER *,
                         ASTERINTEGER *, ASTERINTEGER *, ASTERDOUBLE *,
                         char *, STRING_SIZE);
#ifdef _STRLEN_AT_END
#define CALL_UTMESS_CORE(cod, idmess, nk, valk, ni, vali, nr, valr, fname) \
    F_FUNC(UTMESS_CORE, utmess_core)(cod, idmess, nk, valk, ni, vali, nr, valr, fname, \
                                     strlen(cod), strlen(idmess), VALK_SIZE, strlen(fname))
#else
#define CALL_UTMESS_CORE(cod, idmess, nk, valk, ni, vali, nr, valr, fname) \
    F_FUNC(UTMESS_CORE, utmess_core)(cod, strlen(cod), idmess, strlen(idmess), nk, \
                                     valk, VALK_SIZE, ni, vali, nr, valr, fname, strlen(fname))
#endif


/* routines UTILITAIRES pour MED */
#define CALL_MDNOMA(a,b,c,d) CALLSPSP(MDNOMA,mdnoma,a,b,c,d)
extern void DEFSPSP(MDNOMA,mdnoma,char *,STRING_SIZE,ASTERINTEGER *,
                    char *,STRING_SIZE,ASTERINTEGER *);

#define CALL_MDNOCH(a,b,c,d,e,f,g) CALLSPPSSSP(MDNOCH,mdnoch,a,b,c,d,e,f,g)
extern void DEFSPPSSSP(MDNOCH,mdnoch,char *,STRING_SIZE,ASTERINTEGER *,ASTERINTEGER *,
                       char *,STRING_SIZE,char *,STRING_SIZE,
                       char *,STRING_SIZE,ASTERINTEGER *);

#ifdef __cplusplus
}
#endif

/* FIN ASTER_FORT_H */
#endif
