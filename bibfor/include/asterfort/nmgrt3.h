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
    subroutine nmgrt3(nno, poids, def, pff,&
                      lVect, lMatr, lMatrPred,&
                      dsidep, sigmPrev, sigmCurr, matsym,&
                      matuu, vectu)
        integer :: nno
        real(kind=8) :: pff(6, nno, nno), def(6, nno, 3), dsidep(6, 6), poids
        real(kind=8) :: vectu(3, nno)
        real(kind=8) :: sigmCurr(6), sigmPrev(6), matuu(*)
        aster_logical :: matsym, lVect, lMatr, lMatrPred
    end subroutine nmgrt3
end interface
