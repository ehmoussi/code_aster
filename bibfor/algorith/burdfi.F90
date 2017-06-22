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

subroutine burdfi(bfi, cfi, nr, yd, dy)
! person_in_charge: alexandre.foucault at edf.fr
!
!=====================================================================
! ROUTINE QUI CALCUL L INCREMENT DE DEFORMATIONS DE FLUAGE PROPRE
!
! IN  BFI      : MATRICE FLUAGE PROPRE IRREVERSIBLE
!     CFI      : MATRICE FLUAGE PROPRE IRREVERSIBLE
!     NR       : DIMENSION VECTEUR YD ET DY
!     YD       : VECTEUR DES INCONNUES INITIALES
!     DY       : INCREMENT DU VECTEUR DES INCONNUES AVEC SIGMA MAJ
! OUT DY       : INCREMENT DU VECTEUR DES INCONNUES AVEC VARI MAJ
!_______________________________________________________________________
!
    implicit none
#include "asterfort/lcprmv.h"
#include "asterfort/lcsove.h"
    integer :: ndt, ndi, i, nr
    real(kind=8) :: bfi(6, 6), cfi(6, 6)
    real(kind=8) :: yd(nr), dy(nr)
    real(kind=8) :: bnsigd(6), sigf(6), cnsigf(6)
    real(kind=8) :: depsf(6)
!
!     ----------------------------------------------------------------
    common /tdim/   ndt ,ndi
!     ----------------------------------------------------------------
!
! === =================================================================
! --- CONSTRUCTION DES PARTIES PRENANTES POUR DEFORMATION IRREVERSIBLE
! === =================================================================
! === =================================================================
! --- CONSTRUCTION TENSEUR BFI*SIGD
! === =================================================================
    call lcprmv(bfi, yd, bnsigd)
! === =================================================================
! --- CONSTRUCTION TENSEUR CFI*SIGF
! === =================================================================
    call lcsove(yd, dy, sigf)
    call lcprmv(cfi, sigf, cnsigf)
! === =================================================================
! --- CONSTRUCTION TENSEUR CNSIGF+BNSIGD EQUIVAUT A BFI*SIGD+CFI*SIGF
! === =================================================================
    call lcsove(bnsigd, cnsigf, depsf)
! === =================================================================
! --- AFFECTATION DES VALEURS A DY + MISE A L'ECHELLE
! === =================================================================
    do 2 i = 1, ndt
        dy(ndt+i) = depsf(i)
 2  end do
!
end subroutine
