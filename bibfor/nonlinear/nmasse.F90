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

subroutine nmasse(fami, kpg, ksp, poum, icodma,&
                  materi, inst, e, nu, deuxmu,&
                  troisk)
!
    implicit none
#include "asterfort/rcvalb.h"
    integer :: kpg, ksp, icodma
    real(kind=8) :: inst
    real(kind=8) :: e, nu, deuxmu, troisk
    character(len=*) :: materi, fami, poum
!      VISCO_PLASTICITE FLUAGE SOUS IRRADIATION
!      RECUPERATION DU PARAMETRE VARIABLE (TEMPS)
!      CARACTERISTIQUES ELASTIQUES: YOUNG, POISSON, ALPHA
!
! IN  ICODMA  : ADRESSE DU MATERIAU CODE
! IN  INST    : INSTANT CONSIDERE
! OUT E       : MODULE DE YOUNG
! OUT NU      : COEFFICIENT DE POISSON
! OUT ALPHA   : COEFFICIENT DE DILATATION
! OUT DEUXMU  : COEFFICIENT DE LAME 1
! OUT TROISK  : COEFFICIENT DE LAME 2
!
    character(len=8) :: nompar
    character(len=16) :: nomres(2)
    real(kind=8) :: valres(2), valpar
    integer :: icodre(2)
!
    nompar='INST'
    valpar=inst
! CARACTERISTIQUES: MODULE D'YOUNG, COEFFICIENT DE POISSON
    nomres(1)='E'
    nomres(2)='NU'
!
    call rcvalb(fami, kpg, ksp, poum, icodma,&
                materi, 'ELAS', 1, nompar, [valpar],&
                2, nomres, valres, icodre, 2)
!
    e = valres(1)
    nu = valres(2)
!
    deuxmu = e/(1.d0+nu)
    troisk = e/(1.d0-2.d0*nu)
!
!
end subroutine
