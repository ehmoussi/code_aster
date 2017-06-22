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

subroutine maskau(nbno, nbec, imask)
!    P. RICHARD     DATE 20/02/91
!-----------------------------------------------------------------------
!  BUT:       CAS AUCUN
    implicit none
!
!    CONTROLER LES DEFORMEES A CALCULER EN TENANT COMPTE DE
!   LA TABLE DES ENTIERS CODES DES DDL AU NOEUD ET DE LA LISTE
!    DES ENTIER CODES DES MASQUES AUX NOEUDS
!
!   TABLE DES ENTIER CODE:  COLONNE 1 DDL PHYSIQUES
!                           COLONNE 2 DDL LAGRANGES
!
!  LE RESULTAT EST POUR CHAQUE NOEUD UN ENTIER CODES DONNANT LA LISTE
!    DES TYPES DE DDL POUR LESQUELS UNE DEFORMEE DOIT ETRE CALCULEE
!
!-----------------------------------------------------------------------
!
! NBNO     /I/: NOMBRE DE NOEUDS DE LA TABLE
! IMASK    /M/: LISTE DES ENTIERS CODES MASQUES EN ENTREE
!
!-----------------------------------------------------------------------
!
    integer :: imask(nbno*nbec)
    integer :: i, nbec, nbno
!-----------------------------------------------------------------------
!
    if (nbno .eq. 0) goto 9999
!
    do 10 i = 1, nbno*nbec
        imask(i)=0
10  end do
!
9999  continue
end subroutine
