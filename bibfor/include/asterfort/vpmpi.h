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
interface
    subroutine vpmpi(option, eigsol, icom1, icom2, lcomod,&
                     mpicou, mpicow, nbvecg, nfreqg, rangl,&
                     omemax, omemin, vpinf, vpmax)
        integer, intent(in) :: option
        character(len=19), intent(in) :: eigsol
!!
        integer, intent(out) :: icom1
        integer, intent(out) :: icom2
        aster_logical , intent(inout) :: lcomod
        mpi_int , intent(inout) :: mpicou
        mpi_int , intent(inout) :: mpicow
        integer, intent(out) :: nbvecg
        integer, intent(out) :: nfreqg
        integer, intent(inout) :: rangl
        real(kind=8), intent(inout) :: omemax
        real(kind=8), intent(inout) :: omemin
        real(kind=8), intent(inout) :: vpinf
        real(kind=8), intent(inout) :: vpmax
    end subroutine vpmpi
end interface
