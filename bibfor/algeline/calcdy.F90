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

subroutine calcdy(mu, k, f0, devg, devgii,&
                  traceg, dfdl, delta, dy)
!
    implicit      none
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lceqvn.h"
    real(kind=8) :: mu, k, f0, devg(6), devgii, traceg
    real(kind=8) :: dfdl, delta, dy(10)
! --- BUT : CALCUL DE DY -----------------------------------------------
! ======================================================================
! IN  : NDT    : NOMBRE DE COMPOSANTES TOTALES DU TENSEUR --------------
! --- : NR     : NOMBRE DE COMPOSANTES NON LINEAIRES -------------------
! --- : MU     : PARAMETRE MATERIAU ------------------------------------
! --- : K      : PARAMETRE MATERIAU ------------------------------------
! --- : F0     : VALEUR SEUIL A L'INSTANT 0 ----------------------------
! --- : DEVG   : DEVIATEUR DE G ----------------------------------------
! --- : DEVGII : NORME DU TENSEUR DEVG ---------------------------------
! --- : TRACEG : TRACE DE G --------------------------------------------
! --- : DFDL   : DF/DLAMBDA --------------------------------------------
! --- : DELTA  : DELTA LAMBDA INITIAL ----------------------------------
! OUT : DY     : INCREMENTS DE L'ITERATION COURANTE --------------------
! ======================================================================
    integer :: ii, ndt, ndi
    real(kind=8) :: ddelta, dgamp, dsn(6), dinv, devp, mun, deux, trois
! ======================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------------
! ======================================================================
    parameter       ( mun    =  -1.0d0  )
    parameter       ( deux   =   2.0d0  )
    parameter       ( trois  =   3.0d0  )
! ======================================================================
    common /tdim/   ndt , ndi
! ======================================================================
    call jemarq()
! ======================================================================
! --- CALCUL DES INCREMENTS --------------------------------------------
! ======================================================================
    ddelta = mun * f0 / dfdl
    delta = delta + ddelta
    dgamp = delta * sqrt(deux/trois) * devgii
    do 10 ii = 1, ndt
        dsn(ii) = mun * deux * mu * delta * devg(ii)
10  end do
    dinv = mun * trois * k * delta * traceg
    devp = delta * traceg
! ======================================================================
! --- STOCKAGE ---------------------------------------------------------
! ======================================================================
    call lceqvn(ndt, dsn(1), dy(1))
    dy(ndt+1)=dinv
    dy(ndt+2)=dgamp
    dy(ndt+3)=devp
    dy(ndt+4)=ddelta


! ======================================================================
    call jedema()
! ======================================================================
end subroutine
