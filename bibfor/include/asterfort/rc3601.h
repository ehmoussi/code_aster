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
    subroutine rc3601(ig, iocs, seisme, npass, ima,&
                      ipt, nbm, adrm, c, k,&
                      cara, nommat, snmax, samax, utot,&
                      sm, factus)
        integer :: ig
        integer :: iocs
        aster_logical :: seisme
        integer :: npass
        integer :: ima
        integer :: ipt
        integer :: nbm
        integer :: adrm(*)
        real(kind=8) :: c(*)
        real(kind=8) :: k(*)
        real(kind=8) :: cara(*)
        character(len=8) :: nommat
        real(kind=8) :: snmax
        real(kind=8) :: samax
        real(kind=8) :: utot
        real(kind=8) :: sm
        real(kind=8) :: factus(*)
    end subroutine rc3601
end interface
