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

subroutine mbtgin(nno,kpg,dff,sigpk2,dsigpk2,ipoids,h,covadef,ktgt)
!
    implicit none
#include "asterfort/r8inir.h"
#include "asterf_types.h"
#include "jeveux.h"
!
    integer :: nno, kpg
    integer :: ipoids
    real(kind=8) :: h
    real(kind=8) :: sigpk2(2, 2), dsigpk2(2, 2, 2, 2)
    real(kind=8) :: dff(2, nno), covadef(3,3)
    real(kind=8) :: ktgt(3*nno,3*nno)
! ----------------------------------------------------------------------
!    - FONCTION REALISEE:  CALCUL DE LA MATRICE TANGENTE ELEMENTAIRE DUE
!                          AUX EFFORTS INTERNES POUR LES MEMBRANES EN 
!                          GRANDES DEFORMATIONS
! ----------------------------------------------------------------------
! IN  NNO          NOMBRE DE NOEUDS
!     KPG          INCREMENT SUR LA BOUCLE DES PTS DE GAUSS
!     DFF          DERIVEE DES F. DE FORME
!     SIGPK2       CONTRAINTES DE PIOLA KIRCHHOFF
!     DSIGPK2      DERIVEES DES CONTRAINTES DE PIOLA KIRCHHOFF
!     IPOIDS       ADRESSE DANS ZR DU TABLEAU POIDS
!     H            EPAISSEUR DE LA MEMBRANES
!     COVADEF      BASE COVARIANTE SUR LA CONFIGURATION DEFORMEE
!
! OUT KTGT          MATRICE TANGENTE
! ----------------------------------------------------------------------
!
    integer :: a, b, p, q, i, j, alpha, beta, gamma, delta, kron
    
    call r8inir(3*nno*3*nno, 0.d0, ktgt, 1)
    
    do a= 1, nno
        do b = 1, nno
            do p = 1, 3
                do q = 1, 3
                    i = 3*(a-1) + p
                    j = 3*(b-1) + q
                    
                    if (p .eq. q) then
                        kron = 1
                    else
                        kron = 0
                    endif
                    
                    do alpha = 1, 2
                        do beta = 1, 2
                            do gamma = 1, 2
                                do delta = 1, 2
                                    
                                    ktgt(i,j) = ktgt(i,j) +                             &
                                                dff(alpha,a)*dff(beta,b)*(              &
                                                kron*sigpk2(beta,alpha) +               &
                                                0.5*covadef(p,gamma)*covadef(q,delta)*( &
                                                dsigpk2(gamma,alpha,beta,delta) +       &
                                                dsigpk2(gamma,alpha,delta,beta)))*      &
                                                h*zr(ipoids+kpg-1)
                                    
                                end do
                            end do
                        end do
                    end do

                end do
            end do
        end do
    end do
      
end subroutine
