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

subroutine rslpli(typ, mod, mater, hook, nmat,&
                  vin)
    implicit none
!       OPERATEUR DE RIGIDITE POUR COMPORTEMENT ELASTIQUE LINEAIRE
!       IN  TYP    :  TYPE OPERATEUR
!                     'ISOTROPE'
!                     'ORTHOTRO'
!                     'ANISOTRO'
!           MOD    :  MODELISATION
!           MATER  :  COEFFICIENTS MATERIAU ELASTIQUE
!       OUT HOOK   :  OPERATEUR RIGIDITE ELASTIQUE LINEAIRE
!       ----------------------------------------------------------------
!
#include "asterfort/lcopli.h"
#include "asterfort/lcprsm.h"
    integer :: nmat
!
    real(kind=8) :: un, rho, f, f0
    real(kind=8) :: hook(6, 6)
    real(kind=8) :: mater(nmat, 2), vin(*)
!
    parameter       ( un   = 1.d0   )
!
    character(len=8) :: mod, typ
!       ----------------------------------------------------------------
!
! --    CALCUL DE RHO
!
    f = vin(2)
    f0 = mater(3,2)
    rho = (un-f)/(un-f0)
!
    call lcopli(typ, mod, mater(1, 1), hook)
    call lcprsm(rho, hook, hook)
end subroutine
