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
    subroutine affono(valr, valk, desc, prnm, nbcomp,&
                      fonree, nomn, ino, nsurch, forimp,&
                      valfor, valfof, motcle, verif, nbec)
        integer :: nbcomp
        real(kind=8) :: valr(1)
        character(len=8) :: valk(1)
        integer :: desc
        integer :: prnm(1)
        character(len=4) :: fonree
        character(len=8) :: nomn
        integer :: ino
        integer :: nsurch
        integer :: forimp(nbcomp)
        real(kind=8) :: valfor(nbcomp)
        character(len=8) :: valfof(nbcomp)
        character(len=16) :: motcle(nbcomp)
        aster_logical :: verif
        integer :: nbec
    end subroutine affono
end interface
