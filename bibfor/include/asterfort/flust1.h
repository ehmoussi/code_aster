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
    subroutine flust1(melflu, typflu, base, nuor, amor,&
                      amoc, freq, masg, fact, vite,&
                      nbm, calcul, npv, nivpar, nivdef)
        character(len=19) :: melflu
        character(len=8) :: typflu
        character(len=8) :: base
        integer :: nuor(*)
        real(kind=8) :: amor(*)
        real(kind=8) :: amoc(*)
        real(kind=8) :: freq(*)
        real(kind=8) :: masg(*)
        real(kind=8) :: fact(*)
        real(kind=8) :: vite(*)
        integer :: nbm
        aster_logical :: calcul(2)
        integer :: npv
        integer :: nivpar
        integer :: nivdef
    end subroutine flust1
end interface
