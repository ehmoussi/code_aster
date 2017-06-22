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
    subroutine ctnotb(nbno, mesnoe, noma, nbval, nkcha,&
                      nkcmp, toucmp, nbcmp, typac, ndim,&
                      nrval, resu, nomtb, nsymb, nival,&
                      niord)
        integer :: nbno
        character(len=24) :: mesnoe
        character(len=8) :: noma
        integer :: nbval
        character(len=24) :: nkcha
        character(len=24) :: nkcmp
        aster_logical :: toucmp
        integer :: nbcmp
        character(len=8) :: typac
        integer :: ndim
        character(len=24) :: nrval
        character(len=8) :: resu
        character(len=8) :: nomtb
        character(len=16) :: nsymb
        character(len=24) :: nival
        character(len=24) :: niord
    end subroutine ctnotb
end interface
