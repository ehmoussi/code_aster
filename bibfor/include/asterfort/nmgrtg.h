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
    subroutine nmgrtg(ndim    , nno   , poids    , kpg   , vff     ,&
                      dfdi    , def   , pff      , axi   ,&
                      lVect   , lMatr , lMatrPred,&
                      r       , fPrev , fCurr    , dsidep, sigmPrev,&
                      sigmCurr, matsym, matuu    , vectu)
        integer :: ndim, nno, kpg
        real(kind=8) :: pff(*), def(*), r, dsidep(6, 6), poids, vectu(*)
        real(kind=8) :: sigmCurr(6), sigmPrev(6), matuu(*), vff(*)
        real(kind=8) :: fPrev(3, 3), fCurr(3, 3), dfdi(*)
        aster_logical :: matsym, axi, lVect, lMatr, lMatrPred
    end subroutine nmgrtg
end interface
