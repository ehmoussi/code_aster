/* -------------------------------------------------------------------- */
/* Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org             */
/* Copyright 1994-2011, Regents of the University of Minnesota          */
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

/*#ifdef _HAVE_METIS */
#include "programs/metisbin.h"
#include "libmetis/rename.h"
#include "libmetis/proto.h"
#include "programs/struct.h"
/*#endif*/

/* Prototypes of internal functions */

graph_t * AffectGraph(ASTERINTEGER *, ASTERINTEGER *, ASTERINTEGER4 *, ASTERINTEGER4 *, int *);

int ComputeFillInL(graph_t *, idx_t *, idx_t *, idx_t *, int *,
                   int *, double *, int *, int *);
int smbfctl(int, idx_t *, idx_t *, idx_t *, idx_t *, idx_t *, int *, idx_t *,
            idx_t *, int *, idx_t *, idx_t *, int *, int *, double *);

void DEFPPPPPP(GPMETIS_ASTER, gpmetis_aster, ASTERINTEGER *nbnd, ASTERINTEGER *nadj, 
               ASTERINTEGER4 *xadjd, ASTERINTEGER4 *adjncy, ASTERINTEGER *nbpart, 
               ASTERINTEGER *partout )

{
#ifdef _HAVE_METIS

  idx_t i;
  char *curptr, *newptr;
  idx_t options[METIS_NOPTIONS];
  graph_t *graph;
  idx_t *part;
  idx_t objval;
  params_t *params;
  int status=0; 
  int wgtflag, ret;  
  long k,l;
  
  params = (params_t *)gk_malloc(sizeof(params_t), "parse_cmdline: params");
  memset((void *)params, 0, sizeof(params_t));
  /* initialize the params data structure */
  params->gtype         = METIS_GTYPE_DUAL;
  params->ptype         = METIS_PTYPE_KWAY;
  params->objtype       = METIS_OBJTYPE_CUT;
  params->ctype         = METIS_CTYPE_SHEM;
  params->iptype        = METIS_IPTYPE_GROW;
  params->rtype         = -1;
  params->minconn       = 0;
  params->contig        = 0;
  params->nooutput      = 0;
  params->wgtflag       = 3;
  params->ncuts         = 1;
  params->niter         = 10;
  params->ncommon       = 1;
  params->dbglvl        = 0;
  params->balance       = 0;
  params->seed          = -1;
  params->dbglvl        = 0;
  params->tpwgtsfile    = NULL;
  params->filename      = NULL;
  params->nparts        = 1;
  params->ufactor       = -1;
  params->nparts        = *nbpart;
/* 
  Set the ptype-specific defaults from cmdline_gpmetis.c
*/
  if (params->ptype == METIS_PTYPE_RB) {
    params->rtype   = METIS_RTYPE_FM;
  }
  if (params->ptype == METIS_PTYPE_KWAY) {
    params->iptype  = METIS_IPTYPE_METISRB;
    params->rtype   = METIS_RTYPE_GREEDY;
  }

  /* Check for invalid parameter combination */
  if (params->ptype == METIS_PTYPE_RB) {
    if (params->contig)
      errexit("***The -contig option cannot be specified with rb partitioning (ignored).\n");
    if (params->minconn)
      errexit("***The -minconn option cannot be specified with rb partitioning (ignored). \n");
    if (params->objtype == METIS_OBJTYPE_VOL)
      errexit("The -objtype=vol option cannot be specified with rb partitioning.\n");
  }

  gk_startcputimer(params->iotimer);
  graph = AffectGraph(nbnd, nadj, xadjd, adjncy, &wgtflag);

  ReadTPwgts(params, graph->ncon);
  gk_stopcputimer(params->iotimer);

  /* Check if the graph is contiguous */
  if (params->contig && !IsConnected(graph, 0)) {
    printf("***The input graph is not contiguous.\n"
           "***The specified -contig option will be ignored.\n");
    params->contig = 0;
  }

  /* Get ubvec if supplied */
  if (params->ubvecstr) {
    params->ubvec = rmalloc(graph->ncon, "main");
    curptr = params->ubvecstr;
    for (i=0; i<graph->ncon; i++) {
      params->ubvec[i] = strtoreal(curptr, &newptr);
      if (curptr == newptr)
        errexit("Error parsing entry #%"PRIDX" of ubvec [%s] (possibly missing).\n",i, 
                params->ubvecstr);
      curptr = newptr;
    }
  }

  /* Setup iptype */
  if (params->iptype == -1) {
    if (params->ptype == METIS_PTYPE_RB) {
      if (graph->ncon == 1)
        params->iptype = METIS_IPTYPE_GROW;
      else
        params->iptype = METIS_IPTYPE_RANDOM;
    }
  }

  GPPrintInfo(params, graph);

  part = imalloc(graph->nvtxs, "main: part");

  METIS_SetDefaultOptions(options);
  options[METIS_OPTION_OBJTYPE] = params->objtype;
  options[METIS_OPTION_CTYPE]   = params->ctype;
  options[METIS_OPTION_IPTYPE]  = params->iptype;
  options[METIS_OPTION_RTYPE]   = params->rtype;
  options[METIS_OPTION_NO2HOP]  = params->no2hop;
  options[METIS_OPTION_MINCONN] = params->minconn;
  options[METIS_OPTION_CONTIG]  = params->contig;
  options[METIS_OPTION_SEED]    = params->seed;
  options[METIS_OPTION_NITER]   = params->niter;
  options[METIS_OPTION_NCUTS]   = params->ncuts;
  options[METIS_OPTION_UFACTOR] = params->ufactor;
  options[METIS_OPTION_DBGLVL]  = params->dbglvl;

  gk_malloc_init();
  gk_startcputimer(params->parttimer);

  switch (params->ptype) {
    case METIS_PTYPE_RB:
      status = METIS_PartGraphRecursive(&graph->nvtxs, &graph->ncon, graph->xadj, 
                   graph->adjncy, graph->vwgt, graph->vsize, graph->adjwgt, 
                   &params->nparts, params->tpwgts, params->ubvec, options, 
                   &objval, part);
      break;

    case METIS_PTYPE_KWAY:
      status = METIS_PartGraphKway(&graph->nvtxs, &graph->ncon, graph->xadj, 
                   graph->adjncy, graph->vwgt, graph->vsize, graph->adjwgt, 
                   &params->nparts, params->tpwgts, params->ubvec, options, 
                   &objval, part);
      break;

  }

  gk_stopcputimer(params->parttimer);

  if (gk_GetCurMemoryUsed() != 0)
    printf("***It seems that Metis did not free all of its memory! Report this.\n");
  params->maxmemory = gk_GetMaxMemoryUsed();
  gk_malloc_cleanup(0);


  if (status != METIS_OK) {
    printf("\n***Metis returned with an error.\n");
  }
  else {
    if (!params->nooutput) {
      /* copy the solution */
      gk_startcputimer(params->iotimer);
      for (i=0; i<graph->nvtxs; i++) {
          partout[i]=part[i];
      }
      gk_stopcputimer(params->iotimer);
    }

    GPReportResults(params, graph, part, objval);
  }

  FreeGraph(&graph);
  gk_free((void **)&part, LTERM);
  gk_free((void **)&params->filename, &params->tpwgtsfile, &params->tpwgts, 
      &params->ubvecstr, &params->ubvec, &params, LTERM);

}

