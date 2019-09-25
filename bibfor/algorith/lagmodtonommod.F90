! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine lagmodtonommod(Cmod, PK2, F, Amod)
!
implicit none
!
#include "asterf_types.h"
!
    real(kind=8), dimension(3,3,3,3), intent(in) :: Cmod
    real(kind=8), dimension(6), intent(in) :: PK2
    real(kind=8), dimension(3,3), intent(in) :: F
    real(kind=8), dimension(3,3,3,3), intent(out) :: Amod
!
! --------------------------------------------------------------------------------------------------
! conversion of Lagrangian modulus (for PK2) to the Nominal modulus (for PK1)
!
! In Cmod   : Lagrangian modulus
! In PK2    : second Piola-Kirshoff stress tensor
! In F      : gradient of the deformation
! Out Amod  : Nominal modulus
! --------------------------------------------------------------------------------------------------
!
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    real(kind=8), dimension(3,3) :: PK2mat
    integer :: i, J, k, L, M, N
    real(kind = 8) :: sum, sum1
!
! - Il faut convertir C au bon format
! - Convert PK2 to matrix form
    PK2mat(1,1) = PK2(1)
    PK2mat(2,2) = PK2(2)
    PK2mat(3,3) = PK2(3)
!
    PK2mat(1,2) = PK2(4) / rac2
    PK2mat(2,1) = PK2mat(1,2)
!
    PK2mat(1,3) = PK2(5) / rac2
    PK2mat(3,1) = PK2mat(1,3)
!
    PK2mat(2,3) = PK2(6) / rac2
    PK2mat(3,2) = PK2mat(2,3)
!
! - Amod(i,J,k,L) = Cmod(M,J,N,L) * F(k,N) * F(i,M) + PK2(J,L) * delta(i,k)
!
    Amod = 0.d0
!
    do i = 1, 3
        do J = 1, 3
            do k = 1, 3
                do L = 1, 3
!
                    sum = 0.d0
                    do M = 1, 3
                        sum1 = 0.d0
                        do N = 1, 3
                            sum1 = sum1 + Cmod(M,J,N,L) * F(k,N)
                        end do
                        sum = sum + sum1 * F(i,M)
                    end do
!
                    if(i == k) then
                        sum = sum + PK2mat(J,L)
                    end if
!
! Like A has major symmetry Aijkl = Aklij, we could save CPU time
                    Amod(i,J,k,L) = sum
                    Amod(k,L,i,J) = sum
                end do
            end do
        end do
    end do
!
end subroutine
