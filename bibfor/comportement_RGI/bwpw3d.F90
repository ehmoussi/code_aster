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

subroutine bwpw3d(mfr,biotw,poro,vw,xnsat,&
                                          mw,pw,bw,srw)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!   calcul de la pression hydrique en saturé et non saturé      
      implicit none
#include "asterc/r8prem.h"
#include "asterfort/utmess.h"
!   variables externes      
      integer mfr
      real(kind=8) :: biotw,poro,vw,xnsat,mw,pw,bw,srw
      real(kind=8), dimension(1) :: valr
      
!   variables locales      
      real(kind=8) :: vvw
        
!   pression capillaire si non sature actif      
      if(mfr.ne.33) then
!      formulation non poreuse : on ne traite que les depression hydriques 
         vvw=poro
         srw=(vw/vvw)
         bw=srw*biotw
         if(vw.lt.vvw) then
            if(srw.gt.0.0d0) then     
                srw=dmin1(srw,1.d0)
            else
                srw=0.01d0
            end if
!         van genuchten
            if (abs(mw).ge.r8prem()) then   
                pw=-xnsat*((((srw**(-1.d0/mw))-1.d0))**(1.d0-mw))
            else
                call utmess('A', 'COMPOR3_14')
            end if
         else
            pw=0.d0
            bw=biotw
            srw=1.d0
         end if
      else
!      en poreux la pression d eau n est pas geree dans le modele local
!      il serait possible de gerer le complement au calcul poro meca 
!      si necessaire (supplement de pression/ resolution poro elastique)
         pw=0.d0
         bw=biotw
         valr(1) = srw
         call utmess('A', 'COMPOR3_15', nr=1, valr=valr)
!      cela influe sur la vitesse de fluage...         
      end if
end subroutine
