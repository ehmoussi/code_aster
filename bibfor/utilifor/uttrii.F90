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

subroutine uttrii(ivale, nbvale)
    implicit none
    integer :: ivale(*)
!     TRIE PAR ORDRE CROISSANT, (METHODE DE REMONTEE DES BULLES)
!     ET SUPPRIME LES VALEURS MULTIPLES .
!     ------------------------------------------------------------------
! VAR IVALE  : R8 : TABLEAU A TRIER PAR ORDRE CROISSANT
! VAR NBVALE : IS : NOMBRE DE VALEUR A TRIER PAR ORDRE CROISSANT
!                 : (SORTIE) NOMBRE DE VALEURS DISTINCTES
!     ------------------------------------------------------------------
    integer :: incrs, is9, diff
!
!     --- RIEN A FAIRE SI NBVALE=0 OU 1 (ET NE PAS MODIFIER NBVALE)
!
!     --- TRI BULLE ---
!-----------------------------------------------------------------------
    integer :: i, j, l, nbvale
!-----------------------------------------------------------------------
    if (nbvale .gt. 1) then
!        --- CHOIX DE L'INCREMENT ---
        incrs = 1
        is9 = nbvale / 9
10      continue
        if (incrs .lt. is9) then
            incrs = 3*incrs+1
            goto 10
        endif
!
!        --- REMONTEE DES BULLES ---
120      continue
        do 150 j = incrs+1, nbvale
            l = j-incrs
130          continue
            if (l .gt. 0) then
                if (ivale(l) .gt. ivale(l+incrs)) then
!                 --- PERMUTATION ---
                    diff = ivale(l)
                    ivale(l) = ivale(l+incrs)
                    ivale(l+incrs) = diff
                    l = l - incrs
                    goto 130
                endif
            endif
150      continue
        incrs = incrs/3
        if (incrs .ge. 1) goto 120
!
!        --- SUPPRESSION DES VALEURS MULTIPLES ---
        j=1
        do 301 i = 2, nbvale
            if (ivale(i) .ne. ivale(j)) then
                j = j + 1
                ivale(j) = ivale(i)
            endif
301      continue
        nbvale = j
    endif
!
end subroutine
