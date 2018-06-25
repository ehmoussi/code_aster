! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
#include "intdef.h"
interface
    subroutine intinivec(sd_int_, ip, lonvec, iocc, vi,&
                         vr, vc, vk8, vk16, vk24, address)
        character(len=*)                    , intent(in) :: sd_int_
        integer                             , intent(in) :: ip
        integer,                              intent(in):: lonvec
        integer,                    optional, intent(in) :: iocc
        integer          , pointer, optional :: vi(:)
        real(kind=8)     , pointer, optional :: vr(:)
        complex(kind=8)  , pointer, optional :: vc(:)
        character(len=8) , pointer, optional :: vk8(:)
        character(len=16), pointer, optional :: vk16(:)
        character(len=24), pointer, optional :: vk24(:)
        integer                   , optional, intent(out) :: address
    end subroutine intinivec
end interface
