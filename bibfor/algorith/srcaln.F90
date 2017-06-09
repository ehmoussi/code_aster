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

subroutine srcaln(s,b,vecn,retcom)

!

!!!
!!! MODELE LKR : CALCUL DE N
!!!

! ===================================================================================
! IN  : S(6)    : DEVIATEUR DES CONTRAINTES
!     : BPRIME  : PARAMETRE BPRIME
! OUT : VECN(6) : N = (BPRIME*S/SII-KRON)/SQRT(BPRIME**2+3)
! ===================================================================================
    
    implicit none
#include "asterc/r8miem.h"
#include "asterfort/lcprsc.h"
#include "asterfort/utmess.h"

    !!!
    !!! Variables globales
    !!!

    integer :: retcom
    real(kind=8) :: b,s(6),vecn(6)
    
    !!!
    !!! Variables locales
    !!!
    
    integer :: i,ndt,ndi
    real(kind=8) :: sii,racine,kron(6),ptit
    common /tdim/ ndt, ndi
    
    data kron /1.d0,1.d0,1.d0,0.d0,0.d0,0.d0/
    
    !!!
    !!! Calcul de sii et verif. qu'il n'est pas nul
    !!!
    
    retcom=0
    ptit=r8miem()

    call lcprsc(s, s, sii)
    sii=sqrt(sii)

    if (sii.lt.ptit) then
        call utmess('A', 'COMPOR1_94')
        retcom=1
        goto 100
    endif
    
    !!!
    !!! Calcul de n
    !!!
    
    racine=sqrt(b*b+3.d0)
    
    do i=1,ndt
        vecn(i)=(b*s(i)/sii-kron(i))/racine
    end do
    
100  continue

end subroutine
