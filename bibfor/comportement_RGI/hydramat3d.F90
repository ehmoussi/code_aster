! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine hydramat3d(hyd0,hydr,hyds,young00,young,&
                                              nu00,nu,rt00,rt,ref00,&
                                              ref,rc00,rc,delta00,delta,&
                                              beta00,beta,gft00,gft,ept00,&
                                              ept,pglim,epsm00,epsm,xnsat00,&
                                              xnsat,biotw00,biotw,brgi00,brgi,&
                                              krgi00,krgi,iso,lambda,mu,&
                                              rt33,rtg33,ref33,raideur66,souplesse66,&
                                              xmt,dtiso,err1)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!   actualisation des parametres materiaux en fonction du degre
!   d hydratation
    implicit none
#include "asterc/r8prem.h"
#include "asterf_types.h"
#include "asterfort/hydrxmat.h"
#include "asterfort/utmess.h"

      integer i,j
      
!   declaration variables externes      
      real(kind=8) :: hyd0,hydr,hyds,young00,young,nu00,nu
      real(kind=8) :: rt00,rt,ref00,ref,rc00,rc,delta00,delta,beta00,beta
      real(kind=8) :: pglim,epsm00,epsm,xnsat00,xnsat,biotw00,biotw
      real(kind=8) :: brgi00,brgi,gft00,gft,krgi00,krgi,xmt,ept00,ept,dpic
      aster_logical ::  iso,dtiso
      real(kind=8) :: lambda,mu,rteff
      real(kind=8) :: rt33(3,3),rtg33(3,3),ref33(3,3)
      real(kind=8) :: raideur66(6,6),souplesse66(6,6)
      integer err1
      
      
!     declarations variables locales      
      real(kind=8) :: umb00,umb,rtg,xrteff
!     coeff d'amplificationpour passer de rt à rteff
      xrteff=dmax1((ept00/(rt00/young00)),1.d0)


!     la actualisation n a lieu que si l hydratation evolue 
!     ou bien est differente de 1      
      if((abs(hydr-1.d0).ge.r8prem()).or.(hydr.gt.hyd0)) then
!        young      
         call hydrxmat(young00,young,hydr,hyds,0.66d0,err1)
!        poisson         
         nu=nu00
!        resistance a la traction         
         call hydrxmat(rt00,rt,hydr,hyds,1.d0,err1)
!        resistance a la refermeture de fissure        
         call hydrxmat(ref00,ref,hydr,hyds,1.d0,err1)
!        resistance à la compresssion  finale (doit augmenter + vite
!        que rt pour eviter pb d interaction entre les criteres     
         call hydrxmat(rc00,rc,hydr,hyds,0.66d0,err1)       
!        coeff drucker prager         
         call hydrxmat(delta00,delta,hydr,hyds,1.d0,err1)
!         delta=delta00
!        dilatance         
         call hydrxmat(beta00,beta,hydr,hyds,1.d0,err1) 
!        potentiel de fluage de maxwell : non actif car c est le taux 
!        de chargement qui accelere le fluage au jeune age    
         epsm=epsm00
!        pris en compte de l hydratation sur biot en non sature
         umb00=1.d0-biotw00
         call hydrxmat(umb00,umb,hydr,hyds,0.66d0,err1) 
         biotw=1.d0-umb       
!        module de biot pour le non sature
         call hydrxmat(xnsat00,xnsat,hydr,hyds,0.66d0,err1) 
!        energie de fissuration pour la traction
         call hydrxmat(gft00,gft,hydr,hyds,0.66d0,err1) 
!        coeff de biot des rgi
         brgi=brgi00
!        concentration de contraintes RGI
         krgi=krgi00
!        deformation au pic de traction
!        on conserve le rapport imposee pour le materiau hydrate
         ept=xrteff*(rt/young)
!        on verifie qu il soit plus grand que la def elastique         
         ept=dmax1(ept,rt/young)         
      else
         young=young00
         nu=nu00
         rt=rt00
         ref=ref00
         rc=rc00
         delta=delta00
         beta=beta00
         epsm=epsm00
         biotw=biotw00
         xnsat=xnsat00
         gft=gft00
         brgi=brgi00
         krgi=krgi00
!        deformation au pic de traction
         ept=dmax1(ept00,rt/young) 
      end if
      
!     actualisation resistance effective a la pression des rgi 
!     resistance a la traction utilisee pour la propagation des fissures de gel
      rtg=rt*xrteff
!     pression pour remplir la poro connectee en gonflement libre      
      pglim=rtg/dmax1(krgi,1.d-3) 
      
!     actualisation parametres endo diffus de traction
      rteff=young*ept
      dpic=1.d0-rt/rteff
!     actualisation energie de fissuration effective en fonction de
!     l endommagement pre pic
      gft=gft*rteff/rt
!     actualisation de la resistance en traction effective pour la plasticite     
      rt=rteff
      if(dpic.gt.1.d-4) then
!       endommagement pre pic de traction non negligeable
        dtiso=.true.      
        xmt=-1.d0/log(1.d0-dpic)
      else
        xmt=1.d0
        dtiso=.false.
      end if
!     actualisation des matrices d elasticite
      if (iso) then
!     Coefficients de Lame       
        lambda=young*nu/(1.d0+nu)/(1.d0-2.d0*nu)
        mu=young/2.d0/(1.d0+nu)     
!       tenseur des resistances 
        do i=1,3
            do j=1,3
                 if (i.eq.j) then
                     rt33(i,j)=rt
                     rtg33(i,j)=rtg
                     ref33(i,j)=ref
                 else
                     rt33(i,j)=0.d0
                     rtg33(i,j)=0.d0
                     ref33(i,j)=0.d0
                 end if
            end do
        end do
!       tenseurs de la loi de comportement en base fixe      
        do i=1,6
             do j=1,6
                 if (i.eq.j) then
                     if(i.le.3) then
                         raideur66(i,j)=lambda+2.d0*mu
                         souplesse66(i,j)=1.d0/young
                     else
                         raideur66(i,j)=mu
                         souplesse66(i,j)=1.d0/mu
                     end if
                 else
                    if ((j.le.3).and.(i.le.3)) then
                         raideur66(i,j)=lambda                    
                         souplesse66(i,j)=-nu/young
                    else
                         raideur66(i,j)=0.d0                    
                         souplesse66(i,j)=0.d0
                    end if
                 end if
             end do
         end do
      else
         call utmess('E', 'COMPOR3_37')
      end if
      
end subroutine
