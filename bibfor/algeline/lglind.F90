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

subroutine lglind(nbmat, mater, parame, ge, q,&
                  vecn, deps, devg, devgii, traceg,&
                  dy)
!
    implicit      none
#include "asterfort/calcg.h"
#include "asterfort/drfdrs.h"
#include "asterfort/drudrs.h"
#include "asterfort/hlode.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lceqvn.h"
    integer :: nbmat
    real(kind=8) :: mater(nbmat, 2), parame(5), q(6), vecn(6), ge
    real(kind=8) :: deps(6), devg(6), devgii, traceg, dy(10)
! --- BUT : CALCUL DU PREMIER MULTIPLICATEUR PLASTIQUE (CAS GAMP = 0) --
! ======================================================================
! IN  : NDT    : NOMBRE DE COMPOSANTES TOTALES DU TENSEUR --------------
! --- : NDI    : NOMBRE DE COMPOSANTES DIAGONALES DU TENSEUR -----------
! --- : NR     : NOMBRE DE RELATIONS NON LINEAIRES ---------------------
! --- : NBMAT  : NOMBRE DE PARAMETRES MATERIAU -------------------------
! --- : MATER  : PARAMETRES MATERIAU -----------------------------------
! --- : PARAME : VARIABLES D'ECROUISSAGES ------------------------------
! --- : GE     : GE ----------------------------------------------------
! --- : Q      : DG/DS -------------------------------------------------
! --- : VECN   : VECTEUR N ---------------------------------------------
! --- : DEPS   : INCREMENT DE DEFORMATIONS DEPUIS L'INSTANT PRECEDENT --
! OUT : DEVG   : DEVIATEUR DE G ----------------------------------------
! --- : DEVGII : NORME DU DEVIATEUR DE G -------------------------------
! --- : TRACEG : TRACE DU TENSEUR G ------------------------------------
! --- : DY     : INCREMENTS (SIG, I1, GAMP, EVP, DELTA) ----------------
! ======================================================================
    integer :: ii, ndt, ndi
    real(kind=8) :: gammax, mu, k, gamcjs, sigc, h0, dgamp, ddelta
    real(kind=8) :: duds(6), dfds(6), g(6), ds(6), dinv, mun, deux, trois, dix
    real(kind=8) :: devp
! ======================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------------
! ======================================================================
    parameter       ( mun    = -1.0d0  )
    parameter       ( deux   =  2.0d0  )
    parameter       ( trois  =  3.0d0  )
    parameter       ( dix    = 10.0d0  )
! ======================================================================
    common /tdim/   ndt , ndi
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
! --- CALCUL DE DFDS ---------------------------------------------------
! ======================================================================
    call drfdrs(q, parame, h0, sigc, ge,&
                duds, dfds)
! ======================================================================
! --- CALCUL DE G ------------------------------------------------------
! ======================================================================
    call calcg(dfds, vecn, g, devg, traceg,&
               devgii)
! ======================================================================
! --- CALCUL DU PREMIER INCREMENT DE GAMP ------------------------------
! ======================================================================
    gammax = 0.0d0
    do 10 ii = 1, ndt
        if (abs(deps(ii)) .gt. gammax) gammax = abs(deps(ii))
10  end do
    dgamp = gammax / dix
! ======================================================================
! --- CALCUL DU PREMIER DELTA ------------------------------------------
! ======================================================================
    ddelta = dgamp*sqrt(trois/deux)/devgii
! ======================================================================
! --- CALCUL DU PREMIER INCREMENT DU DEVIATEUR DES CONTRAINTES ---------
! ======================================================================
    do 20 ii = 1, ndt
        ds(ii) = mun * deux * mu * ddelta * devg(ii)
20  end do
! ======================================================================
! --- CALCUL DU PREMIER INCREMENT DU PREMIER INVARIANT DES CONTRAINTES -
! ======================================================================
    dinv = mun * trois * k * ddelta * traceg
! ======================================================================
! --- CALCUL DU PREMIER INCREMENT DE EVP -------------------------------
! ======================================================================
    devp = ddelta * traceg
! ======================================================================
! --- STOCKAGE ---------------------------------------------------------
! ======================================================================
    call lceqvn(ndt, ds(1), dy(1))
    dy(ndt+1)=dinv
    dy(ndt+2)=dgamp
    dy(ndt+3)=devp
    dy(ndt+4)=ddelta
! ======================================================================
    call jedema()
! ======================================================================
end subroutine