/*************************************************************************/
/*! This function build a sparse graph */
/*************************************************************************/
graph_t *AffectGraph(ASTERINTEGER *nbnd,ASTERINTEGER *nadj,ASTERINTEGER4 *xadjd,
                     ASTERINTEGER4 *adjnci, int *wgtflag)
{
  idx_t i, j, k, l, fmt, ncon, nfields, readew, readvw, readvs, edge, ewgt;
  idx_t *xadj, *adjncy, *vwgt, *adjwgt, *vsize;
  graph_t *graph;

/* Pour tester et sortir les arguments */
/*  printf("\ndébut impression arguments\n");
  printf("%d %d\n",*nbnd,*nadj);
  for(k=0;k<=*nbnd-1;k++)
    {printf("%d %d - ",k+1,xadjd[k+1]-xadjd[k]);
      for(l=xadjd[k]-1;l<xadjd[k+1]-1;l++)
        {
           printf("%d ",adjnci[l]);
        }
        printf("\n");
    }
     printf("\nfin impression arguments\n"); 
*/
  graph = CreateGraph();
  graph->nvtxs = *nbnd;
  graph->nedges=*nadj;

  *wgtflag = 0;
/*  graph->nedges *=2; */
  ncon = graph->ncon = 1;

  xadj   = graph->xadj   = ismalloc(graph->nvtxs+1, 0, "AffectGraph: xadj");
  adjncy = graph->adjncy = imalloc(graph->nedges, "AffectGraph: adjncy");
  vwgt   = graph->vwgt   = ismalloc(ncon*graph->nvtxs, 1, "AffectGraph: vwgt");
  adjwgt = graph->adjwgt = ismalloc(graph->nedges, 1, "AffectGraph: adjwgt");
  vsize  = graph->vsize  = ismalloc(graph->nvtxs, 1, "AffectGraph: vsize");

  for(k=0;k<=graph->nvtxs;k++)
    {
      xadj[k] = xadjd[k]-1; /* -1 on est en C */
    }
  int ll=graph->nedges;
  for(k=0;k<ll;k++)
    {
         adjncy[k]=adjnci[k]-1; /*  on est en C */
    }


/* Pour tester et sortir le graphe dans le .mess */
/*  printf("\ndébut impression graphe\n");printf("graph->nvtxs = %d \n",graph->nvtxs);
  printf("%d %d\n",graph->nvtxs,graph->ncon);
  for(k=0;k<graph->nvtxs;k++)
    {printf("k = %d | %d %d\n",k,graph->xadj[k],graph->xadj[k+1]-1);
      for(l=graph->xadj[k];l<graph->xadj[k+1];l++)
        {
           printf("%d ",graph->adjncy[l]+1);
        }
        printf("\n");
    }

     printf("\nfin impression graphe\n"); 
*/
  return graph;



#else

  CALL_UTMESS("F", "FERMETUR_15");


#endif
}

