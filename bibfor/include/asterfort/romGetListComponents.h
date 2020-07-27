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
#include "asterf_types.h"
!
interface
    subroutine romGetListComponents(fieldRefe  , fieldSupp  , nbEqua,&
                                    equaCmpName, listCmpName,&
                                    nbCmp      , lLagr)
        character(len=24), intent(in) :: fieldRefe
        character(len=4), intent(in) :: fieldSupp
        integer, intent(in) :: nbEqua
        integer, pointer :: equaCmpName(:)
        character(len=8), pointer :: listCmpName(:)
        integer, intent(out) :: nbCmp
        aster_logical, intent(out) :: lLagr
    end subroutine romGetListComponents
end interface
