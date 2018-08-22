! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
    integer, pointer :: v_tbnp(:) => null()
    character(len=19) :: tabl_name
!
! --------------------------------------------------------------------------------------------------
!
    tabl_name = tabl_namez
    call jeveuo(tabl_name(1:19)//'.TBNP', 'E', vi=v_tbnp)
    v_tbnp(2) = 0
!
end subroutine
