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

function ucritp(nbmat, mater, parame, rgdev, invar1)
!
    implicit      none
#include "asterfort/hlode.h"
    integer :: nbmat
    real(kind=8) :: mater(nbmat, 2), parame(5), rgdev, invar1, ucritp
! --- BUT : CALCUL DU CRITERE PLASTIQUE --------------------------------
! ======================================================================
! IN  : NBMAT  : NOMBRE DE PARAMETRES DU MODELE ------------------------
! --- : MATER  : PARAMETRES DU MODELE ----------------------------------
! --- : PARAME : VARIABLES D'ECROUISSAGE -------------------------------
! --- : RGDEV  : FONCTION G(S) -----------------------------------------
! --- : INVAR1 : PREMIER INVARIANT DES CONTRAINTES ---------------------
! OUT : UCRITP = U(SIG,GAMP) -------------------------------------------
! ------------ = - M(GAMP)*K(GAMP)*G(S)/(RAC(6)*SIGMA_C*H0 -------------
! ------------ : - M(GAMP)*K(GAMP)*I1/(3*SIGMA_C) ----------------------
! ------------ : + S(GAMP)*K(GAMP) -------------------------------------
! ======================================================================
    real(kind=8) :: sgamp, kgamp, mgamp, mun, trois, six
    real(kind=8) :: h0, fact1, fact2, fact3, sigc, gamcjs
! ======================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------------
! ======================================================================
    parameter       ( mun    = -1.0d0  )
    parameter       ( trois  =  3.0d0  )
    parameter       ( six    =  6.0d0  )
! ======================================================================
! --- RECUPERATION DES PARAMETRES MATERIAU -----------------------------
! ======================================================================
    sigc = mater( 9,2)
    gamcjs = mater(12,2)
! ======================================================================
! --- RECUPERATION DES VARIABLES D'ECROUISSAGE -------------------------
! ======================================================================
    sgamp = parame(1)
    kgamp = parame(3)
    mgamp = parame(4)
! ======================================================================
! --- CALCUL DE H0 = (1-GAMCJS)**(1/6) ---------------------------------
! ======================================================================
    h0 = hlode(gamcjs, mun)
! ======================================================================
! --- CALCUL DE U(SIG,GAMP) --------------------------------------------
! ======================================================================
    fact1 = mun*mgamp*kgamp*rgdev/(sqrt(six)*sigc*h0)
    fact2 = mun*mgamp*kgamp*invar1/(trois*sigc)
    fact3 = sgamp*kgamp
    ucritp = fact1 + fact2 + fact3
! ======================================================================
end function
