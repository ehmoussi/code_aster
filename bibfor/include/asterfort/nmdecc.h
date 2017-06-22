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
    subroutine nmdecc(nomlis, linfo, optdez, deltat, instam,&
                      ratio, typdec, nbrpas, deltac, dtmin,&
                      retdec)
        character(len=24) :: nomlis
        aster_logical :: linfo
        character(len=*) :: optdez
        real(kind=8) :: deltat
        real(kind=8) :: instam
        real(kind=8) :: ratio
        character(len=4) :: typdec
        integer :: nbrpas
        real(kind=8) :: deltac
        real(kind=8) :: dtmin
        integer :: retdec
    end subroutine nmdecc
end interface
