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

subroutine dxtbm(jacob, bm)
    implicit none
    real(kind=8) :: jacob(*), bm(3, 6)
!     MATRICE BM(3,6) EN MEMBRANE POUR LES ELEMENT DKT ET DST
!     ------------------------------------------------------------------
    real(kind=8) :: vj11, vj12, vj21, vj22
!     ------------------------------------------------------------------
    vj11 = jacob(1)
    vj12 = jacob(2)
    vj21 = jacob(3)
    vj22 = jacob(4)
!
    bm(1,1) = - vj11 - vj12
    bm(1,2) = 0.d0
    bm(1,3) = vj11
    bm(1,4) = 0.d0
    bm(1,5) = vj12
    bm(1,6) = 0.d0
    bm(2,1) = 0.d0
    bm(2,2) = - vj21 - vj22
    bm(2,3) = 0.d0
    bm(2,4) = vj21
    bm(2,5) = 0.d0
    bm(2,6) = vj22
    bm(3,1) = bm(2,2)
    bm(3,2) = bm(1,1)
    bm(3,3) = bm(2,4)
    bm(3,4) = bm(1,3)
    bm(3,5) = bm(2,6)
    bm(3,6) = bm(1,5)
!
end subroutine
