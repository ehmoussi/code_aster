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
#include "asterf_types.h"
!
interface
    subroutine comp_nbvari(rela_comp    , defo_comp , type_cpla    , kit_comp_ ,&
                           post_iter_   , mult_comp_   , libr_name_,&
                           subr_name_   , model_dim_, model_mfront_, nb_vari_  ,&
                           nb_vari_umat_, l_implex_ , &
                           nb_vari_comp_, nume_comp_)
        use NonLin_Datastructure_type
        character(len=16), intent(in) :: rela_comp
        character(len=16), intent(in) :: defo_comp
        character(len=16), intent(in) :: type_cpla
        character(len=16), optional, intent(in) :: kit_comp_(4)
        character(len=16), optional, intent(in) :: post_iter_
        character(len=16), optional, intent(in) :: mult_comp_
        character(len=255), optional, intent(in) :: libr_name_
        character(len=255), optional, intent(in) :: subr_name_
        integer, optional, intent(in) :: model_dim_
        character(len=16), optional, intent(in) :: model_mfront_
        integer, optional, intent(out) :: nb_vari_
        integer, optional, intent(in) :: nb_vari_umat_
        aster_logical, optional, intent(in) :: l_implex_
        integer, optional, intent(out) :: nb_vari_comp_(4)
        integer, optional, intent(out) :: nume_comp_(4)
    end subroutine comp_nbvari
end interface
