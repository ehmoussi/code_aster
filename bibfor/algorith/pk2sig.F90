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

subroutine pk2sig(ndim, f, jac, pk2, sig,&
                  ind)
    implicit none
#include "asterfort/matinv.h"
!
! ----------------------------------------------------------------------
!     SI IND=1
!     CALCUL DES CONTRAINTES DE CAUCHY, CONVERSION PK2 -> CAUCHY
!     LES CONTRAINTES PK2 EN ENTREE ONT DES RAC2
!     LES CONTRAINTES DE CAUCHY SIG EN SORTIE N'ONT PAS DE RAC2
!     SI IND=-1
!     CALCUL DES CONTRAINTES DE PIOLA-KIRCHHOFF-2 A PARTIR DE CAUCHY
!     LES CONTRAINTES DE CAUCHY SIG EN ENTREE N'ONT PAS DE RAC2
!     LES CONTRAINTES PK2 EN SORTIE N'ONT PAS DE RAC2
! ----------------------------------------------------------------------
    integer, intent(in) :: ndim, ind
    real(kind=8), intent(in) :: f(3,3), jac
    real(kind=8), intent(inout) :: pk2(2*ndim), sig(2*ndim)
!
! IN  NDIM    : DIMENSION DE L'ESPACE
! IN  F       : GRADIENT TRANSFORMATION EN T+
! IN  JAC     : DET DU GRADIENT TRANSFORMATION EN T-
! IN/OUT  PK2 : CONTRAINTES DE PIOLA-KIRCHHOFF 2EME ESPECE
! IN/OUT  SIG : CONTRAINTES DE CAUCHY
! IN  IND     : CHOIX
!
    integer :: pq, kl
    real(kind=8) :: ftf, fmm(3, 3), r8bid
    integer, parameter ::  indi(6) = (/ 1 , 2 , 3 , 1, 1, 2 /)
    integer, parameter ::  indj(6) = (/ 1 , 2 , 3 , 2, 3, 3 /)
    real(kind=8), parameter :: rind(6) = (/ 0.5d0,0.5d0,0.5d0,0.70710678118655d0,&
                            &               0.70710678118655d0,0.70710678118655d0 /)
    real(kind=8), parameter :: rind1(6) = (/ 0.5d0 , 0.5d0 , 0.5d0 , 1.d0, 1.d0, 1.d0 /)
!


!
!     SEPARATION DIM 2 ET DIM 3 POUR GAGNER DU TEMPS CPU
    if (ind .eq. 1) then
        sig = 0.d0
!
        if (ndim .eq. 2) then
!
            do pq = 1, 4
                do  kl = 1, 4
                    ftf = (f(indi(pq), indi(kl))*f(indj(pq), indj(kl)) + &
                         & f(indi(pq),indj(kl))*f(indj(pq), indi(kl))) * rind(kl)
                    sig(pq) = sig(pq)+ ftf*pk2(kl)
                  end do
                sig(pq) = sig(pq)/jac
        end do
!
        else if (ndim.eq.3) then
!
            do pq = 1, 6
                do  kl = 1, 6
                    ftf = (f(indi(pq), indi(kl))*f(indj(pq), indj(kl))+&
                         & f(indi(pq), indj(kl))*f(indj(pq), indi(kl))) *rind(kl)
                    sig(pq) = sig(pq)+ ftf*pk2(kl)
                end do
                sig(pq) = sig(pq)/jac
            end do
!
        endif
!
    else if (ind.eq.-1) then
        pk2 = 0.d0
!
        call matinv('S', 3, f, fmm, r8bid)
!
        if (ndim .eq. 2) then
!
            do pq = 1, 4
                do kl = 1, 4
                    ftf=(fmm(indi(pq),indi(kl))*fmm(indj(pq),indj(kl))&
                     & + fmm(indi(pq),indj(kl))*fmm(indj(pq),indi(kl))) * rind1(kl)
                    pk2(pq) = pk2(pq)+ ftf*sig(kl)
                end do
                pk2(pq) = pk2(pq)*jac
            end do
!
        else if (ndim.eq.3) then
!
            do pq = 1, 6
                do kl = 1, 6
                    ftf=(fmm(indi(pq),indi(kl))*fmm(indj(pq),indj(kl))&
                    + fmm(indi(pq),indj(kl))*fmm(indj(pq),indi(kl))) * rind1(kl)
                    pk2(pq) = pk2(pq)+ ftf*sig(kl)
                end do
                pk2(pq) = pk2(pq)*jac
            end do
!
        endif
!
    endif
!
end subroutine
