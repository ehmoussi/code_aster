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
    subroutine evalPressure(l_func , l_time , time      ,&
                            nb_node, ndim   , ipg       ,&
                            jv_shap, jv_geom, jv_pres   ,&
                            pres   , cisa_  , geom_reac_)
        aster_logical, intent(in) :: l_func, l_time
        integer, intent(in) :: ndim, nb_node, ipg
        integer, intent(in) :: jv_geom, jv_shap, jv_pres
        real(kind=8), intent(in) :: time
        real(kind=8), intent(out) :: pres
        real(kind=8), optional, intent(out) :: cisa_
        real(kind=8), optional, intent(in) :: geom_reac_(*)
    end subroutine evalPressure
end interface
