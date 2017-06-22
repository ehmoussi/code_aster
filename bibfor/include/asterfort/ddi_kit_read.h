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
    subroutine ddi_kit_read(keywordfact, iocc, rela_flua, rela_plas, rela_cpla, &
                            rela_coup  )
        character(len=16), intent(in) :: keywordfact
        integer, intent(in) :: iocc
        character(len=16), intent(out) :: rela_flua
        character(len=16), intent(out) :: rela_plas
        character(len=16), intent(out) :: rela_cpla
        character(len=16), intent(out) :: rela_coup
    end subroutine ddi_kit_read
end interface
