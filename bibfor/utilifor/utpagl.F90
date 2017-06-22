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

subroutine utpagl(nn, nc, p, sg, sl)
!
    implicit none
    real(kind=8) :: p(3, 3), sl(*), sg(*)
    integer :: nn, nc
!     ------------------------------------------------------------------
!     PASSAGE D'UNE MATRICE TRIANGULAIRE ANTISYMETRIQUE DE NN*NC LIGNES
!     DU REPERE GLOBAL AU REPERE LOCAL (3D)
!     ------------------------------------------------------------------
!IN   I   NN   NOMBRE DE NOEUDS
!IN   I   NC   NOMBRE DE COMPOSANTES
!IN   R   P    MATRICE DE PASSAGE 3D DE GLOBAL A LOCAL
!IN   R   SL   NN*NC COMPOSANTES DE LA TRIANGULAIRE SL DANS LOCAL
!OUT  R   SG   NN*NC COMPOSANTES DE LA TRIANGULAIRE SG DANS GLOBAL
!     ------------------------------------------------------------------
    real(kind=8) :: r(9), zero
    integer :: in(3), i, j, m, n, nb, k, l
    data     zero / 0.d0 /
!
    if (mod(nc,3) .eq. 0) then
        nb = nn * nc / 3
        do 100 i = 1, nb
            k = 3 * ( i - 1 )
            do 110 j = 1, i
                in(1) = k * (k+1) / 2 + 3*(j-1)
                in(2) = (k+1) * (k+2) / 2 + 3*(j-1)
                in(3) = (k+2) * (k+3) / 2 + 3*(j-1)
                if (i .eq. j) then
!            --------- BLOC DIAGONAL
! MATRICE SL ANTISYMETRIQUE
                    r(1) = sg(in(1)+1)
                    r(2) = - sg(in(2)+1)
                    r(3) = - sg(in(3)+1)
                    r(4) = sg(in(2)+1)
                    r(5) = sg(in(2)+2)
                    r(6) = - sg(in(3)+2)
                    r(7) = sg(in(3)+1)
                    r(8) = sg(in(3)+2)
                    r(9) = sg(in(3)+3)
                    do 120 m = 1, 3
                        do 130 n = 1, m
                            sl(in(m)+n) = zero
                            do 140 l = 1, 3
                                sl(in(m)+n) = sl(&
                                              in(m)+n) + p(l,&
                                              m) * (&
                                              r(&
                                              3*(l-1)+1)*p(1, n) + r(3*(l-1)+2)*p( 2,&
                                              n) + r(3*(l-1)+3&
                                              )*p(3, n&
                                              )&
                                              )
140                          continue
130                      continue
120                  continue
                else
!              --------- BLOC EXTRA - DIAGONAL
                    do 150 m = 1, 3
                        do 160 n = 1, 3
                            sl(in(m)+n) = zero
                            do 170 l = 1, 3
                                sl(in(m)+n) = sl(&
                                              in(m)+n) + p(l,&
                                              m) * (&
                                              sg(&
                                              in(l)+1)*p(1, n) + sg(in(l)+2)*p(2, n) + sg(in(l)+3&
                                              )*p(3, n&
                                              )&
                                              )
170                          continue
160                      continue
150                  continue
                endif
110          continue
100      continue
!
    endif
!
end subroutine