/*************************************************************************/
/*! This function reads in the target partition weights. If no file is 
    specified the weights are set to 1/nparts */
/*************************************************************************/
void ReadTPwgts(params_t *params, idx_t ncon)
{
  idx_t i, j, from, to, fromcnum, tocnum, nleft;
  real_t awgt=0.0, twgt;
  char *line=NULL, *curstr, *newstr;
  size_t lnlen=0;
  FILE *fpin;

  params->tpwgts = rsmalloc(params->nparts*ncon, -1.0, "ReadTPwgts: tpwgts");

  if (params->tpwgtsfile == NULL) {
    for (i=0; i<params->nparts; i++) {
      for (j=0; j<ncon; j++)
        params->tpwgts[i*ncon+j] = 1.0/params->nparts;
    }
    return;
  }

  if (!gk_fexists(params->tpwgtsfile)) 
    errexit("Graph file %s does not exist!\n", params->tpwgtsfile);

  fpin = gk_fopen(params->tpwgtsfile, "r", "ReadTPwgts: tpwgtsfile");

  while (gk_getline(&line, &lnlen, fpin) != -1) {
    gk_strchr_replace(line, " ", "");
    /* start extracting the fields */

    curstr = line;
    newstr = NULL;

    from = strtoidx(curstr, &newstr, 10);
    if (newstr == curstr)
      errexit("The 'from' component of line <%s> in the tpwgts file is incorrect.\n", line);
    curstr = newstr;

    if (curstr[0] == '-') {
      to = strtoidx(curstr+1, &newstr, 10);
      if (newstr == curstr)
        errexit("The 'to' component of line <%s> in the tpwgts file is incorrect.\n", line);
      curstr = newstr;
    }
    else {
      to = from;
    }

    if (curstr[0] == ':') {
      fromcnum = strtoidx(curstr+1, &newstr, 10);
      if (newstr == curstr)
        errexit("The 'fromcnum' component of line <%s> in the tpwgts file is incorrect.\n", line);
      curstr = newstr;

      if (curstr[0] == '-') {
        tocnum = strtoidx(curstr+1, &newstr, 10);
        if (newstr == curstr)
          errexit("The 'tocnum' component of line <%s> in the tpwgts file is incorrect.\n", line);
        curstr = newstr;
      }
      else {
        tocnum = fromcnum;
      }
    }
    else {
      fromcnum = 0;
      tocnum   = ncon-1;
    }

    if (curstr[0] == '=') {
      awgt = strtoreal(curstr+1, &newstr);
      if (newstr == curstr)
        errexit("The 'wgt' component of line <%s> in the tpwgts file is incorrect.\n", line);
      curstr = newstr;
    }
    else {
      errexit("The 'wgt' component of line <%s> in the tpwgts file is missing.\n", line);
    }

    /*printf("Read: %"PRIDX"-%"PRIDX":%"PRIDX"-%"PRIDX"=%"PRREAL"\n",
        from, to, fromcnum, tocnum, awgt);*/

    if (from < 0 || to < 0 || from >= params->nparts || to >= params->nparts)
      errexit("Invalid partition range for %"PRIDX":%"PRIDX"\n", from, to);
    if (fromcnum < 0 || tocnum < 0 || fromcnum >= ncon || tocnum >= ncon)
      errexit("Invalid constraint number range for %"PRIDX":%"PRIDX"\n", 
          fromcnum, tocnum);
    if (awgt <= 0.0 || awgt >= 1.0)
      errexit("Invalid partition weight of %"PRREAL"\n", awgt);
    for (i=from; i<=to; i++) {
      for (j=fromcnum; j<=tocnum; j++)
        params->tpwgts[i*ncon+j] = awgt;
    }
  } 

  gk_fclose(fpin);

  /* Assign weight to the unspecified constraints x partitions */
  for (j=0; j<ncon; j++) {
    /* Sum up the specified weights for the jth constraint */
    for (twgt=0.0, nleft=params->nparts, i=0; i<params->nparts; i++) {
      if (params->tpwgts[i*ncon+j] > 0) {
        twgt += params->tpwgts[i*ncon+j];
        nleft--;
      }
    }

    /* Rescale the weights to be on the safe side */
    if (nleft == 0) 
      rscale(params->nparts, 1.0/twgt, params->tpwgts+j, ncon);
  
    /* Assign the left-over weight to the remaining partitions */
    if (nleft > 0) {
      if (twgt > 1)
        errexit("The total specified target partition weights for constraint #%"PRIDX
                " of %"PRREAL" exceeds 1.0.\n", j, twgt);
  
      awgt = (1.0 - twgt)/nleft;
      for (i=0; i<params->nparts; i++)
        params->tpwgts[i*ncon+j] = 
            (params->tpwgts[i*ncon+j] < 0 ? awgt : params->tpwgts[i*ncon+j]);
    }
  }
  #ifdef HAVE_GETLINE
  free(line);
  line = NULL; /* set to null to match behavior of gk_free() */
  #else
  gk_free((void *)&line, LTERM);
  #endif
}

