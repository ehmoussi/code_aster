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
    subroutine romTableSave(tablResu  , nbMode   , v_gamma  ,&
                            numeStore_, timeCurr_, numeSnap_)
        use NonLin_Datastructure_type
        type(NL_DS_TableIO), intent(in) :: tablResu
        integer, intent(in) :: nbMode
        real(kind=8), pointer :: v_gamma(:)
        integer, optional, intent(in) :: numeStore_
        real(kind=8), optional, intent(in) :: timeCurr_
        integer, optional, intent(in) :: numeSnap_
    end subroutine romTableSave
end interface
