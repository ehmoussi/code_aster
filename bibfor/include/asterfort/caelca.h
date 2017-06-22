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
    subroutine caelca(modele, chmat, caelem, irana1, icabl,&
                      nbnoca, numaca, quad, regl, relax, &
                      ea, rh1000, prelax, fprg, frco, &
                      frli, sa)
        character(len=8) :: modele
        character(len=8) :: chmat
        character(len=8) :: caelem
        integer :: irana1
        integer :: icabl
        integer :: nbnoca(*)
        character(len=19) :: numaca
        aster_logical :: quad
        character(len=4) :: regl
        aster_logical :: relax
        real(kind=8) :: ea
        real(kind=8) :: rh1000
        real(kind=8) :: prelax
        real(kind=8) :: fprg
        real(kind=8) :: frco
        real(kind=8) :: frli
        real(kind=8) :: sa
    end subroutine caelca
end interface
