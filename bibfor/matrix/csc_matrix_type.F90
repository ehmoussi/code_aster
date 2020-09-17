! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

module csc_matrix_type
!
use csc_store_type
use sort_module
!
implicit none
!
private
#include "asterf_petsc.h"
#include "asterc/asmpi_comm.h"
#include "asterc/r8prem.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
character(len=7), parameter, public :: zero_based="0-based", one_based="1-based"
!
integer(kind=4), parameter, private :: un = 1, zero =0
!
type, public :: csc_matrix
   ! Name of the matrix
   character(len=24) :: name
   ! Number of rows
   integer :: m=0
   ! Number of columns
   integer :: n=0
   ! Number of non-zero elements
   integer :: nnz=0
   ! rowind(i) is the row index of the ith non zero element
   integer(kind=4), dimension(:), pointer :: rowind=> null()
   ! colptr(i) is the starting index in rowind and values
   ! column i
   integer(kind=4), dimension(:), pointer :: colptr=> null()
   ! values(i) is the value of the ith non zero element
   real(kind=8), dimension(:), pointer ::  values  =>null()
   ! Type of indexing (Fortran/C)
   character(len=7) :: indexing = one_based
end type csc_matrix

!
public :: get_block_from_csc_matrix, print_csc_matrix, create_csc_matrix, free_csc_matrix
public :: transpose_csc_matrix, inverse_permutation, eye_csc_matrix
public :: concat_csc_matrix, hsplit_csc_matrix,  create_csc_matrix_from_csc_store
public :: permute_rows_of_csc_matrix, compress_csc_matrix, permute_cols_of_csc_matrix
public :: sort_rows_of_csc_matrix, copy_col_of_csc_matrix, copy_csc_matrix
public :: norm2_of_csc_matrix, check_csc_matrix, define_csc_matrix_from_array
public :: to_zero_based_indexing, to_one_based_indexing

!
contains
!
! The routine returns a fresh, unallocated  csc_matrix
!
subroutine new_csc_matrix(name, indexing, a  )
  character(len=*), intent(in) :: name
  character(len=*), intent(in) :: indexing
  type(csc_matrix), intent(out) :: a
!
  ASSERT( len(name) <= 24 )
  ASSERT( len(indexing) == 7 )
  ASSERT( (indexing == zero_based).or.(indexing == one_based) )
  a%name = name
  a%indexing = indexing
!
end subroutine new_csc_matrix
!
! The routine returns a fresh, allocated csc_ matrix
!
subroutine create_csc_matrix(name, m,n,nnz, a)
  ! Dummy arguments
  character(len=*), intent(in)    :: name
  integer, intent(in)             :: m,n,nnz
  type(csc_matrix), intent(inout) :: a
  ! Local variables
  integer :: ierr
  !
  call new_csc_matrix( name, one_based, a )
  a%m=m
  a%n=n
  a%nnz=nnz
  allocate( a%colptr(n+1), stat = ierr )
  ASSERT( ierr == 0 )
  if (nnz > 0 ) then
    allocate( a%rowind(nnz), stat = ierr )
    ASSERT( ierr == 0 )
    allocate( a%values(nnz), stat = ierr )
    ASSERT( ierr == 0 )
    a%rowind(:) = 0
    a%values(:) = 0.d0
  endif
  a%colptr(:) = 0
  a%colptr(1) = 1
  !
end subroutine create_csc_matrix
!
! The routine returns a fresh csc_matrix built from
! a csc_store
!
subroutine create_csc_matrix_from_csc_store(name, cs, m, a )
  !
  character(len=*), intent(in)  :: name
  integer, intent(in)           :: m
  type(csc_store), intent(in)   :: cs
  type(csc_matrix), intent(out) :: a
  !
  integer :: ii, jj, pos
  integer(kind=4) :: nnz
  !
  call create_csc_matrix(name, m, cs%ncol,cs%nnz, a)
  pos = 0
  do jj=1, a%n
    if (cs%pcol(jj)%nnz > 0 ) then
    do ii = 1, cs%pcol(jj)%nnz
    pos = pos +1
    a%values(pos) = cs%pcol(jj)%values(ii)
    a%rowind(pos) = cs%pcol(jj)%rowind(ii)
    enddo
    endif
    nnz=int(cs%pcol(jj)%nnz, kind=4)
    a%colptr(jj+1) = a%colptr(jj)+nnz
  enddo
  !
