! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------
!
module constraint_module
!
! person_in_charge: natacha.bereux at edf.fr
!
! because the pointer is a result
! aslint: disable=W1304,C1308
!
use csc_matrix_type
use csc_store_type
use matrix_conversion_module
!
implicit none
private
#include "asterf_types.h"
#include "asterc/slu_factorize.h"
#include "asterc/slu_free_factors.h"
#include "asterc/slu_get_diag_of_upper_factor.h"
#include "asterc/slu_get_lower_factor.h"
#include "asterc/slu_get_nnz_of_lower_factor.h"
#include "asterc/slu_get_perm_col.h"
#include "asterc/slu_get_perm_row.h"
#include "asterc/slu_get_upper_factor.h"
#include "asterc/slu_solve.h"
#include "asterfort/assert.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
#ifdef _HAVE_PETSC
!
  public ::  get_nullbasis_trans, get_columnspace_basis
!
  contains
!
! Builds a basis Z of the nullspace of matrix B^T 
! i.e. Z such that B^T Z = 0 
! Before calling this routine, you should replace
! B by a matrix of maximum rank 
! to do so use routine get_column_space_basis 
! 
subroutine get_nullbasis_trans( b, z ) 
    ! Dummy arguments 
    type(csc_matrix), intent(inout)  :: b
    type(csc_matrix), intent(out) :: z 
    !
    ! Local variables  
    type(csc_matrix) :: l, l1, l2, l2t, t, id
    integer :: nnz_l, ldrhs, nrhs
    integer(kind=4):: info, trans
    integer(kind=4):: m_4, n_4, nnz_4
    integer(kind=4), dimension(:), pointer :: perm_r => null()
    integer(kind=4), dimension(:), pointer :: permr_inv => null()
    real(kind=8), dimension(:), pointer    :: diag_u=> null()
    real(kind=8), dimension(:), pointer    :: rhs=> null() 
    real(kind=8) :: t1, t2, tol, tolref, valref
    integer ::  step, ifm, niv
    integer ::  jj, blocksize
    integer(kind=8) :: factors
    integer, dimension(:), pointer :: icol =>null()
    type(csc_store) :: cs
    aster_logical :: debug = .false. 
    integer(kind=4), parameter :: un =1 

    call infniv( ifm, niv ) 
!  -------------------------------------
!  Factorisation LU de B => Pr B Pc = LU 
!  -------------------------------------
    !call CPU_time( t1 ) 
    m_4=int(b%m, kind=4) 
    n_4=int(b%n, kind=4) 
    nnz_4=int(b%nnz, kind=4) 
    call slu_factorize( m_4, n_4, nnz_4,b%values, b%rowind, b%colptr, factors, info ) 
    ASSERT( info == 0 ) 
    !call CPU_time( t2 ) 
    if ( debug ) then
       print*, "ELG Factorisation LU (SuperLU dgtrf) de la matrice C^T de taille : ",  b%m, "x", b%n
       print*, "ELG Temps CPU (s): ", t2-t1 
    endif 
!  Récupération de L à partir de factors
    call slu_get_nnz_of_lower_factor( factors, nnz_l, info) 
    ASSERT( info == 0 ) 
    call create_csc_matrix("L", b%m,b%n,nnz_l, l) 
    call slu_get_lower_factor( factors, l%values, l%rowind, l%colptr, info )
    ASSERT( info == 0 )
    call sort_rows_of_csc_matrix( l )   
!  Récupération de Pr à partir de factors et construction de la permutation 
!  inverse 
    AS_ALLOCATE( vi4=perm_r, size = b%m)
    call slu_get_perm_row( factors, perm_r,  info )
    ASSERT( info == 0 )
    AS_ALLOCATE( vi4=permr_inv, size = to_aster_int(b%m) )
    call inverse_permutation( perm_r, permr_inv) 
!  Récupération de diag(U) à partir de factors
    AS_ALLOCATE( vr=diag_u, size = to_aster_int(b%n) )
    call slu_get_diag_of_upper_factor ( factors, diag_u, info ) 
    ASSERT( info == 0 )
