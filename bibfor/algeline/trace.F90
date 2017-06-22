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

function trace(ndi, s)
!
    implicit      none
    integer :: ndi
    real(kind=8) :: s(6), trace
! --- BUT : CALCUL DE LA TRACE D'UNE MATRICE ---------------------------
! ======================================================================
! IN  : ND     : NOMBRE DE COMPOSANTES DE LA DIAGONALE DE LA MATRICE S -
! --- : S      : MATRICE -----------------------------------------------
! OUT : TRACE  : TRACE DE LA MATRICE -----------------------------------
! ======================================================================
    integer :: ii
! ======================================================================
    trace = 0.0d0
    do 10 ii = 1, ndi
        trace = trace + s(ii)
10  end do
! ======================================================================
end function
