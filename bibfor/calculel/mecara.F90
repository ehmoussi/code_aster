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

subroutine mecara(cara_elem, chcara)
!
    implicit none
#include "asterf_types.h"
!
!
    character(len=*), intent(in) :: cara_elem
    character(len=*), intent(inout) :: chcara(18)
!
! --------------------------------------------------------------------------------------------------
!
! Preparing <CARTE> field for elementary characteristics
!
! --------------------------------------------------------------------------------------------------
!
! In  cara_elem   : name of elementary characteristics (field)
! IO  chcara      : name of <CARTE> field for elementary characteristics
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ii
!
! --------------------------------------------------------------------------------------------------
!
    do ii = 1, 18
        chcara(ii) = ' '
    end do
!
    if (cara_elem(1:8) .ne. ' ') then
        chcara(1) = cara_elem(1:8)//'.CARORIEN'
        chcara(2) = cara_elem(1:8)//'.CARDISCK'
        chcara(3) = cara_elem(1:8)//'.CARDISCM'
        chcara(4) = cara_elem(1:8)//'.CARDISCA'
        chcara(5) = cara_elem(1:8)//'.CARGEOPO'
        chcara(6) = cara_elem(1:8)//'.CARGENPO'
        chcara(7) = cara_elem(1:8)//'.CARCOQUE'
        chcara(8) = cara_elem(1:8)//'.CARSECTI'
        chcara(9) = cara_elem(1:8)//'.CARARCPO'
        chcara(10)= cara_elem(1:8)//'.CARCABLE'
        chcara(11)= cara_elem(1:8)//'.CARGENBA'
        chcara(12)= cara_elem(1:8)//'.CARMASSI'
        chcara(13)= cara_elem(1:8)//'.CARPOUFL'
        chcara(14)= cara_elem(1:8)//'.CVENTCXF'
        chcara(15)= cara_elem(1:8)//'.CARDINFO'
        chcara(16)= cara_elem(1:8)//'.CANBSP'
        chcara(17)= cara_elem(1:8)//'.CAFIBR'
    endif
!
end subroutine
