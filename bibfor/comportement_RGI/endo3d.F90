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

subroutine endo3d(wpl3,vwpl33,vwpl33t,wplx3,vwplx33,vwplx33t,&
      gft,gfr,iso,sigf6,sigf6d,rt33,ref33,&
      souplesse66,epspg6,eprg00,a,b,x,ipzero,ngf,&
      ekdc,epspc6,dt3,dr3,dgt3,dgc3,dc,wl3,xmt,dtiso,rt,dtr,&
      dim3,ndim,ifour,epeqpc)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
      
!   calcul de l endommagement de traction directe
      
    implicit none
#include "asterf_types.h"
#include "asterfort/x6x33.h"
#include "asterfort/b3d_valp33.h"
#include "asterfort/transpos1.h"
#include "asterfort/tail_reel.h"
#include "asterfort/chrep6.h"
#include "asterfort/chrep3d.h"
#include "asterfort/umdt3d.h"
#include "asterfort/partition3d.h"
#include "asterfort/indice1.h"
#include "asterfort/indice0.h"

      integer i,j,k,l

      real(kind=8) :: sigf6(6),sigf6d(6),rt33(3,3),ref33(3,3)
      real(kind=8) :: gft,long3(3)
      real(kind=8) :: epspg6(6),gfr,souplesse66(6,6)
      real(kind=8) :: epspc6(6),rt,beta1,wpl3(3),vwpl33(3,3),vwpl33t(3,3)
      real(kind=8) :: wplx3(3),vwplx33(3,3),vwplx33t(3,3),gfreff,wkr,wkt
      real(kind=8) :: xx,youngmin,rt331(3,3),ref331(3,3)
      real(kind=8) :: ekdc,dc,dt3(3),dt1
      real(kind=8) :: xmt,sigefft
      aster_logical ::  iso,dtiso,faux
      integer ndim,ifour
      real(kind=8) :: eprg00,dtr,dim3,epeqpc
      
      real(kind=8) :: dr3(3),wl3(3)      
      real(kind=8) :: sigf3(3),vsigf33(3,3),vsigf33t(3,3)
      real(kind=8) :: sigft6(6),sigfc6(6),sigfc3(3),sigft3(3)
      
      real(kind=8) :: sigft6p(6),sigft6d(6),sigfc6p(6),sigfc6r(6)
      real(kind=8) :: sigft61(6),sigfc61(6)
      
      real(kind=8) :: epspg33(3,3),epspg3(3),vepspg33(3,3),vepspg33t(3,3)
      real(kind=8) :: dgt3(3),dgc3(3),sigfc6d(6)
      
      real(kind=8) :: gfrmin,trepsdc,xx1
      
      real(kind=8) :: umdtr

!     seuil init d endo par rgi      
      real(kind=8) :: epsseuil0
      parameter (epsseuil0=0.d0)
      
!     endo de refermeture de fissure      
      aster_logical ::  endor
      
!     matrice des en do de traction      
      real(kind=8) :: umdt66(6,6),umdr66(6,6)
      integer errg
      
!     matrice pour methode e Gauss      
      integer ngf
      real(kind=8) :: x(ngf),b(ngf),a(ngf,(ngf+1))
      integer ipzero(ngf)
      
