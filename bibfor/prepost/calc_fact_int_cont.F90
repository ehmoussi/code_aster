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

subroutine calc_fact_int_cont(nbnoe, sigma, abscr, prodef, trans, &
                              k1a, k1b)
!
    implicit none
#include "asterc/r8pi.h"
#include "asterc/r8prem.h"
    integer :: nbnoe
    real(kind=8) :: sigma(nbnoe), abscr(nbnoe), trans
    real(kind=8) :: prodef, k1a, k1b
! --- BUT : CALCUL DES FACTEURS D'INTENSITE DE CONTRAINTES ELASTIQUES
! ======================================================================
! IN  : nbnoe  : NOMBRE DE NOEUDS COTE REVETEMENT ----------------------
! --- : sigma  : CONTRAINTES -------------------------------------------
! --- : abscr  : ABSCISSES CURVILIGNES ---------------------------------
! --- : prodef : PROFONDEUR DU DEFAUT ----------------------------------
! --- : trans  : translation pour changement de repere -----------------
! OUT : k1a    : FACTEUR D'INTENSITE DE CONTRAINTES POINTE A -----------
! --- : k1b    : FACTEUR D'INTENSITE DE CONTRAINTES POINTE B -----------
! ======================================================================
! ======================================================================
    integer :: ific
    real(kind=8) :: zero, un, deux, gamma1, gamma2
    real(kind=8) :: a,  pi, alpha, beta
    real(kind=8) :: gamx, gamy
! ======================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------------
! ======================================================================
    parameter       ( zero   =  0.0d0 )
    parameter       ( un     =  1.0d0 )
    parameter       ( deux   =  2.0d0 )
! ======================================================================
! --- INITIALISATIONS DES VARIABLES NECESSAIRE AU CALCUL ---------------
! ======================================================================
    a = prodef/deux
    pi = r8pi()
! ====================================================
! --- CALCULS DES FACTEURS D'INTENSITE DE CONTRAINTES 
! ====================================================
    do 20 ific = 1, nbnoe-1
        alpha = ( sigma(ific+1) - sigma(ific) ) / ( abscr(ific+1) - abscr(ific))
        beta  =   sigma(ific)   - alpha * ( abscr(ific) + trans )
        gamx  = ( abscr(ific)   + trans )
        gamy = sqrt( abs(a*a - gamx*gamx) )
        if (gamy .le. r8prem()) then
            if (gamx .lt. zero) then
                gamma1 = - pi / deux
            else
                gamma1 = pi / deux
            endif
        else
            gamma1 = atan2( gamx/gamy , un )
        endif
        gamx = ( abscr(ific+1 ) + trans )
        gamy = sqrt( abs(a*a - gamx*gamx) )
        if (gamy .le. r8prem()) then
            if (gamx .lt. zero) then
                gamma2 = - pi / deux
            else
                gamma2 = pi / deux
            endif
        else
            gamma2 = atan2( gamx/gamy , un )
        endif
        k1a = k1a + (beta-alpha*a/2) * (gamma2-gamma1) + (beta-alpha* a) * (cos(gamma2)-cos(gamma&
              &1)) + alpha*a*(sin(2*gamma2)-sin(2* gamma1))/4
        k1b = k1b + (beta+alpha*a/2) * (gamma2-gamma1) - (beta+alpha* a) * (cos(gamma2)-cos(gamma&
              &1)) - alpha*a*(sin(2*gamma2)-sin(2* gamma1))/4
20  continue

end subroutine
