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

subroutine gdclel(fami, kpg, ksp, poum, imate,&
                  young, nu)
!
!
    implicit none
#include "asterfort/verift.h"
    real(kind=8) :: young, nu
    character(len=*) :: fami
    integer :: kpg, ksp, imate
    character(len=1) :: poum
!
! ----------------------------------------------------------------------
!        INTEGRATION DES LOIS EN GRANDES DEFORMATIONS CANO-LORENTZ
!           AFFECTATION DES CARACTERISTIQUES THERMO-ELASTIQUES
! ----------------------------------------------------------------------
!  COMMON GRANDES DEFORMATIONS CANO-LORENTZ
!
    integer :: ind1(6), ind2(6)
    real(kind=8) :: kr(6), rac2, rc(6)
    real(kind=8) :: lambda, mu, deuxmu, unk, troisk, cother
    real(kind=8) :: jm, dj, jp, djdf(3, 3), epsth
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
    lambda = young*nu/(1+nu)/(1-2*nu)
    deuxmu = young/(1+nu)
    mu = deuxmu/2
    troisk = young/(1-2*nu)
    unk = troisk/3
    call verift(fami, kpg, ksp, poum, imate,&
                epsth_=epsth)
    cother = troisk*epsth
!
end subroutine
