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
    subroutine pmsta1(sigm, sigp, deps, vim, vip,&
                      nbvari, nbvita, iforta, nbpar, nompar,&
                      vr, igrad, typpar, nomvi, sddisc,&
                      liccvg, itemax, conver, actite)
        real(kind=8) :: sigm(6)
        real(kind=8) :: sigp(6)
        real(kind=8) :: deps(9)
        real(kind=8) :: vim(*)
        real(kind=8) :: vip(*)
        integer :: nbvari
        integer :: nbvita
        integer :: iforta
        integer :: nbpar
        character(len=16) :: nompar(*)
        real(kind=8) :: vr(*)
        integer :: igrad
        character(len=8) :: typpar(*)
        character(len=8) :: nomvi(*)
        character(len=19) :: sddisc
        integer :: liccvg(5)
        aster_logical :: itemax
        aster_logical :: conver
        integer :: actite
    end subroutine pmsta1
end interface
