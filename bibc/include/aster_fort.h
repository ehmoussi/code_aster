/* ================================================================== */
/* COPYRIGHT (C) 1991 - 2015  EDF R&D              WWW.CODE-ASTER.ORG */
/*                                                                    */
/* THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR      */
/* MODIFY IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS     */
/* PUBLISHED BY THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE */
/* LICENSE, OR (AT YOUR OPTION) ANY LATER VERSION.                    */
/* THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL,    */
/* BUT WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF     */
/* MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU   */
/* GENERAL PUBLIC LICENSE FOR MORE DETAILS.                           */
/*                                                                    */
/* YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE  */
/* ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,      */
/*    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.     */
/* ================================================================== */

#ifndef ASTER_FORT_H
#define ASTER_FORT_H

#include "aster.h"
#include "aster_mpi.h"

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
extern void DEFSSSPSSP(DISMOI, dismoi, const char *,STRING_SIZE,
                       const char *,STRING_SIZE, const char *,STRING_SIZE, ASTERINTEGER *,
                       char *,STRING_SIZE, const char *,STRING_SIZE, ASTERINTEGER *);

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

#define CALL_ASABRT(a) CALLP(ASABRT,asabrt,a)
extern void DEFP(ASABRT, asabrt, _IN ASTERINTEGER *);


/* routines JEVEUX */
#define CALL_JEMARQ() CALL0(JEMARQ, jemarq)
extern void DEF0(JEMARQ,jemarq);

#define CALL_JEDEMA() CALL0(JEDEMA, jedema)
extern void DEF0(JEDEMA,jedema);

#define CALL_JEDETR(a) CALLS(JEDETR, jedetr, a)
extern void DEFS(JEDETR, jedetr, const char *, STRING_SIZE);

#define CALL_JEDETC(a, b, c) CALLSSP(JEDETC, jedetc, a, b, c)
extern void DEFSSP(JEDETC, jedetc, char *, STRING_SIZE, char *, STRING_SIZE, ASTERINTEGER*);

#define CALL_JELST3(a,b,c,d)  CALLSSPP(JELST3,jelst3,a,b,c,d)
extern void DEFSSPP(JELST3,jelst3, char*, STRING_SIZE, char*, STRING_SIZE, ASTERINTEGER*,
                    ASTERINTEGER*);

#define CALL_JELIRA(a,b,c,d)  CALLSSPS(JELIRA,jelira,a,b,c,d)
extern void DEFSSPS(JELIRA,jelira, const char*, STRING_SIZE, const char*, STRING_SIZE,
                    ASTERINTEGER*, char*, STRING_SIZE );

#define CALL_JEEXIN(a,b)  CALLSP(JEEXIN,jeexin,a,b)
extern void DEFSP(JEEXIN,jeexin, const char*, STRING_SIZE, ASTERINTEGER* );

/* char functions: the first two arguments is the result */
#define CALL_JEXNUM(a,b,c) CALLVSP(JEXNUM,jexnum,a,b,c)
extern void DEFVSP(JEXNUM, jexnum, char*, STRING_SIZE, const char*, STRING_SIZE, ASTERINTEGER* );

#define CALL_JEXNOM(a,b,c) CALLVSS(JEXNOM,jexnom,a,b,c)
extern void DEFVSS(JEXNOM,jexnom, char*, STRING_SIZE, const char*, STRING_SIZE,
                   const char*, STRING_SIZE );

#define CALL_JENUNO(a, b) CALLSS(JENUNO, jenuno, a, b)
extern void DEFSS(JENUNO,jenuno, char*, STRING_SIZE, char*, STRING_SIZE );

#define CALL_JENONU(a, b) CALLSP(JENONU, jenonu, a, b)
extern void DEFSP(JENONU,jenonu, char*, STRING_SIZE, ASTERINTEGER* );

