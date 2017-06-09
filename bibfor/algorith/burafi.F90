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

subroutine burafi(vin, nvi, materd, materf, nmat,&
                  timed, timef, afi, bfi, cfi)
! person_in_charge: alexandre.foucault at edf.fr
!=======================================================================
!
! ROUTINE QUI CALCULE LES MATRICES DE DEFORMATION
!  DE FLUAGE PROPRE SPHERIQUE ET DEVIATORIQUE IRREVERSIBLE LINEARISEE
!
! IN  VIN      : VARIABLES INTERNES INITIALES
!     NVI      : DIMENSION DES VECTEURS VARIABLES INTERNES
!     MATERD   : VECTEUR DE PARAMETRES MATERIAU A T
!     MATERF   : VECTEUR DE PARAMETRES MATERIAU A T+DT
!     NMAT     : DIMENSION DE CMAT
!     TIMED    : INSTANT T
!     TIMEF    : INSTANT T+DT
! OUT AFI      : VECTEUR LIE A LA DEFOR. IRREV. DE FLUAGE PROPRE
!     BFI      : MATRICE LIEE A LA DEFOR. IRREV. DE FLUAGE PROPRE
!     CFI      : MATRICE LIEE A LA DEFOR. IRREV. DE FLUAGE PROPRE
!=======================================================================
    implicit none
#include "asterfort/burail.h"
    integer :: nvi, nmat, ndt, ndi, i, j
    real(kind=8) :: vin(*)
    real(kind=8) :: materd(nmat, 2), materf(nmat, 2)
    real(kind=8) :: timed, timef
    real(kind=8) :: afi(6), bfi(6, 6), cfi(6, 6)
    real(kind=8) :: bfis, cfis
    real(kind=8) :: bfid, cfid
!
    common /tdim/   ndt,ndi
!
! === =================================================================
! INITIALISATION DES VARIABLES
! === =================================================================
    do 1 i = 1, ndt
        afi(i) = 0.d0
        do 2 j = 1, ndt
            bfi(i,j) = 0.d0
            cfi(i,j) = 0.d0
 2      continue
 1  end do
! === =================================================================
! CALCUL DE LA MATRICE DES DEFORMATIONS IRREVERSIBLES LINEARISEE
!          DE FLUAGE PROPRE SPHERIQUE INCREMENTALES
! === =================================================================
    call burail(vin, nvi, materd, materf, nmat,&
                timed, timef, 'SPH', bfis, cfis)
! === =================================================================
! CALCUL DE LA MATRICE DES DEFORMATIONS IRREVERSIBLES LINEARISEE
!          DE FLUAGE PROPRE DEVIATORIQUE INCREMENTALES
! === =================================================================
    call burail(vin, nvi, materd, materf, nmat,&
                timed, timef, 'DEV', bfid, cfid)
! === =================================================================
! CONSTRUCTION DE LA MATRICE DES DEFORMATIONS IRREVERSIBLES
!          DE FLUAGE PROPRE INCREMENTALES
! === =================================================================
    do 3 i = 1, ndi
        bfi(i,i) = (bfis+2.d0*bfid)/3.d0
        cfi(i,i) = (cfis+2.d0*cfid)/3.d0
        bfi(i+ndi,i+ndi) = bfid
        cfi(i+ndi,i+ndi) = cfid
 3  end do
    bfi(1,2) = (bfis-bfid)/3
    cfi(1,2) = (cfis-cfid)/3
    bfi(2,1) = bfi(1,2)
    cfi(2,1) = cfi(1,2)
    bfi(3,1) = bfi(1,2)
    cfi(3,1) = cfi(1,2)
    bfi(1,3) = bfi(1,2)
    cfi(1,3) = cfi(1,2)
    bfi(2,3) = bfi(1,2)
    cfi(2,3) = cfi(1,2)
    bfi(3,2) = bfi(1,2)
    cfi(3,2) = cfi(1,2)
!
end subroutine
