!  --------------------------------------------------------------------
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
! The sort_module contains routines for sorting an integer(kind=4) array,
! by different algorithms:
! - quicksort (the permutation vector is provided as an output of the routine)
! - insertion sort
!
! Reference: "Introduction to Algorithms", Thomas H. Cormen, Charles E. Leiserson,
!
! Ronald L. Rivest, The MIT Press, 1990
!
! Quicksort -> Chapter 8, p154
!
! person_in_charge: natacha.bereux at edf.fr
!

module sort_module
  !!!!!!!!!!!!!!!!!!!!!!!!
  !!!!!! QUICK SORT !!!!!!
  !!!!!!!!!!!!!!!!!!!!!!!!
  !
  !> EXAMPLE :
  !! en input  : A  = [| 31;17;49;8 |]
  !!
  !! A' = A; qsort( A', pv )
  !! en sortie : A' = [| 8;17;31;49 |]
  !!             pv = [| 4; 2; 1; 3 |]
  !! de sorte que : A( pv ) = A'
  !!
  !! Pour obtenir la permutation inverse :
  !! pv' = pv; qsort( pv', ipv )
  !!
  !! A'( ipv ) = A
  !!
  !! Sort in place an integer(kind=4) array by the Quicksort algorithm
  !
implicit none

private
#include "asterf_types.h"
#include "asterfort/assert.h"

public :: qsort, qsort_i4

integer(kind=4), parameter, private :: un = 1
integer(kind=8), parameter, private :: un8 = 1

contains

subroutine qsort(a,pv)
!  Generic function for the default integer size
!  Use `qsort_i4` to explicitly work on short integers
   integer, dimension(:), intent(inout) :: a
   integer, dimension(:), intent(inout), optional :: pv

#if ASTER_INT_SIZE == 4
   call qsort_i4(a, pv)
#else
   call qsort_i8(a, pv)
#endif

end subroutine qsort


subroutine qsort_i4(a,pv)
! Dummy arguments
   integer(kind=4), dimension(:), intent(inout) :: a
   integer(kind=4), dimension(:), intent(inout), optional     :: pv
   ! Local variables
   integer(kind=4) :: p, r, i
   !
   p = un
   r = int(size(a),4)
   !
   if (present(pv)) then
      ASSERT( size(pv) == size(a))
      do i = un, r
         pv(i) = i
      enddo
   endif
   ! Mix the array before sorting
   call mixer(a,r/10_4,pv)
   ! Call the recursive routine
   !
   if (present(pv)) then
      call rqsort(A,p,r,pv)
   else
      call rqsort(A,p,r)
   endif
   !
 end subroutine qsort_i4

! --- Privates functions
!
 recursive subroutine rqsort(A,p,r,pv)
   ! Dummy arguments
   integer(kind=4), dimension(:), intent(inout)           :: A
   integer(kind=4)                                        :: p,r,q
   integer(kind=4), dimension(:), intent(inout), optional :: pv
   !
   if (p < r) then
      if (present(pv)) then
         call partition(A, p, r, q, pv)
         call rqsort(A,p,q,pv)
         call rqsort(A,q+ un ,r,pv)
      else
         call partition(A, p, r, q)
         call rqsort(A,p,q)
         call rqsort(A,q+ un ,r)
      endif
   endif
   !
 end subroutine rqsort
 !
 !> Réorganise le tableau A de sorte que les valeurs inférieures à x
 !! soient dans la partie gauche de A et les valeurs supérieures dans la
 !! partie droite
 !
 subroutine partition(a,p,r,q,pv)
   ! Dummy arguments
   integer(kind=4), dimension(:), intent(inout)          :: a
   integer(kind=4), intent(in)                           :: p,r
   integer(kind=4), intent(out)                          :: q
   integer(kind=4), dimension(:),intent(inout), optional :: pv
   ! Local variables
   integer(kind=4) :: temp
   integer(kind=4) :: i,j
   ! pivot
   integer(kind=4) :: x
   !
   x = a(p)
   i = p- un
   j = r+ un
   !
   do
      do
         j = j-un
         if (a(j) <= x) exit
      enddo
      do
         i = i+ un
         if (a(i) >= x) exit
      enddo
      if (i<j) then
         ! Echanger A(i) et A(j)
         temp = a(i)
         a(i) = a(j)
         a(j) = temp
         if (present(pv)) then
            temp = pv(i)
            pv(i) = pv(j)
            pv(j) = temp
         endif
      else
         q = j
         exit
      endif
   enddo
   !
 end subroutine partition
