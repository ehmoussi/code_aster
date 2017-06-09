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

subroutine coefdg(compor, mat, dpida2)
!
!
!
    implicit none
#include "asterfort/rcvalb.h"
    character(len=16) :: compor
    integer :: mat
    real(kind=8) :: dpida2
!
! ---------------------------------------------------------------------
!     LOIS A GRADIENTS : COEFFICIENT DIAGONAL MATRICE GVNO
! ---------------------------------------------------------------------
!
! ---------------------------------------------------------------------
!
    real(kind=8) :: val(1)
    character(len=8) :: nom(2), fami, poum
    integer :: k2(5), kpg, spt
! ---------------------------------------------------------------------
    fami='FPG1'
    kpg=1
    spt=1
    poum='+'
!
    if (compor .eq. 'ENDO_CARRE') then
!
        nom(1) = 'E'
        nom(2) = 'NU'
        call rcvalb(fami, kpg, spt, poum, mat,&
                    ' ', 'ELAS', 0, ' ', [0.d0],&
                    1, nom(1), val(1), k2, 2)
!
        dpida2 = val(1)
!
    endif
!
end subroutine
