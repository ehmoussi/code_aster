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

subroutine mbvfie(nno,kpg,dff,sigpk2,ipoids,h,covadef,vecfie)
!
    implicit none
#include "asterfort/r8inir.h"
#include "jeveux.h"
!
    integer :: nno, kpg
    integer :: ipoids
    real(kind=8) :: h
    real(kind=8) :: sigpk2(2, 2)
    real(kind=8) :: dff(2, nno), covadef(3,3)
    real(kind=8) :: vecfie(3*nno)
! ----------------------------------------------------------------------
!    - FONCTION REALISEE:  CALCUL DU VECTEUR FORCE INTERNE ELEMENTAIRE
!                          POUR LES MEMBRANES EN GRANDES DEFORMATIONS
! ----------------------------------------------------------------------
! IN  NNO          NOMBRE DE NOEUDS
!     KPG          INCREMENT SUR LA BOUCLE DES PTS DE GAUSS
!     DFF          DERIVEE DES F. DE FORME
!     SIGPK2       CONTRAINTES DE PIOLA KIRCHHOFF
!     IPOIDS       ADRESSE DANS ZR DU TABLEAU POIDS
!     H            EPAISSEUR DE LA MEMBRANES
!     COVADEF      BASE COVARIANTE SUR LA CONFIGURATION DEFORMEE
!
! OUT VECFIE       VECTEUR FORCE INTERNE
! ----------------------------------------------------------------------
!
    integer :: a, p, i, alpha, gamma
    
    call r8inir(3*nno, 0.d0, vecfie, 1)
    
    do a = 1, nno
        do p = 1, 3
            i = 3*(a-1) + p
            
            do alpha = 1, 2
                do gamma = 1, 2
                    vecfie(i) = vecfie(i) + dff(alpha,a)*covadef(p,gamma)*&
                                sigpk2(gamma,alpha)*h*zr(ipoids+kpg-1)
                end do
            end do
        end do
    end do
    
end subroutine
