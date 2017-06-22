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
    subroutine meta_vpta_coef(rela_comp, lgpg      , fami     , kpg      , j_mater  ,&
                              l_temp   , temp      , meta_type, nb_phasis, phas_prev,&
                              phas_curr, zcold_curr, young    , deuxmu   , coef     ,&
                              trans)
        character(len=16), intent(in) :: rela_comp
        integer, intent(in) :: lgpg 
        character(len=4), intent(in) :: fami
        integer, intent(in) :: kpg
        integer, intent(in) :: j_mater
        logical, intent(in) :: l_temp
        real(kind=8), intent(in) :: temp
        integer, intent(in) :: meta_type
        integer, intent(in) :: nb_phasis
        real(kind=8), intent(in) :: phas_prev(*)
        real(kind=8), intent(in) :: phas_curr(*)
        real(kind=8), intent(in) :: zcold_curr
        real(kind=8), intent(in) :: young
        real(kind=8), intent(in) :: deuxmu
        real(kind=8), intent(out) :: coef
        real(kind=8), intent(out) :: trans
    end subroutine meta_vpta_coef
end interface
