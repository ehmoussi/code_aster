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

subroutine srvarp(vin, nvi, nbmat, mater, tmp, paraep)

!

!!!
!!! MODELE LKR : CALCUL DES PARAMETRES D'ECROUISSAGE PLASTIQUES
!!!

! ===================================================================================
! IN  : VIN(NVI)       : TABLEAU DES VARIABLES INTERNES
!     : NVI            : NOMBRE DE VARIABLES INTERNES
!     : NBMAT          : NOMBRE DE PARAMETRES DU MODELE
!     : MATER(NBMAT,2) : PARAMETRES DU MODELE
!     : TMP            : TEMPERATURE A L'INSTANT - OU +
! OUT : PARAEP(3)      : PARAMETRES D'ECROUISSAGE (AXIP, SXIP, MXIP)
! ===================================================================================
    
    implicit      none

    !!!
    !!! Variables globales
    !!!
    
    integer :: nbmat,nvi
    real(kind=8) :: vin(nvi),mater(nbmat,2),paraep(3),tmp
    
    !!!
    !!! Variables locales
    !!!
    
    real(kind=8) :: sxip,axip,mxip,xip,xi2,xi1,m0,m1,a0,a1,a2,s0,qi0
    real(kind=8) :: s1,v1,v2,sigc,qi,fi,m00,m10,xi10,xi20,rm,rq,rs,rx1
    real(kind=8) :: rx2,trr,dtmp,fact1,fact2
    
    !!!
    !!! Recuperation des parametres materiaux
    !!!
    
    !!! parametres a T0
    sigc=mater(3,2)
    v1=mater(6,2)
    v2=mater(7,2)
    a0=5.0d-1
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
    
    !!! temperatures
    trr=mater(8,1)
    
    !!! parametres a T
    if ((tmp.ge.trr).and.(trr.gt.0.d0)) then
        qi=qi0*(1.d0-rq*log(tmp/trr))
        dtmp=tmp-trr
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
    
    !!!
    !!! Calcul des parametres d'ecrouissage lorsque xip .lt. xi1
    !!!
    
    xip=vin(1)
    
    if (xip.lt.0.d0) then
        
        axip=a0
        sxip=s0
        mxip=m0
        
    else if ((xip.ge.0.d0).and.(xip.lt.xi1)) then
        
        fact1=(1.d0-xip/xi1)**v1
        axip=5.0d-1
        sxip=s1-(s1-s0)*fact1
        mxip=m1-(m1-m0)*fact1
        
    !!!
    !!! Calcul des parametres d'ecrouissage lorsque xi1 .le. xip .lt. xi2
    !!!
    
    else if ((xip.ge.xi1).and.(xip.lt.xi2)) then
        
        fact1=(xip-xi1)/(xi2-xi1)
        axip=a1+(a2-a1)*(fact1**v2)
        sxip=s1*(1.d0-(fact1**v2)*(1.d0+v2*(xi2-xip)/(xi2-xi1)))
        mxip=m1*(fi**(1.d0/axip)-sxip)/(fi**2.d0-s1)
    
    !!!
    !!! Calcul des parametres d'ecrouissage lorsque xip .ge. xi2
    !!!
    
    else if (xip.ge.xi2) then
        
        fact1=(a2-a1)/(1.d0-a2)
        fact2=(xip-xi2)/(xi2-xi1)
        axip=1.d0-(1.d0-a2)*exp(-v2*fact1*fact2)
        sxip=0.d0
        mxip=m1*(fi**(1.d0/axip)-sxip)/(fi**2.d0-s1)
        
    endif
    
    !!!
    !!! Stockage
    !!!
    
    paraep(1)=axip
    paraep(2)=sxip
    paraep(3)=mxip
    
end subroutine
