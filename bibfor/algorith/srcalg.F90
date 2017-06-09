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

subroutine srcalg(dfdsig, vecn, g, devgii)

!

!!!
!!! MODELE LKR : CALCUL DE G = DF/DSIG - (DF/DSIG*N)*N
!!!

! ===================================================================================
! IN  : DFDSIG(6) : DF/DSIG(6)
!     : VECN(6)   : N = (BPRIME*S/SII - KRON)/SQRT(BPRIME**2 + 3)
! OUT : G(6)      : G = DF/DSIG - (DF/DSIG*N)*N
!     : DEVGII    : SECOND INVARIANT DE G = DEV(G)
! ===================================================================================

    implicit      none

#include "asterfort/lcdevi.h"
#include "asterfort/lcprsc.h"
#include "asterfort/r8inir.h"

    !!!
    !!! Variables globales
    !!!
    
    integer :: ndi,ndt,i
    real(kind=8) :: dfdsig(6),vecn(6),g(6),devgii
    common /tdim/ ndt,ndi
    
    !!!
    !!! Variables locales
    !!!
    
    real(kind=8) :: devg(6),fact1
    
    !!!
    !!! Calcul de g
    !!!
    call r8inir(6,0.d0,g,1)
    call lcprsc(dfdsig,vecn,fact1)
    
    do i=1,ndt
        g(i)=dfdsig(i)-fact1*vecn(i)
    end do
    
    !!!
    !!! Calcul du deviateur de g et de sa norme
    !!!
    
    call lcdevi(g,devg)
    call lcprsc(devg,devg,devgii)
    
    devgii=sqrt(devgii)

end subroutine
