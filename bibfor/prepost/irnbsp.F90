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
subroutine irnbsp(chaine, nbsp)
!
    implicit none
!
    character(len=8), intent(in) :: chaine
    integer, intent(out)         ::  nbsp
!
! ----------------------------------------------------------------------------
!  Read number of sous-point from a chaine
!  In chaine : string containing the number of sous-point
!  Out nbsp : number of sous point
! -----------------------------------------------------------------------------
!
    character(len=1), parameter :: chiffr(0:9) = ['0','1','2','3','4',&
                                                  '5','6','7','8','9']
    integer, parameter :: num(0:9) = [0,1,2,3,4,5,6,7,8,9]
    integer :: val(0:7), expo, ii, icara
!
    val(:) = 0
!
! -- Read number
!
    do icara = 1, 8
        do ii = 0, 9
            if(chaine(icara:icara) == chiffr(ii)) then
                val(8-icara) = num(ii)
                exit
            end if
        end do
    end do
!
! -- Convert to integer
!
    nbsp = 0
    expo = 1
    do ii = 0, 7
        nbsp = nbsp + val(ii) * expo
        expo = 10 * expo
    end do
!
end subroutine
