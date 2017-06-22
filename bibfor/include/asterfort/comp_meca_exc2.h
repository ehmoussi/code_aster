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
#include "asterf_types.h"
!
interface
    subroutine comp_meca_exc2(l_cristal, l_prot_comp, l_pmf,&
                              l_excl   , vari_excl)
        aster_logical, intent(in) :: l_cristal
        aster_logical, intent(in) :: l_prot_comp
        aster_logical, intent(in) :: l_pmf
        aster_logical, intent(out) :: l_excl
        character(len=16), intent(out) :: vari_excl
    end subroutine comp_meca_exc2
end interface
