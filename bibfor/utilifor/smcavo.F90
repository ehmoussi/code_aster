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

subroutine smcavo(x, ind, nbhist, trc)
!......................................................................C
! RECHERCHE DES PLUS PROCHES VOISINS DE X PARMI LES POINTS CONSTRUITS  C
!......................................................................C
    implicit none
    real(kind=8) :: sdx, trc((3*nbhist), 5), x(5), d(6), dx(5)
    integer :: ind(6), nbhist, invois, i, j, n
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    do 10 i = 1, 6
        ind(i)=0
        d(i)=10.0d25
10  end do
    do 70 n = 1, (3*nbhist)
        do 20 i = 1, 3
            dx(i)=(x(i)-trc(n,i))**2
20      continue
        do 30 i = 4, 5
            dx(i)=((x(i)-trc(n,i))/x(i))**2
30      continue
        sdx=0.d0
        do 40 i = 1, 5
            sdx=sdx+dx(i)
40      continue
        if (sdx .ge. d(6)) then
            goto 70
        else
            do 50 i = 6, 1, -1
                if (sdx .lt. d(i)) then
                    invois=i
                endif
50          continue
            if (invois .eq. 6) then
                d(6)=sdx
                ind(6)=n
            else
                do 60 j = 6, invois+1, -1
                    d(j)=d(j-1)
                    ind(j)=ind(j-1)
60              continue
                d(invois)=sdx
                ind(invois)=n
            endif
        endif
70  end do
end subroutine
