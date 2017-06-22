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
    subroutine nmcore_swap(sderro , nume_inst, load_norm, load_mini, last_resi_conv,&
                           ds_conv)
        use NonLin_Datastructure_type
        character(len=24), intent(in) :: sderro
        integer, intent(in) :: nume_inst
        real(kind=8), intent(in) :: load_norm
        real(kind=8), intent(in) :: load_mini
        real(kind=8), intent(in) :: last_resi_conv
        type(NL_DS_Conv), intent(inout) :: ds_conv
    end subroutine nmcore_swap
end interface
