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
    subroutine nmevel(sddisc, nume_inst  , vale  , loop_name, lsvimx,&
                      ldvres, lresmx     , linsta, lerrcv   , lerror,&
                      conver, ds_contact_)
        use NonLin_Datastructure_type
        character(len=19), intent(in) :: vale(*)
        character(len=19), intent(in) :: sddisc
        character(len=4), intent(in) :: loop_name
        integer, intent(in) :: nume_inst
        aster_logical, intent(in) :: lsvimx
        aster_logical, intent(in) :: ldvres
        aster_logical, intent(in) :: lresmx
        aster_logical, intent(in) :: linsta
        aster_logical, intent(in) :: lerrcv
        aster_logical, intent(in) :: lerror
        aster_logical, intent(in) :: conver
        type(NL_DS_Contact), optional, intent(in) :: ds_contact_
    end subroutine nmevel
end interface
