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

subroutine srdepp(vin,nvi,nbmat,mater,paraep,derpar)

!

!!!
!!! MODELE LKR : DERIVEES DES PARAMETRES D'ECROUISSAGE PAR RAPPORT A XIP
!!!

! ===================================================================================
! IN  : VIN(NVI)       : VECTEUR DES VARIABLES INTERNES ( ICI XIP)
!     : NVI            : NOMBRE DE VARIABLES INTERNES
!     : NBMAT          : NOMBRE DE PARAMETRES DU MODELE
!     : MATER(NBMAT,2) : PARAMETRES DU MODELE
!     : PARAEP(3)      : PARAMETRES D'ECROUISSAGE
!                           PARA(1) = AXIP
!                           PARA(2) = SXIP
!                           PARA(3) = MXIP
! OUT : DERPAR(3) : DERIVEES DES PARAMETRES D'ECROUISSAGE
!                        DERPAR(1) = DA/DXIP
!                        DERPAR(2) = DS/DXIP
!                        DERPAR(3) = DM/DXIP
! ===================================================================================

    implicit      none
    
    !!!
    !!! Variable globales
    !!!
    
    integer :: nbmat,nvi
    real(kind=8) :: vin(nvi),paraep(3),mater(nbmat,2),derpar(3)
    
    !!!
    !!! Variables locales
    !!!
    
    real(kind=8) :: xi2,xi1,m0,m1,a2,a1,s0,s1,v1,v2,sigc,qi,fi
    real(kind=8) :: fact1,fact2,ap,fact3
    real(kind=8) :: dsp,dap,dmp,xip,dtmp,qi0,m00,m10,xi10,xi20
    real(kind=8) :: rq,rm,rs,rx1,rx2,trr,tmm
    
    !!!
    !!! Recuperation de parametres du modele
    !!!
    
    !!! Parametres a T0
    sigc=mater(3,2)
    v1=mater(6,2)
    v2=mater(7,2)
    a1=5.0d-1
    a2=mater(8,2)
    m00=mater(9,2)
    m10=mater(10,2)
    qi0=mater(11,2)
    xi10=mater(12,2)
    xi20=mater(13,2)
    rq=mater(21,2)
    rm=mater(22,2)
    rs=mater(23,2)
    rx1=mater(24,2)
    rx2=mater(25,2)
    
    !!! Temperatures
    trr=mater(8,1)
    tmm=mater(6,1)
    
    !!! Parametres a T
    if ((tmm.ge.trr).and.(trr.gt.0.d0)) then
        qi=qi0*(1.d0-rq*log(tmm/trr))
        dtmp=tmm-trr
    else
        qi=qi0
        dtmp=0.d0
    endif
    
    m0=m00*exp(-rm*(dtmp**2.d0))
    m1=m10*exp(-rm*(dtmp**2.d0))
    s1=1.d0*exp(-rs*(dtmp**2.d0))
    xi1=xi10*exp(rx1*dtmp)
    xi2=xi20*exp(rx2*dtmp)
    s0=(m0*1.d-1/(1.d0-1.d-1**2.d0))**2.d0
    fi=qi/sigc
    
    !!! Parametre d'ecrouissage a
    ap=paraep(1)
    
    !!!
    !!! Calcul des derivees pour 0 .le. xip .lt. xi1
    !!!
    
    xip=vin(1)
    
    if ((xip.ge.0.d0).and.(xip.lt.xi1)) then
        
        fact1=v1*((1.d0-xip/xi1)**(v1-1.d0))/xi1
        dap=0.d0
        dsp=(s1-s0)*fact1
        dmp=(m1-m0)*fact1
    
    !!!
    !!! Calcul des derivees pour xi1 .le. xip .lt. xi2
    !!!
    
    else if ((xip.ge.xi1).and.(xip.lt.xi2)) then
        
        fact1=(xip-xi1)/(xi2-xi1)
        fact2=-m1/(fi**2.d0-s1)
        dap=v2*(a2-a1)*(fact1**(v2-1.d0))/(xi2-xi1)
        dsp=s1*v2*(1.d0+v2)*(fact1**(v2-1.d0))*(xip-xi2)/&
            & ((xi2-xi1)**2.d0)
        dmp=fact2*(log(fi)*(fi**(1.d0/ap))*dap/(ap**2.d0)+dsp)
    
    !!!
    !!! Calcul des derivees pour xip .ge. xi2
    !!!
    
    else if (xip.ge.xi2) then
        
        fact1=(a2-a1)/(xi2-xi1)
        fact2=-m1/(fi**2.d0-s1)
        fact3=fact1*(xip-xi2)/(1.d0-a2)
        dap=v2*fact1*exp(-v2*fact3)
        dsp=0.d0
        dmp=fact2*(log(fi)*(fi**(1.d0/ap))*dap/(ap**2.d0)+dsp)
        
    endif
    
    !!!
    !!! Stockage
    !!!
    
    derpar(1)=dap
    derpar(2)=dsp
    derpar(3)=dmp

end subroutine
