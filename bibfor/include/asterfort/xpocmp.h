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
    subroutine xpocmp(elrefp, cns1, ima, n, jconx1,&
                      jconx2, ndim, nfh, nfe, ddlc,&
                      nbcmp, cmp, lmeca, pre1)
        integer :: nbcmp
        integer :: n
        character(len=8) :: elrefp
        character(len=19) :: cns1
        integer :: ima
        integer :: jconx1
        integer :: jconx2
        integer :: ndim
        integer :: nfh
        integer :: nfe
        integer :: ddlc
        integer :: cmp(*)
        aster_logical :: lmeca
        aster_logical :: pre1
    end subroutine xpocmp
end interface 
