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
interface
    subroutine vetnth(optioz, modelz, carelz, matcdz, instz,&
                      chtnz, compoz, tpchiz, tpchfz, chhyz,&
                      vecelz, veceiz, varc_curr, base_)
        character(len=*) :: optioz
        character(len=*) :: modelz
        character(len=*) :: carelz
        character(len=*) :: matcdz
        character(len=*) :: instz
        character(len=*) :: chtnz
        character(len=*) :: compoz
        character(len=*) :: tpchiz
        character(len=*) :: tpchfz
        character(len=*) :: chhyz
        character(len=*) :: vecelz
        character(len=*) :: veceiz
        character(len=19), intent(in) :: varc_curr
        character(len=1), optional, intent(in) :: base_
    end subroutine vetnth
end interface
