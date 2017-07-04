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
    subroutine getExternalStateVariable(rela_comp    , comp_code_py   ,&
                                        l_mfront_offi, l_mfront_proto ,&
                                        cptr_nbvarext, cptr_namevarext)
        aster_logical, intent(in) :: l_mfront_offi
        aster_logical, intent(in) :: l_mfront_proto
        character(len=16), intent(in) :: rela_comp
        character(len=16), intent(in) :: comp_code_py
        integer, intent(in) :: cptr_nbvarext
        integer, intent(in) :: cptr_namevarext
    end subroutine getExternalStateVariable
end interface
