! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
#include "asterf_types.h"
!
interface
    subroutine nmgrt2(nno, poids, kpg, vff, def,&
                      pff, axi, r,&
                      lVect, lMatr, lMatrPred,&
                      dsidep, sigmPrev, sigmCurr, matsym,&
                      matuu, vectu)
        integer :: nno, kpg
        real(kind=8) :: pff(4, nno, nno), def(4, nno, 2), dsidep(6, 6), poids
        real(kind=8) :: vectu(*)
        real(kind=8) :: sigmCurr(6), sigmPrev(6), matuu(*), vff(*)
        real(kind=8) :: r
        aster_logical :: matsym, axi, lVect, lMatr, lMatrPred
    end subroutine nmgrt2
end interface
