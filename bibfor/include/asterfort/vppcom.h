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
    subroutine vppcom(lcomod, icom1, icom2, resui, resur,&
                      resuk, nbpari, nbparr, nbpark, mxresf,&
                      vectr, nconv, neq, typres)
        aster_logical :: lcomod
        integer :: icom1
        integer :: icom2
        integer :: resui(*)
        real(kind=8) :: resur(*)
        character(len=*) :: resuk(*)
        integer :: nbpari
        integer :: nbparr
        integer :: nbpark
        integer :: mxresf
        real(kind=8) :: vectr(*)
        integer :: nconv
        integer :: neq
        character(len=16) :: typres
    end subroutine vppcom
end interface
