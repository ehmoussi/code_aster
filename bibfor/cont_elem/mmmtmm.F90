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
subroutine mmmtmm(phase , l_pena_cont, l_pena_fric,&
                  ndim  , nnm        ,&
                  mprojn, mprojt     ,&
                  wpg   , ffm        , jacobi     ,&
                  coefac, coefaf     , coefff     , lambda,&
                  rese  , nrese      ,&
                  matrmm)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/mmmmpb.h"
#include "asterfort/pmat.h"
#include "asterfort/pmavec.h"
!
character(len=4), intent(in) :: phase
aster_logical, intent(in) :: l_pena_cont, l_pena_fric
integer, intent(in) :: ndim, nnm
real(kind=8), intent(in) :: mprojn(3, 3), mprojt(3, 3)
real(kind=8), intent(in) :: wpg, ffm(9), jacobi
real(kind=8), intent(in) :: coefac, coefaf, coefff
real(kind=8), intent(in) :: rese(3), nrese, lambda
real(kind=8), intent(out) :: matrmm(27, 27)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute matrix for DOF [master x master]
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : phase to compute
!                        'SANS' - No contact
!                        'ADHE' - Stick
!                        'GLIS' - Slip
! In  l_pena_cont      : flag for penalized contact
! In  l_pena_fric      : flag for penalized friction
! In  ndim             : dimension of problem (2 or 3)
! In  nnm              : number of master nodes
! In  mprojn           : matrix of normal projection
! In  mprojt           : matrix of tangent projection
! In  wpg              : weight for current Gauss point
! In  ffm              : shape function for master nodes
! In  jacobi           : jacobian at integration point
! In  coefac           : coefficient for updated Lagrangian method (contact)
! In  coefaf           : coefficient for updated Lagrangian method (friction)
! In  coefff           : friction coefficient (Coulomb)
! In  lambda           : contact pressure
! In  rese             : Lagrange (semi) multiplier for friction
! In  nrese            : norm of Lagrange (semi) multiplier for friction
! Out matrmm           : matrix for DOF [master x master]
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j, k, l, ii, jj
    real(kind=8) :: g(3, 3), e(3, 3), d(3, 3), matprb(3, 3)
    real(kind=8) :: c1(3), c2(3), c3(3), d1(3), d2(3), d3(3)
!
! --------------------------------------------------------------------------------------------------
!
    e(:,:) = 0.d0
    d(:,:) = 0.d0
    g(:,:) = 0.d0
    d1(:)  = 0.d0
    d2(:)  = 0.d0
    d3(:)  = 0.d0
    c1(:)  = 0.d0
    c2(:)  = 0.d0
    c3(:)  = 0.d0
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
        if (l_pena_cont) then
            do i = 1, nnm
                do j = 1, nnm
                    do k = 1, ndim
                        do l = 1, ndim
                            ii = ndim*(i-1)+l
                            jj = ndim*(j-1)+k
                            matrmm(ii,jj) = matrmm(ii,jj) +&
                                            coefac*wpg*jacobi*ffm(i)*mprojn(l,k)*ffm(j)
                        end do
                    end do
                end do
            end do
        else
            do i = 1, nnm
                do j = 1, nnm
                    do k = 1, ndim
                        do l = 1, ndim
                            ii = ndim*(i-1)+l
                            jj = ndim*(j-1)+k
                            matrmm(ii,jj) = matrmm(ii,jj) +&
                                            coefac*wpg*jacobi*ffm(i)*mprojn(l,k)*ffm(j)
                        end do
                    end do
                end do
            end do
        endif
    endif

    if (phase .eq. 'ADHE') then
        if (l_pena_fric) then
            do i = 1, nnm
                do j = 1, nnm
                    do k = 1, ndim
                        do l = 1, ndim
                            ii = ndim*(i-1)+k
                            jj = ndim*(j-1)+l
                            matrmm(ii,jj) = matrmm(ii,jj) -&
                                            coefaf*coefff*lambda*wpg*jacobi*ffm(i)*e(k,l)*ffm(j)
                        end do
                    end do
                end do
            end do
        else
            do i = 1, nnm
                do j = 1, nnm
                    do k = 1, ndim
                        do l = 1, ndim
                            ii = ndim*(i-1)+k
                            jj = ndim*(j-1)+l
                            matrmm(ii,jj) = matrmm(ii,jj) -&
                                            coefaf*coefff*lambda*wpg*jacobi*ffm(i)*e(k,l)*ffm(j)
                        end do
                    end do
                end do
            end do
        endif
    endif

    if (phase .eq. 'GLIS') then
        if (l_pena_fric) then
            do i = 1, nnm
                do j = 1, nnm
                    do k = 1, ndim
                        do l = 1, ndim
                            ii = ndim*(i-1)+l
                            jj = ndim*(j-1)+k
                            matrmm(ii,jj) = matrmm(ii,jj) -&
                                            coefaf*coefff*lambda*wpg*jacobi*ffm(i)*d(l,k)*ffm(j)
                        end do
                    end do
                end do
            end do
        else
            do i = 1, nnm
                do j = 1, nnm
                    do k = 1, ndim
                        do l = 1, ndim
                            ii = ndim*(i-1)+l
                            jj = ndim*(j-1)+k
                            matrmm(ii,jj) = matrmm(ii,jj) -&
                                            coefaf*coefff*lambda*wpg*jacobi*ffm(i)*d(l,k)*ffm(j)
                        end do
                    end do
                end do
            end do
        endif
    endif
!
end subroutine
