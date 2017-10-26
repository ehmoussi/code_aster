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
    subroutine comp_mfront_vname(nb_vari   , &
                                 defo_comp , type_cpla  , post_iter   ,&
                                 libr_name , subr_name  , model_mfront, model_dim,&
                                 vari_begin, v_vari_name)
        integer, intent(in) :: nb_vari
        character(len=16), intent(in) :: defo_comp
        character(len=16), intent(in) :: type_cpla
        character(len=16), intent(in) :: post_iter
        character(len=255), intent(in) :: libr_name
        character(len=255), intent(in) :: subr_name
        character(len=16), intent(in) :: model_mfront
        integer, intent(in) :: model_dim
        integer, intent(in) :: vari_begin
        character(len=16), pointer, intent(in) :: v_vari_name(:)
    end subroutine comp_mfront_vname
end interface