#define CALL_JEVEUOC(a, b, c) CALLSSP(JEVEUOC, jeveuoc, a, b, c)
void DEFSSP(JEVEUOC, jeveuoc, const char *, STRING_SIZE, const char *, STRING_SIZE, void*);

#define CALL_WKVECTC(a, b, c, d) CALLSSPP(WKVECTC, wkvectc, a, b, c, d)
void DEFSSPP(WKVECTC, wkvectc, const char *, STRING_SIZE, const char *, STRING_SIZE,
             ASTERINTEGER*, void*);

#define CALL_ALCART(a, b, c, d) CALLSSSS(ALCART, alcart, a, b, c, d)
void DEFSSSS(ALCART, alcart, const char *, STRING_SIZE, const char *, STRING_SIZE,
             const char *, STRING_SIZE, const char *, STRING_SIZE);

#define CALL_NOCARTC(a, b, c, d, e, f, g, h, i) \
    CALLSPPSSPSPS(NOCART_C, nocart_c, a, b, c, d, e, f, g, h, i)
void DEFSPPSSPSPS(NOCART_C, nocart_c, const char *, STRING_SIZE, const ASTERINTEGER*,
                  const ASTERINTEGER*, const char *, STRING_SIZE, const char *, STRING_SIZE,
                  const ASTERINTEGER*, const char *, STRING_SIZE, const ASTERINTEGER*,
                  const char *, STRING_SIZE);

#define CALL_RSEXCH(a, b, c, d, e, f) CALLSSSPSP(RSEXCH, rsexch, a, b, c, d, e, f)
void DEFSSSPSP(RSEXCH, rsexch, const char *, STRING_SIZE, const char *, STRING_SIZE,
               const char *, STRING_SIZE, const ASTERINTEGER*, const char *, STRING_SIZE,
               const ASTERINTEGER*);

#define CALL_RSNOCH(a, b, c) CALLSSP(RSNOCH_FORWARD, rsnoch_forward, a, b, c)
void DEFSSP(RSNOCH_FORWARD, rsnoch_forward, const char *, STRING_SIZE, const char *, STRING_SIZE,
            const ASTERINTEGER*);

#define CALL_RSCRSD(a, b, c, d) CALLSSSP(RSCRSD, rscrsd, a, b, c, d)
void DEFSSSP(RSCRSD, rscrsd, const char *, STRING_SIZE, const char *, STRING_SIZE,
                             const char *, STRING_SIZE, const ASTERINTEGER*);

#define CALL_UTIMSD(a, b, c, d, e, f, g, h) CALLPPPPSPSS(UTIMSD, utimsd, a, b, c, d, e, f, g, h)
void DEFPPPPSPSS(UTIMSD,utimsd, ASTERINTEGER*, ASTERINTEGER*, ASTERINTEGER*, ASTERINTEGER*,
                                const char*, STRING_SIZE, ASTERINTEGER*, const char*,
                                STRING_SIZE, const char*, STRING_SIZE );

#define CALL_MERIME_WRAP(a, b, c, d, e, f, g, h, i, j) \
    CALLSPSSSPSSPS(MERIME_WRAP, merime_wrap, a, b, c, d, e, f, g, h, i, j)
void DEFSPSSSPSSPS(MERIME_WRAP,merime_wrap, const char*, STRING_SIZE, ASTERINTEGER*,
                   const char*, STRING_SIZE, const char*, STRING_SIZE, const char*, STRING_SIZE,
                   ASTERDOUBLE *, const char*, STRING_SIZE, const char*, STRING_SIZE,
                   ASTERINTEGER*, const char*, STRING_SIZE );

#define CALL_RCMFMC(a, b) CALLSS(RCMFMC, rcmfmc, a, b)
void DEFSS(RCMFMC,rcmfmc, const char*, STRING_SIZE, const char*, STRING_SIZE);

#define CALL_CRESOL_WRAP(a, b) CALLSS(CRESOL_WRAP, cresol_wrap, a, b)
void DEFSS(CRESOL_WRAP,cresol_wrap, const char*, STRING_SIZE, const char*, STRING_SIZE);

