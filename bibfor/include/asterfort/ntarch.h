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
    subroutine ntarch(numins, modele  , mate , carele      , para       ,&
                      sddisc, ds_inout, force, sdcrit_nonl_, ds_algorom_)
        use NonLin_Datastructure_type
        use Rom_Datastructure_type
        integer, intent(in) :: numins
        character(len=24), intent(in) :: modele
        character(len=24), intent(in) :: mate
        character(len=24), intent(in) :: carele
        real(kind=8), intent(in) :: para(*)
        character(len=19), intent(in) :: sddisc
        type(NL_DS_InOut), intent(in) :: ds_inout
        aster_logical, intent(inout) :: force
        character(len=19), optional, intent(in) :: sdcrit_nonl_
        type(ROM_DS_AlgoPara), optional, intent(in) :: ds_algorom_
    end subroutine ntarch
end interface
