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
    subroutine nmimrv(ds_print, list_func_acti, iter_newt, line_sear_coef, line_sear_iter,&
                      eta     , eref_rom)
        use NonLin_Datastructure_type
        type(NL_DS_Print), intent(inout) :: ds_print
        integer, intent(in) :: list_func_acti(*)
        integer, intent(in) :: iter_newt
        real(kind=8), intent(in) :: line_sear_coef
        integer, intent(in) :: line_sear_iter
        real(kind=8), intent(in) :: eta
        real(kind=8), intent(in) :: eref_rom
    end subroutine nmimrv
end interface