#define CALL_NUMERO_WRAP(a, b, c, d, e, f) CALLSSSSSS(NUMERO_WRAP, numero_wrap, a, b, c, d, e, f)
void DEFSSSSSS(NUMERO_WRAP,numero_wrap, const char*, STRING_SIZE, const char*, STRING_SIZE,
                                        const char*, STRING_SIZE, const char*, STRING_SIZE,
                                        const char*, STRING_SIZE, const char*, STRING_SIZE);

#define CALL_GNOMSD(a, b, c, d) CALLSSPP(GNOMSD, gnomsd, a, b, c, d)
void DEFSSPP(GNOMSD,gnomsd, const char*, STRING_SIZE, const char*, STRING_SIZE, ASTERINTEGER *,
             ASTERINTEGER *);

#define CALL_NMDOCH_WRAP(a, b, c) CALLSPS(NMDOCH_WRAP, nmdoch_wrap, a, b, c)
void DEFSPS(NMDOCH_WRAP,nmdoch_wrap, const char*, STRING_SIZE, ASTERINTEGER *,
            const char*, STRING_SIZE);

#define CALL_ASMATR(a, b, c, d, e, f, g, h, i) \
    CALLPSSSSSSPS(ASMATR, asmatr, a, b, c, d, e, f, g, h, i)
void DEFPSSSSSSPS(ASMATR,asmatr, ASTERINTEGER *, const char*, STRING_SIZE,
                                  const char*, STRING_SIZE, const char*, STRING_SIZE,
                                  const char*, STRING_SIZE, const char*, STRING_SIZE,
                                  const char*, STRING_SIZE, ASTERINTEGER *,
                                  const char*, STRING_SIZE);

#define CALL_MATRIX_FACTOR(a, b, c, d, e, f, g) \
    CALLSSPSSPP(MATRIX_FACTOR, matrix_factor, a, b, c, d, e, f, g)
void DEFSSPSSPP(MATRIX_FACTOR,matrix_factor, const char*, STRING_SIZE, const char*, STRING_SIZE,
                                  ASTERINTEGER *, const char*, STRING_SIZE,
                                  const char*, STRING_SIZE,
                                  ASTERINTEGER *, ASTERINTEGER *);

#define CALL_RESOUD_WRAP(a, b, c, d, e, f, g, h, i, j, k, l) \
    CALLSSSSPSSSSPPP(RESOUD_WRAP, resoud_wrap, a, b, c, d, e, f, g, h, i, j, k, l)
void DEFSSSSPSSSSPPP(RESOUD_WRAP,resoud_wrap, const char*, STRING_SIZE, const char*, STRING_SIZE,
                                              const char*, STRING_SIZE, const char*, STRING_SIZE,
                                              ASTERINTEGER*,
                                              const char*, STRING_SIZE, const char*, STRING_SIZE,
                                              const char*, STRING_SIZE, const char*, STRING_SIZE,
                                              ASTERINTEGER *, ASTERINTEGER *, ASTERINTEGER *);

#define CALL_VEDIME(a, b, c, d, e, f) CALLSSSPSS(VEDIME, vedime, a, b, c, d, e, f)
void DEFSSSPSS(VEDIME,vedime, const char*, STRING_SIZE, const char*, STRING_SIZE,
                              const char*, STRING_SIZE, ASTERDOUBLE *, const char*, STRING_SIZE,
                              const char*, STRING_SIZE);

#define CALL_VELAME(a, b, c, d, e) CALLSSSSS(VELAME, velame, a, b, c, d, e)
void DEFSSSSS(VELAME,velame, const char*, STRING_SIZE, const char*, STRING_SIZE,
                             const char*, STRING_SIZE, const char*, STRING_SIZE,
                             const char*, STRING_SIZE);

#define CALL_VECHME_WRAP(a, b, c, d, e, f, g, h, i) \
    CALLSSSSPSSSS(VECHME_WRAP, vechme_wrap, a, b, c, d, e, f, g, h, i)
