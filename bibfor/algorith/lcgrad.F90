! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine lcgrad(resi, rigi, sig, apg, lag, grad, aldc,&
                  r, c, deps_sig,dphi_sig,deps_a,dphi_a, sief, dsde)
    implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
    aster_logical :: resi, rigi
    real(kind=8),intent(in) :: sig(:), apg, lag, grad(:), aldc, r, c
    real(kind=8),intent(in) :: deps_sig(:,:),dphi_sig(:),deps_a(:),dphi_a
    real(kind=8)            :: sief(*), dsde(:,:)
! ----------------------------------------------------------------------
!  GRAD_VARI : CALCUL DES TERMES COMMUNS AU LAGRANGIEN AUGMENTE
! ----------------------------------------------------------------------
! IN  RESI     .TRUE. SI CALCUL DES CONTRAINTES
! IN  RIGI     .TRUE. SI CALCUL DE LA RIGIDITE
! IN  SIG      CONTRAINTES MECANIQUES
! IN  APG      VARIABLE NON LOCALE NODALE INTERPOLEE AU POINT DE GAUSS
! IN  LAG      MULTIPLICATEUR DE LAGRANGE
! IN  GRAD     GRADIENT DE LA VARIABLE NON LOCALE
! IN  ALDC     VARIABLE NON LOCALE ISSUE DE LA LOI DE COMPORTEMENT
! IN  R        COEFFICIENT D'AUGMENTATION DU LAGRANGIEN AUGMENTE
! IN  C        COEFFICIENT DE PONDERATION DU TERME NON LOCAL
! IN  DEPS_SIG DSIGMA/DEPS
! IN  DPHI_SIG DSIGMA/DPHI
! IN  DEPS_A   DALDC/DEPS
! IN  DPHI_A   DALDC/DPHI
! OUT SIEF     CONTRAINTES GENERALISEES
! OUT DSDE     MATRICE TANGENTE GENERALISEE
! ----------------------------------------------------------------------
    integer :: i,neps,ndim,ndimsi
! ----------------------------------------------------------------------

! Initialisation
    ndim   = size(grad)
    ndimsi = 2*ndim
    neps   = 3*ndim + 2
    ASSERT(size(sig).eq.ndimsi)
    ASSERT(size(dsde,1).eq.neps)
    ASSERT(size(dsde,2).eq.neps)


! -- CALCUL DES CONTRAINTES GENERALISEES
    if (resi) then
        sief(1:ndimsi) = sig
        sief(ndimsi+1) = lag + r*(apg-aldc)
        sief(ndimsi+2) = apg-aldc
        sief(ndimsi+3:ndimsi+2+ndim) = c*grad
    endif


! -- CALCUL DE LA MATRICE TANGENTE GENERALISEE
    if (rigi) then
        dsde = 0.d0

        ! SIG - EPS
        dsde(1:ndimsi,1:ndimsi) = deps_sig

        ! SIG - A ET SIG - MU
        dsde(1:ndimsi,ndimsi+1) = dphi_sig*r
        dsde(1:ndimsi,ndimsi+2) = dphi_sig

        ! SIGA - EPS ET SIGMU - EPS
        dsde(ndimsi+1,1:ndimsi) = -deps_a*r
        dsde(ndimsi+2,1:ndimsi) = -deps_a

        ! SIGA - A
        dsde(ndimsi+1,ndimsi+1) = (1-r*dphi_a)*r

        ! SIGA - MU ET SIGMU - A
        dsde(ndimsi+1,ndimsi+2) = 1-r*dphi_a
        dsde(ndimsi+2,ndimsi+1) = 1-r*dphi_a

        ! SIGMU - MU
        dsde(ndimsi+2,ndimsi+2) = -dphi_a

        ! SIGG - GRAD
        do i = 1, ndim
            dsde(ndimsi+2+i,ndimsi+2+i) = c
        end do
    endif

end subroutine
