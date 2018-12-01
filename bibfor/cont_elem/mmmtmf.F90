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
subroutine mmmtmf(phase , l_pena_fric,&
                  ndim  , nnm        , nnl        , nbcps ,&
                  wpg   , jacobi     , ffm        , ffl   ,&
                  tau1  , tau2       , mprojt,&
                  rese  , nrese      , lambda     , coefff,&
                  matrmf)
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
integer, intent(in) :: ndim, nnm, nnl, nbcps
real(kind=8), intent(in) :: tau1(3), tau2(3), mprojt(3, 3)
real(kind=8), intent(in) :: wpg, ffl(9), ffm(9), jacobi
real(kind=8), intent(in) :: rese(3), nrese, lambda, coefff
real(kind=8), intent(out) :: matrmf(27, 18)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute matrix for DOF [master x friction]
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
! In  nnm              : number of master nodes
! In  nbcps            : number of components by node for Lagrange multiplicators
! In  wpg              : weight for current Gauss point
! In  jacobi           : jacobian at integration point
! In  ffm              : shape function for master nodes
! In  ffl              : shape function for Lagrange dof
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! In  mprojt           : matrix of tangent projection
! In  rese             : Lagrange (semi) multiplier for friction
! In  nrese            : norm of Lagrange (semi) multiplier for friction
! In  lambda           : contact pressure
! In  coefff           : friction coefficient (Coulomb)
! Out matrmf           : matrix for DOF [master x friction]
!
! --------------------------------------------------------------------------------------------------
!
    integer :: inof, inom, icmp, idim, i, j, k, ii, jj, nbcpf
    real(kind=8) :: a(2, 3), b(2, 3), h(3, 2), matprb(3, 3)
    real(kind=8) :: h1(3), h2(3)
!
! --------------------------------------------------------------------------------------------------
!
    a(:,:) = 0.d0
    b(:,:) = 0.d0
    h(:,:) = 0.d0
    h1(:)  = 0.d0
    h2(:)  = 0.d0
    nbcpf = nbcps - 1
!
! - MATRICE [A] = [T]t*[P]
!
    if (phase .eq. 'ADHE') then
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
    endif
!
! - MATRICE DE PROJECTION SUR LA BOULE UNITE
!
    if (phase .eq. 'GLIS') then
        call mmmmpb(rese, nrese, ndim, matprb)
    endif
!
! - VECTEUR PROJ. BOULE SUR TANGENTES: {H1} = [K].{T1}
!
    if (phase .eq. 'GLIS') then
        call pmavec('ZERO', 3, matprb, tau1, h1)
        call pmavec('ZERO', 3, matprb, tau2, h2)
! ----- MATRICE [H] = [{H1}{H2}]
        h(:,1) = h1(:)
        h(:,2) = h2(:)
! ----- MATRICE [B] = [Pt]*[H]t
        do icmp = 1, nbcpf
            do j = 1, ndim
                do k = 1, ndim
                    b(icmp,j) = h(k,icmp)*mprojt(k,j)+b(icmp,j)
                end do
            end do
        end do
    endif
!
! - CALCUL DES TERMES
!
    if (phase .eq. 'ADHE') then
        if (.not. l_pena_fric) then
            do inof = 1, nnl
                do inom = 1, nnm
                    do icmp = 1, nbcpf
                        do idim = 1, ndim
                            jj = nbcpf*(inof-1)+icmp
                            ii = ndim*(inom-1)+idim
                            matrmf(ii,jj) = matrmf(ii,jj)+&
                                            wpg*ffl(inof)*ffm(inom)*jacobi*&
                                            lambda*coefff*a(icmp,idim)
                        end do
                    end do
                end do
            end do
        endif
    else if (phase .eq. 'GLIS') then
        if (.not. l_pena_fric) then
            do inof = 1, nnl
                do inom = 1, nnm
                    do icmp = 1, nbcpf
                        do idim = 1, ndim
                            jj = nbcpf*(inof-1)+icmp
                            ii = ndim*(inom-1)+idim
                            matrmf(ii,jj) = matrmf(ii,jj)+&
                                            wpg*ffl(inof)*ffm(inom)*jacobi*&
                                            lambda*coefff*b(icmp,idim)
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
