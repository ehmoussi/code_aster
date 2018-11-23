/* -------------------------------------------------------------------- */
/* Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org             */
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
/* aslint:disable=W3004
/*! \file
Copyright (c) 2003, The Regents of the University of California, through
Lawrence Berkeley National Laboratory (subject to receipt of any required 
approvals from U.S. Dept. of Energy) 

All rights reserved. 

The source code is distributed under BSD license, see the file License.txt
at the top-level directory.
*/

/*
 * -- SuperLU routine (version 5.0) --
 * Univ. of California Berkeley, Xerox Palo Alto Research Center,
 * and Lawrence Berkeley National Lab.
 * October 15, 2003
 *
 */
#include "aster.h" 
#ifdef _HAVE_PETSC
#include "slu_ddefs.h"

#define HANDLE_SIZE  8

/* kind of integer to hold a pointer.  Use 64-bit. */
//typedef long long int fptr;
typedef ASTERINTEGER fptr;

typedef struct {
    SuperMatrix *L;
    SuperMatrix *U;
    int *perm_c;
    int *perm_r;
} factors_t;

/* Compute the LU decomposition of matrix */
void DEFPPPPPPPP(SLU_FACTORIZE, slu_factorize, ASTERINTEGER4 *m, ASTERINTEGER4 *n, 
                     ASTERINTEGER4 *nnz,  ASTERDOUBLE *values,
                     ASTERINTEGER4 *rowind, ASTERINTEGER4 *colptr, 
                     fptr *f_factors, ASTERINTEGER4 *info)
{
    SuperMatrix A, AC, B;
    SuperMatrix *L, *U;
    int *perm_r = NULL; /* row permutations from partial pivoting */
    int *perm_c = NULL; /* column permutation vector */
    int *etree = NULL ;  /* column elimination tree */
    SCformat *Lstore;
    NCformat *Ustore;
    int i;
    int panel_size, permc_spec, relax;
    superlu_options_t options;
    SuperLUStat_t stat;    
    mem_usage_t   mem_usage;
    factors_t *LUfactors;
    GlobalLU_t Glu;   /* Not needed on return. */
    int    *rowind0;  /* counter 1-based indexing from Fortran arrays. */
    int    *colptr0;  

/* Set the default input options. */
    set_default_options(&options);

/* Initialize the statistics variables. */
    StatInit(&stat);

/* Adjust to 0-based indexing */
    if ( !(rowind0 = intMalloc(*nnz)) ) ABORT("Malloc fails for rowind0[].");
    if ( !(colptr0 = intMalloc(*n+1)) ) ABORT("Malloc fails for colptr0[].");
    for (i = 0; i < *nnz; ++i) rowind0[i] = rowind[i] - 1;
    for (i = 0; i <= *n; ++i) colptr0[i] = colptr[i] - 1;

/* Create (rectangular) SuperMatrix A (m rows n columns)*/
    dCreate_CompCol_Matrix(&A, *m, *n, *nnz, values, rowind0, colptr0,
                           SLU_NC, SLU_D, SLU_GE);
    L = (SuperMatrix *) SUPERLU_MALLOC( sizeof(SuperMatrix) );
    U = (SuperMatrix *) SUPERLU_MALLOC( sizeof(SuperMatrix) );
    if ( !(perm_r = intMalloc(*m)) ) ABORT("Malloc fails for perm_r[].");
    if ( !(perm_c = intMalloc(*n)) ) ABORT("Malloc fails for perm_c[].");
    if ( !(etree = intMalloc(*m)) ) ABORT("Malloc fails for etree[].");

/*
* Get column permutation vector perm_c[], according to permc_spec:
*   permc_spec = 0: natural ordering 
*   permc_spec = 1: minimum degree on structure of A'*A
*   permc_spec = 2: minimum degree on structure of A'+A
*   permc_spec = 3: approximate minimum degree for unsymmetric matrices
*/
    permc_spec = options.ColPerm;
    permc_spec=0;
// dPrint_CompCol_Matrix("Matrice à factoriser", &A);
    get_perm_c(permc_spec, &A, perm_c);
// for (i=0;i< *n; i++) printf( "perm_c(%d)=%d\n", i, perm_c[i]);
    sp_preorder(&options, &A, perm_c, etree, &AC);
    panel_size = sp_ienv(1);
    relax = sp_ienv(2);
/* Effective call to LU decomposition */
    dgstrf(&options, &AC, relax, panel_size, etree,
                NULL, 0, perm_c, perm_r, L, U, &Glu, &stat, info);
/* Analyze info return code */
    if ( *info != 0 ) 
    {
        printf("dgstrf() error returns INFO= %d\n", *info);
        if ( *info <= *n ) 
        { /* factorization completes */
            dQuerySpace(L, U, &mem_usage);
            printf("L\\U MB %.3f\ttotal MB needed %.3f\n",
            mem_usage.for_lu/1e6, mem_usage.total_needed/1e6);
        }
     }
/* Save the LU factors in the factors handle */
    LUfactors = (factors_t*) SUPERLU_MALLOC(sizeof(factors_t));
    LUfactors->L = L;
    LUfactors->U = U;
    LUfactors->perm_c = perm_c;
    LUfactors->perm_r = perm_r;
    *f_factors = (fptr) LUfactors;

/* Free un-wanted storage */
    SUPERLU_FREE(etree);
    Destroy_SuperMatrix_Store(&A);
    Destroy_CompCol_Permuted(&AC);
    SUPERLU_FREE(rowind0);
    SUPERLU_FREE(colptr0);
    StatFree(&stat);
}
/*
/* Get the number of non-zero terms in L factor 
*/
void DEFPPP(SLU_GET_NNZ_OF_LOWER_FACTOR, slu_get_nnz_of_lower_factor,
            fptr *f_factors, ASTERINTEGER *nnz_l, ASTERINTEGER4 *info)
{
   factors_t *LUfactors;
/* Extract the L factors in the factors handle */
    LUfactors = (factors_t*) *f_factors;
    SuperMatrix *L;
    L = LUfactors->L;
    SCformat *Lstore;
    Lstore = (SCformat *) L->Store;
/* Returns the number of nonzeros in L*/
    *nnz_l= (ASTERINTEGER)(Lstore->nnz);
*info = 0; 
}
/*
/* Get the number of non-zero terms in U factor 
*/
void DEFPPP(SLU_GET_NNZ_OF_UPPER_FACTOR, slu_get_nnz_of_upper_factor, 
             fptr *f_factors, ASTERINTEGER *nnz_u, ASTERINTEGER4 *info)
{
   factors_t *LUfactors;
/* Extract the U factors in the factors handle */
    LUfactors = (factors_t*) *f_factors;
    SuperMatrix *U;
    U = LUfactors->U;
    NCformat *Ustore;
    Ustore = (NCformat *) U->Store;
/* Returns the number of nonzeros in U*/
    *nnz_u= (ASTERINTEGER)(Ustore->nnz);
*info = 0; 
}
/*
/* Obtain L  from LUfactors 
/* L is returned as a CSC matrix, stored in values, rowind, colptr arrays 
*/
void DEFPPPPP(SLU_GET_LOWER_FACTOR, slu_get_lower_factor,
              fptr *f_factors, ASTERDOUBLE *values,
              ASTERINTEGER4 *rowind, ASTERINTEGER4 *colptr, ASTERINTEGER4 *info)
{
    SuperMatrix *L, *U;
    double *dp;
    int *col_to_sup, *sup_to_col, *rowind_colptr;
    int *sc_rowind; /*compressed rowind SC format*/ 
    SCformat *Lstore;
    int i, j, k, c, d, p, nsup, ncol;
    factors_t *LUfactors;

/* Extract the L factors in the factors handle */
    LUfactors = (factors_t*) *f_factors;
    L = LUfactors->L;
    ncol = L->ncol;
    Lstore = (SCformat *) L->Store;
    dp = (double *) Lstore->nzval;
    col_to_sup = Lstore->col_to_sup;
    sup_to_col = Lstore->sup_to_col;
    rowind_colptr = Lstore->rowind_colptr;
    sc_rowind = Lstore->rowind;
    /* On veut récupérer la matrice L au format CSC */
    /* L est stockée au formet SuperLU */
    /* Initialisation de l'indice "position" dans les 
    tableaux rowind et values*/
    p=0;
    /* On parcourt les superblocs*/
    for (k = 0; k <= Lstore->nsuper; ++k) {
    /* c est la première colonne du superbloc courant*/
        c = sup_to_col[k];
        /* Il y a nsup colonnes dans le superbloc courant */
        nsup = sup_to_col[k+1] - c;
        /* On parcourt chaque colonne*/
        for (j = c; j < c + nsup; ++j) {
        /* d est la position dans le tableau de valeurs nzval_colptr 
        du premier terme de la colonne courante */
            d = Lstore->nzval_colptr[j];
            colptr[j]= p; 
            /* rowind_colptr[c] est la position dans le tableau des indices 
            lignes rowind du premier terme de la colonne courante */
            for (i = rowind_colptr[c]; i < rowind_colptr[c+1]; ++i) {
                if ( sc_rowind[i] < j ) {
                /* On est dans la partie "U" -> skip */
                }
                else if ( sc_rowind[i] == j ) {
                /* On est sur la diagonale */
                values[p]=1.0;
                rowind[p]=sc_rowind[i];
                ++p;
                } 
                else
                {
                values[p]=dp[d];
                rowind[p]=sc_rowind[i];
          //      printf(" L[%d,%d]=%f\n",sc_rowind[i],j,dp[d]);
                ++p;
                }
            ++d;
            }
        }
    }
    colptr[ncol]= p;
/* Use 1-based indexing */
  for (i = 0; i < Lstore->nnz; ++i) ++rowind[i];
  for (i = 0; i <= L->ncol ; ++i) ++colptr[i];

  *info = 0; 
}
/*
/* Obtain perm_row  from LUfactors 
*/
void DEFPPP( SLU_GET_PERM_ROW, slu_get_perm_row, 
            fptr *f_factors, ASTERINTEGER4* perm_row, ASTERINTEGER4 *info )
{
    SuperMatrix *L;
    int *perm_r; /* row permutation from partial pivoting */
    SCformat *Lstore;
    int i;
    factors_t *LUfactors;

/* Extract the L factors in the factors handle */
    LUfactors = (factors_t*) *f_factors;
    L = LUfactors->L;
    perm_r = LUfactors->perm_r;
/* Copy row permutation  (using 1-based-indexing) */ 
    for ( i = 0; i < L->nrow ; i++) {
      perm_row[i]=perm_r[i]+1;
    }
    *info = 0; 
}
/*
/* Obtain perm_col  from LUfactors 
*/
void DEFPPP( SLU_GET_PERM_COL, slu_get_perm_col, fptr *f_factors, 
                        ASTERINTEGER4* perm_col, ASTERINTEGER4 *info)
{
    SuperMatrix *L;
    int *perm_c; /* row permutation from partial pivoting */
    SCformat *Lstore;
    int i;
    factors_t *LUfactors;
/* Extract the L factors in the factors handle */
    LUfactors = (factors_t*) *f_factors;
    L = LUfactors->L;
    perm_c = LUfactors->perm_c;
/* Copy column permutation  (using 1-indexing) */ 
    for ( i = 0; i < L->ncol ; i++) {
      perm_col[i]=perm_c[i]+1;
 //     printf(" Permc[%d]=%d\n",i,perm_c[i]);
    }
    *info = 0; 
}
/*
/* Obtain diagonal of upper factor U from LUFactors 
*/
void DEFPPP(SLU_GET_DIAG_OF_UPPER_FACTOR, slu_get_diag_of_upper_factor, 
            fptr *f_factors, ASTERDOUBLE *diag_u, ASTERINTEGER4 *info)
{
    SuperMatrix *L, *U;
    double *dp;
    int *col_to_sup, *sup_to_col, *rowind_colptr;
    int *sc_rowind; /*compressed rowind SC format*/ 
    SCformat *Lstore;
    int i, j, k, c, d, p, nsup, ncol;
    factors_t *LUfactors;

/* Extract the L factors in the factors handle */
    LUfactors = (factors_t*) *f_factors;
    L = LUfactors->L;
   //dPrint_SuperNode_Matrix("LU factor, SuperNode  L ", L );
  //  dPrint_CompCol_Matrix("LU factor, U ", LUfactors->U );
    ncol = L->ncol;
    Lstore = (SCformat *) L->Store;
    dp = (double *) Lstore->nzval;
    col_to_sup = Lstore->col_to_sup;
    sup_to_col = Lstore->sup_to_col;
    rowind_colptr = Lstore->rowind_colptr;
    sc_rowind = Lstore->rowind;
    /* On veut récupérer diag(U), qui est stockée 
      dans la partie "L" des facteurs */
    /* L est stockée au format SuperLU */
    /* Initialisation de l'indice "position" dans les 
    tableaux rowind et values*/
    p=0;
    /* On parcourt les superblocs*/
    for (k = 0; k <= Lstore->nsuper; ++k) {
    /* c est la première colonne du superbloc courant*/
        c = sup_to_col[k];
        /* Il y a nsup colonnes dans le superbloc courant */
        nsup = sup_to_col[k+1] - c;
        /* On parcourt chaque colonne*/
        for (j = c; j < c + nsup; ++j) {
        /* d est la position dans le tableau de valeurs nzval_colptr 
        du premier terme de la colonne courante */
            d = Lstore->nzval_colptr[j];
            /* rowind_colptr[c] est la position dans le tableau des indices 
            lignes rowind du premier terme de la colonne courante */
            for (i = rowind_colptr[c]; i < rowind_colptr[c+1]; ++i) {
                if ( sc_rowind[i] == j ) {
                /* On est sur la diagonale */
                   diag_u[sc_rowind[i]]=dp[d];
          //      printf(" U[%d,%d]=%f\n",sc_rowind[i],j,dp[d]);
                ++p;
                } 
            ++d;
            }
        }
    }
*info = 0; 
}
/*
/* Obtain  upper factor U from LUFactors 
/* U is returned as a CSC matrix, stored in values, rowind, colptr arrays 
*/
void DEFPPPPP(SLU_GET_UPPER_FACTOR, slu_get_upper_factor, 
              fptr *f_factors, ASTERDOUBLE *values, ASTERINTEGER4 *rowind, 
                            ASTERINTEGER4 *colptr, ASTERINTEGER4 *info )
{
    SuperMatrix *L, *U;
    double *dp;
    int *col_to_sup, *sup_to_col, *rowind_colptr;
    int *sc_rowind; /*compressed rowind SC format*/ 
    SCformat *Lstore;
    NCformat *Ustore;
    int i, j, k, c, d, p,n, nsup, ncol;
    factors_t *LUfactors;

/* colptr[j+1] = nombre de termes non-nuls dans la colonne j */ 
/* on parcourt L  */
    LUfactors = (factors_t*) *f_factors;
    L = LUfactors->L;
    ncol = L->ncol;
    Lstore = (SCformat *) L->Store;
    dp = (double *) Lstore->nzval;
    col_to_sup = Lstore->col_to_sup;
    sup_to_col = Lstore->sup_to_col;
    rowind_colptr = Lstore->rowind_colptr;
    sc_rowind = Lstore->rowind;    
    colptr[0]=0;
    /* On parcourt les superblocs*/
    for (k = 0; k <= Lstore->nsuper; ++k) {
    /* c est la première colonne du superbloc courant*/
        c = sup_to_col[k];
        /* Il y a nsup colonnes dans le superbloc courant */
        nsup = sup_to_col[k+1] - c;
        /* On parcourt chaque colonne*/
        for (j = c; j < c + nsup; ++j) {
            /* rowind_colptr[c] est la position dans le tableau des indices 
            lignes rowind du premier terme de la colonne courante */
            for (i = rowind_colptr[c]; i < rowind_colptr[c+1]; ++i) {
                if ( sc_rowind[i] <= j ) {
                /* On est dans la partie "U"  */
                ++colptr[j+1];
                }
            }
        }
    }
/* on parcourt U */
    U=LUfactors->U;
    ncol = U->ncol;
    Ustore = (NCformat *) U->Store;
    dp = (double *) Ustore->nzval;
    /* On parcourt chaque colonne*/
    for (j = 0; j < ncol; ++j) {
        /* d est la position dans le tableau de valeurs nzval 
        du premier terme de la colonne courante */
        for (d = Ustore->colptr[j]; d<Ustore->colptr[j+1]; d++)  {
             ++colptr[j+1];
        }
    }
/* puis on somme pour que colptr[j] désigne l'indice du premier terme de la 
la colonne j dans values et rowind */
    for (i=1; i<= ncol; ++i ) {
       colptr[i]+=colptr[i-1];
    }
/* On remplit rowind et values */
 /* on parcourt L  */
    LUfactors = (factors_t*) *f_factors;
    L = LUfactors->L;
    ncol = L->ncol;
    Lstore = (SCformat *) L->Store;
    dp = (double *) Lstore->nzval;
    col_to_sup = Lstore->col_to_sup;
    sup_to_col = Lstore->sup_to_col;
    rowind_colptr = Lstore->rowind_colptr;
    sc_rowind = Lstore->rowind;    
    /* On parcourt les superblocs*/
    for (k = 0; k <= Lstore->nsuper; ++k) {
    /* c est la première colonne du superbloc courant*/
        c = sup_to_col[k];
        /* Il y a nsup colonnes dans le superbloc courant */
        nsup = sup_to_col[k+1] - c;
        /* On parcourt chaque colonne*/
        for (j = c; j < c + nsup; ++j) {
        /* d est la position dans le tableau de valeurs nzval_colptr 
        du premier terme de la colonne courante */
            d = Lstore->nzval_colptr[j];
            /* rowind_colptr[c] est la position dans le tableau des indices 
            lignes rowind du premier terme de la colonne courante */
            for (i = rowind_colptr[c]; i < rowind_colptr[c+1]; ++i) {
                if ( sc_rowind[i] <= j ) {
                /* On est dans la partie "U"  */
   //             printf(" U[%d,%d]=%f\n",sc_rowind[i],j,dp[d]);
                rowind[colptr[j]]=sc_rowind[i];
                values[colptr[j]]=dp[d];
                ++colptr[j];
                }
            ++d; 
            }
        }
    }
/* On parcourt U */
    U=LUfactors->U;
    ncol = U->ncol;
    Ustore = (NCformat *) U->Store;
    dp = (double *) Ustore->nzval;
    /* On parcourt chaque colonne*/
    for (j = 0; j < ncol; ++j) {
         /*printf("\n colonne: %d", j );*/
        /* d est la position dans le tableau de valeurs nzval 
        du premier terme de la colonne courante */
        for (d = Ustore->colptr[j]; d<Ustore->colptr[j+1]; d++)  {
             rowind[colptr[j]]= Ustore->rowind[d];
             values[colptr[j]]=dp[d];
 //            printf(" U[%d,%d]=%f\n",rowind[colptr[j]],j,dp[d]);
             colptr[j]++;
        }
    }
/* On décale colptr vers la droite*/
    
    for (i=ncol;i>0; --i){
    colptr[i]=colptr[i-1];
    }
    colptr[0]=0;
/* Use 1-based indexing */
  for (i = 0; i < Ustore->nnz; ++i) ++rowind[i];
  for (i = 0; i <= U->ncol ; ++i) ++colptr[i];

*info = 0; 
}
/*
/* Free memory 
*/
void DEFPP( SLU_FREE_FACTORS, slu_free_factors, fptr *f_factors, 
            ASTERINTEGER4 *info)
{
    factors_t *LUfactors;
/* Free the LU factors in the factors handle */
    LUfactors = (factors_t*) *f_factors;
    SUPERLU_FREE (LUfactors->perm_r);
    SUPERLU_FREE (LUfactors->perm_c);
    Destroy_SuperNode_Matrix(LUfactors->L);
    Destroy_CompCol_Matrix(LUfactors->U);
    SUPERLU_FREE (LUfactors->L);
    SUPERLU_FREE (LUfactors->U);
    SUPERLU_FREE (LUfactors);
    *info = 0;
}
/*
/* Solve linear system using LU decomposition stored in LUfactors 
/* On exit, right-hand-side b is overwritten with solution x 
*/
void DEFPPPPPP( SLU_SOLVE, slu_solve, fptr *f_factors, 
                ASTERINTEGER4 *trans_option, 
                ASTERINTEGER4 *nrhs, ASTERDOUBLE *b, ASTERINTEGER4 *ldb,  
                ASTERINTEGER4 *info ) 
{
    SuperLUStat_t stat;
    SuperMatrix B; 
    factors_t *LUfactors;
    SuperMatrix *L, *U;
    int *perm_r, *perm_c; 
    trans_t  trans;
    int ncol; 

/* Triangular solve */
/* Initialize the statistics variables. */
    StatInit(&stat);

/* Extract the LU factors in the factors handle */
    LUfactors = (factors_t*) *f_factors;
    L = LUfactors->L;
    U = LUfactors->U;
    ncol = L->ncol;
    perm_c = LUfactors->perm_c;
    perm_r = LUfactors->perm_r;

    if ( *trans_option == 0 ) {
           trans = NOTRANS;
        }
    else if ( *trans_option == 1 ) {
           trans = TRANS; 
    }
    dCreate_Dense_Matrix(&B, ncol, *nrhs, b, *ldb, SLU_DN, SLU_D, SLU_GE);

/* Solve the system A*X=B, overwriting B with X. */
    dgstrs (trans, L, U, perm_c, perm_r, &B, &stat, info);
/* Free un-wanted storage */
    Destroy_SuperMatrix_Store(&B);
    StatFree(&stat);
}
#endif
