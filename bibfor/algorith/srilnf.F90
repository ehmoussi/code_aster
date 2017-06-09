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

subroutine srilnf(nvi,vind,nmat,materf,dt,nr,yf,deps,vinf)

!

!!!
!!! MODELE LKR : POST-TRAITEMENTS SPECIFIQUES AU MODELE LKR
!!!

! ===================================================================================
! IN   : NVI            : NOMBRE DE VARIABLES INTERNES
!      : VIND(NVI)      : VARIABLE INTERNES A T
!      : NMAT           : DIMENSION TABLEAU MATERIAU
!      : MATERF(NMAT,2) : COEF MATERIAU A T+DT
!      : DT             : INCREMENT DE TEMPS
!      : SIGD(6)        : ETAT DE CONTRAINTES A T
!      : NR             : DIMENSION VECTEUR INCONNUES (YF/DY)
!      : YD(NR)         : INCONNUES DU COMPORTEMENT INTEGRES A T
!      : YF(NR)         : INCONNUES DU COMPORTEMENT INTEGRES A T+DT
!      : DEPS(6)        : INCREMENT DE DEFORMATIONS
!  OUT : VINF           :  VARIABLES INTERNES A T+DT
! ===================================================================================
    
    implicit none

#include "asterfort/r8inir.h"
#include "asterfort/lcdevi.h"
#include "asterfort/srbpri.h"
#include "asterfort/srcalg.h"
#include "asterfort/srcaln.h"
#include "asterfort/srcrip.h"
#include "asterfort/srcriv.h"
#include "asterfort/srdfds.h"
#include "asterfort/srdgde.h"
#include "asterfort/srdhds.h"
#include "asterfort/srds2h.h"
#include "asterfort/srvacp.h"
#include "asterfort/srvarp.h"
#include "asterfort/cos3t.h"
#include "asterc/r8pi.h"

    !!!
    !!! Variables globales
    !!!
    
    integer :: val,ndt,nvi,nmat,ndi,nr
    real(kind=8) :: materf(nmat,2)
    real(kind=8) :: vind(nvi),dt,deps(6)
    real(kind=8) :: yf(nr),vinf(nvi)
    
    !!!
    !!! Variables locales
    !!!
    
    integer :: retcom,i
    real(kind=8) :: devsig(6),i1,xi1,ucriv,seuilv
    real(kind=8) :: depsv(6),dgamv,seuilp,ucrip
    real(kind=8) :: varv,seuivm,dhds(6),ds2hds(6)
    real(kind=8) :: paraep(3),varpl(4),dfdsp(6),bprimp
    real(kind=8) :: sigt(6),xi50,xi5,rx5
    real(kind=8) :: vecnp(6),gp(6),devgii
    real(kind=8) :: xi10,rx1,xi20,xi2,rx2
    real(kind=8) :: alpha,tpp,trr,dtmp,tmm
    common /tdim/ ndt,ndi
    
    !!!
    !!! Remplissage direct de vinf(1) et vinf(3)
    !!!
    
    vinf(1)=max(yf(ndt+2),0.d0)
    vinf(3)=max(yf(ndt+3),0.d0)
    
    !!!
    !!! Passage en convention meca. des sols
    !!!
    
    do i=1,ndt
        sigt(i)=-yf(i)
    end do
    
    !!!
    !!! s et i1
    !!!
    
    call lcdevi(sigt, devsig)
    i1=sigt(1)+sigt(2)+sigt(3)
    
    !!!
    !!! Para. mater.
    !!!
    
    tmm=materf(6,1)
    tpp=materf(7,1)
    trr=materf(8,1)
    
    if ((tpp.ge.trr).and.(trr.gt.0.d0)) then
        dtmp=tpp-trr
    else
        dtmp=0.d0
    endif
    
    xi10=materf(12,2)
    xi20=materf(13,2)
    xi50=materf(14,2)
    rx1=materf(24,2)
    rx2=materf(25,2)
    rx5=materf(26,2)
    xi1=xi10*exp(rx1*dtmp)
    xi2=xi20*exp(rx2*dtmp)
    xi5=xi50*exp(rx5*dtmp)
    
    !!!
    !!! Calcul de la def. visco. et de dgamv
    !!!
    
    !!! Indicateur sur l'angle de dilatance
    val=0
    
    !!! Calcul du seuil visco. par rapport a yf
    
    call srcriv(yf(ndt+3),i1,devsig,nmat,materf,tpp,ucriv,seuilv)
    
    if (seuilv.ge.0.d0) then
        
        call srdgde(val,yf(ndt+3),dt,seuilv,ucriv,&
                    i1,devsig,vinf,nvi,nmat,materf,&
                    tpp,depsv,dgamv,retcom)
        
        vinf(4)=vind(4)+dgamv
        vinf(6)=1.d0
        vinf(11)=vind(11)+depsv(1)+depsv(2)+depsv(3)
        
    else
        
        vinf(4)=vind(4)
        vinf(6)=0.d0
        vinf(11)=vind(11)+depsv(1)+depsv(2)+depsv(3)
        
    endif
    
    !!!
    !!! Calcul de depsp et dgamp
    !!!
    
    !!! Seuil plast. en yf
    seuilp=0.d0
    
    call srcrip(i1,devsig,vinf,nvi,nmat,materf,tpp,ucrip,seuilp)
    
    if (yf(ndt+1) .gt. 0.d0) then
        
        vinf(7)=1.d0
        
        if (yf(ndt+2) .le. xi1) then
            val=0
        else
            val=1
        endif
        
        call srcriv(xi5,i1,devsig,nmat,materf,tpp,ucriv,seuivm)
        
        if (seuivm.le.0.d0) then
            varv=0
        else
            varv=1
        endif
        
        vinf(5)=varv
        
        !!! Calcul de d(f)/d(sig)
        call srdhds(nmat,materf,devsig,dhds,retcom)
        call srds2h(nmat,materf,devsig,dhds,ds2hds,retcom)
        call srvarp(vinf,nvi,nmat,materf,tpp,paraep)
        call srvacp(nmat,materf,paraep,varpl)
        call srdfds(nmat,materf,paraep,varpl,ds2hds,ucrip,dfdsp)
        
        !!! Calcul de g
        bprimp=srbpri(val,vinf,nvi,nmat,materf,paraep,i1,devsig,tpp)
        call srcaln(devsig,bprimp,vecnp,retcom)
        call srcalg(dfdsp,vecnp,gp,devgii)
        
        vinf(2)=yf(ndt+1)*devgii*sqrt(2.d0/3.d0)+vind(2)
        vinf(10)=vind(10)+yf(ndt+1)*(gp(1)+gp(2)+gp(3))
        
    else
        
        vinf(2)=vind(2)
        vinf(7)=0.d0
        
        call srcriv(xi5,i1,devsig,nmat,materf,tpp,ucriv,seuivm)
        
        if (seuivm.le.0.d0) then
            varv=0
        else
            varv=1
        endif
        
        vinf(5)=varv
        vinf(10)=vind(10)+yf(ndt+1)*(gp(1)+gp(2)+gp(3))
        vinf(12)=0
        
    endif
    
    !!! Actualisation domaine
    if ((vinf(1).ge.0.d0)) then
        vinf(12)=0
    else if ((vinf(1).gt.0.d0).and.(vinf(1).lt.xi1)) then 
        vinf(12)=1
    else if ((vinf(1).ge.xi1).and.(vinf(1).lt.xi2)) then 
        vinf(12)=2
    else if (vinf(1).ge.xi2) then 
        vinf(12)=3
    endif
    
    !!! Actualisation def. elastiques
    alpha=materf(3,1)
    vinf(9)=vind(9)-3.d0*alpha*(tpp-tmm)
    vinf(8)=vind(8)-deps(1)-deps(2)-deps(3)-&
            (vinf(9)-vind(9))-&
            (vinf(10)-vind(10))-&
            (vinf(11)-vind(11))

end subroutine
