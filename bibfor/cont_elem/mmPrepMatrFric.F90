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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine mmPrepMatrFric(ndim  , nbcps ,&
                          tau1  , tau2  , mprojt,&
                          rese  , nrese ,&
                          dlagrf, djeut ,&
                          e     , a     ,&
                          b     , d     ,&
                          r     , tt    ,&
                          dlagft, pdlaft,&
                          pdjeut, prese)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterfort/pmat.h"
#include "asterfort/mmmmpb.h"
#include "asterfort/pmavec.h"
!
integer, intent(in) :: ndim, nbcps
real(kind=8), intent(in) :: tau1(3), tau2(3), mprojt(3, 3)
real(kind=8), intent(in) :: rese(3), nrese
real(kind=8), intent(in) :: dlagrf(2), djeut(3)
real(kind=8), intent(out) :: e(3, 3), a(2, 3), b(2, 3)
real(kind=8), intent(out) :: d(3, 3), r(2, 2), tt(3, 3)
real(kind=8), intent(out) :: dlagft(3), pdlaft(3), pdjeut(3), prese(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Prepare quantities for friction
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : phase to compute
!                        'SANS' - No contact
!                        'ADHE' - Stick
!                        'GLIS' - Slip
!                        'NCON' - Friction but not contact (!)
! In  ndim             : dimension of problem (2 or 3)
! In  nbcps            : number of components by node for Lagrange multiplicators
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! => matrix [T] =[{tau1} {tau2}]
! In  mprojt           : matrix of tangent projection - [Pt]
! In  rese             : Lagrange (semi) multiplier for friction
! In  nrese            : norm of Lagrange (semi) multiplier for friction
! => matrix of projection on unit ball [K] = (Id-{rese}*<rese>/nrese^2)/nrese
! => matrix [HP] = [[K]{tau1} [K]{tau2}]
! In  djeut            : increment of tangent gaps
! In  dlagrf           : increment of friction Lagrange from beginning of time step
! Out e                : matrix [E] = [Pt]x[Pt]
! Out a                : matrix [A] = [T]t*[Pt]
! Out b                : matrix [B] = [Pt]*[HP]t with [HP]=[[K]{tau1} [K]{tau2}] and
! Out d                : matrix [D] = [Pt]*[GP]t with [GP]=[[K][Pt{:,1}] [K][Pt{:,2}] [K][Pt{:,3}]]
! Out r                : matrix [R] = [T]t*[T]-[T]t*[HP]
! Out tt               : matrix [TT] = [T]t*[T]
! Out dlagft           : projection of friction Lagrange on tangent plane
! Out pdlaft           : product of friction Lagrange by [Pt]
! Out pjeudt           : product of increment of displacement from beginning of step by [Pt]
! Out prese            : product of Lagrange (semi) multiplier by [Pt]
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbcpf
    integer :: i, j, k
    real(kind=8) :: matprb(3, 3), hp1(3), hp2(3), hp(3, 2)
    real(kind=8) :: c1(3), c2(3), c3(3), gp1(3), gp2(3), gp3(3), gp(3, 3)
!
! --------------------------------------------------------------------------------------------------
!
    nbcpf     = nbcps - 1
    e(:,:)    = 0.d0
    a(:,:)    = 0.d0
    b(:,:)    = 0.d0
    d(:,:)    = 0.d0
    r(:,:)    = 0.d0
    tt(:,:)   = 0.d0
    dlagft(:) = 0.d0
    pdlaft(:) = 0.d0
    pdjeut(:) = 0.d0
    prese(:)  = 0.d0
!
! - Matrix of projection on unit ball [K] = (Id-{rese}*<rese>/nrese^2)/nrese
!
    if (nrese .gt. r8prem()) then
        call mmmmpb(rese, nrese, ndim, matprb)
    endif
!
! - Matrix [E] = [Pt]x[Pt]
!
    call pmat(3, mprojt, mprojt, e)
!
! - Matrix [A] = [T]t*[Pt] with [T] = [{tau1} {tau2}]
!
    do i = 1, ndim
        do k = 1, ndim
            a(1,i) = tau1(k)*mprojt(k,i) + a(1,i)
        end do
    end do
    do i = 1, ndim
        do k = 1, ndim
            a(2,i) = tau2(k)*mprojt(k,i) + a(2,i)
        end do
    end do
!
! - Matrix [B] = [Pt]*[HP]t with [HP] = [[K]{tau1} [K]{tau2}]
!
    call pmavec('ZERO', 3, matprb, tau1, hp1)
    call pmavec('ZERO', 3, matprb, tau2, hp2)
! - MATRICE [HP] = [[K]{tau1} [K]{tau22}]
    hp(:,1) = hp1(:)
    hp(:,2) = hp2(:)
! - MATRICE [B] = [Pt]*[[K]{tau1} [K]{tau2}]t
    do i = 1, nbcpf
        do j = 1, ndim
            do k = 1, ndim
                b(i,j) = hp(k,i)*mprojt(k,j)+b(i,j)
            end do
        end do
    end do
!
! - Matrix [D] = [Pt]*[GP]t with [GP] = [[K][Pt{:,1}] [K][Pt{:,2}] [K][Pt{:,3}]]
!
    c1(:) = mprojt(:,1)
    c2(:) = mprojt(:,2)
    c3(:) = mprojt(:,3)
    call pmavec('ZERO', 3, matprb, c1, gp1)
    call pmavec('ZERO', 3, matprb, c2, gp2)
    call pmavec('ZERO', 3, matprb, c3, gp3)
! - MATRICE [GP] = [[K][Pt{:,1}] [K][Pt{:,2}] [K][Pt{:,3}]]
    gp(:,1) = gp1(:)
    gp(:,2) = gp2(:)
    gp(:,3) = gp3(:)
! - MATRICE [D] = [Pt]*[GP]t
    do i = 1, ndim
        do j = 1, ndim
            do k = 1, ndim
                d(i,j) = gp(k,i)*mprojt(k,j) + d(i,j)
            end do
        end do
    end do
!
! - Matrix [R] = [T]t*[T]-[T]t*[HP] with [T] = [{tau1} {tau2}]
!
    do i = 1, ndim
        r(1,1) = (tau1(i)-hp1(i))*tau1(i) + r(1,1)
        r(1,2) = (tau2(i)-hp2(i))*tau1(i) + r(1,2)
        r(2,1) = (tau1(i)-hp1(i))*tau2(i) + r(2,1)
        r(2,2) = (tau2(i)-hp2(i))*tau2(i) + r(2,2)
    end do
!
! - Matrix [TT] = [T]t*[T]
!
    do k = 1, ndim
        tt(1,1) = tau1(k)*tau1(k) + tt(1,1)
        tt(1,2) = tau1(k)*tau2(k) + tt(1,2)
        tt(2,1) = tau2(k)*tau1(k) + tt(2,1)
        tt(2,2) = tau2(k)*tau2(k) + tt(2,2)
    end do
!
! - Projection of friction Lagrange on tangent plane
!
    dlagft(:) = dlagrf(1)*tau1(:)+dlagrf(2)*tau2(:)
!
! - Product of friction Lagrange by [Pt]
!
    do i = 1, ndim
        do j = 1, ndim
            pdlaft(i) = mprojt(i,j)*dlagft(j)+pdlaft(i)
        end do
    end do
!
! - Product increment of displacement from beginning of step by [Pt]
!
    do i = 1, ndim
        do j = 1, ndim
            pdjeut(i) = mprojt(i,j)*djeut(j)+pdjeut(i)
        end do
    end do
!
! - Product Lagrange (semi) multiplier by [Pt]
!
    if (nrese .gt. r8prem()) then
        do i = 1, ndim
            do j = 1, ndim
                prese(i) = mprojt(i,j)*(rese(j)/nrese)+prese(i)
            end do
        end do
    endif
!
end subroutine
