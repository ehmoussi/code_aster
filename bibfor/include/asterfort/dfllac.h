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
    subroutine dfllac(keywf          , i_fail       , dtmin     , event_type,&
                      action_type    ,&
                      subd_methode   , subd_pas_mini,&
                      subd_niveau    , subd_pas     ,&
                      subd_auto      , subd_inst    , subd_duree,&
                      pcent_iter_plus, coef_maxi    )
        character(len=16), intent(in) :: keywf
        integer, intent(in) :: i_fail
        real(kind=8), intent(in) :: dtmin
        character(len=16), intent(in) :: event_type
        character(len=16), intent(out) :: action_type
        character(len=16), intent(out) :: subd_methode
        real(kind=8), intent(out) :: subd_pas_mini
        integer, intent(out) :: subd_niveau
        integer, intent(out) :: subd_pas
        character(len=16), intent(out) :: subd_auto
        real(kind=8), intent(out) :: subd_inst
        real(kind=8), intent(out) :: subd_duree
        real(kind=8), intent(out) :: pcent_iter_plus
        real(kind=8), intent(out) :: coef_maxi
    end subroutine dfllac
end interface
