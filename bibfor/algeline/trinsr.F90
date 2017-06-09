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

subroutine trinsr(clef, tab, ntab, n)
! A_UTIL
! ----------------------------------------------------------------------
!                            TRI PAR INSERTION
! ----------------------------------------------------------------------
! VARIABLES D'ENTREE / SORTIE
! INTEGER CLEF(N)         : VECTEUR CLEF
! INTEGER TAB(N,NTAB)     : TABLEAU A TRIER EN MEME TEMPS QUE CLEF
!                           (SI NTAB = 0, PAS PRIS EN COMPTE)
!
! VARIABLES D'ENTREE
! INTEGER NTAB            : NOMBRE DE COLONNES DE TAB
! INTEGER N               : NOMBRE DE LIGNES A TRIER
! ----------------------------------------------------------------------
!
    implicit none
!
! --- VARIABLES
!
    integer :: n, ntab, clef(*)
    real(kind=8) :: tab(n, *)
    integer :: g, d, i, j, inser
    real(kind=8) :: tmpr
!
! --- TRI PAR INSERTION
!
    do 10 d = 2, n
!
        inser = clef(d)
        g = d
!
! ----- INSERTION DE INSER
!
20      continue
!
        g = g - 1
!
        if (g .gt. 0) then
            if (clef(g) .gt. inser) then
                clef(g+1) = clef(g)
                goto 20
            endif
        endif
!
        g = g + 1
!
        if (g .ne. d) then
!
            clef(g) = inser
!
! ------- DEPLACEMENT TABLEAU
!
            do 30 i = 1, ntab
                tmpr = tab(d,i)
                do 40 j = d-1, g, -1
                    tab(j+1,i) = tab(j,i)
40              continue
                tab(g,i) = tmpr
30          continue
!
        endif
!
10  end do
!
end subroutine
