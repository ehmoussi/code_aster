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

subroutine gdclco(e, tau)
!
!
    implicit none
    real(kind=8) :: e(6), tau(6)
! ----------------------------------------------------------------------
!       INTEGRATION DES LOIS EN GRANDES DEFORMATIONS CANO-LORENTZ
!   CALCUL DES CONTRAINTES A PARTIR DE LA DEFORMATION THERMO-ELASTIQUE
! ----------------------------------------------------------------------
! IN  E       DEFORMATION ELASTIQUE
! OUT TAU     CONTRAINTE DE KIRCHHOFF
! ----------------------------------------------------------------------
!  COMMON GRANDES DEFORMATIONS CANO-LORENTZ
!
    integer :: ind1(6), ind2(6)
    real(kind=8) :: kr(6), rac2, rc(6)
    real(kind=8) :: lambda, mu, deuxmu, unk, troisk, cother
    real(kind=8) :: jm, dj, jp, djdf(3, 3)
    real(kind=8) :: etr(6), dvetr(6), eqetr, tretr, detrdf(6, 3, 3)
    real(kind=8) :: dtaude(6, 6)
!
    common /gdclc/&
     &          ind1,ind2,kr,rac2,rc,&
     &          lambda,mu,deuxmu,unk,troisk,cother,&
     &          jm,dj,jp,djdf,&
     &          etr,dvetr,eqetr,tretr,detrdf,&
     &          dtaude
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
!
    integer :: ij
    real(kind=8) :: e2(6), tre
! ----------------------------------------------------------------------
!
!
!
!    CALCUL DE E.E
    e2(1) = e(1)*e(1) + e(4)*e(4)/2.d0 + e(5)*e(5)/2.d0
    e2(2) = e(4)*e(4)/2.d0 + e(2)*e(2) + e(6)*e(6)/2.d0
    e2(3) = e(5)*e(5)/2.d0 + e(6)*e(6)/2.d0 + e(3)*e(3)
    e2(4) = e(1)*e(4) + e(4)*e(2) + e(5)*e(6)/rac2
    e2(5) = e(1)*e(5) + e(4)*e(6)/rac2 + e(5)*e(3)
    e2(6) = e(4)*e(5)/rac2 + e(2)*e(6) + e(6)*e(3)
!
!    CALCUL DE TAU
    tre = e(1)+e(2)+e(3)
    do 10 ij = 1, 6
        tau(ij) = (lambda*tre+cother)*(2*e(ij) - kr(ij)) + deuxmu *(2*e2(ij) - e(ij))
10  end do
!
end subroutine
