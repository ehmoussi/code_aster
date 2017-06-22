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

subroutine inical(nbin, lpain, lchin, nbout, lpaout,&
                  lchout)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
    integer :: nbin, nbout
    character(len=8) :: lpaout(nbout), lpain(nbin)
    character(len=19) :: lchin(nbin), lchout(nbout)
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE POUR CALCUL
!
! INITIALISATIONS DES CHAMPS IN/OUT POUR CALCUL
!
! ----------------------------------------------------------------------
!
!
! IN  NBIN   : NOMBRE MAXI DE CHAMPS IN POUR CALCUL
! IN  LPAIN  : NOM DES TYPES DE CHAMP D'ENTREE
! IN  LCHIN  : NOM DES CHAMPS D'ENTREE
! IN  NBOUT  : NOMBRE MAXI DE CHAMPS OUT POUR CALCUL
! IN  LPAOUT : NOM DES TYPES DE CHAMP DE SORTIE
! IN  LCHOUT : NOM DES CHAMPS DE SORTIE
!
! ----------------------------------------------------------------------
!
    integer :: ich
    character(len=8) :: k8bla
    character(len=19) :: k19bla
!
! ---------------------------------------------------------------------
!
    k8bla = ' '
    k19bla = ' '
!
    do 100 ich = 1, nbin
        lchin(ich) = k19bla
        lpain(ich) = k8bla
100  end do
!
    do 200 ich = 1, nbout
        lchout(ich) = k19bla
        lpaout(ich) = k8bla
200  end do
end subroutine
