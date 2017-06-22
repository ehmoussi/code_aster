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
    subroutine gcchar(ichar , iprec , time  , carteo, lfchar,&
                      lpchar, lformu, lfmult, lccomb, cartei,&
                      nomfct, newfct, oldfon)
        aster_logical :: lfchar
        aster_logical :: lpchar
        aster_logical :: lformu
        aster_logical :: lfmult
        aster_logical :: lccomb
        character(len=24) :: oldfon
        character(len=8) ::  nomfct
        character(len=8) ::  newfct
        integer :: ichar
        integer :: iprec
        real(kind=8) :: time
        character(len=19) :: cartei
        character(len=19) :: carteo
    end subroutine gcchar
end interface
