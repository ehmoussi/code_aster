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
    subroutine xprtor(method, noma, cnxinv, fispre,&
                      fiss, vcn, grlr, cnsln, grln,&
                      cnslt, grlt, tore, radtor, radimp,&
                      cnsdis, disfr, cnsbl, nodcal, elecal,&
                      liggrd, vcnt, grlrt)
        character(len=8) :: method
        character(len=8) :: noma
        character(len=19) :: cnxinv
        character(len=8) :: fispre
        character(len=8) :: fiss
        character(len=24) :: vcn
        character(len=24) :: grlr
        character(len=19) :: cnsln
        character(len=19) :: grln
        character(len=19) :: cnslt
        character(len=19) :: grlt
        aster_logical :: tore
        real(kind=8) :: radtor
        real(kind=8) :: radimp
        character(len=19) :: cnsdis
        character(len=19) :: disfr
        character(len=19) :: cnsbl
        character(len=19) :: nodcal
        character(len=19) :: elecal
        character(len=19) :: liggrd
        character(len=24) :: vcnt
        character(len=24) :: grlrt
    end subroutine xprtor
end interface
