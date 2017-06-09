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

subroutine ut2agl(nn, nc, p, sg, sl)
!
    implicit none
    real(kind=8) :: p(3, 3), sl(*), sg(*)
!     ------------------------------------------------------------------
!     PASSAGE EN 2D D'UNE MATRICE TRIANGULAIRE DE NN*NC LIGNES
!     DU REPERE LOCAL AU REPERE GLOBAL
!     ------------------------------------------------------------------
!IN   I   NN   NOMBRE DE NOEUDS
!IN   I   NC   NOMBRE DE COMPOSANTES
!IN   R   P    MATRICE DE PASSAGE 3D DE GLOBAL A LOCAL
!IN   R   SL   NN*NC COMPOSANTES DE LA TRIANGULAIRE SL DANS LOCAL
!OUT  R   SG   NN*NC COMPOSANTES DE LA TRIANGULAIRE SG DANS GLOBAL
!     ------------------------------------------------------------------
    real(kind=8) :: r(4)
    integer :: in(2)
!
!-----------------------------------------------------------------------
    integer :: i, j, k, l, m, n, nb
    integer :: nc, nn
    real(kind=8) :: zero
!-----------------------------------------------------------------------
    zero = 0.0d0
!
    if (mod(nc,2) .eq. 0) then
        nb = nn * nc / 2
        do 10 i = 1, nb
            k = 2 * ( i - 1 )
            do 20 j = 1, i
                in(1) = k * (k+1) / 2 + 2*(j-1)
                in(2) = (k+1) * (k+2) / 2 + 2*(j-1)
                if (i .eq. j) then
!            --------- BLOC DIAGONAL
                    r(1) = sg(in(1)+1)
                    r(2) = - sg(in(2)+1)
                    r(3) = sg(in(2)+1)
                    r(4) = sg(in(2)+2)
!
                    do 30 m = 1, 2
                        do 40 n = 1, m
                            sl(in(m)+n) = zero
                            do 50 l = 1, 2
                                sl(in(m)+n) = sl(&
                                              in(m)+n) + p(l,&
                                              m) * (r( 2*(l-1)+1)*p(1, n) + r(2*(l-1)+2 )*p( 2, n&
                                              )&
                                              )
50                          continue
40                      continue
30                  continue
                else
!              --------- BLOC EXTRA - DIAGONAL
                    do 60 m = 1, 2
                        do 70 n = 1, 2
                            sl(in(m)+n) = zero
                            do 80 l = 1, 2
                                sl(in(m)+n) = sl(&
                                              in(m)+n) + p(l,&
                                              m) * ( sg(in(l)+1)*p(1, n) + sg(in(l)+2 )*p(2, n )&
                                              )
80                          continue
70                      continue
60                  continue
                endif
20          continue
10      continue
!
    endif
!
end subroutine
