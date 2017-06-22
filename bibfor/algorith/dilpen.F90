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

subroutine dilpen(imate, rpena)
    implicit none
#include "asterfort/rcvalb.h"
    integer :: imate
    real(kind=8) :: rpena
! ======================================================================
! --- BUT : RECUPERATION DU COEFFICIENT DE PENALISATION ----------------
! ======================================================================
    real(kind=8) :: val(1)
    integer :: icodre(1), kpg, spt
    character(len=16) :: ncra
    character(len=8) :: fami, poum
! ======================================================================
! --- DEFINITION DES DONNEES INITIALES ---------------------------------
! ======================================================================
    data ncra  / 'PENA_LAGR' /
    fami='FPG1'
    kpg=1
    spt=1
    poum='+'
    val(1) = 0.0d0
    call rcvalb(fami, kpg, spt, poum, imate,&
                ' ', 'NON_LOCAL', 0, ' ', [0.0d0],&
                1, ncra, val, icodre, 0, nan='NON')
    rpena = val(1)
! ======================================================================
end subroutine
