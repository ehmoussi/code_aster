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
    subroutine xprvit(noma, fiss, ndim, nvit, nbeta,&
                      lcmin, cnsvt, cnsvn, vpoint, cnsbl,&
                      cnsdis, disfr, cnsbet, listp, damax,&
                      locdom, rdimp, rdtor, delta, ucnslt,&
                      ucnsln)
        character(len=8) :: noma
        character(len=8) :: fiss
        integer :: ndim
        character(len=24) :: nvit
        character(len=24) :: nbeta
        real(kind=8) :: lcmin
        character(len=19) :: cnsvt
        character(len=19) :: cnsvn
        character(len=19) :: vpoint
        character(len=19) :: cnsbl
        character(len=19) :: cnsdis
        character(len=19) :: disfr
        character(len=19) :: cnsbet
        character(len=19) :: listp
        real(kind=8) :: damax
        aster_logical :: locdom
        real(kind=8) :: rdimp
        real(kind=8) :: rdtor
        character(len=19) :: delta
        character(len=19) :: ucnslt
        character(len=19) :: ucnsln
    end subroutine xprvit
end interface