void DEFSSSSPSSSS(VECHME_WRAP,vechme_wrap, const char*, STRING_SIZE, const char*, STRING_SIZE,
                                            const char*, STRING_SIZE, const char*, STRING_SIZE,
                                            const ASTERDOUBLE*,
                                            const char*, STRING_SIZE, const char*, STRING_SIZE,
                                            const char*, STRING_SIZE, const char*, STRING_SIZE);

#define CALL_VTCREB_WRAP(a, b, c, d) CALLSSSS(VTCREB_WRAP, vtcreb_wrap, a, b, c, d)
void DEFSSSS(VTCREB_WRAP,vtcreb_wrap, const char*, STRING_SIZE, const char*, STRING_SIZE,
                                      const char*, STRING_SIZE, const char*, STRING_SIZE);

#define CALL_ASASVE(a, b, c, d) CALLSSSS(ASASVE, asasve, a, b, c, d)
void DEFSSSS(ASASVE,asasve, const char*, STRING_SIZE, const char*, STRING_SIZE,
                            const char*, STRING_SIZE, const char*, STRING_SIZE);

#define CALL_ASCOVA(a, b, c, d, e, f, g) CALLSSSSPSS(ASCOVA, ascova, a, b, c, d, e, f, g)
void DEFSSSSPSS(ASCOVA,ascova, const char*, STRING_SIZE, const char*, STRING_SIZE,
                               const char*, STRING_SIZE, const char*, STRING_SIZE, const ASTERDOUBLE*,
                               const char*, STRING_SIZE, const char*, STRING_SIZE );

#define CALL_ASCAVC(a, b, c, d, e, f) CALLSSSSPS(ASCAVC, ascavc, a, b, c, d, e, f)
void DEFSSSSPS(ASCAVC,ascavc, const char*, STRING_SIZE, const char*, STRING_SIZE,
                              const char*, STRING_SIZE, const char*, STRING_SIZE,
                              const ASTERDOUBLE*, const char*, STRING_SIZE );

#define CALL_CORICH(a, b, c, d) CALLSSPP(CORICH, corich, a, b, c, d)
void DEFSSPP(CORICH,corich, const char*, STRING_SIZE, const char*, STRING_SIZE,
                            ASTERINTEGER*, ASTERINTEGER*);

#define CALL_DETRSD(a, b) CALLSS(DETRSD, detrsd, a, b)
void DEFSS(DETRSD,detrsd, const char*, STRING_SIZE, const char*, STRING_SIZE);

#define CALL_CNOCNS(a, b, c) CALLSSS(CNOCNS, cnocns, a, b, c)
void DEFSSS(CNOCNS,cnocns, const char*, STRING_SIZE, const char*, STRING_SIZE,
                           const char*, STRING_SIZE);

#define CALL_CELCES(a, b, c) CALLSSS(CELCES, celces, a, b, c)
void DEFSSS(CELCES,celces, const char*, STRING_SIZE, const char*, STRING_SIZE,
                           const char*, STRING_SIZE);

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

/* routines de manipulation de la SD RESULTAT */
extern void DEFSPPSPPPSP(RSACPA,rsacpa,char *, STRING_SIZE, ASTERINTEGER *, ASTERINTEGER *,
          char *, STRING_SIZE, ASTERINTEGER *, ASTERINTEGER *, ASTERDOUBLE *,
          char *, STRING_SIZE, ASTERINTEGER *);
#define CALL_RSACPA(nomsd, numva, icode, nomva, ctype, ival, rval, kval, ier) \
    CALLSPPSPPPSP(RSACPA,rsacpa, nomsd, numva, icode, nomva, ctype, ival, rval, kval, ier)

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
#define CALL_AFFICH(a,b) CALLSS(AFFICH,affich,a,b)
extern void DEFSS(AFFICH,affich,char *,STRING_SIZE,char *,STRING_SIZE);

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
