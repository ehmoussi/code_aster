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
#include "aster_fort.h"

#ifdef _HAVE_METIS
#include "programs/metisbin.h"
#endif

/* Prototypes of internal functions */
int ReadGraphL(graph_t *, int *, int *, int *, int *, int *, int *);
int ComputeFillInL(graph_t *, idx_t *, int *, int *, int *,
                   int *, double *, int *, int *);
int smbfctl(int, idx_t *, idx_t *, idx_t *, idx_t *, idx_t *, int *, idx_t *,
            idx_t *, int *, int *, int *, int *, int *, double *);


void DEFPPPPPPPPPPPPP(ONMETL,onmetl,nbnd,nadj,xadjd,adjncy,
                      invpnd,permnd,supnd,parent,
                      nbsn,nbops,fctnzs,lgind,niv)

     ASTERINTEGER4 *nbnd,*nadj,  *xadjd, *adjncy;
     ASTERINTEGER4 *invpnd, *permnd,*supnd, *parent,*nbsn;
     ASTERDOUBLE   *nbops;
     ASTERINTEGER4 *fctnzs, *lgind;
     ASTERINTEGER  *niv;
{
#ifdef _HAVE_METIS
  /*
Donnees (allouees ds vecteurs JEVEUX via preml1)
--------
nbnd : Nombre de noeuds
nadj : Nombre d aretes du graphe de connexion
xadj[1:nbnd+1]: pointeur de adjncy
  (Notes SD adjncy: SD locale a ReadGraphL s'appelant adjncy aussi, elle de type idx_t)
adjncy[1:nadj] : connexion du graphe, voisins de chaque noeud

niv : niveau des impressions 0, 1, 2

Resultats (allouees ds vecteurs JEVEUX via preml1):
---------
invpnd[1:nbnd] : Renumerotation des noeuds (nouveau numero)
permnd[1:nbnd] : inverse du precedent (ancien numero)
nbsn : Nombre de super noeuds
  (Notes SD parent: seul les nbsd premiers sont exploites par la suite ds preml1;
  Attention: SD locale a smbfctl s'appelant parent aussi, elle de type idx_t)
parent[1:nbnd] : arborescence des super noeuds
  (Note supnd: seul les nbsd+1 premiers sont exploites par la suite ds preml1)
supnd[1:nbnd] : definition des supernoeuds

nbops : Nombre d operation flottantes pour la factorisation a effectuer
fctnzs : Nombre de termes non nuls dans la matrice factorisee
lgind  : longueur de tableaux de pointeurs
   */
   int n,m,i,ret,wgtflag,kkk,debug1,debug2;
   idx_t lll, options[METIS_NOPTIONS], *perm, *iperm;
   float TOTALTmr, METISTmr, IOTmr, SMBTmr;
   graph_t *graph=NULL;
   
   debug1=0; /* si 1 affiche les resultats intermediaires ds .mess*/
   debug2=0; /* si 1, force la permutation identite pour bypasser METIS*/

   n=*nbnd;
   m=*nadj;

/* Init. pour METIS */
   gk_clearcputimer(TOTALTmr);
   gk_clearcputimer(METISTmr);
   gk_clearcputimer(IOTmr);
   gk_clearcputimer(SMBTmr);
   gk_startcputimer(TOTALTmr);
   gk_startcputimer(IOTmr);
/* Creation et lecture du graphe METIS*/
   graph = CreateGraph();
   ret=ReadGraphL(graph, nbnd, nadj, xadjd, adjncy, &wgtflag, &debug1);
   if (graph->nvtxs <= 0) {
     printf("Empty graph. Nothing to do.\n");
     exit(4);
   }
   if (graph->ncon != 1) {
     printf("Ordering can only be applied to graphs with one constraint.\n");
     exit(4);
   }
   gk_stopcputimer(IOTmr);

/* On n'utilise pas de graphes avec poids ici */
   gk_free((void **) &graph->vwgt, &graph->adjwgt, LTERM);

/* Caracteristiques du graphes fourni a METIS en entree*/
   if (*niv > 1 ) {
     printf("**********************************************************************\n");
     printf("%s", METISTITLE);
     printf("Graph Information ---------------------------------------------------\n");
     printf("#Vertices: %d, #Edges: %d\n\n", graph->nvtxs, graph->nedges/2);
     printf("Node-Based Ordering... ----------------------------------------------\n");
   }
/* Allocation des vecteurs de permutation construits via l'appel a METIS_NodeND*/
   perm  = imalloc(graph->nvtxs, "main: perm");
   iperm = imalloc(graph->nvtxs, "main: iperm");

/* Parametrage des options de METIS pour l'appel a METIS_NodeND */
   options[0] = 0;
   METIS_SetDefaultOptions(options);
   options[METIS_OPTION_PTYPE]    = METIS_PTYPE_RB;  /* Rajout pour être consistant avec METIS4*/
   options[METIS_OPTION_CTYPE]    = METIS_CTYPE_SHEM; /* Au lieu de METIS_CTYPE_RM */
   options[METIS_OPTION_IPTYPE]   = METIS_IPTYPE_NODE; /*Why ?* */
   options[METIS_OPTION_RTYPE]    = METIS_RTYPE_SEP1SIDED; /* OK, consistant METIS4 */
 /*  options[METIS_OPTION_DBGLVL]   = METIS_DBG_INFO; */ /* Pour mode debug */
   options[METIS_OPTION_UFACTOR]  = 1.200; /* why ?*/
   options[METIS_OPTION_PFACTOR]  = 0.0; /* why ?*/
   options[METIS_OPTION_NO2HOP]   = 0; /* why ?*/
   options[METIS_OPTION_COMPRESS] = 1; /* OK consistant METIS4 */
   options[METIS_OPTION_CCORDER]  = 0; /* why ?*/
   options[METIS_OPTION_SEED]     = -1;
   options[METIS_OPTION_NITER]    = 10; /* why ?*/
   options[METIS_OPTION_NSEPS]    = 1; /* why ?*/
   options[METIS_OPTION_NUMBERING] = 0;

/* Appel effectif a METIS pour reduire le profil de la matrice associee au graphe 
   Algo par dissections emboitees recursives*/
   gk_startcputimer(METISTmr);
   ret=METIS_OK;
   METIS_NodeND(&graph->nvtxs, graph->xadj, graph->adjncy, graph->vwgt, options, perm, iperm);
   gk_stopcputimer(METISTmr);
   gk_startcputimer(IOTmr);

/* on bluffe METIS pour verifier que le reste fonctionne */
   if (debug2==1) {
     for(i=0;i<graph->nvtxs;i++)
       {perm[i]=i;iperm[i]=i;}
                  }
/* Pour afficher le resultat de METIS dans le .mess*/
   if (debug1==1) {
     printf("\nDebut impression METIS_NodeND\n");
     printf("%d %d\n",sizeof(graph->nvtxs),sizeof(graph->ncon));
     printf("%d %d\n",graph->nvtxs,graph->ncon);
     for(i=0;i<graph->nvtxs;i++)
       {printf("%d %d\n",perm[i],iperm[i]);}
        printf("\nfin impression METIS_NodeND\n");
                  }
   gk_stopcputimer(IOTmr);
   gk_startcputimer(SMBTmr);
   ret=METIS_OK;
   ComputeFillInL(graph, iperm, parent, supnd, (int *) &graph->nvtxs, nbsn, nbops, lgind, fctnzs);
   gk_stopcputimer(SMBTmr);
   gk_stopcputimer(TOTALTmr);
     
/* Temps de calcul des differentes etapes de METIS*/
   if (*niv > 1 ) {
     printf("\nTiming Information --------------------------------------------------\n");
     printf("  I/O:                     \t %7.3f\n", gk_getcputimer(IOTmr));
     printf("  Ordering:                \t %7.3f   (ONMETIS time)\n", gk_getcputimer(METISTmr));
     printf("  Symbolic Factorization:  \t %7.3f\n", gk_getcputimer(SMBTmr));
     printf("  Total:                   \t %7.3f\n", gk_getcputimer(TOTALTmr));
     printf("**********************************************************************\n");
   }

/* Transmission des resultats METIS (perm/iperm) en resultats code_aster (permnd/invpnd)*/
/* Attention si le typeaster est trop petit (ASTERINTEGER versus idx_t) */

   lll=graph->nvtxs;
   for(kkk=0;kkk<lll;kkk++)
     {invpnd[kkk]= iperm[kkk];
      permnd[ invpnd[kkk] ]= kkk;}

   for(kkk=0;kkk<lll;kkk++)
     {invpnd[kkk]+=1;
      permnd[kkk]+=1;}

/* Pour afficher les resultats de ComputeFillInL dans le .mess*/
   if (debug1==1) {
     printf("\nDebut impression ComputeFillInL\n");
     printf("%d %d\n",*nbnd,*nbsn);
     for (kkk=0;kkk<lll;kkk++)
       {printf("%d %d %d\n",invpnd[kkk],permnd[kkk],parent[kkk]);}
     for (kkk=0;kkk<*nbsn+1;kkk++)
       {printf("%d\n",supnd[kkk]);}
     printf("\nFin impression ComputeFillInL\n");
                  }

/* On libere les objets alloues par METIS*/
   gk_free((void **) &graph->xadj, &graph->adjncy, &perm, &iperm, LTERM);
#else

    CALL_UTMESS("F", "FERMETUR_15");


#endif
}


