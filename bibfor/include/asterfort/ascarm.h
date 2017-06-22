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
    subroutine ascarm(nomsy, monoap, nbsup, nsupp, neq,&
                      nbmode, vecmod, momec, id, reasup,&
                      spectr, repmod, corfre, amort, muapde,&
                      tcosup, im, nbdis, nopara, nordr)
        integer :: nbmode
        integer :: neq
        integer :: nbsup
        character(len=16) :: nomsy
        aster_logical :: monoap
        integer :: nsupp(*)
        real(kind=8) :: vecmod(neq, *)
        character(len=*) :: momec
        integer :: id
        real(kind=8) :: reasup(nbsup, nbmode, *)
        real(kind=8) :: spectr(*)
        real(kind=8) :: repmod(nbsup, neq, *)
        aster_logical :: corfre
        real(kind=8) :: amort(*)
        aster_logical :: muapde
        integer :: tcosup(nbsup, *)
        integer :: im
        integer :: nbdis(*)
        character(len=16) :: nopara(*)
        integer :: nordr(*)
    end subroutine ascarm
end interface