!
 !> The subroutine mixer mixes the integer(kind=4) array a by performing
 !! k random swaps.
 !
 subroutine mixer(a,k,pv)
   ! Dummy arguments
   integer(kind=4), dimension(:), intent(inout) :: a
   integer(kind=4), intent(in) :: k
   integer(kind=4),dimension(:), intent(inout), optional :: pv
   ! Local variables
   integer(kind=4) :: n, i
   integer(kind=4) :: p, q
   integer(kind=4) :: atmp, pvtmp
   real(kind=4), dimension(2)  :: harvest
   !
   n = int(size(a),4)
   ASSERT(( n > 0 ).and.( k<=n ) )
   ! Nothing is done if k=0
   if (k>0) then
      !
      do i = un , k
         ! Init seed
         ! harvest is a vector with 2 random numbers in [0,1]
         call random_number(harvest)
         ! Define p, q
         p = max(un,int(harvest(1)*real(n),kind=4))
         q = max(un,int(harvest(2)*real(n), kind=4))
         ! Swap a(p) and a(q)
         atmp = a(p)
         a(p) = a(q)
         a(q) = atmp
         ! Record the permutation
         if (present(pv)) then
            pvtmp = pv(p)
            pv(p) = pv(q)
            pv(q) = pvtmp
         endif
      enddo
   endif
   !
 end subroutine mixer
 !
subroutine qsort_i8(a,pv)
   ! Dummy arguments
   integer(kind=8), dimension(:), intent(inout) :: a
   integer(kind=8), dimension(:), intent(inout), optional     :: pv
   ! Local variables
   integer(kind=8) :: p, r, i
   !
   p = un8
   r = int(size(a),8)
   !
   if (present(pv)) then
      ASSERT( size(pv) == size(a))
      do i = un8, r
         pv(i) = i
      enddo
   endif
   ! Mix the array before sorting
   call mixer_i8(a,r/10,pv)
   ! Call the recursive routine
   !
   if (present(pv)) then
      call rqsort_i8(A,p,r,pv)
   else
      call rqsort_i8(A,p,r)
   endif
   !
 end subroutine qsort_i8
 !
 recursive subroutine rqsort_i8(A,p,r,pv)
   ! Dummy arguments
   integer(kind=8), dimension(:), intent(inout)           :: A
   integer(kind=8)                                        :: p,r,q
   integer(kind=8), dimension(:), intent(inout), optional :: pv
   !
   if (p < r) then
      if (present(pv)) then
         call partition_i8(A, p, r, q, pv)
         call rqsort_i8(A,p,q,pv)
         call rqsort_i8(A,q+ un ,r,pv)
      else
         call partition_i8(A, p, r, q)
         call rqsort_i8(A,p,q)
         call rqsort_i8(A,q+ un ,r)
      endif
   endif
   !
 end subroutine rqsort_i8
 !
 !> Réorganise le tableau A de sorte que les valeurs inférieures à x
 !! soient dans la partie gauche de A et les valeurs supérieures dans la
 !! partie droite
 !
 subroutine partition_i8(a,p,r,q,pv)
   ! Dummy arguments
   integer(kind=8), dimension(:), intent(inout)          :: a
   integer(kind=8), intent(in)                           :: p,r
   integer(kind=8), intent(out)                          :: q
   integer(kind=8), dimension(:),intent(inout), optional :: pv
   ! Local variables
   integer(kind=8) :: temp
   integer(kind=8) :: i,j
   ! pivot
   integer(kind=8) :: x
   !
   x = a(p)
   i = p- un8
   j = r+ un8
   !
   do
      do
         j = j-un8
         if (a(j) <= x) exit
      enddo
      do
         i = i+ un8
         if (a(i) >= x) exit
      enddo
      if (i<j) then
         ! Echanger A(i) et A(j)
         temp = a(i)
         a(i) = a(j)
         a(j) = temp
         if (present(pv)) then
            temp = pv(i)
            pv(i) = pv(j)
            pv(j) = temp
         endif
      else
         q = j
         exit
      endif
   enddo
   !
 end subroutine partition_i8
!
 !> The subroutine mixer mixes the integer(kind=8) array a by performing
 !! k random swaps.
 !
 subroutine mixer_i8(a,k,pv)
   ! Dummy arguments
   integer(kind=8), dimension(:), intent(inout) :: a
   integer(kind=8), intent(in) :: k
   integer(kind=8),dimension(:), intent(inout), optional :: pv
   ! Local variables
   integer(kind=8) :: n, i
   integer(kind=8) :: p, q
   integer(kind=8) :: atmp, pvtmp
   real(kind=8), dimension(2)  :: harvest
   !
   n = int(size(a),8)
   ASSERT(( n > 0 ).and.( k<=n ) )
   ! Nothing is done if k=0
   if (k>0) then
      !
      do i = un8 , k
         ! Init seed
         ! harvest is a vector with 2 random numbers in [0,1]
         call random_number(harvest)
         ! Define p, q
         p = max(un8,int(harvest(1)*real(n),kind=8))
         q = max(un8,int(harvest(2)*real(n), kind=8))
         ! Swap a(p) and a(q)
         atmp = a(p)
         a(p) = a(q)
         a(q) = atmp
         ! Record the permutation
         if (present(pv)) then
            pvtmp = pv(p)
            pv(p) = pv(q)
            pv(q) = pvtmp
         endif
      enddo
   endif
   !
 end subroutine mixer_i8
 !
end module sort_module
