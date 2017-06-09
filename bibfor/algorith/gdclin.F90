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

subroutine gdclin()
!
!
    implicit none
!
! ----------------------------------------------------------------------
!        INTEGRATION DES LOIS EN GRANDES DEFORMATIONS CANO-LORENTZ
!                            INITIALISATION
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
!
    rac2 = sqrt(2.d0)
!
!    AFFECTATION DU RACINE DE 2 EN REPRESENTATION VECTORIELLE
    rc(1) = 1.d0
    rc(2) = 1.d0
    rc(3) = 1.d0
    rc(4) = rac2
    rc(5) = rac2
    rc(6) = rac2
!
!    TENSEUR DU SECOND ORDRE IDENTITE (REPRESENTATION VECTORIELLE)
    kr(1) = 1.d0
    kr(2) = 1.d0
    kr(3) = 1.d0
    kr(4) = 0.d0
    kr(5) = 0.d0
    kr(6) = 0.d0
!
!    MANIPULATION DES INDICES : IJ -> I
    ind1(1) = 1
    ind1(2) = 2
    ind1(3) = 3
    ind1(4) = 2
    ind1(5) = 3
    ind1(6) = 3
!
!    MANIPULATION DES INDICES : IJ -> J
    ind2(1) = 1
    ind2(2) = 2
    ind2(3) = 3
    ind2(4) = 1
    ind2(5) = 1
    ind2(6) = 2
!
end subroutine
