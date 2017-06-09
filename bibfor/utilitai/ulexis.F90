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

function ulexis(iul)
    implicit none
#include "asterf_types.h"
#include "asterfort/codent.h"
#include "asterfort/ulopen.h"
    aster_logical :: ulexis
    integer :: iul, i, unit
!     VERIFIE QUE L'UNITE LOGIQUE EST RATTACHE A UN FICHIER
!
!     ------------------------------------------------------------------
    integer :: mxf
    parameter       (mxf=100)
    character(len=1) :: typefi(mxf), accefi(mxf), etatfi(mxf), modifi(mxf)
    character(len=16) :: ddname(mxf)
    character(len=255) :: namefi(mxf)
    integer :: first, unitfi(mxf), nbfile
    common/ asgfi1 / first, unitfi      , nbfile
    common/ asgfi2 / namefi,ddname,typefi,accefi,etatfi,modifi
    aster_logical :: ficexi
    character(len=8) :: k8b
    character(len=255) :: namell
!     ------------------------------------------------------------------
!
    ulexis = .false.
!
    do 10 i = 1, nbfile
        unit = unitfi(i)
        if (unit .eq. iul) then
            ulexis = .true.
            goto 12
        endif
 10 end do
    call codent(iul, 'G', k8b)
    namell = 'fort.'//k8b
    inquire(file=namell,exist=ficexi)
    if (ficexi) then
        call ulopen(iul, ' ', ' ', 'A', 'O')
        ulexis = .true.
    endif
 12 continue
!
end function