!     deformation equivalente pour endo grand lors de la reouverture 
!     de fissure (lorsque la fissure se reouvre on a 2*epsmt6    
      
!     endo maxi (risque de perte de convergence a 1e-4 si >0.975)
!     drgi maxi borne plus bas a cause du couplage avec autres endos
      real(kind=8) :: dmaxi,drgimaxi
      parameter (dmaxi=1.0d0,drgimaxi=1.0d0) 

      faux=.false.

      sigf3(:)=0.d0
      sigfc3(:)=0.d0
      sigft3(:)=0.d0
      vsigf33(:,:)=0.d0
      vsigf33t(:,:)=0.d0
      sigft6(:)=0.d0
      sigfc6(:)=0.d0
      dgc3(:)=0.d0
      ref331(:,:)=0.d0
      wl3(:)=0.d0
      wpl3(:)=0.d0

!***********************************************************************
!     prise en compte de l endommagement de traction
!*********************************************************************** 
!     passage de rt dans la base principale des ouvertures maxi
      call chrep3d(rt331,rt33,vwplx33)   
      do i=1,3
        wkt=gft/rt331(i,i)      
        dt3(i)=wplx3(i)*(wplx3(i)+2.d0*wkt)/(wkt+wplx3(i))**2
      end do    
!     calcul de la matrice d endommagement de traction
      call umdt3d(souplesse66,dt3,umdt66,a,b,x,ipzero,ngf,errg,iso)      
      
!***********************************************************************
!     appli de l endo de traction aux contraintes positives
!***********************************************************************
!     partition du tenseur des contraintes
      call partition3d(sigf6,sigf3,vsigf33,vsigf33t,&
      sigft6,sigfc6,sigfc3,sigft3) 
!     ******************************************************************
!     traitement de l endo isotrope de traction pre pic si necessaire
      if(dtiso) then
!       contrainte effective maxi      
        sigefft=dmax1(sigft3(1),sigft3(2),sigft3(3)) 
!       partie elastique de l ouverture de fissure
!       a positionner ici si utile        
        beta1=((sigefft/rt)**xmt)/xmt
!       endommagement        
        dt1=1.d0-dexp(-beta1) 
!       actualisation de l endommagement iso de traction
        dtr=dmax1(dt1,dtr) 
      else
        dtr=0.d0
      end if
      umdtr=1.d0-dtr
!     ******************************************************************             
!     passage  des contraintes effectives dans la base prin des endo
      call chrep6(sigft6,vwplx33,faux,sigft6p)  
!     application du tenseur d endommagement aux contraintes de tractions
      do i=1,6
        sigft6d(i)=0.d0
        do j=1,6
             sigft6d(i)=sigft6d(i)+umdt66(i,j)*sigft6p(j)
        end do
        if(dtiso) then
!         application de l endo iso prepic
          sigft6d(i)=sigft6d(i)*umdtr
        end if          
      end do
!     retour des contraintes positives en base fixe
      call chrep6(sigft6d,vwplx33t,faux,sigft61)      

!***********************************************************************
!     calcul de l endommagement de refermetude de fissure
!***********************************************************************

!     passage de ref dans la base principale des ouvertures maxi
      call chrep3d(ref331,ref33,vwpl33)
!     calcul des indicateur de refermetures 
      xx=dmax1(souplesse66(1,1),souplesse66(2,2),souplesse66(3,3)) 
      youngmin=1.d0/xx
      call tail_reel(long3,vwpl33,dim3,ndim,ifour) 
      do i=1,3
          gfrmin=2.d0*(ref331(i,i)**2/youngmin)*long3(i)
          if(gfr.lt.gfrmin) then
!             on adopte le gfr mini necessaire
              gfreff=gfrmin
          else
              gfreff=gfr
          end if          
          wkr=gfreff/ref331(i,i)     
!         nouvelles valeurs          
          dr3(i)=wpl3(i)*(wpl3(i)+2.d0*wkr)/(wkr+wpl3(i))**2
      end do
      call umdt3d(souplesse66,dr3,umdr66,a,b,x,ipzero,ngf,errg,iso) 
      
!***********************************************************************
!     application de l endo de refermeture aux contraintes negatives
!***********************************************************************
      
!     passage  des contraintes effectives dans la base prin des endo
      call chrep6(sigfc6,vwpl33,faux,sigfc6p)  
!     application du tenseur d endommagement aux contraintes de tractions
      do i=1,6
         sigfc6r(i)=0.d0
         do j=1,6
            sigfc6r(i)=sigfc6r(i)+umdr66(i,j)*sigfc6p(j)
         end do            
      end do
!     retour des contraintes positives en base fixe
      call chrep6(sigfc6r,vwpl33t,faux,sigfc61)  

!***********************************************************************
!      calcul de l endommagement rgi
!***********************************************************************
!     valeurs propres des deformations plastiques de rgi
      do i=4,6
         epspg6(i)=epspg6(i)/2.d0
      end do
!     passage 33      
      call x6x33(epspg6,epspg33) 
      do i=4,6
         epspg6(i)=epspg6(i)*2.d0
      end do      
!     diagonalisation      
      call b3d_valp33(epspg33,epspg3,vepspg33)
!     construction matrice de passage inverse         
      call transpos1(vepspg33t,vepspg33,3)
!     calcul des endommagements 
      endor=.false.
      do i=1,3
         xx1=epspg3(i)-epsseuil0
         if(xx1.gt.0.d0) then
            endor=.true.
         else
            xx1=0.d0
         end if
         if(eprg00.eq.0.d0) then
             dgt3(i) = dmin1(0.d0,drgimaxi)
         else
             dgt3(i)=dmin1(dmax1((xx1/(xx1+eprg00)),0.d0),drgimaxi)
         end if
      end do
!***********************************************************************      
!     test utilite endo de rgi     
      if(endor) then      
!         calcul des endommagements de compression
!         (coeff de couplage g/c fixe==0.15)
          do i=1,3   
!         complementarite par orthogonalite      
             call indice1(i,k,l)
             dgc3(i)=1.d0-((1.d0-dgt3(k))*(1.d0-dgt3(l)))**0.15d0
             dgc3(i)=dmin1(dmax1(dgc3(i),0.d0),drgimaxi)
          end do
!***********************************************************************
!        prise en compte des endo rgi de traction
!***********************************************************************
!         passage  des contraintes effectives dans la base prin des endo
          call chrep6(sigft61,vepspg33,faux,sigft6p)  
!         application du tenseur d endommagement aux
!         contraintes de tractions
          do i=1,6
                if(i.le.3) then
                    sigft6d(i)=(1.d0-dgt3(i))*sigft6p(i)
                else
                    call indice0(i,k,l)
                    sigft6d(i)=(1.d0-dmax1(dgt3(k),dgt3(l)))*sigft6p(i)
                end if
          end do
!         retour des contraintes positives en base fixe
          call chrep6(sigft6d,vepspg33t,faux,sigft61)
          
!***********************************************************************
!         prise en compte des endo rgi de compression
!***********************************************************************
!         passage  des contraintes effectives dans la base prin des endo
          call chrep6(sigfc61,vepspg33,faux,sigfc6p)  
!         application du tenseur d endommagement aux contraintes de tractions
          do i=1,6
                if(i.le.3) then
                    sigfc6d(i)=(1.d0-dgc3(i))*sigfc6p(i)
                else
                    call indice0(i,k,l)
                    sigfc6d(i)=(1.d0-dmax1(dgc3(k),dgc3(l)))*sigfc6p(i)
                end if
          end do
!         retour des contraintes positives en base fixe
          call chrep6(sigfc6d,vepspg33t,faux,sigfc61)       
      end if
!***********************************************************************
!     combinaison des contraintes endommagées
!***********************************************************************
      do i=1,6
         sigf6d(i)=sigfc61(i)+sigft61(i)
      end do
!***********************************************************************
!     variation de raideur isotrope due aux autres variations volumiques
!     induites par le cisaillement
!***********************************************************************
      trepsdc=0.d0
      do i=1,3
        trepsdc=trepsdc+epspc6(i)
      end do
      if(trepsdc.gt.epeqpc) then
         trepsdc=trepsdc-epeqpc
         dc=dmin1(trepsdc/(trepsdc+ekdc),dmaxi)
      else
         dc=0.d0
      endif
      
      do i=1,6
         sigf6d(i)=sigf6d(i)*(1.d0-dc)
      end do
!***********************************************************************
!     calcul des ouvertures de fissure dans la base principale
!     des deformations plastiques de traction actuelles
!***********************************************************************
      do i=1,3
!       si on neglige la contribution visco elastique de l ouverture devant la plastique      
        wl3(i)=wpl3(i)
      end do 
!***********************************************************************      
end
