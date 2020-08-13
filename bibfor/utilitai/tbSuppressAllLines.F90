! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine tbSuppressAllLines(tabl_namez)
!
implicit none
!
#include "asterfort/jeveuo.h"
#include "asterfort/jedetr.h"
!
character(len=*), intent(in) :: tabl_namez
!
! --------------------------------------------------------------------------------------------------
!
! Table
!
! Suppress all lines in table
!
! --------------------------------------------------------------------------------------------------
!
! In  tabl_name        : name of table
!
! --------------------------------------------------------------------------------------------------
!
    integer, pointer :: tbnp(:) => null()
    integer, pointer :: flag(:) => null()
    character(len=24), pointer :: tblp(:) => null()
    character(len=19) :: tablName
    integer :: nbLine, iPara, nbPara
    character(len=24) :: lineObje, lineFlag
!
! --------------------------------------------------------------------------------------------------
!
    tablName = tabl_namez
!
    call jeveuo(tablName(1:19)//'.TBNP', 'E', vi   = tbnp)
    call jeveuo(tablName(1:19)//'.TBLP', 'E', vk24 = tblp)
    nbPara = tbnp(1)
    nbLine = tbnp(2)
    do iPara = 1, nbPara
        lineObje = tblp(1+4*(iPara-1)+2)
        lineFlag = tblp(1+4*(iPara-1)+3)
        call jeveuo(lineFlag, 'E', vi = flag)
        flag(1:nbLine) = 0
    end do
    tbnp(2) = 0
!
end subroutine
