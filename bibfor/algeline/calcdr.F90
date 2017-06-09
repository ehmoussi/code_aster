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

subroutine calcdr(nbmat, mater, parame, derive, g,&
                  i, q, devg, devgii, traceg,&
                  dfdl)
!
    implicit      none
#include "asterfort/drfdrg.h"
#include "asterfort/drfdrs.h"
#include "asterfort/drfnew.h"
#include "asterfort/drudrg.h"
#include "asterfort/drudrs.h"
#include "asterfort/hlode.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: nbmat
    real(kind=8) :: mater(nbmat, 2), parame(5), derive(4), g, i
    real(kind=8) :: q(6), devg(6), devgii, traceg, dfdl
! --- BUT : CALCUL DE DF/DLAMBDA POUR LES ITERATIONS DE NEWTON ---------
! ======================================================================
! IN  : NDT    : NOMBRE DE COMPOSANTES TOTALES D'UN TENSEUR ------------
! --- : NDI    : NOMBRE DE COMPOSANTES DIAGONALES D'UN TENSEUR ---------
! --- : NBMAT  : NOMBRE DE PARAMETRES MATERIAU -------------------------
! --- : MATER  : PARAMETRES MATERIAU -----------------------------------
! --- : PARAME : VARIABLES D'ECROUISSAGE -------------------------------
! --- : DERIVE : DERIVEES DES VARIABLES D'ECROUISSAGE ------------------
! --- : G      : G(S) A L'ITERATION COURANTE ---------------------------
! --- : I      : 1ER INVARIANT DES CONTRAINTES A L'ITERATION COURANTE --
! --- : Q      : DG/DS A L'ITERATION COURANTE --------------------------
! --- : DEVG   : DEVIATEUR DU TENSEUR G, DIRECTION D'ECOULEMENT --------
! --- : DEVGII : NORME DE DEVG -----------------------------------------
! --- : TRACEG : 1ER INVARIANT DE G ------------------------------------
! OUT : DFDL   : DERIVEE A L'ITERATION COURANTE ------------------------
! ======================================================================
    real(kind=8) :: mun, mu, k, sigc, gamcjs, h0
    real(kind=8) :: duds(6), dudg, dfds(6), dfdg
! ======================================================================
! --- INITIALISATION DE PARAMETRE --------------------------------------
! ======================================================================
    parameter       ( mun    = -1.0d0  )
! ======================================================================
    call jemarq()
! ======================================================================
! --- RECUPERATION DES PARAMETRES MATERIAU -----------------------------
! ======================================================================
    mu = mater( 4,1)
    k = mater( 5,1)
    sigc = mater( 9,2)
    gamcjs = mater(12,2)
! ======================================================================
! --- CALCUL DE H0, CALCUL INTERMEDIAIRE -------------------------------
! ======================================================================
    h0 = hlode(gamcjs, mun)
! ======================================================================
! --- CALCUL DE DUDS ---------------------------------------------------
! ======================================================================
    call drudrs(parame, q, h0, sigc, duds)
! ======================================================================
! --- CALCUL DE DUDG ---------------------------------------------------
! ======================================================================
    call drudrg(parame, derive, h0, sigc, g,&
                i, dudg)
! ======================================================================
! --- CALCUL DE DFDS ---------------------------------------------------
! ======================================================================
    call drfdrs(q, parame, h0, sigc, g,&
                duds, dfds)
! ======================================================================
! --- CALCUL DE DFDG ---------------------------------------------------
! ======================================================================
    call drfdrg(parame, derive, h0, sigc, g,&
                dudg, dfdg)
! ======================================================================
! --- CALCUL DE DFDL ---------------------------------------------------
! ======================================================================
    call drfnew(devg, devgii, traceg, dfds, dfdg,&
                mu, k, dfdl)
! ======================================================================
    call jedema()
! ======================================================================
end subroutine
