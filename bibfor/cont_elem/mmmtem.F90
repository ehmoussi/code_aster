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
subroutine mmmtem(phase ,&
                  ndim  , nne   ,nnm   ,&
                  mprojn, mprojt,wpg   , jacobi,&
                  ffe   , ffm   , &
                  coefac, coefaf,coefff, lambda,&
                  rese  , nrese,&
                  matrem)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/mmmmpb.h"
#include "asterfort/pmat.h"
#include "asterfort/pmavec.h"
!
character(len=4), intent(in) :: phase
integer, intent(in) :: ndim, nne, nnm
real(kind=8), intent(in) :: mprojn(3, 3), mprojt(3, 3)
real(kind=8), intent(in) :: wpg, jacobi
real(kind=8), intent(in) :: ffe(9), ffm(9)
real(kind=8), intent(in) :: coefac, coefaf, coefff, lambda
real(kind=8), intent(in) :: rese(3), nrese
real(kind=8), intent(out) :: matrem(27, 27)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute matrix for DOF [slave x master]
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : phase to compute
!                        'SANS' - No contact
!                        'ADHE' - Stick
!                        'GLIS' - Slip
! In  ndim             : dimension of problem (2 or 3)
! In  nnm              : number of master nodes
! In  nne              : number of slave nodes
! In  mprojn           : matrix of normal projection
! In  mprojt           : matrix of tangent projection
! In  wpg              : weight for current Gauss point
! In  jacobi           : jacobian at integration point
! In  ffe              : shape function for slave nodes
! In  ffm              : shape function for master nodes
! In  coefac           : coefficient for updated Lagrangian method (contact)
! In  coefaf           : coefficient for updated Lagrangian method (friction)
! In  coefff           : friction coefficient (Coulomb)
! In  lambda           : contact pressure
! In  rese             : Lagrange (semi) multiplier for friction
! In  nrese            : norm of Lagrange (semi) multiplier for friction
! Out matrem           : matrix for DOF [slave x master]
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j, k, l, ii, jj
    real(kind=8) :: g(3, 3), e(3, 3), d(3, 3), matprb(3, 3)
    real(kind=8) :: c1(3), c2(3), c3(3), d1(3), d2(3), d3(3)
!
! --------------------------------------------------------------------------------------------------
!
    d(:,:) = 0.d0
    e(:,:) = 0.d0
    g(:,:) = 0.d0
    c1(:)  = 0.d0
    c2(:)  = 0.d0
    c3(:)  = 0.d0
    d1(:)  = 0.d0
    d2(:)  = 0.d0
    d3(:)  = 0.d0
    c1(:)  = mprojt(:,1)
    c2(:)  = mprojt(:,2)
    c3(:)  = mprojt(:,3)
!
! - PRODUIT [E] = [Pt]x[Pt]
!
    call pmat(3, mprojt, mprojt, e)
!
! - MATRICE DE PROJECTION SUR LA BOULE UNITE
!
    if (phase .eq. 'GLIS') then
        call mmmmpb(rese, nrese, ndim, matprb)
    endif
!
! - VECTEUR PROJ. BOULE SUR PLAN TGT
!
    if (phase .eq. 'GLIS') then
        call pmavec('ZERO', 3, matprb, c1, d1)
        call pmavec('ZERO', 3, matprb, c2, d2)
        call pmavec('ZERO', 3, matprb, c3, d3)
! ----- MATRICE [G] = [{D1}{D2}{D3}]
        g(:,1) = d1(:)
        g(:,2) = d2(:)
        g(:,3) = d3(:)
! ----- MATRICE [D] = [Pt]*[G]t
        do i = 1, ndim
            do j = 1, ndim
                do k = 1, ndim
                    d(i,j) = g(k,i)*mprojt(k,j) + d(i,j)
                end do
            end do
        end do
    endif
!
! - CALCUL DES TERMES
!
    if (phase .ne. 'SANS') then
        do i = 1, nne
            do j = 1, nnm
                do k = 1, ndim
                    do l = 1, ndim
                        ii = ndim*(i-1)+l
                        jj = ndim*(j-1)+k
                        matrem(ii,jj) = matrem(ii,jj) -&
                                        coefac*wpg*jacobi*ffe(i)*mprojn(l,k)*ffm(j)
                    end do
                end do
            end do
        end do
    endif

    if (phase .eq. 'ADHE') then
        do i = 1, nne
            do j = 1, nnm
                do k = 1, ndim
                    do l = 1, ndim
                        ii = ndim*(i-1)+l
                        jj = ndim*(j-1)+k
                        matrem(ii,jj) = matrem(ii,jj) +&
                                        coefaf*coefff*lambda*wpg*jacobi*ffe(i)*e(k,l)*ffm(j)
                    end do
                end do
            end do
        end do
    endif

    if (phase .eq. 'GLIS') then
        do i = 1, nne
            do j = 1, nnm
                do k = 1, ndim
                    do l = 1, ndim
                        ii = ndim*(i-1)+l
                        jj = ndim*(j-1)+k
                        matrem(ii,jj) = matrem(ii,jj) +&
                                        coefaf*coefff*lambda*wpg*jacobi*ffe(i)*d(l,k)*ffm(j)
                    end do
                end do
            end do
        end do
    endif
!
end subroutine
