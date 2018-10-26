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
subroutine mmmvff(phase , l_pena_cont, l_pena_fric,&
                  ndim  , nnl        , nbcps      ,&
                  ffl   ,&
                  wpg   , jacobi     , djeu       , lambda,&
                  coefaf, coefff     , &
                  tau1  , tau2       , mprojt     , &
                  dlagrf, rese       , &
                  vectff)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/normev.h"
!
character(len=4), intent(in) :: phase
aster_logical, intent(in) :: l_pena_cont, l_pena_fric
integer, intent(in) :: ndim, nnl, nbcps
real(kind=8), intent(in) :: ffl(9)
real(kind=8), intent(in) :: wpg, jacobi, djeu(3),lambda
real(kind=8), intent(in) :: coefaf, coefff
real(kind=8), intent(in) :: tau1(3), tau2(3), mprojt(3, 3)
real(kind=8), intent(in) :: dlagrf(2), rese(3)
real(kind=8), intent(out) :: vectff(18)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute vector for DOF [friction]
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
! In  nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! In  nbcps            : number of components by node for Lagrange multiplicators
! In  ffl              : shape function for Lagrange dof
! In  wpg              : weight for current Gauss point
! In  jacobi           : jacobian at integration point
! In  djeu             : increment of gap
! In  lambda           : contact pressure
! In  coefff           : friction coefficient (Coulomb)
! In  coefaf           : coefficient for updated Lagrangian method (friction)
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! In  mprojt           : matrix of tangent projection
! In  dlagrf           : increment of friction Lagrange from beginning of time step
! In  rese             : Lagrange (semi) multiplier for friction
! Out vectff           : vector for DOF [friction]
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, k, l, ii, nbcpf
    real(kind=8) :: tt(2)
    real(kind=8) :: nrese, inter(2)
    real(kind=8) :: dvitet(3)
!
! --------------------------------------------------------------------------------------------------
!
    dvitet(:) = 0.0d0
    tt(:)     = 0.d0
    inter(:)  = 0.d0
    nbcpf     = nbcps-1
!
! - MATRICE DE CHANGEMENT DE REPERE DES LAGR. DE FROTTEMENT
!
    if (ndim .eq. 2) then
        do  k = 1, ndim
            tt(1) = tau1(k)*tau1(k) +tt(1)
        enddo
        tt(1) = dlagrf(1)*tt(1)
        tt(2) = 0.d0
    else if (ndim.eq.3) then
        do  k = 1, ndim
            tt(1) = (dlagrf(1)*tau1(k)+dlagrf(2)*tau2(k))*tau1(k)+tt( 1)
        enddo
        do  k = 1, ndim
            tt(2) = (dlagrf(1)*tau1(k)+dlagrf(2)*tau2(k))*tau2(k)+tt( 2)
        enddo
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Compute stick
!
    if (phase  .eq. 'ADHE') then
! ----- PROJECTION DU SAUT SUR LE PLAN TANGENT
        do  i = 1, ndim
            do  k = 1, ndim
                dvitet(i) = mprojt(i,k)*djeu(k)+dvitet(i)
            enddo
        enddo
        if (ndim .eq. 2) then
            do  i = 1, 2
                inter(1) = dvitet(i)*tau1(i)+inter(1)
            enddo
        else if (ndim .eq. 3) then
            do  i = 1, 3
                inter(1) = dvitet(i)*tau1(i)+inter(1)
                inter(2) = dvitet(i)*tau2(i)+inter(2)
            enddo
        endif
    endif
!
! - Compute slip
!
    if (phase .eq. 'GLIS') then
        call normev(rese, nrese)
        if (ndim .eq. 2) then
            do  i = 1, 2
                inter(1) = (dlagrf(1)*tau1(i)-rese(i))*tau1(i)+inter(1)
            enddo
        else if (ndim .eq. 3) then
            do  i = 1, 3
                inter(1) = (dlagrf(1)*tau1(i)+ dlagrf(2)*tau2(i)-rese(i))*tau1(i)+inter(1)
                inter(2) = (dlagrf(1)*tau1(i)+ dlagrf(2)*tau2(i)-rese(i))*tau2(i)+inter(2)
            enddo
        endif
    endif
!
! - CALCUL DU VECTEUR
!
    if (phase .eq. 'SANS') then
        if (l_pena_cont .or. l_pena_fric) then
            do i = 1, nnl
                do l = 1, nbcpf
                    ii = (i-1)*nbcpf+l
                    vectff(ii) = vectff(ii)-&
                                 wpg*ffl(i)*jacobi*tt(l)/coefaf
                enddo
            enddo
        else
            do i = 1, nnl
                do l = 1, nbcpf
                    ii = (i-1)*nbcpf+l
                    vectff(ii) = vectff(ii)+&
                                 wpg*ffl(i)*jacobi*tt(l)
                enddo
            enddo
        endif
    else if (phase.eq.'ADHE') then
        if (l_pena_fric) then
            do i = 1, nnl
                do l = 1, nbcpf
                    ii = (i-1)*nbcpf+l
                    vectff(ii) = vectff(ii)+&
                                 wpg*ffl(i)*jacobi*coefff*lambda*((tt(l)/coefaf)-inter(l))
                enddo
            enddo
        else
            do i = 1, nnl
                do l = 1, nbcpf
                    ii = (i-1)*nbcpf+l
                    vectff(ii) = vectff(ii)-&
                                 wpg*ffl(i)*jacobi*coefff*lambda*inter(l)
                enddo
            enddo
        endif
    else if (phase.eq.'GLIS') then
        if (l_pena_fric) then
            do i = 1, nnl
                do l = 1, nbcpf
                    ii = (i-1)*nbcpf+l
                    vectff(ii) = vectff(ii)+&
                                 wpg*ffl(i)*jacobi*coefff*lambda*inter(l)/coefaf
                enddo
            enddo
        else
            do i = 1, nnl
                do l = 1, nbcpf
                    ii = (i-1)*nbcpf+l
                    vectff(ii) = vectff(ii)+&
                                 wpg*ffl(i)*jacobi*coefff*lambda*inter(l)/coefaf
                enddo
            enddo
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
