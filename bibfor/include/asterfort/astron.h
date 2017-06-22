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
    subroutine astron(nomsy, psmo, monoap, muapde, nbsup,&
                      nsupp, neq, nbmode, id, vecmod,&
                      momec, gamma0, nomsup, reasup, recmor,&
                      recmop, nopara, nordr)
        integer :: nbmode
        integer :: neq
        integer :: nbsup
        character(len=16) :: nomsy
        character(len=*) :: psmo
        aster_logical :: monoap
        aster_logical :: muapde
        integer :: nsupp(*)
        integer :: id
        real(kind=8) :: vecmod(neq, *)
        character(len=*) :: momec
        real(kind=8) :: gamma0(*)
        character(len=*) :: nomsup(nbsup, *)
        real(kind=8) :: reasup(nbsup, nbmode, *)
        real(kind=8) :: recmor(nbsup, neq, *)
        real(kind=8) :: recmop(nbsup, neq, *)
        character(len=16) :: nopara(*)
        integer :: nordr(*)
    end subroutine astron
end interface
