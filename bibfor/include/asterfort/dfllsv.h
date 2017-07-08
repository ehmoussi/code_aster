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
! aslint: disable=W1504
!
interface
    subroutine dfllsv(v_sdlist_linfor, v_sdlist_eevenr, v_sdlist_eevenk, v_sdlist_esubdr,&
                      i_fail_save    ,&
                      event_typek    , vale_ref       , nom_cham        , nom_cmp       ,&
                      crit_cmp       , pene_maxi      , resi_glob_maxi  ,&
                      action_typek   , subd_methode   , subd_auto       , subd_pas_mini ,&
                      subd_pas       , subd_niveau    , pcent_iter_plus , coef_maxi     ,&
                      subd_inst      , subd_duree)
        real(kind=8), intent(in), pointer :: v_sdlist_linfor(:)
        real(kind=8), intent(in), pointer :: v_sdlist_eevenr(:)
        character(len=16), intent(in), pointer :: v_sdlist_eevenk(:)
        real(kind=8), intent(in), pointer :: v_sdlist_esubdr(:)
        integer, intent(in) :: i_fail_save
        character(len=16), intent(in) :: event_typek
        real(kind=8), intent(in) :: vale_ref
        character(len=16), intent(in) :: nom_cham
        character(len=16), intent(in) :: nom_cmp
        character(len=16), intent(in) :: crit_cmp
        real(kind=8), intent(in) :: pene_maxi
        real(kind=8), intent(in) :: resi_glob_maxi
        character(len=16), intent(in) :: action_typek
        character(len=16), intent(in) :: subd_methode
        real(kind=8), intent(in) :: subd_pas_mini
        integer, intent(in) :: subd_niveau
        integer, intent(in) :: subd_pas
        character(len=16), intent(in) :: subd_auto
        real(kind=8), intent(in) :: subd_inst
        real(kind=8), intent(in) :: subd_duree
        real(kind=8), intent(in) :: pcent_iter_plus
        real(kind=8), intent(in) :: coef_maxi
    end subroutine dfllsv
end interface
