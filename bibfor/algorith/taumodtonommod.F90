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
subroutine taumodtonommod(Tmod, tau, F, Amod)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
    real(kind=8), dimension(6,3,3), intent(in) :: Tmod
    real(kind=8), dimension(6), intent(in) :: tau
    real(kind=8), dimension(3,3), intent(in) :: F
    real(kind=8), dimension(3,3,3,3), intent(out) :: Amod
!
! --------------------------------------------------------------------------------------------------
! conversion of Kirchoff modulus (for Tau) to the Nominal modulus (for PK1)
!
! In Tmod   : Kirchoff modulus
! In tau    : Kirshoff stress tensor
! In F      : gradient of the deformation
! Out Amod  : Nominal modulus
! --------------------------------------------------------------------------------------------------
!
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    real(kind=8), dimension(3,3) :: Taumat
    integer :: i, J, k, L, M, N
    real(kind = 8) :: sum, sum1
!
! - Il faut convertir C au bon format
! - Convert Tau to matrix form
    Taumat(1,1) = Tau(1)
    Taumat(2,2) = Tau(2)
    Taumat(3,3) = Tau(3)
!
    Taumat(1,2) = Tau(4) / rac2
    Taumat(2,1) = Taumat(1,2)
!
    Taumat(1,3) = Tau(5) / rac2
    Taumat(3,1) = Taumat(1,3)
!
    Taumat(2,3) = Tau(6) / rac2
    Taumat(3,2) = Taumat(2,3)
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
                            sum1 = sum1 + Tmod(M,N,L) * F(k,N)
                        end do
                        sum = sum + sum1 * F(i,M)
                    end do
!
                    if(i == k) then
                        sum = sum + Taumat(J,L)
                    end if
!
! Like A has minor symmetry Aijkl = Aklij, we could save CPU time
                    Amod(i,J,k,L) = sum
                    Amod(k,L,i,J) = sum
                end do
            end do
        end do
    end do
!
! A finir
    ASSERT(ASTER_FALSE)
!
end subroutine