#ifdef _HAVE_METIS


 /*************************************************************************
 * This function reads the spd matrix
 **************************************************************************/

int ReadGraphL(graph_t *graph,int *nbnd,int *nadj,int *xadjd,int *adjnci,int *wgtflag,
               int *debug1)
{
  int ncon, k, l;
  idx_t *xadj,*adjncy,*vwgt,*adjwgt;

  graph->nvtxs = *nbnd;
  graph->nedges= *nadj;

  /*  graph->nedges *=2;mis directement a nadj */
  ncon = 0;
  ncon = graph->ncon = (ncon == 0 ? 1 : ncon);

  xadj = graph->xadj = ismalloc(graph->nvtxs+1, 0, "ReadGraph: xadj");
  adjncy = graph->adjncy = imalloc(graph->nedges, "ReadGraph: adjncy");

  vwgt=graph->vwgt=adjwgt=graph->adjwgt = NULL;
  for(k=0;k<=graph->nvtxs;k++)
    {xadj[k]=xadjd[k]-1; /* -1 on est en C */}
  int ll=graph->nedges;
  for(k=0;k<ll;k++)
    {adjncy[k]=adjnci[k]-1; /*  on est en C */}
   
/* Pour tester et sortir le graphe dans le .mess*/
  if (*debug1==1) {
    printf("\nDebut impression graphe\n");
    printf("%d %d\n",sizeof(graph->nvtxs),sizeof(graph->nedges));
    printf("%d %d\n",graph->nvtxs,graph->nedges);
    for(k=0;k<graph->nvtxs;k++)
      {printf("vertex %d ",k);
       for(l=xadj[k];l<xadj[k+1];l++)
         {printf("%d ",adjncy[l]);}
       printf("\n");
      }
    printf("\nFin impression graphe\n");
                }
  *wgtflag=0;
  return 0;
}


