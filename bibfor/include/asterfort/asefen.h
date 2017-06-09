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
    subroutine asefen(muapde, nomsy, id, stat, neq,&
                      nbsup, ndir, nsupp, masse, nomsup,&
                      depsup, recmod, nintra, nbdis)
        integer :: nbsup
        integer :: neq
        aster_logical :: muapde
        character(len=16) :: nomsy
        integer :: id
        character(len=*) :: stat
        integer :: ndir(*)
        integer :: nsupp(*)
        character(len=*) :: masse
        character(len=*) :: nomsup(nbsup, *)
        real(kind=8) :: depsup(nbsup, *)
        real(kind=8) :: recmod(nbsup, neq, *)
        integer :: nintra
        integer :: nbdis(nbsup)
    end subroutine asefen
end interface
