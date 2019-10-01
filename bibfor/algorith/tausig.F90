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

subroutine tausig(ndim,  jac, tau, sig, ind)
!
implicit none
!
    integer, intent(in) :: ndim, ind
    real(kind=8), intent(in) :: jac
    real(kind=8) :: tau(2*ndim), sig(2*ndim)
!
! ----------------------------------------------------------------------
!     SI IND=1
!     CALCUL DES CONTRAINTES DE CAUCHY, CONVERSION TAU -> CAUCHY
!     LES CONTRAINTES TAU EN ENTREE ONT DES RAC2
!     LES CONTRAINTES DE CAUCHY SIG EN SORTIE N'ONT PAS DE RAC2
!     SI IND=-1
!     CALCUL DES CONTRAINTES DE PIOLA-KIRCHHOFF-2 A PARTIR DE CAUCHY
!     LES CONTRAINTES DE CAUCHY SIG EN ENTREE N'ONT PAS DE RAC2
!     LES CONTRAINTES TAU EN SORTIE N'ONT PAS DE RAC2
! ----------------------------------------------------------------------
!
! IN  NDIM    : DIMENSION DE L'ESPACE
! IN  JAC     : DET DU GRADIENT TRANSFORMATION
! IN/OUT  TAU : CONTRAINTES DE KIRCHHOFF
! IN/OUT  SIG : CONTRAINTES DE CAUCHY
! IN  IND     : CHOIX
!
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
!
!
!   SEPARATION DIM 2 ET DIM 3 POUR GAGNER DU TEMPS CPU
    if (ind .eq. 1) then
        sig = tau / jac
!
        if (ndim .eq. 2) then
            sig(4) = sig(4) / rac2
        else if (ndim.eq.3) then
            sig(4:6) = sig(4:6) / rac2
        endif
!
    else if (ind.eq.-1) then
        tau = sig * jac
!
    endif
!
end subroutine
