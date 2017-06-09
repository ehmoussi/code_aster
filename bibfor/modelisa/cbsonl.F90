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

subroutine cbsonl(char, noma, ligrmo, ndim, fonree)
!
    implicit   none
#include "asterc/getfac.h"
#include "asterfort/casonl.h"
    integer :: ndim
    character(len=4) :: fonree
    character(len=8) :: char, noma
    character(len=*) :: ligrmo
! ----------------------------------------------------------------------
!                   SOURCE THERMIQUE NON LINEAIRE
!
!  EXISTENCE DU MOT-CLE FACTEUR SOUR_NL
! ----------------------------------------------------------------------
!
    integer :: nbfac
    character(len=16) :: motfac
! ----------------------------------------------------------------------
!
    if (fonree .eq. 'FONC') then
        motfac = 'SOUR_NL'
        call getfac(motfac, nbfac)
        if (nbfac .ne. 0) call casonl(char, ligrmo, noma, ndim)
    endif
!
end subroutine
