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
    subroutine dfllpe(keywf    , i_fail        , event_type,&
                      vale_ref , nom_cham      , nom_cmp   , crit_cmp,&
                      pene_maxi, resi_glob_maxi)
        character(len=16), intent(in) :: keywf
        integer, intent(in) :: i_fail
        character(len=16), intent(in) :: event_type
        real(kind=8), intent(out) :: vale_ref
        character(len=16), intent(out) :: nom_cham
        character(len=16), intent(out) :: nom_cmp
        character(len=16), intent(out) :: crit_cmp
        real(kind=8), intent(out) :: pene_maxi
        real(kind=8), intent(out) :: resi_glob_maxi
    end subroutine dfllpe
end interface