end subroutine create_csc_matrix_from_csc_store
 !
subroutine define_csc_matrix_from_array( name, indexing, mm, rowind, &
                                         colptr, values, a )
! Dummy arguments
    character(len=*), intent(in) :: name, indexing
    integer, intent(in)  :: mm
    integer(kind=4), dimension(:), pointer :: rowind , colptr
    real(kind=8), dimension(:), pointer :: values
    type(csc_matrix), intent(out) :: a
! Local variables
    integer ::  nnz , nn
!
    ASSERT( size( values ) == size( rowind ))
    ASSERT( size( colptr ) > 1  )
!
    call new_csc_matrix( name, indexing, a )
    nnz      = size( values )
    nn       = size( colptr ) - 1
    a%n      = nn
    a%m      = mm
    a%nnz    = nnz
    a%rowind => rowind
    a%colptr => colptr
    a%values => values
!
end subroutine define_csc_matrix_from_array
!
! The routine frees a csc_matrix
!
subroutine free_csc_matrix(a)
  type(csc_matrix), intent(inout) :: a
  !
  if ( a%nnz >  0 ) then
    deallocate( a%rowind, a%values )
  endif
  deallocate( a%colptr )
  !
end subroutine free_csc_matrix
!
! The routine allocates a fresh csc_matrix b
! and copies a on b
!
subroutine copy_csc_matrix( a, b,  name )
type(csc_matrix), intent(in) :: a
type(csc_matrix), intent(out) :: b
character(len=*), intent(in), optional :: name
!
character(len=24) :: bname
!
if (present(name)) then
  bname = name
else
  bname = a%name
endif
!
call create_csc_matrix(bname,  a%m, a%n, a%nnz, b)
!
b%indexing = a%indexing
b%rowind(:)=a%rowind(:)
b%colptr(:)=a%colptr(:)
b%values(:)=a%values(:)
!
end subroutine  copy_csc_matrix
!
subroutine to_one_based_indexing( a )
  !
  type(csc_matrix), intent(inout) :: a
  integer(kind=4), parameter :: un=1
  select case ( a%indexing )
  case (zero_based)
     a%rowind(:) = a%rowind(:)+ un
     a%colptr(:) = a%colptr(:)+ un
     a%indexing=one_based
  case(one_based)
     ! Nothing to do
  case default
      ASSERT( .false. )
  end select
end subroutine to_one_based_indexing
!
subroutine to_zero_based_indexing( a )
  !
  type(csc_matrix), intent(inout) :: a
   integer(kind=4), parameter :: un=1
  select case ( a%indexing )
  case (zero_based)
     ! Nothing to do
  case(one_based)
     a%rowind(:) = a%rowind(:)-un
     a%colptr(:) = a%colptr(:)-un
     a%indexing=zero_based
  case default
      ASSERT( .false. )
  end select
end subroutine to_zero_based_indexing
!
subroutine check_csc_matrix( a )
   type(csc_matrix), intent(in) :: a
   integer :: ii
   do ii=1, a%n
      ASSERT ( a%colptr(ii+1) - a%colptr(ii) >= 0 )
   enddo
end subroutine check_csc_matrix
!
subroutine print_csc_matrix( a )
!
    type(csc_matrix), intent(in) :: a
!
    integer :: pos,  ii,  jj, nnz_col, row, col
!

    print*, "************************************************"
    print*, "La matrice ", a%name, " a ", a%m, " ligne(s) et ",a%n, "colonne(s)."
    print*, "Elle contient ", a%nnz," terme(s) non-nul(s)."
    print*, " Convention de stockage = ", a%indexing
    pos=0
    do jj = 1, a%n
       nnz_col=a%colptr(jj+1) - a%colptr(jj)
       if ( nnz_col > 0 ) then
       print*, " Colonne ", jj, " nnz = ", nnz_col
             do ii = 1,  nnz_col
                pos=pos+1
                row = a%rowind(pos)
                col = jj
                print*, trim(a%name)//"[",row, ",",col,"]=", a%values(pos)
             enddo
       endif
    enddo
    print*, "************************************************"
