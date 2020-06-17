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
interface
    subroutine vefnme(optionz, modelz    , mate , cara_elem,&
                      compor , partps    , nh   , ligrelz  ,&
                      varcz  , sigmz     , strxz,&
                      dispz  , disp_incrz,&
                      base   , vect_elemz)
        character(len=*), intent(in) :: optionz, modelz
        character(len=24), intent(in) :: cara_elem, mate
        character(len=19), intent(in) :: compor
        real(kind=8), intent(in) :: partps(*)
        integer, intent(in) :: nh
        character(len=*), intent(in) :: ligrelz
        character(len=*), intent(in) :: sigmz, varcz, strxz, dispz, disp_incrz
        character(len=1), intent(in) :: base
        character(len=*), intent(in) :: vect_elemz
    end subroutine vefnme
end interface
