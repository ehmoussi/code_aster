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
    subroutine ascorm(monoap, typcmo, nbsup, nsupp, neq,&
                      nbmode, repmo1, repmo2, amort, momec,&
                      id, temps, recmor, recmop, tabs,&
                      nomsy, vecmod, reasup, spectr, corfre,&
                      muapde, tcosup, nintra, nbdis, f1gup,&
                      f2gup, nopara, nordr)
        integer :: nbmode
        integer :: neq
        integer :: nbsup
        aster_logical :: monoap
        character(len=*) :: typcmo
        integer :: nsupp(*)
        real(kind=8) :: repmo1(nbsup, neq, *)
        real(kind=8) :: repmo2(nbsup, neq, *)
        real(kind=8) :: amort(*)
        character(len=*) :: momec
        integer :: id
        real(kind=8) :: temps
        real(kind=8) :: recmor(nbsup, neq, *)
        real(kind=8) :: recmop(nbsup, neq, *)
        real(kind=8) :: tabs(nbsup, *)
        character(len=16) :: nomsy
        real(kind=8) :: vecmod(neq, *)
        real(kind=8) :: reasup(nbsup, nbmode, *)
        real(kind=8) :: spectr(*)
        aster_logical :: corfre
        aster_logical :: muapde
        integer :: tcosup(nbsup, *)
        integer :: nintra
        integer :: nbdis(nbsup)
        real(kind=8) :: f1gup
        real(kind=8) :: f2gup
        character(len=16) :: nopara(*)
        integer :: nordr(*)
    end subroutine ascorm
end interface
