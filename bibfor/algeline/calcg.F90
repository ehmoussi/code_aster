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

subroutine calcg(dfds, vecn, g, devg, traceg,&
                 devgii)
!
    implicit      none
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lcdevi.h"
#include "asterfort/trace.h"
#include "blas/ddot.h"
    real(kind=8) :: dfds(6), vecn(6), g(6), devg(6), traceg, devgii
! --- BUT : RECHERCHE DE LA DIRECTION D'ECOULEMENT ---------------------
! ======================================================================
! IN  : N      : NOMBRE TOTAL DE COMPOSANTES DU TENSEUR ----------------
! --- : ND     : NOMBRE DE COMPOSANTES DIAGONALES DU TENSEUR -----------
! --- : DFDS   : DF/DSIG -----------------------------------------------
! --- : VECN   : VECTEUR N ---------------------------------------------
! OUT : G      : G = DF/DSIG - (DF/DSIG.VECN)VECN ----------------------
! --- : DEVG   : DEVIATEUR DE G ----------------------------------------
! --- : TRACEG : PREMIER INVARIANT DE G --------------------------------
! --- : DEVGII : NORME DU DEVIATEUR ------------------------------------
! ======================================================================
    integer :: ii, ndt, ndi
    real(kind=8) :: fact1
! ======================================================================
    common /tdim/   ndt , ndi
! ======================================================================
    call jemarq()
! ======================================================================
! --- CALCUL DE G ------------------------------------------------------
! ======================================================================
    fact1=ddot(ndt,dfds,1,vecn,1)
    do 10 ii = 1, ndt
        g(ii) = dfds(ii) - fact1*vecn(ii)
10  end do
! ======================================================================
! --- CALCUL DU DEVIATEUR DE G ET DE SA NORME --------------------------
! ======================================================================
    call lcdevi(g, devg)
    devgii=ddot(ndt,devg,1,devg,1)
    devgii = sqrt (devgii)
! ======================================================================
! --- CALCUL DU PREMIER INVARIANT DE G ---------------------------------
! ======================================================================
    traceg = trace(ndi, g)
! ======================================================================
    call jedema()
! ======================================================================
end subroutine