!
end subroutine print_csc_matrix
!
! Horizontal split of A
! A => (A11) (square)
!      (A12)
! On entry, a may use 0- or 1- based indexing
! On exit a11 and a12 use 1-based indexing
!
subroutine hsplit_csc_matrix( a, a11, a12 )
! Dummy argument
  type(csc_matrix), intent(inout) :: a
  type(csc_matrix), intent(out) :: a11, a12
! Local variables
  integer :: nnz11, nnz12
  integer :: ii, jj, nnz_col
  integer :: passe, pos, pos11, pos12
!
! Rectangular tall matrix only
  ASSERT( a%m >= a%n )
!
! Use 1-based indexing
!
  call to_one_based_indexing( a )
!
  do passe = 1, 2
  nnz11=0
  nnz12=0
  pos11=1
  pos12=1
  do jj = 1, a%n
      if ( passe == 2 ) then
      a11%colptr(jj)=int(pos11,4)
      a12%colptr(jj)=int(pos12,4)
      endif
      pos=to_aster_int(a%colptr(jj))
      nnz_col=a%colptr(jj+1) - a%colptr(jj)
      do ii = 1,  nnz_col
         if ( a%rowind(pos) <= a%n ) then
             nnz11 = nnz11+1
             if ( passe == 2 ) then
               a11%rowind(pos11) = a%rowind(pos)
               a11%values(pos11) = a%values(pos)
               pos11=pos11+1
             endif
         else
             nnz12 = nnz12+1
             if ( passe == 2 ) then
               a12%rowind(pos12) = a%rowind(pos)-int(a%n,4)
               a12%values(pos12) = a%values(pos)
               pos12=pos12+1
             endif
         endif
         pos=pos+1
      enddo
  enddo
   if ( passe == 2 ) then
      a11%colptr(a%n+1)=int(pos11,4)
      a12%colptr(a%n+1)=int(pos12,4)
   endif
  ASSERT ( nnz11+nnz12 == a%nnz )
