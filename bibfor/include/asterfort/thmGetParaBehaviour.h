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
    subroutine thmGetParaBehaviour(compor,&
                                   meca_ , thmc_, ther_, hydr_,&
                                   nvim_ , nvic_, nvit_, nvih_,&
                                   nume_meca_, nume_thmc_)
        character(len=16), intent(in) :: compor(*)
        character(len=16), optional, intent(out) :: meca_
        character(len=16), optional, intent(out) :: thmc_
        character(len=16), optional, intent(out) :: ther_
        character(len=16), optional, intent(out) :: hydr_
        integer, optional, intent(out) :: nvim_
        integer, optional, intent(out) :: nvit_
        integer, optional, intent(out) :: nvih_
        integer, optional, intent(out) :: nvic_
        integer, optional, intent(out) :: nume_meca_
        integer, optional, intent(out) :: nume_thmc_
    end subroutine thmGetParaBehaviour
end interface
