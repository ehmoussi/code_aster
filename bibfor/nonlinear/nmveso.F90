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

subroutine nmveso(rb, nb, rp, np, drbdb,&
                  drbdp, drpdb, drpdp, dp, dbeta,&
                  nr, cplan)
    implicit none
!
#include "asterf_types.h"
#include "asterfort/lceqvn.h"
#include "asterfort/lcicma.h"
#include "asterfort/lcpsvn.h"
#include "asterfort/mgauss.h"
    integer :: nb, np, nr
    aster_logical :: cplan
    real(kind=8) :: rb(nb), rp(np), drbdb(nb, nb), drbdp(nb, np)
    real(kind=8) :: dp(np), dbeta(nb), drpdp(np, np), drpdb(np, nb)
! ----------------------------------------------------------------------
!     INTEGRATION DE LA LOI DE COMPORTEMENT VISCO PLASTIQUE DE
!     CHABOCHE AVEC ENDOMAGEMENT
!     METHODE ITERATIVE D'EULER IMPLICITE
!
!     GENERATION ET RESOLUTION DU SYSTEME LINEAIRE DRDY(DY).DDY = -R(DY)
!-----------------------------------------------------------------------
    integer :: nmod, i, iret
    real(kind=8) :: zero, un, mun, det
    parameter  ( nmod = 25 )
    parameter  ( zero = 0.d0   )
    parameter  ( un   = 1.d0   )
    parameter  ( mun   = -1.d0   )
!
    real(kind=8) :: drdy(nmod, nmod), r(nmod)
!
!
!-----------------------------------------------------------------------
!-- 1. INITIALISATIONS
!-- 1.1. INITIALISATION DE L OPERATEUR LINEAIRE DU SYSTEME
!                     DRDY = ( DRBDB, DRBDP )
!                            ( DRPDB, DRPDP )
!
    call lcicma(drbdb, nb, nb, nb, nb,&
                1, 1, drdy, nmod, nmod,&
                1, 1)
    call lcicma(drbdp, nb, np, nb, np,&
                1, 1, drdy, nmod, nmod,&
                1, nb+1)
    call lcicma(drpdb, np, nb, np, nb,&
                1, 1, drdy, nmod, nmod,&
                nb+1, 1)
    call lcicma(drpdp, np, np, np, np,&
                1, 1, drdy, nmod, nmod,&
                nb+1, nb+1)
!
!-- 1.2. INITIALISATION R = ( -RB , -RP )
!
    call lcpsvn(nb, mun, rb, r)
    call lcpsvn(np, mun, rp, r(nb+1))
!
!-- 2. RESOLUTION DU SYSTEME LINEAIRE DRDY(DY).DDY = -R(DY)
!
    if (cplan) then
        r(3) = zero
        do 110 i = 1, nr
            drdy(i,3) = zero
            drdy(3,i) = zero
110     continue
        drdy(3,3) = un
    endif
!
    call mgauss('NFVP', drdy, r, nmod, nr,&
                1, det, iret)
    call lceqvn(nb, r, dbeta)
    call lceqvn(np, r(nb+1), dp)
!
end subroutine
