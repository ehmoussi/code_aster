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
    subroutine vpnorm(norm, para, lmatr, neq, nbmode,&
                      ddlexc, vecpro, resufr, xmastr, isign,&
                      numddl, coef)
        integer :: nbmode
        integer :: neq
        character(len=*) :: norm
        character(len=*) :: para
        integer :: lmatr
        integer :: ddlexc(*)
        real(kind=8) :: vecpro(neq, *)
        real(kind=8) :: resufr(nbmode, *)
        real(kind=8) :: xmastr(3)
        integer :: isign
        integer :: numddl
        real(kind=8) :: coef(*)
    end subroutine vpnorm
end interface
