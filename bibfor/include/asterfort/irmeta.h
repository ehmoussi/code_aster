! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
    subroutine irmeta(ifi        , field_med    , meta_elno, field_loca, model    ,&
                      nb_cmp_sele, cmp_name_sele, partie   , numpt     , instan   ,&
                      nume_store , nbmaec       , limaec   , result    , cara_elem,&
                      codret)
        integer, intent(in) :: ifi
        character(len=64), intent(in) :: field_med
        character(len=19), intent(in) :: meta_elno
        character(len=8), intent(in) :: field_loca
        character(len=8), intent(in) :: model
        integer, intent(in) :: nb_cmp_sele
        character(len=*), intent(in) :: cmp_name_sele(*)
        character(len=*), intent(in) :: partie
        integer, intent(in) :: numpt
        real(kind=8), intent(in) :: instan
        integer, intent(in) :: nume_store
        integer, intent(in) :: nbmaec
        integer, intent(in) :: limaec(*)
        character(len=8), intent(in) :: result
        character(len=8), intent(in) :: cara_elem
        integer, intent(out) :: codret
    end subroutine irmeta
end interface
