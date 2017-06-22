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
    subroutine coefmo(typflu, zrigi, nbm, nmode, indic,&
                      x, pulsc, vgap, xsi0, veci1,&
                      vecr1, vecr2, vecr3, vecr4, vecr5,&
                      xmf, xkf, xcf)
        character(len=8) :: typflu
        aster_logical :: zrigi
        integer :: nbm
        integer :: nmode
        integer :: indic
        real(kind=8) :: x(2)
        real(kind=8) :: pulsc
        real(kind=8) :: vgap
        real(kind=8) :: xsi0
        integer :: veci1(*)
        real(kind=8) :: vecr1(*)
        real(kind=8) :: vecr2(*)
        real(kind=8) :: vecr3(*)
        real(kind=8) :: vecr4(*)
        real(kind=8) :: vecr5(*)
        real(kind=8) :: xmf
        complex(kind=8) :: xkf
        real(kind=8) :: xcf
    end subroutine coefmo
end interface
