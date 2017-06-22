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
    subroutine xcatls(ndim, geofis, callst, jltsv, jltsl,&
                      jlnsv, jlnsl, noma, vect1, vect2,&
                      noeud, a, b, r, cote)
        integer :: ndim
        character(len=16) :: geofis
        aster_logical :: callst
        integer :: jltsv
        integer :: jltsl
        integer :: jlnsv
        integer :: jlnsl
        character(len=8) :: noma
        real(kind=8) :: vect1(3)
        real(kind=8) :: vect2(3)
        real(kind=8) :: noeud(3)
        real(kind=8) :: a
        real(kind=8) :: b
        real(kind=8) :: r
        character(len=8) :: cote
    end subroutine xcatls
end interface
