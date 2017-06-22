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
    subroutine asstoc(mome, resu, nomsy, neq, repdir,&
                      ndir, comdir, typcdi, glob, prim)
        integer :: neq
        character(len=*) :: mome
        character(len=*) :: resu
        character(len=16) :: nomsy
        real(kind=8) :: repdir(neq, *)
        integer :: ndir(*)
        aster_logical :: comdir
        character(len=*) :: typcdi
        aster_logical :: glob
        aster_logical :: prim
    end subroutine asstoc
end interface
