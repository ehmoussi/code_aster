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

subroutine lcump1(cmat, nmat, ambda1, ambda2, x1,&
                  x2)
!
!
! ROUTINE APPELE DANS LCUMFS
! LCUMP1     SOURCE    BENBOU   01/03/26
!
!_______________________________________________________________________
!
! CALCUL DE PARAMETRE DE LA LOI DE FLUAGE PROPRE SPHERIQUE
! IN  CMAT     : VECTEUR DE PARAMETRES (MATERIAU ET AUTRE)
! IN  NMAT     : DIMENSION DE CMAT
! OUT AMBDA1   : PARAMETRE MATERIAU LAMBDA1
! OUT AMBDA2   : PARAMETRE MATERIAU LAMBDA2
! OUT X1       : PARAMETRE MATERIAU X1
! OUT X2       : PARAMETRE MATERIAU X2
!_______________________________________________________________________
!
!     IMPLICIT REAL*8(A-H,O-Z)
    implicit none
    integer :: nmat
    real(kind=8) :: cmat(nmat)
    real(kind=8) :: ambda1, ambda2, delta, risp, rrsp, uii, uri
    real(kind=8) :: urr, visp, vrsp, x1, x2
!
! RECUPERATION DES VALEURS DES PARAMETRES MATERIAU
!
    rrsp = cmat(3)
    vrsp = cmat(4)
    risp = cmat(5)
    visp = cmat(6)
!
! PARAMETRES INTERMEDIAIRES => EQUATION (3.10-1)
!
    urr = rrsp/vrsp
    uii = risp/visp
    uri = rrsp/visp
!
! PARAMETRE INTERMEDIAIRE => EQUATION (3.10-2)
!
    delta = (urr - uii)**2 + 8*uri*(urr + uii) + 16*uri**2
!
! INVERSE DES TEMPS CARACTERISTIQUES => EQUATION (3.10-4)
!
    ambda1 = - (urr + 4*uri + uii + sqrt(delta))/2
    ambda2 = - (urr + 4*uri + uii - sqrt(delta))/2
!
! PARAMETRES INTERMEDIAIRES => EQUATION (3.10-3)
!
    x1 = (ambda1 + uii)/(2*uri)
    x2 = 2*uri/(ambda2 + uii)
!
end subroutine
