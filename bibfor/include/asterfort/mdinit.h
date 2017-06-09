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
#include "asterf_types.h"
!
interface
    subroutine mdinit(basemo, nbmode, nbnoli, depgen, vitgen,&
                      vint, ier, tinit, reprise, accgen,&
                      index)
        character(len=8) :: basemo
        integer :: nbmode
        integer :: nbnoli
        real(kind=8) :: depgen(*)
        real(kind=8) :: vitgen(*)
        real(kind=8), pointer :: vint(:)
        integer :: ier
        real(kind=8) :: tinit
        aster_logical, optional, intent(out) :: reprise
        real(kind=8), optional, intent(out) :: accgen(*)
        integer, optional, intent(out) :: index
    end subroutine mdinit
end interface
