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
    subroutine nmcore(sdcrit        , sderro, list_func_acti, nume_inst, iter_newt,&
                      line_sear_iter, eta   , resi_norm     , load_norm, ds_conv )
        use NonLin_Datastructure_type
        character(len=19), intent(in) :: sdcrit
        character(len=24), intent(in) :: sderro
        integer, intent(in) :: list_func_acti(*)
        integer, intent(in) :: nume_inst
        integer, intent(in) :: iter_newt
        integer, intent(in) :: line_sear_iter
        real(kind=8), intent(in) :: eta
        real(kind=8), intent(in) :: resi_norm
        real(kind=8), intent(in) :: load_norm
        type(NL_DS_Conv), intent(inout) :: ds_conv
    end subroutine nmcore
end interface
