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
    subroutine nmimre_dof(nume_dof , ds_conv  , vale_rela, vale_maxi     , vale_refe     ,&
                          vale_comp, vale_frot, vale_geom, ieq_rela      , ieq_maxi      ,&
                          ieq_refe , noddlm   , ieq_comp , name_node_frot, name_node_geom,vpene)
        use NonLin_Datastructure_type
        character(len=24), intent(in) :: nume_dof
        type(NL_DS_Conv), intent(inout) :: ds_conv
        integer, intent(in) :: ieq_rela
        integer, intent(in) :: ieq_maxi
        integer, intent(in) :: ieq_refe
        integer, intent(in) :: ieq_comp
        real(kind=8), intent(in) :: vale_rela
        real(kind=8), intent(in) :: vale_maxi
        real(kind=8), intent(in) :: vale_refe
        real(kind=8), intent(in) :: vale_comp
        real(kind=8), intent(in) :: vale_frot
        real(kind=8), intent(in) :: vale_geom
        real(kind=8), intent(in) :: vpene
        character(len=8), intent(in) :: noddlm
        character(len=16), intent(in) :: name_node_frot
        character(len=16), intent(in) :: name_node_geom
    end subroutine nmimre_dof
end interface
