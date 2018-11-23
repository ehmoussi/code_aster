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

module matrix_conversion_module
!
use csc_matrix_type
use aster_petsc_module
!
implicit none 
!
! person_in_charge: natacha.bereux at edf.fr
! aslint:disable=C1308
!
private 
#include "asterf_petsc.h"
#include "asterc/asmpi_comm.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
! 
public :: csc2dense, csc2csr, matas2csc
#ifdef  _HAVE_PETSC
public :: csc2matseq , matseq2csr
#endif 
!
contains 
!
subroutine  matas2csc( matas, aa, matrix_name )
!   Dummy arguments
      character(len=19), intent(in)      :: matas
      type(csc_matrix), intent(out) :: aa
      character(len=*), intent(in)      :: matrix_name
!   Local variables 
    character(len=14) :: nonu
    integer :: iret, nsmdi, nvalm, nsmhc
    character(len=32) :: syme
    logical :: lsym
    integer :: irow, icol, irow_csc, icol_csc
    integer :: pstart, pend, pass, pp
    real(kind=8) :: val
    integer, pointer :: smdi(:) => null()
    integer(kind=4), pointer :: smhc(:) => null()
    real(kind=8), pointer :: valm(:) => null()
    real(kind=8), pointer :: valm2(:) => null()
    integer :: nnz_half, nbeq
    integer :: neq, nnz
    aster_logical :: stocke 
    integer(kind=4), parameter :: un = 1 
      !
      call jemarq()
      ! La matrice existe-t-elle ?
      call jeexin(matas//'.REFA', iret)
      ASSERT(iret > 0)
      ! Quelle est sa taille ?
      call dismoi('NB_EQUA', matas, 'MATR_ASSE', repi=nbeq)
      neq=nbeq
      ! Est-elle symétrique ?  
      call dismoi('TYPE_MATRICE', matas, 'MATR_ASSE', repk=syme)
      lsym = (syme == 'SYMETRI')
      ! On vérifie que le nombre de tableaux de valeurs est 
      ! cohérent avec la symétrie de la matrice 
      call jelira(matas//'.VALM', 'NMAXOC', nvalm)
      if (lsym) then 
         ASSERT( nvalm == 1 )
      elseif (.not.lsym) then 
         ASSERT ( nvalm == 2 ) 
      endif 
      !
      ! Vecteurs définissant le stockage de la matr_asse 
      call dismoi('NOM_NUME_DDL', matas, 'MATR_ASSE', repk=nonu)
      call jeveuo(nonu//'.SMOS.SMDI', 'L', vi=smdi)
      call jelira(nonu//'.SMOS.SMDI', 'LONMAX', nsmdi)
      call jeveuo(nonu//'.SMOS.SMHC', 'L', vi4=smhc)
      call jelira(nonu//'.SMOS.SMHC', 'LONMAX', nsmhc)
      neq = nsmdi
      ! Nombre de termes non-nuls dans la moitié supérieure de la 
      ! matr_asse
      nnz_half = smdi(neq)
      ! Nombre de termes non-nuls pour la matrice complète
      nnz = 2*nnz_half - neq
      ! Allocation de la matrice au format CSC 
      call create_csc_matrix(matrix_name, neq , neq ,nnz, aa)
      !  
      ! On remplit colptr 
      ! colptr(i) est l'indice
      ! dans rowind et values du premier terme de la ieme colonne 
      pstart = 1 
      do icol=1, neq
         pend = smdi(icol)
         do pp=pstart, pend
      ! on stocke le nombre de termes non-nuls de la colonne icol
      ! dans colptr(icol+1)
            aa%colptr(icol+1)=aa%colptr(icol+1)+un
      ! on compte aussi les termes symétriques par rapport à la 
      ! diagonale (en évitant le terme diagonal déjà compté 
      ! dans la partie supérieure)  
            irow = smhc(pp)
            if ( irow /= icol ) then 
              aa%colptr(irow+1)=aa%colptr(irow+1)+un
            endif 
         enddo 
         pstart = pend+1 
      enddo  
      ! On somme
      do icol = 2, neq+1
        aa%colptr(icol)=aa%colptr(icol-1)+ aa%colptr(icol)
      enddo
      !
      ! Remplissage de la structure csc (colptr, values et rowind)
      call jeveuo(jexnum(matas//'.VALM', 1), 'L', vr = valm)
      !   si la matrice n'est pas symetrique, on a aussi besoin des valeurs de
      !   la partie triangulaire inferieure
      if (.not.lsym) then 
        call jeveuo(jexnum(matas//'.VALM', 2), 'L', vr = valm2)
      endif 
      ! On parcourt la matrice aster deux fois
      ! 1 - copie des termes de la 1/2 matrice supérieure
      ! 2 - on complète par symétrie 
      ! colptr(icol) contient l'indice où stocker le 
      ! le prochain terme de la colonne icol dans 
      ! la matrice CSC
      do pass=1,2
        pstart = 1 
        do icol= 1, neq 
         pend = smdi(icol)
         do pp = pstart, pend
           ! Lecture de la matrice aster du terme 
           ! (irow, icol)
           irow=smhc(pp)
           ! Si la matrice n'est pas symétrique, les
           ! valeurs de la partie "L", lues à la 
           ! deuxième passe, sont stockées dans valm2
           if (( pass == 2 ).and.(.not. lsym )) then
               val = valm2(pp) 
           else 
           ! dans tous les autres cas (pass=1 ou matrice 
           ! symétrique) on utilise les valeurs de valm
                val = valm(pp)
           endif 
           ! Stockage dans la matrice CSC
           ! du terme (irow_csc, icol_csc)
           if ( pass == 1 ) then 
             ! Première passe : stockage de la partie "U" 
             icol_csc = icol 
             irow_csc = irow 
             stocke = .true. 
           else if ( pass == 2 ) then
             ! Deuxième passe : stockage de la partie "L"
             ! en évitant le terme diagonal déjà 
             ! stocké à la première passe
             icol_csc = irow 
             irow_csc = icol  
             stocke = (  irow /= icol )
           endif 
           !
           if ( stocke ) then 
             aa%rowind( aa%colptr(icol_csc) ) = int(irow_csc, 4)
             aa%values( aa%colptr(icol_csc) ) = val
             aa%colptr(icol_csc)=aa%colptr(icol_csc)+un
           endif 
           ! 
         enddo
         pstart = pend +1 
        enddo 
      enddo 
      ! 
      ! Il reste à décaler aa%colptr
      do icol = neq + 1, 2, -1
         aa%colptr(icol) = aa%colptr(icol-1)
      enddo
      aa%colptr(1) = 1
      !
      call jedema()
      ! 
end subroutine matas2csc 
!
subroutine csc2dense( a_csc , a_dense )
   !
   type( csc_matrix ), intent(inout)          :: a_csc
   real(kind=8), dimension(:,:), allocatable  :: a_dense
   !
   integer :: pos,  ii,  jj, nnz_col, ierr 
   !
   call to_one_based_indexing( a_csc ) 
   pos = 0  
   allocate( a_dense ( a_csc%m, a_csc%n ), stat = ierr ) 
   a_dense(:,:) = 0.d0
   do jj = 1, a_csc%n
       nnz_col=a_csc%colptr(jj+1) - a_csc%colptr(jj) 
      do ii = 1, nnz_col
        pos = pos + 1 
        a_dense( a_csc%rowind( pos ), jj ) = a_csc%values( pos ) 
      enddo 
   enddo 
   !
end subroutine csc2dense 
!
!
! Convert to CSR storage ( values, ia, ja ) 
!
subroutine csc2csr( a, values, ia, ja ) 
!
! Dummy arguments 
 type(csc_matrix), intent(inout) :: a
 real(kind=8), dimension(:), allocatable :: values
 integer(kind=4), dimension(:), allocatable :: ia, ja 
 !
 integer :: ii,  k, ierr , jj
 integer(kind=4) :: next
 integer(kind=4), parameter :: un=1
 !
 allocate(values(a%nnz), stat = ierr )
 ASSERT( ierr == 0 ) 
 allocate(ia(a%m +1), stat = ierr )
 ASSERT( ierr == 0 )
 allocate(ja(a%nnz), stat = ierr)
 ASSERT( ierr == 0 )
 !
 call to_one_based_indexing( a ) 
!  Compute lengths of rows of A.
!
  ia(1:a%m+1) = 0

  do jj = 1, a%n
    do k = a%colptr(jj), a%colptr(jj+1)-1
      ii = a%rowind(k) + 1 
      ia(ii) = ia(ii) + un
    end do
  end do
!
!  Compute pointers from lengths.
!
  ia(1) = 1
  do ii = 1, a%m
    ia(ii+1) = ia(ii) + ia(ii+1)
  end do
!
!  Do the actual copying.
!
  do jj = 1, a%n
    do k = a%colptr(jj), a%colptr(jj+1)-1
      ii = a%rowind(k)
      next = ia(ii)
      values(next) = a%values(k)
      ja(next) = int(jj,4)
      ia(ii) = next + un
    end do
  end do
!
!  Reshift IAO and leave.
!
  do jj = a%m, 1, -1
    ia(jj+1) = ia(jj)
  end do
  ia(1) = un

end subroutine csc2csr
!
#ifdef  _HAVE_PETSC
! Conversion de a_csc (format CSC) en une matrice
! PETSc a_mat
! On utilise fonctionnellement une routine PETSc permettant
! de créer une matrice PETSc à partir de tableaux définissant une 
! matrice au format CSR 
! La routine retourne une matrice de type MATSEQ 
!
   subroutine csc2matseq( a_csc, a_mat )
   ! Dummy argument 
   type(csc_matrix), intent(inout) :: a_csc
   Mat, intent(out) :: a_mat 
   ! Local variables 
   Mat :: at_mat 
   PetscInt :: nrow, ncol 
   PetscInt, dimension(:), pointer :: rowptr_c, colind_c 
   integer :: jerr 
   PetscErrorCode :: ierr
! 
! La structure CSR de A^T est la structure CSC de A 
! Nombre de lignes de A^T = nombre de colonnes de A 
    nrow=to_petsc_int(a_csc%n)
! Nombre de colonnes de A^T = nombre de lignes de A 
    ncol=to_petsc_int(a_csc%m)
! Rowptr_c(i) = position (dans le tableau des valeurs et dans le 
! tableau des indices colonnes) du premier terme 
! de  la ligne i de A^T (en convention C)
! Colind_c(k) = indice colonne (convention C) du terme stocké dans 
! values(k)   
    allocate(rowptr_c(nrow+1), stat = jerr )  
    ASSERT( jerr ==  0) 
    allocate(colind_c(a_csc%nnz), stat = jerr )
    ASSERT( jerr ==  0)
! Utilisation de A (CSC) <=> A^T (CSR) et passage en convention C
    call to_zero_based_indexing( a_csc ) 
    rowptr_c => a_csc%colptr(:)
    colind_c => a_csc%rowind(:)
! 
    call MatCreateSeqAIJWithArrays(PETSC_COMM_SELF,nrow,ncol, &
     rowptr_c, colind_c, &
     a_csc%values, at_mat, ierr )
    ASSERT( ierr == 0 )
! 
    call MatTranspose(at_mat, MAT_INITIAL_MATRIX, a_mat, ierr )
    ASSERT(ierr==0)
    call MatDestroy( at_mat, ierr ) 
    ASSERT(ierr==0)
    nullify( rowptr_c )
    nullify( colind_c ) 
!
    end subroutine csc2matseq
!
! Cette routine convertit une matrice au format PETSc en une matrice au format CSR.
! Les tableaux ia, ja et val sont alloués par matseq2csr 
! 
    subroutine matseq2csr ( a_mat, nn, ia, ja, val ) 
      ! Dummy arguments 
      Mat, intent(in) :: a_mat
      PetscInt, intent(out)  :: nn
      PetscInt, dimension(:), pointer :: ia, ja 
      PetscScalar, dimension(:), pointer :: val 
      ! Local variables 
      PetscErrorCode :: ierr
      PetscInt :: ii, shift, pia(1), pja(1), mm, nnz 
      PetscScalar, dimension(:), pointer :: pval => null()
      PetscOffset :: iia , jja 
      PetscBool :: done
      PetscReal :: info(MAT_INFO_SIZE) 
      !
      call MatGetInfo( a_mat, MAT_GLOBAL_SUM, info, ierr ) 
      nnz = info( MAT_INFO_NZ_USED ) 
      call MatGetSize( a_mat, mm, nn, ierr )
      ASSERT( ierr == 0 ) 
      allocate( ia( mm + 1 ), stat = ierr  )
      ASSERT( ierr == 0 ) 
      allocate( ja (nnz), stat = ierr  )
      ASSERT( ierr == 0 ) 
      allocate( val (nnz), stat = ierr  )
      ASSERT( ierr == 0 )  
      shift = 1
      call MatGetRowIJ( a_mat, shift, PETSC_FALSE, PETSC_FALSE, mm, &
        pia, iia,  pja, jja, done, ierr )
      ASSERT( ierr == 0 )
      ASSERT( done .eqv. PETSC_TRUE)
      do ii = 1, nnz
           ja(ii) = pja(jja+ii)
      enddo
      do ii = 1, mm +1 
           ia(ii)=pia(iia+ii)
      enddo
      call MatRestoreRowIJ(  a_mat, shift, PETSC_FALSE, PETSC_TRUE, mm, &
        pia, iia, pja, jja, done, ierr )
      ASSERT( ierr == 0 ) 
      call MatSeqAijGetArrayF90( a_mat, pval, ierr )
      ASSERT( ierr == 0 ) 
      do ii = 1, nnz
         val(ii) = pval(ii)  
      enddo
      call MatSeqAijRestoreArrayF90( a_mat, pval, ierr ) 
      ASSERT( ierr == 0 ) 
      ! 
    end subroutine matseq2csr
!
#endif 

end module 
