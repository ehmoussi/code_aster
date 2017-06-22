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
    subroutine sansno(sdcont , keywf    , mesh     , sans, psans,&
                      nb_keyw, keyw_type, keyw_name)
        character(len=8), intent(in) :: sdcont
        character(len=16), intent(in) :: keywf
        character(len=24), intent(in) :: sans
        character(len=24), intent(in) :: psans
        character(len=8), intent(in) :: mesh
        integer, intent(in) :: nb_keyw
        character(len=16), intent(in) :: keyw_type(nb_keyw)
        character(len=16), intent(in) :: keyw_name(nb_keyw)
    end subroutine sansno
end interface
