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

subroutine srdfdx(nbmat,mater,ucrip,invar,s,paraep,varpl,derpar,dfdxip)

!

!!!
!!! MODELE LKR : CALCUL DE DF/DXI
!!!

! ===================================================================================
! IN  : NBMAT          : NOMBRE DE PARAMETRES DU MODELE
!     : MATER(NBMAT,2) : PARAMETRES DU MODELE
!     : UCRIP          : PARTIE SOUS LA PUISSANCE DANS LE CRITERE
!     : INVAR          : INVARIANT TCONTRAINTES
!     : S(6)           : DEVIATEUR DES CONTRAINTES
!     : PARAEP(3)      : VARIABLE D'ECROUISSAGE
!                           PARAEP(1) = AXIP
!                           PARAEP(2) = SXIP
!                           PARAEP(3) = MXIP
!     : VARPL(4)       : VARPL(1) = ADXIP
!                        VARPL(2) = BDXIP
!                        VARPL(3) = DDXIP
!                        VARPL(4) = KDXIP
!     : DERPAR(3)      : DERPAR(1) = DAD
!                        DERPAR(2) = DSD
!                        DERPAR(3) = DMD
! OUT : DFDXIP         : DF*/DXI*
! ===================================================================================

    implicit      none

#include "asterfort/cos3t.h"
#include "asterfort/lcprsc.h"
#include "asterfort/srhtet.h"

    !!!
    !!! Variables globales
    !!!
    
    integer :: nbmat
    real(kind=8) :: mater(nbmat,2),ucrip,s(6),paraep(3),varpl(4),derpar(3)
    real(kind=8) :: dfdxip,invar
    
    !!!
    !!! Variables locales
    !!!
    
    real(kind=8) :: pref,sigc,rcos3t,r0c,rtheta,sii
    real(kind=8) :: dfdad,dfdsd,dfdmd,fact1,fact3,fact4,fact5
    
    !!!
    !!! Recuperation des parametres du modele
    !!!
    
    sigc=mater(3,2)
    pref=mater(1,2)
    
    !!!
    !!! Calcul de sii et recuperation de h0c et h(theta)
    !!!
    
    call lcprsc(s,s,sii)
    sii=sqrt(sii)
    
    rcos3t=cos3t(s,pref,1.d-8)
    call srhtet(nbmat,mater,rcos3t,r0c,rtheta)
    
    !!!
    !!! Calcul de df*/ds*
    !!!
    
    fact1=-paraep(1)*varpl(4)*sigc*r0c
    
    if (ucrip.gt.0.d0) then
        dfdsd=fact1*ucrip**(paraep(1)-1.d0)
    else
        dfdsd=0.d0
    endif
    
    !!!
    !!! Calcul de df*/dm*
    !!!
    
    if (ucrip.gt.0.d0) then
        
        fact3=-paraep(1)*sigc*r0c
        fact4=varpl(1)*sii*rtheta/paraep(3)
        fact5=varpl(2)*invar/paraep(3)
        dfdmd=fact3*(fact4+fact5)*ucrip**(paraep(1)-1.d0)
        
    else
        
        dfdmd=0.d0
        
    endif
    
    !!!
    !!! Calcul de df*/da*
    !!!
    
    if (ucrip.gt.0.d0) then
        
        dfdad=-sigc*r0c*log(ucrip/varpl(4))*ucrip**paraep(1)
        
    else
        
        dfdad=0.d0
        
    endif
    
    !!!
    !!! Assemblage
    !!!
    
    dfdxip=derpar(1)*dfdad+derpar(2)*dfdsd+derpar(3)*dfdmd

end subroutine
