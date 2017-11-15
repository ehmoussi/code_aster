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
    subroutine cppt15_2(main  , maout , inc   , jcoor , jcnnpa, conloc,&
                      limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                      macsu , ind   , ind1)
        character(len=8), intent(in) :: main
        character(len=8), intent(in) :: maout
        integer, intent(in) :: inc
        integer, intent(in) :: jcoor
        integer, intent(in) :: jcnnpa
        character(len=24), intent(in) :: conloc
        character(len=24), intent(in) :: limane
        character(len=24), intent(in) :: nomnoe
        integer, intent(in) :: nbno
        integer, intent(in) :: jmacou
        integer, intent(in) :: jmacsu
        integer, intent(in) :: macou
        integer, intent(in) :: macsu
        integer, intent(out) :: ind
        integer, intent(out) :: ind1
    end subroutine cppt15_2
end interface
