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
    subroutine tgverm(option, carcri, compor, nno1, nno2,&
                      nno3, geom, ndim, nddl, deplp,&
                      sdepl, vu, vg, vp, vectu,&
                      svect, ncont, contp, scont, nvari,&
                      varip, svari, matuu, smatr, matsym,&
                      epsilo, epsilp, epsilg, varia, iret)
        integer :: nddl
        character(len=16) :: option
        real(kind=8) :: carcri(*)
        character(len=16) :: compor(*)
        integer :: nno1
        integer :: nno2
        integer :: nno3
        real(kind=8) :: geom(*)
        integer :: ndim
        real(kind=8) :: deplp(*)
        real(kind=8) :: sdepl(*)
        integer :: vu(3, 27)
        integer :: vg(27)
        integer :: vp(27)
        real(kind=8) :: vectu(*)
        real(kind=8) :: svect(*)
        integer :: ncont
        real(kind=8) :: contp(*)
        real(kind=8) :: scont(*)
        integer :: nvari
        real(kind=8) :: varip(*)
        real(kind=8) :: svari(*)
        real(kind=8) :: matuu(*)
        real(kind=8) :: smatr(*)
        aster_logical :: matsym
        real(kind=8) :: epsilo
        real(kind=8) :: epsilp
        real(kind=8) :: epsilg
        real(kind=8) :: varia(*)
        integer :: iret
    end subroutine tgverm
end interface