/*************************************************************************/
/*! This function prints run parameters */
/*************************************************************************/
void GPPrintInfo(params_t *params, graph_t *graph)
{ 
  idx_t i;

  if (params->ufactor == -1) {
    if (params->ptype == METIS_PTYPE_KWAY)
      params->ufactor = KMETIS_DEFAULT_UFACTOR;
    else if (graph->ncon == 1)
      params->ufactor = PMETIS_DEFAULT_UFACTOR;
    else
      params->ufactor = MCPMETIS_DEFAULT_UFACTOR;
  }

  printf("******************************************************************************\n");
  printf("%s", METISTITLE);
  printf(" (Built on: %s, %s)\n", __DATE__, __TIME__);
  printf(" size of idx_t: %zubits, real_t: %zubits, idx_t *: %zubits\n", 
      8*sizeof(idx_t), 8*sizeof(real_t), 8*sizeof(idx_t *));
  printf("\n");
  printf("Graph Information -----------------------------------------------------------\n");
  printf(" Name: %s, #Vertices: %"PRIDX", #Edges: %"PRIDX", #Parts: %"PRIDX"\n", 
      params->filename, graph->nvtxs, graph->nedges/2, params->nparts);
  if (graph->ncon > 1)
    printf(" Balancing constraints: %"PRIDX"\n", graph->ncon);

  printf("\n");
  printf("Options ---------------------------------------------------------------------\n");
  printf(" ptype=%s, objtype=%s, ctype=%s, rtype=%s, iptype=%s\n",
      ptypenames[params->ptype], objtypenames[params->objtype], ctypenames[params->ctype], 
      rtypenames[params->rtype], iptypenames[params->iptype]);

  printf(" dbglvl=%"PRIDX", ufactor=%.3f, no2hop=%s, minconn=%s, contig=%s, nooutput=%s\n",
      params->dbglvl,
      I2RUBFACTOR(params->ufactor),
      (params->no2hop   ? "YES" : "NO"), 
      (params->minconn  ? "YES" : "NO"), 
      (params->contig   ? "YES" : "NO"),
      (params->nooutput ? "YES" : "NO")
      );

  printf(" seed=%"PRIDX", niter=%"PRIDX", ncuts=%"PRIDX"\n", 
      params->seed, params->niter, params->ncuts);

  if (params->ubvec) {
    printf(" ubvec=(");
    for (i=0; i<graph->ncon; i++)
      printf("%s%.2e", (i==0?"":" "), (double)params->ubvec[i]);
    printf(")\n");
  }

  printf("\n");
  switch (params->ptype) {
    case METIS_PTYPE_RB:
      printf("Recursive Partitioning ------------------------------------------------------\n");
      break;
    case METIS_PTYPE_KWAY:
      printf("Direct k-way Partitioning ---------------------------------------------------\n");
      break;
  }
}
/*************************************************************************/
/*! This function does any post-partitioning reporting */
/*************************************************************************/
void GPReportResults(params_t *params, graph_t *graph, idx_t *part, idx_t objval)
{ 
  gk_startcputimer(params->reporttimer);
  ComputePartitionInfo(params, graph, part);

  gk_stopcputimer(params->reporttimer);

  printf("\nTiming Information ----------------------------------------------------------\n");
  printf("  I/O:          \t\t %7.3"PRREAL" sec\n", gk_getcputimer(params->iotimer));
  printf("  Partitioning: \t\t %7.3"PRREAL" sec   (METIS time)\n", 
         gk_getcputimer(params->parttimer));
  printf("  Reporting:    \t\t %7.3"PRREAL" sec\n", gk_getcputimer(params->reporttimer));
  printf("\nMemory Information ----------------------------------------------------------\n");
  printf("  Max memory used:\t\t %7.3"PRREAL" MB\n", (real_t)(params->maxmemory/(1024.0*1024.0)));
  printf("******************************************************************************\n");
}
/* ComputePartitionInfo */
/****************************************************************************/
/*! This function computes various information associated with a partition */
/****************************************************************************/
void ComputePartitionInfo(params_t *params, graph_t *graph, idx_t *where)
{
  idx_t i, ii, j, k, nvtxs, ncon, nparts, tvwgt;
  idx_t *xadj, *adjncy, *vwgt, *adjwgt, *kpwgts;
  real_t *tpwgts, unbalance;
  idx_t pid, ndom, maxndom, minndom, tndom, *pptr, *pind, *pdom;
  idx_t ncmps, nover, *cptr, *cind, *cpwgts;

  nvtxs  = graph->nvtxs;
  ncon   = graph->ncon;
  xadj   = graph->xadj;
  adjncy = graph->adjncy;
  vwgt   = graph->vwgt;
  adjwgt = graph->adjwgt;

  nparts = params->nparts;
  tpwgts = params->tpwgts;

  /* Compute objective-related infomration */
  printf(" - Edgecut: %"PRIDX", communication volume: %"PRIDX".\n\n", 
      ComputeCut(graph, where), ComputeVolume(graph, where));


  /* Compute constraint-related information */
  kpwgts = ismalloc(ncon*nparts, 0, "ComputePartitionInfo: kpwgts");

  for (i=0; i<nvtxs; i++) {
    for (j=0; j<ncon; j++) 
      kpwgts[where[i]*ncon+j] += vwgt[i*ncon+j];
  }

  /* Report on balance */
  printf(" - Balance:\n");
  for (j=0; j<ncon; j++) {
    tvwgt = isum(nparts, kpwgts+j, ncon);
    for (k=0, unbalance=1.0*kpwgts[k*ncon+j]/(tpwgts[k*ncon+j]*tvwgt), i=1; i<nparts; i++) {
      if (unbalance < 1.0*kpwgts[i*ncon+j]/(tpwgts[i*ncon+j]*tvwgt)) {
        unbalance = 1.0*kpwgts[i*ncon+j]/(tpwgts[i*ncon+j]*tvwgt);
        k = i;
      }
    }
    printf("     constraint #%"PRIDX":  %5.3"PRREAL" out of %5.3"PRREAL"\n", 
        j, unbalance,
         1.0*nparts*vwgt[ncon*iargmax_strd(nvtxs, vwgt+j, ncon)+j]/
            (1.0*isum(nparts, kpwgts+j, ncon)));
  }
  printf("\n");

  if (ncon == 1) {
    tvwgt = isum(nparts, kpwgts, 1);
    for (k=0, unbalance=kpwgts[k]/(tpwgts[k]*tvwgt), i=1; i<nparts; i++) {
      if (unbalance < kpwgts[i]/(tpwgts[i]*tvwgt)) {
        unbalance = kpwgts[i]/(tpwgts[i]*tvwgt);
        k = i;
      }
    }

    printf(" - Most overweight partition:\n"
           "     pid: %"PRIDX", actual: %"PRIDX", desired: %"PRIDX", ratio: %.2"PRREAL".\n\n",
        k, kpwgts[k], (idx_t)(tvwgt*tpwgts[k]), unbalance);
  }

  gk_free((void **)&kpwgts, LTERM);


  /* Compute subdomain adjacency information */
  pptr = imalloc(nparts+1, "ComputePartitionInfo: pptr");
  pind = imalloc(nvtxs, "ComputePartitionInfo: pind");
  pdom = imalloc(nparts, "ComputePartitionInfo: pdom");

  iarray2csr(nvtxs, nparts, where, pptr, pind);

  maxndom = nparts+1;
  minndom = 0;
  for (tndom=0, pid=0; pid<nparts; pid++) {
    iset(nparts, 0, pdom);
    for (ii=pptr[pid]; ii<pptr[pid+1]; ii++) {
      i = pind[ii];
      for (j=xadj[i]; j<xadj[i+1]; j++)
        pdom[where[adjncy[j]]] += adjwgt[j];
    }
    pdom[pid] = 0;
    for (ndom=0, i=0; i<nparts; i++)
      ndom += (pdom[i] > 0 ? 1 : 0);
    tndom += ndom;
    if (pid == 0 || maxndom < ndom)
      maxndom = ndom;
    if (pid == 0 || minndom > ndom)
      minndom = ndom;
  }

  printf(" - Subdomain connectivity: max: %"PRIDX", min: %"PRIDX", avg: %.2"PRREAL"\n\n",
      maxndom, minndom, 1.0*tndom/nparts);
      
  gk_free((void **)&pptr, &pind, &pdom, LTERM);


  /* Compute subdomain adjacency information */
  cptr   = imalloc(nvtxs+1, "ComputePartitionInfo: cptr");
  cind   = imalloc(nvtxs, "ComputePartitionInfo: cind");
  cpwgts = ismalloc(nparts, 0, "ComputePartitionInfo: cpwgts");

  ncmps = FindPartitionInducedComponents(graph, where, cptr, cind);
  if (ncmps == nparts)
    printf(" - Each partition is contiguous.\n");
  else {
    if (IsConnected(graph, 0)) {
      for (nover=0, i=0; i<ncmps; i++) {
        cpwgts[where[cind[cptr[i]]]]++;
        if (cpwgts[where[cind[cptr[i]]]] == 2)
          nover++;
      }
      printf(" - There are %"PRIDX" non-contiguous partitions.\n"
             "   Total components after removing the cut edges: %"PRIDX",\n"
             "   max components: %"PRIDX" for pid: %"PRIDX".\n",
          nover, ncmps, imax(nparts, cpwgts), (idx_t)iargmax(nparts, cpwgts));
    }
    else {
      printf(" - The original graph had %"PRIDX" connected components and the resulting\n"
             "   partitioning after removing the cut edges has %"PRIDX" components.",
         FindPartitionInducedComponents(graph, NULL, NULL, NULL), ncmps);
    }
  }

  gk_free((void **)&cptr, &cind, &cpwgts, LTERM);
             
}

