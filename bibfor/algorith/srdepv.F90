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

subroutine srdepv(depsv, ddepsv, dgamv, ddgamv)

!

!!!
!!! MODELE LKR : DERIVEE DE LA DEF. VISCO. ET DU PARAMETRE D ECROUISSAGE VISCO.
!!!

! ===================================================================================
! IN  : DT     : PAS DE TEMPS
!     : DEPSV  : DEFORMATIONS VISCO.
! OUT : DDEPSV : DEFORMATIONS DEVIATORIQUES VISQUEUSES
!     : DGAMV  : PARAMETRE D ECROUISSAGE VISQUEUX
!     : DDGAMV : DERIVEE DU PARAMETRE D ECROUISSAGE VISQUEUX PAR  RAPPORT A DEPS
! ===================================================================================

    implicit    none

#include "asterfort/lcdevi.h"
#include "asterfort/lcprmv.h"
#include "asterfort/lctrma.h"
#include "asterfort/r8inir.h"

    !!!
    !!! Variables globales
    !!!
    
    real(kind=8) :: depsv(6), ddepsv(6)
    real(kind=8) :: dgamv, ddgamv(6)
    
    !!!
    !!! Variables locales 
    !!!
    
    integer :: i, k, ndi, ndt
    real(kind=8) :: devia(6,6), deviat(6,6)
    common /tdim/   ndt , ndi
    
    !!!
    !!! Deviateur du tenseur des def. visco.
    !!!
    
    call lcdevi(depsv, ddepsv)

    !!!
    !!! Calcul de dgamv
    !!!
    
    dgamv=0.d0
    
    do i=1, ndt
        dgamv=dgamv+ddepsv(i)**2
    end do
    
    dgamv=sqrt(2.d0/3.d0*dgamv)
    
    !!!
    !!! Matrice de projection dev.
    !!!
    
    call r8inir(6*6, 0.d0, devia, 1)
    
    do i=1, 3
        do k=1, 3
            devia(i,k)=-1.d0/3.d0
        end do
    end do
    
    do i=1, ndt
        devia(i,i)=devia(i,i)+1.d0
    end do
    
    call lctrma(devia, deviat)
    
    !!!
    !!! Calcul de dgamv/deps
    !!!
    
    call r8inir(6, 0.d0, ddgamv, 1)
    
    if (dgamv.le.0.d0) then
        do i=1, ndt
            ddgamv(i)=0.d0
        end do
    else
        call lcprmv(deviat, ddepsv, ddgamv)
        do i = 1, ndt
            ddgamv(i)=2.d0/3.d0*ddgamv(i)/dgamv
        end do
    endif

end subroutine
