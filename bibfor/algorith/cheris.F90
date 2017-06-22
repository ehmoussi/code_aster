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

subroutine cheris(nb, ivec, i, iran)
    implicit none
!
!***********************************************************************
!    P. RICHARD     DATE 19/02/91
!-----------------------------------------------------------------------
!  BUT:  CHERCHER LE RANG D'UN ENTIER DANS UNE LISTE D'ENTIER
!
!-----------------------------------------------------------------------
!
! NB       /I/: NOMBRE D'ENTIER DE LA LISTE
! IVEC     /I/: VECTEUR DES ENTIERS
! I        /I/: ENTIER A TROUVER
! IRAN     /O/: RANG DE L'ENTIER
!
!-----------------------------------------------------------------------
!
    integer :: ivec(nb)
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, iran, j, nb
!-----------------------------------------------------------------------
    iran=0
    do 10 j = 1, nb
        if (ivec(j) .eq. i) iran=j
10  end do
!
end subroutine
