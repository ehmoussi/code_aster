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
#include "dtmdef.h"
interface
    subroutine dtminivec(sd_dtm_, ip, lonvec, iocc, vi,&
                         vr, vc, vk8, vk16, vk24, address)
        character(len=*)                    , intent(in) :: sd_dtm_
        integer                             , intent(in) :: ip
        integer,                              intent(in):: lonvec
        integer,                    optional, intent(in) :: iocc
        integer          , pointer, optional, intent(out) :: vi(:)
        real(kind=8)     , pointer, optional, intent(out) :: vr(:)
        complex(kind=8)  , pointer, optional, intent(out) :: vc(:)
        character(len=8) , pointer, optional, intent(out) :: vk8(:)
        character(len=16), pointer, optional, intent(out) :: vk16(:)
        character(len=24), pointer, optional, intent(out) :: vk24(:)
        integer                   , optional, intent(out) :: address
    end subroutine dtminivec
end interface
