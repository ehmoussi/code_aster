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
    subroutine char_affe_neum(mesh, ndim, keywordfact, iocc, nb_carte, &
                              carte, nb_cmp)
        character(len=8), intent(in)  :: mesh
        integer, intent(in)  :: ndim
        character(len=16), intent(in) :: keywordfact
        integer, intent(in) :: iocc
        integer, intent(in) :: nb_carte
        character(len=19), intent(in) :: carte(nb_carte)
        integer, intent(in) :: nb_cmp(nb_carte)
    end subroutine char_affe_neum
end interface
