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
    subroutine comp_nbvari_std(rela_comp , defo_comp    , type_cpla , nb_vari,&
                               kit_comp_ , post_iter_   , mult_comp_,&
                               l_cristal_, l_implex_    , &
                               nume_comp_, nb_vari_rela_)
        character(len=16), intent(in) :: rela_comp
        character(len=16), intent(in) :: defo_comp
        character(len=16), intent(in) :: type_cpla
        integer, intent(out) :: nb_vari
        character(len=16), optional, intent(in) :: kit_comp_(4)
        character(len=16), optional, intent(in) :: post_iter_
        character(len=16), optional, intent(in) :: mult_comp_
        aster_logical, optional, intent(in) :: l_cristal_
        aster_logical, optional, intent(in) :: l_implex_
        integer, optional, intent(out) :: nb_vari_rela_
        integer, optional, intent(out) :: nume_comp_(4)
    end subroutine comp_nbvari_std
end interface
