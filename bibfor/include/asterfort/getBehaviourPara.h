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
    subroutine getBehaviourPara(l_mfront_offi , l_mfront_proto, l_kit_thm,&
                                keywf         , i_comp        , algo_inte,&
                                iter_inte_maxi, resi_inte_rela)
        aster_logical, intent(in) :: l_mfront_offi
        aster_logical, intent(in) :: l_mfront_proto
        aster_logical, intent(in) :: l_kit_thm
        character(len=16), intent(in) :: keywf
        integer, intent(in) :: i_comp
        character(len=16), intent(in) :: algo_inte
        real(kind=8), intent(out) :: iter_inte_maxi
        real(kind=8), intent(out) :: resi_inte_rela
    end subroutine getBehaviourPara
end interface
