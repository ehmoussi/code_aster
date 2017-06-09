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

subroutine calcds(hook, devg, devgii, dfds, dfdg,&
                  dsde)
!
    implicit   none
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lcinma.h"
#include "asterfort/lglpma.h"
#include "asterfort/lglpmv.h"
#include "blas/ddot.h"
    real(kind=8) :: hook(6, 6), devg(6), devgii, dfds(6), dfdg, dsde(6, 6)
! --- BUT : CALCUL DE DSDE ---------------------------------------------
! ======================================================================
! IN  : NDT    : DIMENSION TOTAL DU TENSEUR ----------------------------
! --- : HOOK   : MATRICE DE HOOK ---------------------------------------
! --- : DEVG   : DEVIATEUR DE G ----------------------------------------
! --- : DEVGII : NORME DU DEVIATEUR ------------------------------------
! --- : DFDS   : DF/DS -------------------------------------------------
! --- : DFDG   : DF/DGAMP ----------------------------------------------
! OUT : DSDE   : DSIG/DEPS ---------------------------------------------
! ======================================================================
    integer :: i, j, ndt, ndi
    real(kind=8) :: mat(6, 6), tmp(6, 6), num(6, 6), vec(6)
    real(kind=8) :: deux, trois, val, denom
! ======================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------------
! ======================================================================
    parameter       ( deux   = 2.0d0  )
    parameter       ( trois  = 3.0d0  )
! ======================================================================
    common /tdim/   ndt , ndi
! ======================================================================
    call jemarq()
! ======================================================================
! --- CALCUL DU NUMERATEUR ---------------------------------------------
! ======================================================================
    call lcinma(0.d0, dsde)
    call lcinma(0.d0, mat)
    call lcinma(0.d0, tmp)
    call lcinma(0.d0, num)
    do 10 i = 1, ndt
        do 20 j = 1, ndt
            mat(i,j) = devg(i)*dfds(j)
20      continue
10  end do
    call lglpma(ndt, hook, mat, tmp)
    call lglpma(ndt, tmp, hook, num)
! ======================================================================
! --- CALCUL DU DENOMINATEUR -------------------------------------------
! ======================================================================
    call lglpmv('ZERO', ndt, hook, devg, vec)
    val=ddot(ndt,dfds,1,vec,1)
    denom = sqrt(deux/trois)*dfdg*devgii-val
! ======================================================================
! --- CALCUL DE DSIG/DEPS (NON SYMETRIQUE) -----------------------------
! --- STOCKAGE DANS MATRICE TEMPORAIRE AVANT SYMETRISATION -------------
! ======================================================================
    call lcinma(0.d0, tmp)
    do 30 i = 1, ndt
        do 40 j = 1, ndt
            dsde(i,j) = hook(i,j) + num(i,j)/denom
40      continue
30  end do
! ======================================================================
    call jedema()
! ======================================================================
end subroutine
