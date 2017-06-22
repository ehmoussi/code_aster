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
    subroutine nmobsz(sd_obsv  , tabl_name    , title         , field_type   , field_disc,&
                      type_extr, type_extr_cmp, type_extr_elem, type_sele_cmp, cmp_name  ,&
                      time     , valr,&
                      node_namez,&
                      elem_namez, poin_numez, spoi_numez)
        character(len=19), intent(in) :: sd_obsv
        character(len=19), intent(in) :: tabl_name
        character(len=4), intent(in) :: field_disc
        character(len=24), intent(in) :: field_type
        character(len=16), intent(in) :: title
        character(len=8), intent(in) :: type_extr
        character(len=8), intent(in) :: type_extr_cmp
        character(len=8), intent(in) :: type_extr_elem
        character(len=8), intent(in) :: type_sele_cmp
        character(len=16), intent(in) :: cmp_name
        real(kind=8), intent(in) :: time
        real(kind=8), intent(in) :: valr
        character(len=8), optional, intent(in) :: node_namez
        character(len=8), optional, intent(in) :: elem_namez
        integer, optional, intent(in) :: poin_numez
        integer, optional, intent(in) :: spoi_numez
    end subroutine nmobsz
end interface
