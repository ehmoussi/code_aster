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
    subroutine xprvir(fiss, covir, bavir, vitvir, angvir,&
                      numvir, numfon, nvit, nbeta, nbptff,&
                      radimp, radtor, damax, noma, locdom)
        character(len=8) :: fiss
        character(len=19) :: covir
        character(len=19) :: bavir
        character(len=19) :: vitvir
        character(len=19) :: angvir
        character(len=19) :: numvir
        integer :: numfon
        character(len=24) :: nvit
        character(len=24) :: nbeta
        integer :: nbptff
        real(kind=8) :: radimp
        real(kind=8) :: radtor
        real(kind=8) :: damax
        character(len=8) :: noma
        aster_logical :: locdom
    end subroutine xprvir
end interface
