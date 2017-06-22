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

subroutine calkbp(nno, ndim, w, dff1, kbp)
! person_in_charge: sebastien.fayolle at edf.fr
    implicit none
!
#include "asterfort/assert.h"
#include "asterfort/r8inir.h"
    integer :: ndim, nno
    real(kind=8) :: w, dff1(nno, ndim)
    real(kind=8) :: kbp(ndim, nno)
!-----------------------------------------------------------------------
!     BUT:  CALCUL LE TERME DE COUPLAGE KBP
!     ON UTILISE UNE FORMULATION AVEC UN SEULE POINT DE GAUSS
!     SITUE AU BARYCENTRE DE L ELEMENT ET DONT LE POIDS EST EGAL
!-----------------------------------------------------------------------
! IN  NDIM   : DIMENSION DE L'ESPACE
! IN  NNO    : NOMBRE DE NOEUDS DE L'ELEMENT
! IN  W      : POIDS DU POINT DE GAUSS
! IN  DFF1   : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
! OUT KBP    : MATRICE KBP
!-----------------------------------------------------------------------
!
    integer :: ia, na
    real(kind=8) :: pbulle
!-----------------------------------------------------------------------
!
!
! - INITIALISATION
    call r8inir(nno*ndim, 0.d0, kbp, 1)
!
    if (ndim .eq. 3) then
        pbulle = 4.d0
    else if (ndim .eq. 2) then
        pbulle = 3.d0
    else
        ASSERT(.false.)
    endif
!
! - TERME KBP
! - BOUCLE SUR LES NOEUDS DE PRESSION
    do 100 na = 1, nno
! - BOUCLE SUR LA DIMENSION
        do 99 ia = 1, ndim
            kbp(ia,na) = - w/pbulle*dff1(na,ia)
99      continue
100  end do
!
end subroutine
