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

!
!
#include "asterf_types.h"
!
interface
    subroutine xinils(noma, maiaux, grille, ndim, meth,&
                      nfonf, nfong, geofis, a, b,&
                      r, noeud, cote, vect1, vect2,&
                      cnslt, cnsln)
        character(len=8) :: noma
        character(len=8) :: maiaux
        aster_logical :: grille
        integer :: ndim
        character(len=8) :: meth
        character(len=8) :: nfonf
        character(len=8) :: nfong
        character(len=16) :: geofis
        real(kind=8) :: a
        real(kind=8) :: b
        real(kind=8) :: r
        real(kind=8) :: noeud(3)
        character(len=8) :: cote
        real(kind=8) :: vect1(3)
        real(kind=8) :: vect2(3)
        character(len=19) :: cnslt
        character(len=19) :: cnsln
    end subroutine xinils
end interface
