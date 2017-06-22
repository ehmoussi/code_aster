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

subroutine lcumsd(vari, nvari, cmat, nmat, nstrs,&
                  isph, tdt, hini, hfin, afp,&
                  bfp, cfp, cfps, cfpd)
!
!
! LCUMSD     SOURCE    BENBOU   01/03/26
!
!_______________________________________________________________________
!
! ROUTINE QUI CALCUL LES MATRICES DE DEFORMATION
!  DE FLUAGE PROPRE SPHERIQUE ET DEVIATORIQUE
!   D APRES LE MODELE UMLV
!
!     EQUATION (3.5-1)
!
!      POUR LES DEFORMATIONS
!         1 : REVERSIBLE
!         2 : IRREVERSIBLE
!         3 : TOTAL (1 + 2)
! IN  VARI     : VARIABLES INTERNES INITIALES
! IN  NVARI    : DIMENSION DES VECTEURS VARIABLES INTERNES
! IN  CMAT     : VECTEUR DE PARAMETRES (MATERIAU ET AUTRE)
! IN  NMAT     : DIMENSION DE CMAT
! IN  NSTRS    : DIMENSION DES VECTEURS CONTRAINTE ET DEFORMATION
! IN  ISPH     : MODE DE CALCUL DE LA PARTIE SPHERIQUE
! IN  TDT      : PAS DE TEMPS
! IN  HINI     : HUMIDITE INITIALE
! IN  HFIN     : HUMIDITE FINALE
! OUT AFP      : VECTEUR RELATIF A LA DEFORMATION DE FLUAGE PROPRE
! OUT BFP      : MATRICE RELATIVE A LA DEFORMATION DE FLUAGE PROPRE
! OUT CFP      : MATRICE RELATIVE A LA DEFORMATION DE FLUAGE PROPRE
! OUT CFPS     : COEFFICICIENT DE CN SPHERIQUE    (MATRICE TANGENTE)
! OUT CFPD     : COEFFICICIENT DE CN DEVIATORIQUE (MATRICE TANGENTE)
!_______________________________________________________________________
!
    implicit none
#include "asterfort/lcumfd.h"
#include "asterfort/lcumfs.h"
    integer :: i, ifou, isph, nmat, nstrs, nvari
    real(kind=8) :: vari(nvari), cmat(nmat)
! MODIFI DU 6 JANVIER 2003 - YLP SUPPRESSION DES DECLARATIONS
! IMPLICITES DES TABLEAUX
!     REAL*8  AFP(NSTRS),BFP(NSTRS,NSTRS),CFP(NSTRS,NSTRS)
    real(kind=8) :: afp(6), bfp(6, 6), cfp(6, 6)
    real(kind=8) :: afpd(6)
    real(kind=8) :: afps, bfpd, bfps, cfpd, cfps, hini, hfin, tdt
!
! RECUPERATION DES VALEURS DES PARAMETRES MATERIAU
!
    ifou = nint(cmat(12))
!
! INITIALISATION DES VARIABLES
!
!
    do 9 i = 1, 3
        afpd(i) = 0.d0
 9  end do
!
! CALCUL DE LA MATRICE DES DEFORMATIONS DE FLUAGE PROPRE SPHERIQUE
!          INCREMENTALES
!
    call lcumfs(vari, nvari, cmat, nmat, 0,&
                isph, tdt, hini, hfin, afps,&
                bfps, cfps)
!
!
! CALCUL DE LA MATRICE DES DEFORMATIONS DE FLUAGE PROPRE DEVIATORIQUE
!          INCREMENTALES
!
!
    call lcumfd(vari, nvari, nstrs, cmat, nmat,&
                0, tdt, hini, hfin, afpd,&
                bfpd, cfpd)
!
!
! CONSTRUCTION DE LA MATRICE DES DEFORMATIONS DE FLUAGE PROPRE
!          INCREMENTALES
!
!   EQUATION (3.5-2)
!
    do 10 i = 1, 2
        afp(i) = afps + afpd(i)
        bfp(i,i) = (bfps + 2.d0 * bfpd)/3.d0
        cfp(i,i) = (cfps + 2.d0 * cfpd)/3.d0
10  end do
    bfp(1,2) = (bfps - bfpd) / 3.d0
    bfp(2,1) = bfp(1,2)
    cfp(1,2) = (cfps - cfpd) / 3.d0
    cfp(2,1) = cfp(1,2)
!
    if ((ifou.eq.0) .or. (ifou.eq.-1) .or. (ifou.eq.2)) then
        afp(3) = afps + afpd(3)
        afp(4) = afpd(4)
        bfp(3,3) = bfp(1,1)
        bfp(1,3) = bfp(1,2)
        bfp(2,3) = bfp(1,2)
        bfp(3,1) = bfp(1,2)
        bfp(3,2) = bfp(1,2)
        bfp(4,4) = bfpd
        cfp(3,3) = cfp(1,1)
        cfp(1,3) = cfp(1,2)
        cfp(2,3) = cfp(1,2)
        cfp(3,1) = cfp(1,2)
        cfp(3,2) = cfp(1,2)
        cfp(4,4) = cfpd
! MODIFI DU 6 JANVIER 2003 - YLP AJOUT DES AFFECTATIONS
        afp(5) = 0.0d0
        afp(6) = 0.0d0
        bfp(5,5) = 0.0d0
        bfp(6,6) = 0.0d0
        cfp(5,5) = 0.0d0
        cfp(6,6) = 0.0d0
        if (ifou .eq. 2) then
            afp(5) = afpd(5)
            afp(6) = afpd(6)
            bfp(5,5) = bfpd
            bfp(6,6) = bfpd
            cfp(5,5) = cfpd
            cfp(6,6) = cfpd
        endif
    else
        afp(3) = afpd(3)
        bfp(3,3) = bfpd
        cfp(3,3) = cfpd
    endif
!
end subroutine
