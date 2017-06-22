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

subroutine jedisp(n, tab)
! person_in_charge: j-pierre.lefebvre at edf.fr
    implicit none
#include "jeveux_private.h"
    integer :: n, tab(*)
! ----------------------------------------------------------------------
! RENVOIE DANS LE TABLEAU TAB LES LONGUEURS MAX DISPONIBLES DANS LA
! PARTITION MEMOIRE NUMERO 1
!
! IN  N      : TAILLE DU TABLEAU TAB
! IN  TAB    : TAILLE DE SEGMENT DE VALEURS DISPONIBLE
!
! SI L'ALLOCATION DYNAMIQUE EST UTILISEE LA ROUTINE RENVOIE L'ENTIER
! MAXIMUM DANS LES N VALEURS DU TABLEAU TAB
!
!
! ----------------------------------------------------------------------
    integer :: lk1zon, jk1zon, liszon, jiszon
    common /izonje/  lk1zon , jk1zon , liszon , jiszon
! ----------------------------------------------------------------------
    integer :: lbis, lois, lols, lor8, loc8
    common /ienvje/  lbis , lois , lols , lor8 , loc8
    integer :: istat
    common /istaje/  istat(4)
    integer :: ldyn, lgdyn, nbdyn, nbfree
    common /idynje/  ldyn , lgdyn , nbdyn , nbfree
    real(kind=8) :: mxdyn, mcdyn, mldyn, vmxdyn, vmet, lgio, cuvtrav
    common /r8dyje/ mxdyn, mcdyn, mldyn, vmxdyn, vmet, lgio(2), cuvtrav
! ----------------------------------------------------------------------
    integer :: k
!
! DEB ------------------------------------------------------------------
    do 1 k = 1, n
        tab(k) = 0
 1  end do
!
! --- ON DONNE LA VALEUR ASSOCIEE A LA MEMOIRE DYNAMIQUE DISPONIBLE
!
    if (ldyn .eq. 1) then
        tab(1) = nint((vmxdyn-mcdyn)/lois)
    endif
! FIN-------------------------------------------------------------------
end subroutine
