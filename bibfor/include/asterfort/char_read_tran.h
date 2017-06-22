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
    subroutine char_read_tran(keywordfact , iocc      , ndim,&
                              l_tran_     , tran_     ,&
                              l_cent_     , cent_     ,&
                              l_angl_naut_, angl_naut_)
        character(len=16), intent(in) :: keywordfact
        integer, intent(in) :: iocc
        integer, intent(in) :: ndim
        aster_logical, optional, intent(out) :: l_tran_
        real(kind=8), optional, intent(out) :: tran_(3)
        aster_logical, optional, intent(out) :: l_cent_
        real(kind=8), optional, intent(out) :: cent_(3)
        aster_logical, optional, intent(out) :: l_angl_naut_
        real(kind=8), optional, intent(out) :: angl_naut_(3)
    end subroutine char_read_tran
end interface
