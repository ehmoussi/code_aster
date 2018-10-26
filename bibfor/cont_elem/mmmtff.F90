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
subroutine mmmtff(phase , l_pena_fric,&
                  ndim  , nbcps      , nnl   ,&
                  wpg   , ffl        , jacobi,&
                  tau1  , tau2       ,&
                  rese  , nrese      , lambda,&
                  coefaf, coefff,&
                  matrff)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/mmmmpb.h"
#include "asterfort/pmavec.h"
!
character(len=4), intent(in) :: phase
aster_logical, intent(in) :: l_pena_fric
integer, intent(in) :: ndim, nnl, nbcps
real(kind=8), intent(in) :: wpg, ffl(9), jacobi
real(kind=8), intent(in) :: tau1(3), tau2(3)
real(kind=8), intent(in) :: rese(3), nrese, lambda
real(kind=8), intent(in) :: coefaf, coefff
real(kind=8), intent(out) :: matrff(18, 18)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute matrix for DOF [friction x friction]
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : phase to compute
!                        'SANS' - No contact
!                        'ADHE' - Stick
!                        'GLIS' - Slip
! In  l_pena_fric      : flag for penalized friction
! In  ndim             : dimension of problem (2 or 3)
! In  nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! In  nbcps            : number of components by node for Lagrange multiplicators
! In  wpg              : weight for current Gauss point
! In  ffl              : shape function for Lagrange dof
! In  jacobi           : jacobian at integration point
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! In  rese             : Lagrange (semi) multiplier for friction
! In  nrese            : norm of Lagrange (semi) multiplier for friction
! In  lambda           : contact pressure
! In  coefaf           : coefficient for updated Lagrangian method (friction)
! In  coefff           : friction coefficient (Coulomb)
! Out matrff           : matrix for DOF [friction x friction]
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j, k, l, ii, jj, idim, nbcpf
    real(kind=8) :: tt(3, 3)
    real(kind=8) :: h1(3), h2(3), matprb(3, 3)
    real(kind=8) :: r(2, 2)
!
! --------------------------------------------------------------------------------------------------
!
    tt(:,:) = 0.d0
    r(:,:)  = 0.d0
    h1(:)   = 0.d0
    h2(:)   = 0.d0
    nbcpf = nbcps - 1
!
! - MATRICE DE CHANGEMENT DE REPERE [TT] = [T]t*[T]
!
    do k = 1, ndim
        tt(1,1) = tau1(k)*tau1(k) + tt(1,1)
        tt(1,2) = tau1(k)*tau2(k) + tt(1,2)
        tt(2,1) = tau2(k)*tau1(k) + tt(2,1)
        tt(2,2) = tau2(k)*tau2(k) + tt(2,2)
    end do
!
! - MATRICE DE PROJECTION SUR LA BOULE UNITE
!
    if (phase  .eq. 'GLIS') then
        call mmmmpb(rese, nrese, ndim, matprb)
    endif
!
! - CALCUL DES TERMES
!
    if (phase .eq. 'SANS') then
        do i = 1, nnl
            do j = 1, nnl
                do l = 1, nbcpf
                    do k = 1, nbcpf
                        ii = (ndim-1)*(i-1)+l
                        jj = (ndim-1)*(j-1)+k
                        matrff(ii,jj) = matrff(ii,jj)+&
                                        wpg*ffl(i)*ffl(j)*jacobi*tt(l,k)
                    end do
                end do
            end do
        end do
    else if (phase .eq. 'GLIS') then
        call pmavec('ZERO', 3, matprb, tau1, h1)
        call pmavec('ZERO', 3, matprb, tau2, h2)
! ----- MATRICE [R] = [T]t*[T]-[T]t*[H]
        do idim = 1, ndim
            r(1,1) = (tau1(idim)-h1(idim))*tau1(idim) + r(1,1)
            r(1,2) = (tau2(idim)-h2(idim))*tau1(idim) + r(1,2)
            r(2,1) = (tau1(idim)-h1(idim))*tau2(idim) + r(2,1)
            r(2,2) = (tau2(idim)-h2(idim))*tau2(idim) + r(2,2)
        end do
        if (l_pena_fric) then
            do i = 1, nnl
                do j = 1, nnl
                    do l = 1, nbcpf
                        do k = 1, nbcpf
                            ii = (ndim-1)*(i-1)+l
                            jj = (ndim-1)*(j-1)+k
                            matrff(ii,jj) = matrff(ii,jj)+&
                                            wpg*ffl(i)*ffl(j)*jacobi*tt(l,k)*coefff*lambda/coefaf
                        end do
                    end do
                end do
            end do
        else
            do i = 1, nnl
                do j = 1, nnl
                    do l = 1, nbcpf
                        do k = 1, nbcpf
                            ii = (ndim-1)*(i-1)+l
                            jj = (ndim-1)*(j-1)+k
                            matrff(ii,jj) = matrff(ii,jj)+&
                                            wpg*ffl(i)*ffl(j)*jacobi*coefff*lambda*r(l,k)/coefaf
                        end do
                    end do
                end do
            end do
        endif
    else if (phase .eq. 'ADHE') then
        if (l_pena_fric) then
            do i = 1, nnl
                do j = 1, nnl
                    do l = 1, nbcpf
                        do k = 1, nbcpf
                            ii = (ndim-1)*(i-1)+l
                            jj = (ndim-1)*(j-1)+k
                            matrff(ii,jj) = matrff(ii,jj)+&
                                            wpg*ffl(i)*ffl(j)*jacobi*tt(l,k)*coefff*lambda/coefaf
                        end do
                    end do
                end do
            end do
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
