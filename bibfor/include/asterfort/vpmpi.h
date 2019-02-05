! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
interface
    subroutine vpmpi(option, eigsol, icom1_, icom2_, lcomod_,&
                     mpicou_, mpicow_, nbvecg_, nfreqg_, rangl_,&
                     omemax_, omemin_, vpinf_, vpmax_)
        integer, intent(in) :: option
        character(len=19), optional, intent(in) :: eigsol
!!
        integer, optional, intent(out) :: icom1_
        integer, optional, intent(out) :: icom2_
        aster_logical, optional, intent(inout) :: lcomod_
        mpi_int, optional, intent(inout) :: mpicou_
        mpi_int, optional, intent(inout) :: mpicow_
        integer, optional, intent(out) :: nbvecg_
        integer, optional, intent(out) :: nfreqg_
        integer, optional, intent(inout) :: rangl_
        real(kind=8), optional, intent(inout) :: omemax_
        real(kind=8), optional, intent(inout) :: omemin_
        real(kind=8), optional, intent(inout) :: vpinf_
        real(kind=8), optional, intent(inout) :: vpmax_
    end subroutine vpmpi
end interface
