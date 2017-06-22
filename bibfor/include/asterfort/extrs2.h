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
    subroutine extrs2(resu0, resu1, typcon, lrest, mailla,&
                      modele, cara, chmat, nbordr, nuordr, nbacc, nomacc,&
                      nbarch, nuarch, nbexcl, chexcl, nbnosy)
        character(len=*) :: resu0
        character(len=*) :: resu1
        character(len=16) :: typcon
        aster_logical :: lrest
        character(len=8), intent(in) :: mailla
        character(len=8), intent(in) :: modele
        character(len=8), intent(in) :: cara
        character(len=8), intent(in) :: chmat
        integer :: nbordr
        integer :: nuordr(*)
        integer :: nbacc
        character(len=16) :: nomacc(*)
        integer :: nbarch
        integer :: nuarch(*)
        integer :: nbexcl
        character(len=16) :: chexcl(*)
        integer :: nbnosy
    end subroutine extrs2
end interface
