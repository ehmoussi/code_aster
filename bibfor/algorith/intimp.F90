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

subroutine intimp(iuni, vect1, vect2, nmatr, nfcod)
    implicit   none
    integer :: iuni, nmatr, nfcod
    real(kind=8) :: vect1(*)
    character(len=24) :: vect2(*)
!     IMPRESSION DES RESULTATS OBTENUS PAR L'OPERATEUR CALC_INTE_SPEC
!
!     ------------------------------------------------------------------
!     IN  : IMP   : NIVEAU D'IMPRESSION
!     IN  : VECT1 : VALEURS DES INTERSPECTRES ET DES AUTOSPECTRES
!     IN  : VECT2 : VECTEURS DES NOMS DE FONCTIONS
!     IN  : NMATR : NOMBRE DE TIRAGES REALISES
!     ------------------------------------------------------------------
    integer :: it1, it2, if, ib, l1
!     ------------------------------------------------------------------
!
    write (iuni,101)
    it1 = 1
    it2 = 0
    do 10 if = 1, nfcod
        if (if .eq. it1) then
            write (iuni,102) vect2(if)
            it2 = it2 + 1
            it1 = it1 + it2 + 1
        else
            write (iuni,100) vect2(if)
        endif
        do 20 ib = 1, nmatr
            l1 = (if-1)*nmatr + ib
            write (iuni,200) vect1(l1)
20      continue
10  end do
!
    101 format ( 'CONVERGENCE DE LA MATRICE INTERSPECTRALE ',&
     &         'EN FONCTION DU NOMBRE DE TIRAGES ALEATOIRES')
    100 format ( 'NOM DE L INTERSPECTRE :',a19 )
    102 format ( 'NOM DE L AUTOSPECTRE :',a19 )
    200 format ( 4 (e11.4,2x) )
!
end subroutine
