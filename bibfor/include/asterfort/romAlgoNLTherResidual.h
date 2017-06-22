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
    subroutine romAlgoNLTherResidual(ther_crit_i, ther_crit_r, vec2nd   , cnvabt, cnresi    ,&
                                     cn2mbr     , resi_rela  , resi_maxi, conver, ds_algorom)
        use ROM_Datastructure_type
        integer, intent(in) :: ther_crit_i(*)
        real(kind=8), intent(in) :: ther_crit_r(*)
        character(len=24), intent(in) :: vec2nd
        character(len=24), intent(in) :: cnvabt
        character(len=24), intent(in) :: cnresi
        character(len=24), intent(in) :: cn2mbr
        real(kind=8)     , intent(out):: resi_rela
        real(kind=8)     , intent(out):: resi_maxi
        aster_logical    , intent(out):: conver
        type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
    end subroutine romAlgoNLTherResidual
end interface
