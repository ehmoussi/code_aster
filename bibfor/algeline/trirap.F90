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

subroutine trirap(clef, tab, ntab, n, g,&
                  d, m)
!
!             TRI RAPIDE : CHOIX PIVOT ET EXPLORATION (CF TRI)
! ----------------------------------------------------------------------
! VARIABLES D'ENTREE / SORTIE
! INTEGER CLEF(N)         : VECTEUR CLEF
! INTEGER TAB(N,NTAB)     : TABLEAU A TRIER EN MEME TEMPS QUE CLEF
!                           (SI NTAB = 0, PAS PRIS EN COMPTE)
! VARIABLES D'ENTREE
! INTEGER NTAB            : NOMBRE DE COLONNES DE TAB
! INTEGER N               : NOMBRE DE LIGNES DE CLEF
! INTEGER G               : INDICE GAUCHE DE CLEF
! INTEGER D               : INDICE DROITE DE CLEF
!
! VARIABLE DE SORTIE
! INTEGER M               : INDICE DU PIVOT
! ----------------------------------------------------------------------
!
    implicit none
!
! --- VARIABLES
    integer :: n, ntab, g, d, m, clef(*), tab(n, *)
    integer :: pivot, gp, dp, i, tmp
!
! --- CHOIX DU PIVOT
!
    m = (d+g)/2
!
    if (clef(g) .lt. clef(m)) then
        if (clef(d) .lt. clef(m)) then
            if (clef(d) .lt. clef(g)) then
                m = g
            else
                m = d
            endif
        endif
    else
        if (clef(m) .lt. clef(d)) then
            if (clef(g) .lt. clef(d)) then
                m = g
            else
                m = d
            endif
        endif
    endif
!
    pivot = clef(m)
    clef(m) = clef(g)
    clef(g) = pivot
!
    do 10 i = 1, ntab
        tmp = tab(m,i)
        tab(m,i) = tab(g,i)
        tab(g,i) = tmp
10  end do
!
! --- EXPLORATION
!
    gp = g
    dp = d + 1
!
20  continue
!
    gp = gp + 1
    if (clef(gp) .lt. pivot) goto 20
!
30  continue
!
    dp = dp - 1
    if (clef(dp) .gt. pivot) goto 30
!
    if (gp .lt. dp) then
!
        tmp = clef(gp)
        clef(gp) = clef(dp)
        clef(dp) = tmp
!
        do 40 i = 1, ntab
            tmp = tab(gp,i)
            tab(gp,i) = tab(dp,i)
            tab(dp,i) = tmp
40      continue
!
        goto 20
!
    endif
!
! --- PLACEMENT DU PIVOT
!
    m = gp - 1
!
    clef(g) = clef(m)
    clef(m) = pivot
!
    do 50 i = 1, ntab
        tmp = tab(g,i)
        tab(g,i) = tab(m,i)
        tab(m,i) = tmp
50  end do
!
end subroutine