!  On vérifie que B est de rang maximum (si ce n'est pas le cas 
!  c'est qu'on a oublié d'appeler get_column_space_basis avant 
!  get_basis_of_nullspace
    tolref=1.d-6
    valref = maxval(abs(diag_u))
    tol=tolref*valref
    ASSERT( all(abs(diag_u) > tolref) )
! Liberation des objets SuperLU et des tableaux inutiles ensuite
    call slu_free_factors( factors, info ) 
    AS_DEALLOCATE( vi4 = perm_r )
    AS_DEALLOCATE( vr = diag_u ) 
!
! -------------------------------------
! Calcul de Z 
! -------------------------------------
!
! Extraction de L1 et L2 
! L = (L1)
!     (L2) 
    call hsplit_csc_matrix(l, l1, l2 ) 
    call free_csc_matrix( l ) 
!  Factorisation LU de L1
!  L1 est déjà triangulaire supérieure mais
!  cette opération est nécessaire pour construire un objet "factors"
!  qui permette de résoudre des systèmes linéaires L1 X = Y  
    m_4=int(l1%m, kind=4) 
    n_4=int(l1%n, kind=4) 
    nnz_4=int(l1%nnz, kind=4) 
    call slu_factorize( m_4,n_4,nnz_4,l1%values, l1%rowind, l1%colptr, factors, info )
    ASSERT( info == 0 )
!   Transposition de L2 
    call transpose_csc_matrix(l2, l2t)
    call free_csc_matrix( l2 ) 
!
!   Calcul de - L1^-T L2^T, colonne par colonne
!   Allocation de la structure de stockage temporaire 
!   "peigne" cs 
    call create_csc_store( l2t%n, cs, l2t%m )
!    
!    Leading dimension de la matrice second membre 
    ldrhs=l2t%m
    trans = un
    blocksize = 500
!    Allocation de la matrice second membre 
    AS_ALLOCATE( vr=rhs, size= blocksize*l2t%m )
    AS_ALLOCATE( vi=icol, size= blocksize )
!    
    if ( debug ) then 
       print *, 'ELG Résolution (SuperLU dgtrs), taille des blocs : ', blocksize
    endif   
    !call CPU_time(t1)
    jj = 0
    step = 0 
    do while( jj < l2t%n )
        nrhs = 0 
        icol(:) = 0 
        rhs(:) = 0.d0 
        step = step + 1 
        do while ( ( nrhs < blocksize ).and.( jj < l2t%n ) )
        jj = jj + 1 
! Préparation du second membre 
            if ( l2t%colptr(jj+1) > l2t%colptr(jj) ) then
                nrhs = nrhs + 1 
                icol(nrhs) = jj 
! - décompression de la jjeme colonne de L2T dans rhs 
                call copy_col_of_csc_matrix( l2t, jj, rhs, nrhs, ldrhs  )
            endif  
         end do     
! - multiplication par (-1)
         rhs(:)=-rhs(:)
! Résolution 
         call slu_solve(factors, trans, int(nrhs, kind=4), rhs, int(ldrhs,kind=4), info )
         ASSERT( info == 0 ) 
! Stockage de la solution dans cs  
         call put_to_csc_store( rhs , ldrhs, nrhs, icol,  cs )
     end do 
!
     !call CPU_time(t2) 
     if ( debug ) then 
        print *, 'ELG Nombre de seconds membres : ', l2t%n
        print*,  'ELG Nombre de résolutions multi-seconds membres :', step 
        print*,  'ELG Temps CPU (s) :', t2 - t1
     endif 
!
! Stockage de T au format CSC 
    call create_csc_matrix_from_csc_store("T", cs, l2t%m, t )
! 
    call slu_free_factors( factors, info )
    call free_csc_store(cs)
    AS_DEALLOCATE(vr=rhs) 
! Id = Identity matrix (size = ncol (L2^T)) 
    id = eye_csc_matrix( l2t%n ) 
! Z = ( T  ) 
!     ( Id )
    z =  concat_csc_matrix( t, id, "Z")
! Appliquer l'inverse de perm_r  à Z 
    call permute_rows_of_csc_matrix(permr_inv, z) 
    call sort_rows_of_csc_matrix( z )
!
    AS_DEALLOCATE(vi4=permr_inv) 
    AS_DEALLOCATE(vr=rhs)
    AS_DEALLOCATE(vi=icol)
end subroutine get_nullbasis_trans
!
! On entry, a is a csc_matrix 
! On exit, columns of b are a basis of the 
! space spanned by columns of a
! if columns of a are independent vectors
! (i.e. a has maximum rank),  b = a 
!
subroutine get_columnspace_basis( a, b )
    ! Dummy arguments 
    type(csc_matrix), intent(in)           :: a 
    type(csc_matrix), intent(out)          :: b
    ! Local variables 
    ! 
    integer                                :: n_b, nnz_b
    integer(kind=4)                        :: m_4, n_4, nnz_4
    integer(kind=4)                        :: info 
    real(kind=8)                           :: tol, valref, tolref
    integer                                :: pass, ii, jj, nnz_col, pos
    integer                                :: ifm, niv, nindep
    integer(kind=8)                        :: factors
    integer(kind=4), dimension(:), pointer :: perm_c=>null(), permc_inv=> null()
    real(kind=8), dimension(:), pointer    :: diag_u=>null()
    aster_logical, dimension(:), pointer   :: is_indep
    !
    call infniv(ifm, niv)
    !
    ! Factorisation LU de A => Pr A Pc = LU
    !
    m_4=int(a%m, kind=4)
    n_4=int(a%n, kind=4)
    nnz_4=int(a%nnz, kind=4)
    call slu_factorize( m_4, n_4, nnz_4, a%values, a%rowind, a%colptr, factors, &
              &         info )   
    ASSERT( info == 0 ) 
    !
    ! Récupérer diag(U) 
    !
    AS_ALLOCATE( vr=diag_u, size=a%n ) 
    diag_u(:)=0.d0
    call slu_get_diag_of_upper_factor( factors, diag_u, info ) 
    ! Si tous les termes de diag_u sont suffisament grands (> tol) 
    ! alors A est de rang a%n, ses colonnes sont indépendantes.
    ! B = A 
    ! valref sert de référence pour estimer si un terme de diag_u 
    ! est suffisament petit pour être négligé  
    !
    valref=maxval(abs(diag_u))
    tolref = 1.e-6
    tol = tolref*valref
    ! Nombre de colonnes indépendantes 
    AS_ALLOCATE( vl=is_indep, size=a%n)
    is_indep = ( abs(diag_u) > tol )
    nindep = count( is_indep )
    if (niv .ge. 2) then
       call utmess('I', 'ELIMLAGR_12', ni=2, vali = (/a%n, nindep/) )
    endif
    ! Toutes les colonnes sont indépendantes 
    if ( nindep == a%n  ) then  
        call copy_csc_matrix( a, b, "B")
    ! Sinon, on utilise diag_u pour éliminer certaines colonnes de A
    else 
    !  On récupère la permutation des colonnes perm_c
    !  Normalement, SuperLu n'effectue pas de permutation des colonnes
    !  Ce test permet de le vérifier 
        AS_ALLOCATE( vi4=perm_c, size=a%n ) 
        AS_ALLOCATE( vi4=permc_inv, size=a%n )
        perm_c(:) = 0
        call slu_get_perm_col( factors, perm_c, info ) 
        ASSERT( info == 0 ) 
        call inverse_permutation(perm_c, permc_inv) 
        ASSERT(any(perm_c/=permc_inv))
    !    Soit A = LU 
    !    La colonne A(:,j) telle que  U(j,j) est nul n'est pas indépendante des autres
    !    Elle correspond à une contrainte redondante ou liéee.
    !    Si A*permc = LU, c'est la colonne A(:, permc_inv) dont il s'agit.
    !
    !    Deux passes : une pour compter les termes non-nuls de b
    !                  une pour la construire    
     do pass = 1,2
         nnz_b = 0   
         n_b= 0
         pos=0
         do jj = 1, a%n
    ! is_indep(jj) = .true. =>  garder la colonne jj
             if ( is_indep( jj ) ) then 
                 n_b = n_b + 1
                 nnz_col = a%colptr(permc_inv(jj)+1) - a%colptr(permc_inv(jj))
                 nnz_b = nnz_b + nnz_col 
                 if ( pass == 2 ) then
                     b%colptr(n_b+1) = b%colptr(n_b)+int(nnz_col,4)
                     do ii = 1,  nnz_col
                         pos=pos+1
                         b%rowind(pos)=a%rowind(a%colptr(permc_inv(jj))+ii-1)
                         b%values(pos)=a%values(a%colptr(permc_inv(jj))+ii-1)
                     enddo 
                 endif
             endif  
         enddo 
         if ( pass == 1 ) then
    ! allocation de la structure CSC pour stocker B
             call create_csc_matrix( "B", a%m, n_b, nnz_b, b ) 
         endif 
     enddo
    !
    endif 
    !
    call check_csc_matrix( b )
    ! libérations 
    AS_DEALLOCATE(vi4=perm_c)
    AS_DEALLOCATE(vi4=permc_inv)
    AS_DEALLOCATE(vr=diag_u )
    AS_DEALLOCATE(vl=is_indep)
    call slu_free_factors( factors, info )
    !
end subroutine get_columnspace_basis
!
#endif 
end module constraint_module
