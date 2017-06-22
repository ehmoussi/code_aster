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

subroutine burafd(materd, materf, nmat, afd, bfd,&
                  cfd)
! person_in_charge: alexandre.foucault at edf.fr
!=====================================================================
!
! SOUS PROGRAMME QUI CALCUL LES MATRICE DE DEFORMATION DE FLUAGE
!   DE DESSICCATION D APRES LE MODELE DE BAZANT
!
!     - MODELE DE BAZANT : => EQUATION (3.3-2)
!
!   DFDES(N+1) = AFD + BFD * SIGMA(N) + CFD * SIGMA(N+1)
!
!    => EQUATION (3.3-1)
!     ----------------------------------------------------------------
!     IN
!          MATERD :  COEFFICIENTS MATERIAU A T
!          MATERF :  COEFFICIENTS MATERIAU A T+DT
!          NMAT   :  DIMENSION TABLEAU MATER
!     OUT
!          AFD     :  VECTEUR LIE AU FLUAGE DE DESSICCATION
!          BFD     :  TENSEUR LIE AU FLUAGE DE DESSICCATION
!          CFD     :  TENSEUR LIE AU FLUAGE DE DESSICCATION
!     ----------------------------------------------------------------
!=====================================================================
    implicit none
!     ----------------------------------------------------------------
    common /tdim/   ndt ,ndi
!     ----------------------------------------------------------------
    integer :: nmat, ndt, ndi
    integer :: i, j
    real(kind=8) :: materd(nmat, 2), materf(nmat, 2)
    real(kind=8) :: afd(6), bfd(6, 6), cfd(6, 6)
    real(kind=8) :: b, c, zero
    real(kind=8) :: etafd, dh
    data      zero/0.d0/
!
! === =================================================================
! RECUPERATION DES VALEURS DES PARAMETRES MATERIAU
! LE MODELE DE BAZANT NE COMPREND QU'UN PARAMETRE
! === =================================================================
    etafd = materd(10,2)
! === =================================================================
! --- INITIALISATION DES VECTEURS ET MATRICES
! === =================================================================
    do 1 i = 1, ndt
        afd(i) = zero
        do 2 j = 1, ndt
            bfd(i,j) = zero
            cfd(i,j) = zero
 2      continue
 1  end do
!
! === =================================================================
! INITIALISATION DES VARIABLES
! === =================================================================
!
    dh = abs(materf(6,1)-materd(6,1))
!
! === =================================================================
! AIGUILLAGE SUIVANT LA VALEUR DE ETAFD -> MODELE DE BAZANT
! === =================================================================
    if (etafd .gt. zero) then
        b = dh / (2.d0*etafd)
        c = b
! === =================================================================
! CONSTRUCTION DE LA MATRICE DE FLUAGE DE DESSICCATION
! === =================================================================
        do 10 i = 1, ndt
            bfd(i,i) = b
            cfd(i,i) = c
10      continue
    endif
!
end subroutine
