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

function domrev(gamcjs, sigc, parame, rgdev, rucpla)
!
    implicit      none
#include "asterfort/hlode.h"
    real(kind=8) :: gamcjs, sigc, parame(5), rgdev, rucpla, domrev
! --- BUT : CALCUL DU DOMAINE DE REVERSIBILITE -------------------------
! ======================================================================
! IN  : NBMAT  : NOMBRE DE PARAMETRES DU MODELE ------------------------
! --- : MATER  : PARAMETRES DU MODELE ----------------------------------
! --- : PARAME : VARIABLES D'ECROUISSAGE -------------------------------
! --- : RGDEV  : FONCTION G(S) -----------------------------------------
! --- : RUCPLA : CRITERE PLASTIQUE -------------------------------------
! OUT : DOMREV : DOMAINE DE REVERSIBILITE (FORMULATION BIS) ------------
! ======================================================================
    real(kind=8) :: agamp, h0, mun, un
! ======================================================================
! --- INITIALISATION ---------------------------------------------------
! ======================================================================
    parameter       ( mun    = -1.0d0  )
    parameter       (  un    =  1.0d0  )
    agamp = parame(2)
! ======================================================================
! --- CALCUL DE H0 = (1-GAMMA_CJS)**(1/6) ------------------------------
! ======================================================================
    h0 = hlode(gamcjs, mun)
! ======================================================================
! --- CALCUL DE FBIS = (G(S)/(SIG_C*H0))**(1/A(GAMP))-U(GAMP) ----------
! ======================================================================
    domrev = (rgdev/(sigc*h0))**(un/agamp) - rucpla
! ======================================================================
end function
