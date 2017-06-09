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

subroutine burars(vin, nvi, materd, materf, nmat,&
                  timed, timef, an, bn, cn)
! person_in_charge: alexandre.foucault at edf.fr
!=======================================================================
!
! ROUTINE QUI CALCULE LES MATRICES DE DEFORMATION DE FLUAGE PROPRE
!  SPHERIQUE REVERSIBLE D APRES LE MODELE BETON_BURGER
!
! IN  VIN      : VARIABLES INTERNES INITIALES
!     NVI      : DIMENSION DES VECTEURS VARIABLES INTERNES
!     MATERD   : VECTEUR DE PARAMETRES MATERIAU A T
!     MATERF   : VECTEUR DE PARAMETRES MATERIAU A T+DT
!     NMAT     : DIMENSION DE CMAT
!     TIMED    : INSTANT T
!     TIMEF    : INSTANT T+DT
! OUT AN       : SCALAIRE LIE A LA DEFOR. REV. DE FLUAGE PROPRE SPH.
!     BN       : SCALAIRE LIE A LA DEFOR. REV. DE FLUAGE PROPRE SPH.
!     CN       : SCALAIRE LIE A LA DEFOR. REV. DE FLUAGE PROPRE SPH.
!=======================================================================
    implicit none
    integer :: nvi, nmat
    real(kind=8) :: vin(nvi)
    real(kind=8) :: materd(nmat, 2), materf(nmat, 2)
    real(kind=8) :: timed, timef, tdt
    real(kind=8) :: an, bn, cn
    real(kind=8) :: krs, etars, hini, hfin
    real(kind=8) :: ersp
    real(kind=8) :: tsph, tsexp
!
! === =================================================================
! --- RECUPERATION DES VALEURS DES PARAMETRES MATERIAU
! === =================================================================
    krs = materf(1,2)
    etars = materf(2,2)
!
    hini = materd(6,1)
    hfin = materf(6,1)
!
! === =================================================================
! --- CALCUL VARIATION DE L'HUMIDITE ET DU TEMPS
! === =================================================================
    tdt = timef - timed
! === =================================================================
! --- INITIALISATION VARIABLES DE SORTIE
! === =================================================================
    an = 0.d0
    bn = 0.d0
    cn = 0.d0
! === =================================================================
! --- RECUPERATION DEFORMATION REVERSIBLE SPHERIQUE
! === =================================================================
    ersp = vin(1)
! === =================================================================
! --- CONSTRUCTION DE LA MATRICE SPHERIQUE REVERSIBLE
! === =================================================================
    tsph = etars / krs
    tsexp = exp(-tdt/tsph)
    an = (tsexp - 1.d0) * ersp
    bn = 1.d0/krs*(&
         tsexp*(&
         -hini*(2*tsph/tdt+1.d0) + hfin*tsph/tdt) + hini*(2.d0*tsph/tdt-1.d0) + hfin*(1.d0-tsph/t&
         &dt&
         )&
         )
    cn = hini/(tdt*krs)*( tsph*tsexp - tsph + tdt )
!
end subroutine
