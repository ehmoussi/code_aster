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

subroutine srdhds(nbmat, mater, s, dhds, retcom)

!

!!!
!!! MODELE LKR : CALCUL DE LA DERIVEE DH(THETA)/DS (H MINUSCULE)
!!!

! ===================================================================================
! IN  : NBMAT          :  NOMBRE DE PARAMETRES MATERIAU
!     : MATER(NBMAT,2) :  COEFFICIENTS MATERIAU A T+DT
!                            MATER(*,1) = CARACTERISTIQUES ELASTIQUES
!                            MATER(*,2) = CARACTERISTIQUES PLASTIQUES
!     : INVAR          : INVARIANT DES CONTRAINTES
!     : S(6)           : DEVIATEUR DES CONTRAINTES
! OUT : DHDS(6)        : DH(THETA)/DS
!     : RETCOM         : CODE RETOUR POUR REDECOUPAGE
! ===================================================================================

    implicit none

#include "asterc/r8miem.h"
#include "asterfort/cjst.h"
#include "asterfort/cos3t.h"
#include "asterfort/lcprsc.h"
#include "asterfort/lcprsv.h"
#include "asterfort/lcsove.h"
#include "asterc/r8pi.h"
#include "asterfort/utmess.h"

    !!!
    !!! Variables globales
    !!!
    
    integer :: nbmat,retcom
    real(kind=8) :: mater(nbmat,2),s(6),dhds(6)
    
    !!!
    !!! Variables locales
    !!!
    
    integer :: ndt,ndi
    real(kind=8) :: gamma,beta,pref,t(6),sii,rcos3t,dets,ptit
    real(kind=8) :: fact1(6),fact2(6),r54,pi,drdcos,dcosds(6)
    common /tdim/ ndt, ndi
    
    !!!
    !!! Recuperation des parametres du modele
    !!!
    
    beta=mater(4,2)
    gamma=mater(5,2)
    pref=mater(1,2)
    r54=sqrt(54.d0)
    pi=r8pi()
    
    !!!
    !!! Calcul du deviateur des contraintes
    !!!
    
    retcom=0
    ptit=r8miem()
    call lcprsc(s,s,sii)
    sii=sqrt(sii)
    
    !!! on verifie si sii n'est pas nul car division par sii dans la routine
    if (sii.lt.ptit) then
        call utmess('A','COMPOR1_92')
        retcom=1
        goto 1000
    endif
    
    !!!
    !!! Calcul de cos(3theta), det(s) et d(det(s))/d(s)
    !!!
    
    rcos3t=cos3t(s,pref,1.d-8)
    dets=(sii**3.d0)*rcos3t/r54
    
    call cjst(s,t)
    
    !!!
    !!! Calcul de d(r(theta))/d(cos(3theta))
    !!!
    
    drdcos=-r54*gamma*sin(beta*pi/6.d0-1.d0/3.d0*acos(gamma*rcos3t))/&
            3.d0/sqrt(1.d0-(gamma*rcos3t)**2.d0)
    
    !!!
    !!! Calcul de d(cos(3theta))/d(s)
    !!!
    
    call lcprsv(1.d0/sii**3.d0,t,fact1)
    call lcprsv(-3.d0*dets/sii**5.d0,s,fact2)
    call lcsove(fact1,fact2,dcosds)
    
    !!!
    !!! Calcul final
    !!!
    call lcprsv(drdcos,dcosds,dhds)
    
1000  continue

end subroutine
