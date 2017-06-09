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

subroutine calajt(j1, j, diag, col, n,&
                  itab, deb, tab, suiv, lt,&
                  ier)
! person_in_charge: olivier.boiteau at edf.fr
    implicit none
    integer :: j1, j, n, diag(0:n), col(*), itab, deb(1:n)
    integer :: tab(*), suiv(*), lt, ier
    integer :: k, l, ok, oj, pred, it
!     ON AJOUTE LES NOEUDS COL(J1) A COL(J-1) DANS LA LISTE
!     DES VOISINS DE COL(J)
    oj = col(j)
    do 1 k = j1, j-1
        ok = col(k)
        do 2 l = diag(oj-1)+1, diag(oj)-1
            if (col(l) .eq. ok) goto 3
 2      continue
!     OK N' EST PAS UN VOISIN INITIAL DE OJ ON L INSERE DANS
!     LA LISTE DES VOISINS
        if (deb(oj) .eq. 0) then
            itab = itab + 1
            if (itab .gt. lt) then
                ier=1
                goto 22
            endif
            deb(oj) = itab
            tab(itab) = ok
            suiv(itab) = 0
        else
            it = deb(oj)
            pred =it
10          continue
            if (it .gt. 0) then
                if (tab(it) .eq. ok) goto 9
                pred = it
                it = suiv(it)
                goto 10
            endif
!     OK N'EST PAS DANS TAB
            itab = itab + 1
            if (itab .gt. lt) then
                ier=1
                goto 22
            endif
            tab(itab) = ok
            suiv(pred) = itab
            suiv(itab) = 0
 9          continue
        endif
 3      continue
 1  end do
    ier = -itab
22  continue
end subroutine