/*************************************************************************
 * This function sets up data structures for fill-in computations
 **************************************************************************/
int ComputeFillInL(graph_t *graph, idx_t *iperm, int *parent,
            int *supnd, int *neq,int *nbsn,double *opc,int *lgindd,int *maxlnz)
 {
   int i, j, k, nvtxs, maxsub,lgind;
   idx_t *xadj, *adjncy, idxbuff;
   idx_t *perm, *xlnz, *xnzsub, *nzsub;


   nvtxs = graph->nvtxs;
   xadj = graph->xadj;
   adjncy = graph->adjncy;

   maxsub = 4*xadj[nvtxs];

   /* Relabel the vertices so that it starts from 1 */
   k = xadj[nvtxs];
   for (i=0; i<k; i++)
     {
       adjncy[i]++;
     }
   for (i=0; i<nvtxs+1; i++)
     { xadj[i]++;
     }

   /* Allocate the required memory */
   perm = imalloc(graph->nvtxs+1, "ComputeFillIn: perm");
   xlnz = imalloc(graph->nvtxs+1, "ComputeFillIn: xlnz");
   xnzsub = imalloc(graph->nvtxs+1, "ComputeFillIn: xnzsub");
   idxbuff=maxsub;
   nzsub = imalloc(idxbuff, "ComputeFillIn: nzsub");
   /* Construct perm from iperm and change the numbering of iperm */
   for (i=0; i<nvtxs; i++)
 {
     perm[iperm[i]] = i;
 }
   for (i=0; i<nvtxs; i++) {
     iperm[i]++;
     perm[i]++;
   }

   /*
    * Call sparspak routine.
    */
   int errs;
   errs=smbfctl(nvtxs, xadj, adjncy, perm, iperm, xlnz, maxlnz, xnzsub, nzsub, &maxsub,
                supnd, parent, nbsn, &lgind, opc);
   if (errs) {
     int errs2;
     free(nzsub);

     maxsub = 4*maxsub;
     idxbuff=maxsub;
     nzsub = imalloc(idxbuff, "ComputeFillIn: nzsub");
     errs2= smbfctl(nvtxs, xadj, adjncy, perm, iperm, xlnz, maxlnz, xnzsub, nzsub, &maxsub,
                    supnd, parent, nbsn, &lgind, opc);
     if (errs2)
       errexit("MAXSUB is too small!");
   }


   gk_free((void **) &perm, &xlnz, &xnzsub, &nzsub, LTERM);


   /* Relabel the vertices so that it starts from 0 */
   for (i=0; i<nvtxs; i++)
     iperm[i]--;
   for (i=0; i<nvtxs+1; i++)
     xadj[i]--;
   k = xadj[nvtxs];
   for (i=0; i<k; i++)
     {
       adjncy[i]--;
     }
   *lgindd=lgind;
   return 0;
 }




 /*****************************************************************
 **********     SMBFCT ..... SYMBOLIC FACTORIZATION       *********
 ******************************************************************
 *   PURPOSE - THIS ROUTINE PERFORMS SYMBOLIC FACTORIZATION
 *   ON A PERMUTED LINEAR SYSTEM AND IT ALSO SETS UP THE
 *   COMPRESSED DATA STRUCTURE FOR THE SYSTEM.
 *
 *   INPUT PARAMETERS -
 *      NEQNS - NUMBER OF EQUATIONS.
 *      (XADJ, ADJNCY) - THE ADJACENCY STRUCTURE.
 *      (PERM, INVP) - THE PERMUTATION VECTOR AND ITS INVERSE.
 *
 *   UPDATED PARAMETERS -
 *      MAXSUB - SIZE OF THE SUBSCRIPT ARRAY NZSUB.  ON RETURN,
 *             IT CONTAINS THE NUMBER OF SUBSCRIPTS USED
 *
 *   OUTPUT PARAMETERS -
 *      XLNZ - INDEX INTO THE NONZERO STORAGE VECTOR LNZ.
 *      (XNZSUB, NZSUB) - THE COMPRESSED SUBSCRIPT VECTORS.
 *      MAXLNZ - THE NUMBER OF NONZEROS FOUND.
 *
 *******************************************************************/
 int smbfctl(int neqns, idx_t *xadj, idx_t *adjncy, idx_t *perm, idx_t *invp,
             idx_t *xlnz, int *maxlnz, idx_t *xnzsub, idx_t *nzsub, int *maxsub,
             int *supnd, int *parsnode, int *nbsn, int *lgin, double *opc)
 {
   /* Local variables */
   int snode,node, rchm, mrgk, lmax, i, j, k, m, nabor, nzbeg, nzend;
   int kxsub, jstop, jstrt, mrkflg, inz, knz, flag,lgind;
   idx_t *mrglnk, *marker, *rchlnk, idxbuff;
 /* jyb */
   int  lnode, xnzi, xnzip1,nbi, nbip1;
   int aux, minsn, maxsn;

   int taille1, k1, taille2, k2, taille3, k3,nd;
/* attention ici parent est local a la routine. A ne pas confondre avec la
   structure de donnees aster */
   idx_t *parent, *nliens, *tbnode;
   FILE *fpout;

   idxbuff=neqns+1;
   rchlnk = imalloc(idxbuff, "smbfct: rchlnk");
   marker = ismalloc(idxbuff, 0, "smbfct: marker");
   mrglnk = ismalloc(idxbuff, 0, "smbfct: mgrlnk");
   /* Parameter adjustments */
   --marker;
   --mrglnk;
   --rchlnk;
   --nzsub;
   --xnzsub;
   --xlnz;
   --invp;
   --perm;
   --adjncy;
   --xadj;
   --parsnode;
   --supnd;

   /* Function Body */
   flag = 0;
   nzbeg = 1;
   nzend = 0;
   xlnz[1] = 1;

   /* FOR EACH COLUMN KNZ COUNTS THE NUMBER OF NONZEROS IN COLUMN K ACCUMULATED IN RCHLNK. */
   for (k = 1; k <= neqns; ++k) {
     knz = 0;
     mrgk = mrglnk[k];
     mrkflg = 0;
     marker[k] = k;
     if (mrgk != 0)
       marker[k] = marker[mrgk];
     xnzsub[k] = nzend;
     node = perm[k];

     if (xadj[node] >= xadj[node+1]) {
       xlnz[k+1] = xlnz[k];
       continue;
     }

     /* USE RCHLNK TO LINK THROUGH THE STRUCTURE OF A(*,K) BELOW DIAGONAL */
     rchlnk[k] = neqns+1;
     for (j=xadj[node]; j<xadj[node+1]; j++) {
       nabor = invp[adjncy[j]];
       if (nabor <= k)
         continue;
       rchm = k;

       do {
         m = rchm;
         rchm = rchlnk[m];
       } while (rchm <= nabor);

       knz++;
       rchlnk[m] = nabor;
       rchlnk[nabor] = rchm;
       if (marker[nabor] != marker[k])
         mrkflg = 1;
     }

     /* TEST FOR MASS SYMBOLIC ELIMINATION */
     lmax = 0;
     if (mrkflg != 0 || mrgk == 0 || mrglnk[mrgk] != 0)
       goto L350;
     xnzsub[k] = xnzsub[mrgk] + 1;
     knz = xlnz[mrgk + 1] - (xlnz[mrgk] + 1);
     goto L1400;


     /* LINK THROUGH EACH COLUMN I THAT AFFECTS L(*,K) */
 L350:
     i = k;
     while ((i = mrglnk[i]) != 0) {
       inz = xlnz[i+1] - (xlnz[i]+1);
       jstrt = xnzsub[i] + 1;
       jstop = xnzsub[i] + inz;

       if (inz > lmax) {
         lmax = inz;
         xnzsub[k] = jstrt;
       }

       /* MERGE STRUCTURE OF L(*,I) IN NZSUB INTO RCHLNK. */
       rchm = k;
       for (j = jstrt; j <= jstop; ++j) {
         nabor = nzsub[j];
         do {
           m = rchm;
           rchm = rchlnk[m];
         } while (rchm < nabor);

         if (rchm != nabor) {
           knz++;
           rchlnk[m] = nabor;
           rchlnk[nabor] = rchm;
           rchm = nabor;
         }
       }
     }

     /* CHECK IF SUBSCRIPTS DUPLICATE THOSE OF ANOTHER COLUMN */
     if (knz == lmax)
       goto L1400;

     /* OR IF TAIL OF K-1ST COLUMN MATCHES HEAD OF KTH */
     if (nzbeg > nzend)
       goto L1200;

     i = rchlnk[k];
     for (jstrt = nzbeg; jstrt <= nzend; ++jstrt) {
       if (nzsub[jstrt] < i)
         continue;

       if (nzsub[jstrt] == i)
         goto L1000;
       else
         goto L1200;
     }
     goto L1200;

 L1000:
     xnzsub[k] = jstrt;
     for (j = jstrt; j <= nzend; ++j) {
       if (nzsub[j] != i)
         goto L1200;

       i = rchlnk[i];
       if (i > neqns)
         goto L1400;
     }
     nzend = jstrt - 1;

     /* COPY THE STRUCTURE OF L(*,K) FROM RCHLNK TO THE DATA STRUCTURE (XNZSUB, NZSUB) */
 L1200:
     nzbeg = nzend + 1;
     nzend += knz;

     if (nzend > *maxsub) {
       flag = 1; /* Out of memory */
       break;
     }

     i = k;
     for (j=nzbeg; j<=nzend; ++j) {
       i = rchlnk[i];
nzsub[j] = i;
       marker[i] = k;
     }
     xnzsub[k] = nzbeg;
     marker[k] = k;

     /*
      * UPDATE THE VECTOR MRGLNK.  NOTE COLUMN L(*,K) JUST FOUND
      * IS REQUIRED TO DETERMINE COLUMN L(*,J), WHERE
      * L(J,K) IS THE FIRST NONZERO IN L(*,K) BELOW DIAGONAL.
      */
 L1400:
     if (knz > 1) {
       kxsub = xnzsub[k];
       i = nzsub[kxsub];
       mrglnk[k] = mrglnk[i];
       mrglnk[i] = k;
     }

     xlnz[k + 1] = xlnz[k] + knz;
   }

   if (flag == 0) {
     *maxlnz = xlnz[neqns] - 1;
     *maxsub = xnzsub[neqns];
     xnzsub[neqns + 1] = xnzsub[neqns];
   }

 idxbuff=neqns;
 parent = ismalloc(idxbuff, 0, "smbfct: parent");
 parent--;
   /* Calculate the elimination tree */
   for (i=1; i<=neqns; i++) {
     if (xlnz[i] < xlnz[i+1])
       parent[i] = nzsub[xnzsub[i]];
     else
       parent[i] = -1;   /* Indicates no parent */
   }
 /* super-noeuds */
  nbip1 = xlnz[2] -xlnz[1] ;
  xnzip1 = xnzsub[1];
  i=1 ;
  snode = 1 ; supnd[snode] = 1 ;
  lgind = nbip1;
  marker[i]= snode;
  nbi = nbip1;
  xnzi = xnzip1;
  marker[i]= snode;
  i = i+ 1;
/* C.Rose ligne suivante : correction de bug 13/03/02  neqns+1 remplace neqns
dans l'instruction suivante
Il y avait un pb pour ssll102a avec le dernier SN qui ne comprend qu'un noeud*/
  while ( i < neqns+1)
      {

      nbip1 = xlnz[i+1] -xlnz[i] ;
  xnzip1 = xnzsub[i];

  if  ( nbip1 != (nbi-1))
      {
          snode ++;supnd[snode] = i;
          lgind += nbip1;
      }
  else if ( xnzip1 != (xnzi+1))
          {
              snode ++;supnd[snode] = i;
              lgind += nbip1;
          }
 else
{/* verification que dans le  sn courant (snode) le noeud i est bien voisin du nd i-1
sinon on crée un nouveau SN
correction des fiches 12345 et 12503  */
   if( i != nzsub[xnzsub[i-1]] )
    { snode ++;supnd[snode] = i;
              lgind += nbip1;
    }
 }
  nbi = nbip1;
  xnzi = xnzip1;
 marker[i]= snode;
  i = i+ 1;
     }

  supnd[snode+1] = neqns +1;
  lnode =neqns;

  marker[neqns] = snode ;
 /* C.Rose ajout de la ligne precedante : correction de bug 11/03/02 */
  /* printf("  nbsn : %d \n",snode);
  for(i=1;i<=neqns;i++) printf("  smarker %8d %8d\n ",i,marker[i]);
 for(i=1;i<=snode+1;i++) printf("  snode %8d %8d\n ",i,supnd[i]);
  */
 /* fin de cr*/
 minsn = neqns;
 maxsn = 0;
 k1 = 0;
 k2 = 0;
 k3 = 0;
 taille1 = 50;
 taille2 = 20;
 taille3 = 05;
 for (i = 1; i<=snode; i++)
 {
   aux = supnd[i+1]-supnd[i];
   if(aux < minsn) minsn = aux;
   if(aux > maxsn) maxsn = aux;
   if(aux < taille1) k1++;
   if(aux < taille2) k2++;
   if(aux < taille3) k3++;
  }
/*
 printf("\n ");
 printf(" taille du plus petit super-noeud %8d\n ",minsn);
 printf(" taille du plus grand super-noeud %8d\n ",maxsn);
 printf(" taille moyenne d un  super-noeud %8d\n ",lnode/snode);
 printf(" nb de super-noeuds de taille < %4d : %8d\n ",taille1,k1);
 printf(" nb de super-noeuds de taille < %4d : %8d\n ",taille2,k2);
 printf(" nb de super-noeuds de taille < %4d : %8d\n ",taille3,k3);
*/
 /* for (i=1; i<=snode+1; i++) {printf(" i pt. %4d%4d\n ",i,supnd[i]);} */

 /* parent des super-noeuds */
 /* principe : on a stocke dans marker pour chaque noeud son super-noeud */
 /* maintenant pour chaque super-noeud on prend son dernier noeud, */
 /* on cherche le parent de ce noeud, puis le supernoeud auquel */
 /* appartient ce parent et on l'affecte comme parent au supernoeud */
 /* quand il n'y a pas de parent on met 0 (convention C. Rose) */
 /*parsnode = idxsmalloc(snode+1, 0, "smbfct: parsnode"); */
 /*parsnode--;*/
 idxbuff=neqns;
 tbnode = ismalloc(idxbuff, 0, "smbfct: tbnode");
 tbnode--;
 /*sauvegarde de parent nodal */
 for(i = 1; i<=neqns; i++) {
     tbnode[i] = parent[i];
     /*      printf(" i %4d parent %8d \n", i, tbnode[i]);*/
 }

 for(i = 1; i<=snode; i++)
 {
      nd = supnd[i+1] - 1;
     if(tbnode[nd] != -1)
         {
             parsnode[i] = marker[tbnode[nd]];
         }
     else
         {
         parsnode[i] = 0;
         }
     /*  printf(" noeud %4d parent %8d \n ",i, parsnode[i]); */

 }
  *opc = 0;
   for (i=1; i<=neqns; i++)
        xlnz[i]--;
          for (i=1; i<=neqns; i++) {
     *opc += (xlnz[i+1]-xlnz[i])*(xlnz[i+1]-xlnz[i]) - (xlnz[i+1]-xlnz[i]);
          }
  *nbsn=snode;
  *lgin=lgind;
   marker++;
   mrglnk++;
   rchlnk++;
   nzsub++;
   xnzsub++;
   xlnz++;
   invp++;
   perm++;
   adjncy++;
   xadj++;
   gk_free((void **) &rchlnk, &mrglnk, &marker, LTERM);
   parsnode++;
   supnd++;



   return flag;


 }

#endif
