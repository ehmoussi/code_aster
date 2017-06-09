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

subroutine lxdeli(tab, nbval)
    implicit none
    character(len=1) :: tab(*)
!     DEFINITION DES SEPARATEURS ADMIS PAR L'ANALYSEUR LEXICAL
!     ------------------------------------------------------------------
!                CETTE ROUTINE A VOCATION A ETRE SURCHARGEE
!     ------------------------------------------------------------------
! OUT TAB   : TABLEAU CONTENANT LES SEPARATEURS
! VAR NBVAL : NOMBRE MAXIMUM DE SEPARATEURS   (EN ENTREE)
!           : NOMBRE EFFECTIF DE SEPARATEURS  (EN SORTIE)
!     ------------------------------------------------------------------
!     ROUTINE(S) UTILISEE(S) :
!         -
!     ROUTINE(S) FORTRAN     :
!         -
!     ------------------------------------------------------------------
! FIN LXDELI
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: nbval
!-----------------------------------------------------------------------
    if (nbval .ge. 11) then
        tab( 1) = '='
        tab( 2) = '('
        tab( 3) = ')'
        tab( 4) = ':'
        tab( 5) = ';'
        tab( 6) = ','
        tab( 7) = '%'
        tab( 8) = '&'
        tab( 9) = '*'
        tab(10) = '/'
        tab(11) = '!'
        nbval = 11
    else
        nbval = 0
    endif
!
end subroutine
