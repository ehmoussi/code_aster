/* ------------------------------------------------------------------ */
/*           CONFIGURATION MANAGEMENT OF EDF VERSION                  */
/* MODIF asterm utilitai  DATE 20/12/2011   AUTEUR COURTOIS M.COURTOIS */
/* ================================================================== */
/* COPYRIGHT (C) 1991 - 2011  EDF R&D              WWW.CODE-ASTER.ORG */
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
/* ALONG WITH THIS PROGRAM; IF NOT, WRITE TO : EDF R&D CODE_ASTER,    */
/*    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.     */
/* ================================================================== */
/* RESPONSABLE LEFEBVRE J-P.LEFEBVRE */
/* ------------------------------------------------------------------ */
#include "aster.h"
#include "aster_fort.h"
#include "aster_utils.h"


#ifdef _POSIX
#include <sys/utsname.h> /* Pour le nom de la machine d'execution */
#endif


void strmaju(char *namin, char *namaj, STRING_SIZE l)
{
    int iin, jjn;
    char *p,*q;

    p=namin;
    q=namaj;

    /* troncature a l caracteres et passage en majuscules */
    iin=0;
    while ((*p != '\0') && (iin < l)) {
        *q++=toupper(*p++);
        iin++;
    }
    for (jjn=iin;jjn<l;jjn++) *q++=' ';
    *q='\0';
}

void strcpBS(char *namin, char *namaj , STRING_SIZE l , INTEGER *ll)
{
    int iin, jjn;
    char *p,*q;
#if defined _POSIX
#define BS  '/'
#else
#define BS  0x5c
#endif

    p=namin;
    q=namaj;

    /* troncature a l caracteres  */
    iin=0;
    while ((*p != '\0') && (iin < l)) {
        *q++=*p++;
        iin++;
    }
    if ( iin != 0) {
        *q++=BS;
        iin++;
        *ll=iin;
    }
    for (jjn=iin;jjn<l;jjn++) *q++=' ';
    *q='\0';
}

char g_memory[32],g_tpmax[32];

