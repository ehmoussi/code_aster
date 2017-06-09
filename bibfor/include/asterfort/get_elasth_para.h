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
    subroutine get_elasth_para(fami     , j_mater     , poum   , ipg       , ispg,&
                               elas_type, elas_keyword, materi_, temp_vale_, &
                               alpha    , alpha_l     , alpha_t, alpha_n,&
                               z_h_r_   , deps_ch_tref_)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: j_mater
        character(len=*), intent(in) :: poum
        integer, intent(in) :: ipg
        integer, intent(in) :: ispg
        integer, intent(in) :: elas_type
        character(len=16), intent(in) :: elas_keyword
        character(len=8), optional, intent(in) :: materi_
        real(kind=8), optional, intent(in) :: temp_vale_
        real(kind=8), optional, intent(out) :: alpha(2)
        real(kind=8), optional, intent(out) :: alpha_l
        real(kind=8), optional, intent(out) :: alpha_t
        real(kind=8), optional, intent(out) :: alpha_n
        real(kind=8), optional, intent(out) :: z_h_r_
        real(kind=8), optional, intent(out) :: deps_ch_tref_
    end subroutine get_elasth_para
end interface
