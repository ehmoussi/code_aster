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
    subroutine nmchfi(ds_algopara, fonact    , sddisc, sddyna, numins,&
                      iterat     , ds_contact, lcfint, lcdiri, lcbudi,&
                      lcrigi     , option)
        use NonLin_Datastructure_type
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        integer :: fonact(*)
        character(len=19) :: sddisc
        character(len=19) :: sddyna
        integer :: numins
        integer :: iterat
        type(NL_DS_Contact), intent(in) :: ds_contact
        aster_logical :: lcfint
        aster_logical :: lcdiri
        aster_logical :: lcbudi
        aster_logical :: lcrigi
        character(len=16) :: option
    end subroutine nmchfi
end interface