void asterm(long argc, char** argv)
/*
** Programme principal d'Aster pour enrober le Code_Aster
** afin de traiter les arguments de la ligne de commande
** et positionner des indicateurs en consequence.
*/
{
    INTEGER ivers, iutil, iniv, ilog;
    char *vdate;
    INTEGER cerr, iret;
    INTEGER inter;
    INTEGER r1,r2,r3;

    /*
** Initialisation
*/

    iret=CALL_INIAST(&r1,&r2,&r3);

    vdate = MakeBlankFStr(16);
    CALL_VERSIO(&ivers,&iutil,&iniv,vdate,&ilog);
    FreeStr(vdate);
    *argv ++;

    /* Nom de la machine */
    {
        char nodename[17],nomos[17],nomcpu[17];
        char *pn,*os,*mach;
        INTEGER fino=0;

#ifdef _POSIX
        struct utsname un;
        uname(&un);
        pn=un.nodename;
        os=un.sysname;
        mach=un.machine;
#else
        pn=getenv ("COMPUTERNAME");
        if ( pn == NULL ) {
            pn="????";
        }
        os=getenv ("OS");
        if ( os == NULL ) {
            os="????";
        }
        mach = getenv("PROCESSOR_ARCHITECTURE");
        if ( mach == NULL ) {
            mach=getenv ("CPU");
            if ( mach == NULL ) {
                mach="????";
            }
        }
#endif
        strmaju(pn, nodename, 16);
        strmaju(os, nomos, 16);
        strmaju(mach, nomcpu, 16);

      CALL_NODNAM(&fino,nodename,nomos,nomcpu);
    }

#ifdef _POSIX
    g_memory[0] = '\0';
    g_tpmax[0] = '\0';
#endif
/*
** Init pour le repertoire associe au catalogue materiau
   pour les scripts appelables depuis aster et pour les
   donnees lues depuis aster
*/
    put_repmat(REP_MAT);
    put_repout(REP_OUT);
    put_repdex(REP_DON);
/*
** Traitement des arguments de la ligne de commande
*/
    while (*argv != NULL) {
        ASSERT(argv!=NULL) ; ASSERT(*argv!=NULL) ;
        /*
   ** Execution en interactif
   */
        if (strcmp(*argv,"-i") == 0) {
            inter=1;
            cerr=CALL_ISINTE(&inter);
        }
        /*
   ** Suivi interactif d'un batch
   */
        if (strcmp(*argv,"-suivi_batch") == 0) {
            inter=1;
            cerr=CALL_ISSUIV(&inter);
        }
        /*
   ** Verification de la syntaxe des commandes
   */
        if (strcmp(*argv,"-verif") == 0) {
            inter=1;
            cerr=CALL_IVERIF(&inter);
        }
        /*
   ** Limite memoire
   */
        if (strcmp(*argv,"-mem") == 0){
            *argv++;
            strcpy(g_memory,*argv);
            inter=1;
            cerr=CALL_LMEMEX(&inter);
        }
        /*
   ** Debug JEVEUX
   */
        if (strcmp(*argv,"-dbgjeveux") == 0) {
            inter=1;
            cerr=CALL_ISDBGJ(&inter);
        }
   /*
   ** Memoire JEVEUX en Mo
   */
        if (strcmp(*argv,"-memory") == 0) {
            double finter;
            *argv++;
            finter=(double) atof(*argv);
            cerr=CALL_MJVXMO(&finter);
        }
   /*
   ** Maximum memoire statique JEVEUX en Mo
   */
        if (strcmp(*argv,"-memory_stat") == 0) {
            double mxmemst;
            *argv++;
            mxmemst=(double) atof(*argv);
            cerr=CALL_MJVSMO(&mxmemst);
        }
   /*
   ** Memoire JEVEUX en Mw
   */
        if (strcmp(*argv,"-memjeveux") == 0) {
            DOUBLE finter;
            *argv++;
            finter=(DOUBLE) atof(*argv);
            cerr=CALL_MEMJVX(&finter);
        }
        /*
   ** Maximum memoire dynamique JEVEUX
   */
        if (strcmp(*argv,"-mxmemdy") == 0) {
            double mxmem;
            *argv++;
            mxmem=(double) atof(*argv);
            cerr=CALL_MEJVDY(&mxmem);
        }
        /*
   ** Type parcours de la segmentation Memoire JEVEUX
   */
        if (strcmp(*argv,"-type_alloc") == 0) {
            INTEGER typseg;
            *argv++;
            typseg=(INTEGER)atol(*argv);
            cerr=CALL_SEGJVX(&typseg);
        }
        /*
   ** Taille des segments de valeurs associ�s (parcours de type 3)
   */
        if (strcmp(*argv,"-taille") == 0) {
            INTEGER lseg;
            *argv++;
            lseg=(INTEGER)atol(*argv);
            cerr=CALL_LSEGJV(&lseg);
        }
        /*
   ** Partition memoire (parcours de type 4)
   */
        if (strcmp(*argv,"-partition") == 0) {
            DOUBLE vpar,rerr;
            *argv++;
            vpar=(DOUBLE)atof(*argv);
            rerr=CALL_VPARJV(&vpar);
        }
        /*
   ** Taille maximale des bases (en mega-octets)
   */
        if (strcmp(*argv,"-max_base") == 0) {
            DOUBLE tmax,rerr;
            *argv++;
            tmax=(DOUBLE) atof(*argv);
            rerr=CALL_MAXBAS(&tmax);
        }
        /*
   ** Repertoire des fichiers du catalogue materiau
   */
        if (strcmp(*argv,"-rep_mat") == 0) {
            *argv++;
            put_repmat( *argv );
        }
        /*
   ** Repertoire des outils (logiciels externes, scripts)
   */
        if (strcmp(*argv,"-rep_outils") == 0) {
            *argv++;
            put_repout( *argv );
        }
        /*
   ** Repertoire des donnees externes
   */
        if (strcmp(*argv,"-rep_dex") == 0) {
            *argv++;
            put_repdex( *argv );
        }
        /*
   ** Limite de temps CPU en secondes
   */
        if (strcmp(*argv,"-tpmax") == 0) {
            *argv++;
            strcpy(g_tpmax,*argv);
        }
        /*
   ** Application d'origine
   */
        if (strcmp(*argv,"-origine") == 0) {
            INTEGER fi=0;
            char ori[17];
            long ii=0;
            long jj;
            char* p;
            char* q;

            /* Formatage d'une chaine de caracteres compatible avec le FORTRAN */
            *argv++;
            p=*argv;
            q=ori;
            while ((*p != '\0') && (ii < 16)) {
                *q++=toupper(*p++);
                ii++;
            }
            for (jj=ii;jj<16;jj++) *q++=' ';
            *q='\0';
            CALL_ORIGIN(&fi,ori);
        }
        /*
   ** Aide en ligne
   */
        else if ((strcmp(*argv,"-help") == 0) ||
            (strcmp(*argv,"-h")    == 0) ||
            (strcmp(*argv,"-aide") == 0) ) {
            printf("USAGE :\n");
            printf("     -i              : execution en interactif\n");
            printf("     -suivi_batch    : suivi en interactif d'un batch\n");
            printf("                     : (le buffer du fichier de sortie est vide a chaque ligne) \n");
            printf("     -verif          : uniquement verification de la syntaxe des commandes\n");
            printf("     -dbgjeveux      : mode debug JEVEUX (positionnement a UNDEF des objets liberes)\n");
            printf("     -mem            : limite memoire superieure pour l'allocation des structures JEVEUX (en Mw)\n");
            printf("     -memjeveux val  : memoire exacte a allouer pour les structures JEVEUX (en Mw)\n");
            printf("     -type_alloc val : mode de parcours de la segmentation memoire\n");
            printf("     -taille val     : taille (en w) des segments de valeurs alloues en fin de memoire (parcours de type 3)\n");
            printf("     -partition val  : pourcentage (0.0<val<1.0) de la memoire allouee affectee a la premiere partition\n");
            printf("     -rep val        : repertoire d'accueil pour les statistiques \n");
            printf("     -rep_mat val    : repertoire des fichiers du catalogue materiau \n");
            printf("     -rep_outils val : repertoire des scripts lances par Aster \n");
            printf("     -rep_dex    val : repertoire des donnees externes lues par Aster \n");
            printf("     -tpmax val      : temps CPU maximum en secondes pour le passage \n");
            printf("     -origine val    : application d'origine qui utilise le Code_Aster(pour les statistiques)\n");
            printf("     -max_base val   : taille maximale en mega-octets des bases JEVEUX\n");
            printf("     -help ou -h ou -aide : le present message\n");
            exit(0);
        }
        *argv++;
    }

    return ;
}
