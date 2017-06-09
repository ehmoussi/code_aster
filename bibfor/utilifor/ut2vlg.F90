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

subroutine ut2vlg(nn, nc, p, vl, vg)
    implicit none
    real(kind=8) :: p(3, 3), vl(*), vg(*)
!     ------------------------------------------------------------------
!     PASSAGE EN 2D D'UN VECTEUR NN*NC DU REPERE LOCAL AU REPERE GLOBAL
!     ------------------------------------------------------------------
!IN   I   NN   NOMBRE DE NOEUDS
!IN   I   NC   NOMBRE DE COMPOSANTES
!IN   R   P    MATRICE DE PASSAGE 3D DE GLOBAL A LOCAL
!IN   R   VL   NN*NC COMPOSANTES DU VECTEUR DANS LOCAL
!OUT  R   VG   NN*NC COMPOSANTES DU VECTEUR DANS GLOBAL
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, nc, nn
!-----------------------------------------------------------------------
    if (mod(nc,2) .eq. 0) then
        do 10 i = 1, nn * nc, 2
            vg(i ) = p(1,1)*vl(i) + p(2,1)*vl(i+1)
            vg(i+1) = p(1,2)*vl(i) + p(2,2)*vl(i+1)
10      continue
!
    else if (mod(nc,2) .eq. 1) then
        do 20 i = 1, nn * nc, 3
            vg(i ) = p(1,1)*vl(i) + p(2,1)*vl(i+1)
            vg(i+1) = p(1,2)*vl(i) + p(2,2)*vl(i+1)
            vg(i+2) = vl(i+2)
20      continue
!
    endif
!
end subroutine
