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
    subroutine aporth(mesh, sdcont_defi, model_ndim, elem_mast_indx, poin_coor,&
                      tau1, tau2)
        character(len=8), intent(in) :: mesh
        character(len=24), intent(in) :: sdcont_defi
        integer, intent(in) :: model_ndim
        integer, intent(in) :: elem_mast_indx
        real(kind=8), intent(in) :: poin_coor(3)
        real(kind=8), intent(inout) :: tau1(3)
        real(kind=8), intent(inout) :: tau2(3)
    end subroutine aporth
end interface