!
  if ( passe == 1 ) then
    call create_csc_matrix( adjustl(trim(a%name))//"1", a%n, a%n, nnz11, a11 )
    call create_csc_matrix( adjustl(trim(a%name))//"2", a%m-a%n, a%n, nnz12, a12 )
  endif
!
  enddo
  call check_csc_matrix( a11 )
  call check_csc_matrix( a12 )
!
end subroutine hsplit_csc_matrix
!
! This routine extracts a submatrix b_csc from a csc_matrix a_csc
! b_csc= a_csc(irow(:), icol(:))
! b_csc is  a b_nrow x b_ncol matrix
! with b_nrow = size(irow), b_ncol=size(icol)
!
subroutine get_block_from_csc_matrix( a_csc, irow, icol, b_csc, b_name )
! Dummy arguments
type(csc_matrix), intent(in)  :: a_csc
integer, dimension(:), intent(in) :: irow, icol
type(csc_matrix), intent(out) :: b_csc
character(len=*), intent(in) :: b_name
! Local variables
integer :: b_nrow, b_ncol, nnz
integer :: a_icol, b_icol
integer(kind=4) :: ii, jj
integer ::  pass
integer(kind=4), dimension(:), pointer :: colptr => null()
!
! Vérifications
b_nrow = size(irow)
b_ncol=size(icol)
ASSERT( b_nrow > 0 )
ASSERT( b_ncol > 0 )
ASSERT( maxval(irow) <= a_csc%m )
ASSERT( maxval(icol) <= a_csc%n )
!
! On utilise un tableau temporaire colptr
! car le tableau colptr de b_csc ne
! sera alloué qu'à la seconde passe
AS_ALLOCATE( vi4=colptr, size=b_ncol+1 )
colptr(:) = 0
colptr(1)=1
!
do pass = 1, 2
    nnz = 0
    do b_icol = 1, b_ncol
! Indice de la colonne courante dans la matrice a
        a_icol=icol(b_icol)
! On doit maintenant
! calculer l'intersection de irow(:) et de rowind(start:end)
! où start et end permettent de repérer la section correspondant
! à la colonne a_icol dans les tableaux rowind et values de a_csc
        ii = un
        jj = a_csc%colptr(a_icol)
        do while (( ii <= b_nrow ).and.( jj < a_csc%colptr(a_icol + 1) ))
           if ( irow(ii) < a_csc%rowind(jj) ) then
              ii = ii + un
           else if ( a_csc%rowind(jj) < irow(ii) ) then
              jj = jj + un
           else
! irow(ii) = rowind(jj) => c'est OK
              if ( pass == 1 ) then
                  colptr(b_icol+1)= colptr(b_icol+1)+ un
              else if ( pass == 2 ) then
                 b_csc%values(to_aster_int( b_csc%colptr(b_icol)))= a_csc%values(jj)
                 b_csc%rowind(to_aster_int(b_csc%colptr(b_icol)))= ii
                 b_csc%colptr(to_aster_int(b_icol))= &
                                        b_csc%colptr(to_aster_int(b_icol))+un
              endif
              nnz = nnz + un
              ii = ii + un
              jj = jj + un
           endif
        enddo
    enddo
    if ( pass == 1 ) then
        call create_csc_matrix(b_name, b_nrow,b_ncol,nnz, b_csc )
       ! On somme
      do b_icol = 2, b_ncol+un
        colptr(b_icol)=colptr(b_icol-un)+ colptr(b_icol)
      enddo
        b_csc%colptr(:) = colptr(:)
    endif
enddo
!
! Il reste à décaler bb%colptr
      do b_icol = b_ncol+ un, 2, -1
         b_csc%colptr(b_icol) = b_csc%colptr(b_icol-un)
      enddo
      b_csc%colptr(un) = un
! Free memory
AS_DEALLOCATE (vi4 = colptr)
!
call check_csc_matrix( b_csc )
!
end subroutine get_block_from_csc_matrix
!
! Compute transpose(A) from A
!
subroutine transpose_csc_matrix( a, at, name )
!
type(csc_matrix), intent(inout) :: a
type(csc_matrix), intent(out) :: at
character(len=*), intent(in), optional :: name
!
integer :: i,j,k
integer(kind=4) :: next
character(len=24) :: at_name
!
if (present(name)) then
   at_name=name
else
   at_name=adjustl(trim(a%name))//"^T"
endif
call create_csc_matrix(at_name, a%n, a%m, a%nnz, at )
!
! Use 1-based indexing
!
  call to_one_based_indexing( a )
!
!  Compute lengths of columns of A'.
!
  at%colptr(1:at%n+1) = 0
!
  do j = 1, a%n
    do k = a%colptr(j), a%colptr(j+1)-1
      i = a%rowind(k) + 1
      at%colptr(i) = at%colptr(i) + un
    end do
  end do
!
!  Compute pointers from lengths.
!
  at%colptr(1) = 1
  do j = 1, at%n
    at%colptr(j+1) = at%colptr(j) + at%colptr(j+1)
  end do
!
!  Do the actual copying.
!
  do j = 1, a%n
    do k = a%colptr(j), a%colptr(j+1)-1
      i = a%rowind(k)
      next = at%colptr(i)
      at%values(next) = a%values(k)
      at%rowind(next) = int(j,kind=4)
      at%colptr(i) = next + un
    end do
  end do
!
!  Reshift at%colptr and leave.
!
  do j = at%n, 1, -1
    at%colptr(j+1) = at%colptr(j)
  end do
  at%colptr(1) = un
  call check_csc_matrix( at )
!
end subroutine  transpose_csc_matrix
!
! v doit être alloué e
! En sortie v(:,jv) = a(,ja)
!
subroutine copy_col_of_csc_matrix( a, ja, v, jv, ldv  )
!  Dummy arguments
   type(csc_matrix), intent(inout) :: a
   integer, intent(in) :: ja, jv, ldv
   real(kind=8), dimension(:), intent(inout) :: v
!  Local variables
   integer :: pos
!
   ASSERT( size(v)>= a%m )
   v(1+ldv*(jv-1):ldv*jv)=0.d0
   do pos=a%colptr(ja), a%colptr(ja+1)-1
      v(a%rowind(pos) + ldv*(jv-1))=a%values(pos)
   enddo
!
end subroutine copy_col_of_csc_matrix
!
! returns eye(m) as a csc_matrix
function eye_csc_matrix( m ) result( eye )
!  Dummy arguments
   integer, intent(in) :: m
   type(csc_matrix) :: eye
!  Local variables
   integer :: i
!
   call create_csc_matrix("Identity", m, m, m, eye )
   eye%values(:) = 1.d0
   do i = 1, m
      eye%rowind(i) = int(i,kind=4)
      eye%colptr(i) = int(i,kind=4)
   enddo
   eye%colptr(m+1) = int(m+1, kind=4)
!
end function eye_csc_matrix
!
! create and returns c = (a)
!                        (b)
function concat_csc_matrix( a, b, name ) result( c )
!  Dummy arguments
   type(csc_matrix), intent(inout)        :: a, b
   character(len=*), intent(in), optional :: name
   type(csc_matrix )                      :: c
!  Local variables
   character(24) :: cname
   integer(kind=4) :: pos_a,pos_b,pos_c,j,k, nnz_a, nnz_b, ncol_c
   integer(kind=4) :: nrow_a
!
  ASSERT ( a%n == b%n )
   if (present(name)) then
      cname = name
   else
     cname=trim(a%name)//"_"//trim(b%name)
   endif
!
   call to_one_based_indexing( a )
   call to_one_based_indexing( b )
!
   call create_csc_matrix(cname, a%m+b%m, a%n, a%nnz+b%nnz, c )
!
   ncol_c = int(c%n, kind=4)
   nrow_a = int(a%m, kind=4)
   do j = un, ncol_c
      pos_a = a%colptr(j)
      pos_b = b%colptr(j)
      pos_c = c%colptr(j)
      nnz_a = a%colptr(j+un) - a%colptr(j)
      nnz_b = b%colptr(j+un) - b%colptr(j)
      do k = un,nnz_a
        c%values(pos_c+k-un) = a%values(pos_a+k-un)
        c%rowind(pos_c+k-un) = a%rowind(pos_a+k-un)
      enddo
      pos_c = pos_c+k-un
      do k = un,nnz_b
        c%values(pos_c+k-un) = b%values(pos_b+k-un)
        c%rowind(pos_c+k-un) = b%rowind(pos_b+k-un) + nrow_a
      enddo
      pos_c = pos_c+k-un
      c%colptr(j+un) = pos_c
   enddo
!
   call check_csc_matrix( c )
!
end function concat_csc_matrix
!
!
subroutine permute_rows_of_csc_matrix( perm, a )
!
 type(csc_matrix), intent(inout)  :: a
 integer(kind=4), dimension(:), intent(in) :: perm
 ! Check that perm and rowind have compatible sizes
 ASSERT (size(perm)== a%m)
 ASSERT( minval(perm) == un )
 call to_one_based_indexing( a )
 a%rowind(:) = perm(a%rowind(:))
 !
end subroutine permute_rows_of_csc_matrix
!
subroutine permute_cols_of_csc_matrix( perm, a_csc )
!
 type(csc_matrix), intent(inout)  :: a_csc
 integer(kind=4), dimension(:), intent(in) :: perm
!
  integer(kind=4), dimension(a_csc%n) :: length
  integer(kind=4) :: astart, bstart,jb,ja,ii, ncolb, nnzb
  type(csc_matrix) :: b_csc
!
  ASSERT( size(perm)== a_csc%n )
  ASSERT( minval(perm ) == 1 )
!
  ncolb=int(b_csc%n, 4 )
  nnzb = int(b_csc%nnz, 4)
!
 call copy_csc_matrix( a_csc, b_csc )
 call free_csc_matrix( a_csc )
 call create_csc_matrix( b_csc%name, b_csc%m, b_csc%n, b_csc%nnz, a_csc)
 !
 ! length(jj) = nombre de termes non-nuls dans la jjeme colonne de aperm
 length(:)=zero
 do jb=un, ncolb
    length(perm(jb))=b_csc%colptr(jb+1)-b_csc%colptr(jb)
 enddo
 !
 a_csc%colptr(un) = un
 do ja=un, int(a_csc%n,kind=4)
    a_csc%colptr(ja+1) = a_csc%colptr(ja) + length(ja)
 enddo
!
! Copie de values et rowind
! Boucle sur les colonnes de b
  do jb=un, ncolb
! la colonne jb de b devient la colonne ja = perm(jb) de a
     ja=perm(jb)
     astart=a_csc%colptr(ja)
     bstart=b_csc%colptr(jb)
     do ii = un, length(ja)
        a_csc%rowind(astart-un+ii)=b_csc%rowind(bstart-un+ii)
        a_csc%values(astart-un+ii)=b_csc%values(bstart-un+ii)
     enddo
  enddo
!
   call free_csc_matrix( b_csc )
   call check_csc_matrix( a_csc )
!
end subroutine permute_cols_of_csc_matrix

subroutine inverse_permutation( perm , perminv )
    integer(kind=4), dimension(:), intent(in)    :: perm
    integer(kind=4), dimension(:), intent(inout) :: perminv
!
    integer(kind=4) :: n, i
    ASSERT( minval( perm ) == un )
    n=int(size(perm), kind=4)
    ASSERT( n == size( perminv ) )
    perminv(:)=0
    do i=un,n
        perminv(perm(i)) = i
    enddo
!
end subroutine inverse_permutation

function norm2_of_csc_matrix( a )  result (norm)
   type(csc_matrix), intent(in)  :: a
   real(kind=8)                  :: norm
   !
   norm=0.d0
   if ( a%nnz > 0 ) then
    norm = sqrt( sum (a%values*a%values) )
   endif
   !
end function norm2_of_csc_matrix
!
! Remove zeros from csc_matrix A
!
subroutine compress_csc_matrix( a_csc )
    !
    type(csc_matrix), intent(inout) :: a_csc
    ! Local variables
    type(csc_matrix) :: b_csc
    integer :: icol, pp_a, pp_b
    integer:: nnz
    !
    nnz = count(abs(a_csc%values) <= r8prem() )
    if ( nnz  /= a_csc%nnz ) then
    !
    call copy_csc_matrix( a_csc, b_csc )
    call free_csc_matrix( a_csc )
    call create_csc_matrix( b_csc%name, b_csc%m, b_csc%n, nnz, a_csc)
    !
    pp_a=0
    do icol =  1, b_csc%n
       ASSERT( b_csc%colptr(icol+1)-b_csc%colptr(icol) >=0 )
       do pp_b=b_csc%colptr(icol), b_csc%colptr(icol+1) - 1
         if ( abs(b_csc%values(pp_b)) <= r8prem() ) then
               pp_a=pp_a+1
               ASSERT(pp_a <=nnz )
               a_csc%values(pp_a)=b_csc%values(pp_b)
               a_csc%rowind(pp_a)=b_csc%rowind(pp_b)
          endif
       enddo
       a_csc%colptr(icol+1)= int(pp_a, kind=4)+ un
    enddo
!
    call free_csc_matrix( b_csc )
    endif
end  subroutine compress_csc_matrix
!
! On veut que pour chaque colonne les indices lignes des termes
! soient triés par ordre croissant
!
subroutine sort_rows_of_csc_matrix( a_csc )
!   Dummy arguments
    type( csc_matrix ), intent(inout) :: a_csc
!   Local variables
    integer :: nrow_max , icol, istart, iend, ierr
    integer :: nrow_cur
    real(kind=8), dimension(:), pointer :: values => null()
    integer(kind=4), dimension(:), pointer :: rowind => null(), pv => null()
    integer(kind=4), dimension(:), allocatable, target :: ibuffer
!
    call to_one_based_indexing( a_csc )
!
    nrow_max = 0
    call check_csc_matrix( a_csc )
    do icol = 1, a_csc%n
      nrow_cur= to_aster_int(a_csc%colptr(icol+1)-a_csc%colptr(icol))
      nrow_max=max(nrow_max,nrow_cur )
    enddo
    if (nrow_max > 0 ) then
       allocate(ibuffer(nrow_max), stat = ierr )
       ASSERT( ierr == 0 )
    do icol = 1, a_csc%n
       istart=a_csc%colptr(icol)
       iend=a_csc%colptr(icol+1) - 1
       if (iend > istart) then
       pv=>ibuffer(1:iend-istart+1)
       rowind=> a_csc%rowind(istart:iend)
       call qsort_i4(rowind, pv)
       values=>a_csc%values(istart:iend)
       values=values(pv)
       endif
    enddo
    deallocate( ibuffer )
    endif
    call check_csc_matrix( a_csc )
!
end subroutine sort_rows_of_csc_matrix
    !
end module csc_matrix_type
