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
    subroutine comp_read_exte(rela_comp   , kit_comp      ,&
                              l_umat      , l_mfront_proto, l_mfront_offi,&
                              libr_name   , subr_name     ,&
                              keywordfact_, i_comp_       , nb_vari_umat_)
        character(len=16), intent(in) :: rela_comp
        character(len=16), intent(in) :: kit_comp(4)
        aster_logical, intent(out) :: l_umat
        aster_logical, intent(out) :: l_mfront_proto
        aster_logical, intent(out) :: l_mfront_offi
        character(len=255), intent(out) :: libr_name
        character(len=255), intent(out) :: subr_name
        character(len=16), optional, intent(in) :: keywordfact_
        integer, optional, intent(in) :: i_comp_
        integer, optional, intent(out) :: nb_vari_umat_
    end subroutine comp_read_exte
end interface
