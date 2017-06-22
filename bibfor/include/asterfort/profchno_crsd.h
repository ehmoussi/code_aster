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
interface
    subroutine profchno_crsd(prof_chnoz , base      , nb_equa     , meshz      , nb_ligrz,&
                             nb_ecz     , gran_namez, prno_lengthz, l_coll_const)
        character(len=*), intent(in) :: prof_chnoz
        character(len=1), intent(in) :: base
        integer, intent(in) :: nb_equa
        character(len=*), optional, intent(in) :: meshz
        character(len=*), optional, intent(in) :: gran_namez
        integer, optional, intent(in) :: nb_ecz
        integer, optional, intent(in) :: nb_ligrz
        integer, optional, intent(in) :: prno_lengthz
        logical, optional, intent(in) :: l_coll_const
    end subroutine profchno_crsd
end interface
