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
    subroutine calcCalcTher(nb_option    , list_option   , &
                            list_load    , model         , mate        , cara_elem,&
                            time_curr    , time,&
                            temp_prev    , incr_temp     , compor_ther , temp_curr,&
                            ve_charther  , me_mtanther   , ve_dirichlet,&
                            ve_evolther_l, ve_evolther_nl, ve_resither ,&
                            nb_obje_maxi , obje_name     , obje_sdname , nb_obje)
        integer, intent(in) :: nb_option
        character(len=16), intent(in) :: list_option(:)
        character(len=19), intent(in) :: list_load
        character(len=24), intent(in) :: model, mate, cara_elem
        real(kind=8), intent(in) :: time_curr
        character(len=24), intent(in) :: time
        character(len=*), intent(in) :: temp_prev, incr_temp, temp_curr
        character(len=24), intent(in) :: compor_ther
        character(len=24), intent(in) :: ve_charther
        character(len=24), intent(inout) :: me_mtanther
        character(len=24), intent(in) :: ve_evolther_l, ve_evolther_nl
        character(len=*), intent(in) :: ve_dirichlet
        character(len=24), intent(inout) :: ve_resither
        integer, intent(in) :: nb_obje_maxi
        character(len=16), intent(inout) :: obje_name(nb_obje_maxi)
        character(len=24), intent(inout) :: obje_sdname(nb_obje_maxi)
        integer, intent(out) ::  nb_obje
    end subroutine calcCalcTher
end interface
