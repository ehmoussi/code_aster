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

subroutine hydravar3d(hyd0,hydr,hyds,phi00,phi0,dth00,dth0,&
      epleq00,epleq0,epspt600,epspt60,epspg600,&
      epspg60,epspc600,epspc60,epsk006,epsk06,epsm006,epsm06,&
      dfl00,dfl0,ett600,ett60,wplt006,wplt06,wpltx006,wpltx06)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!   actualisation des variables internes en fonction du degre
!   d hydratation
      implicit none
#include "asterfort/hydrvari.h"

      
!     actualisation des variables internes en fonction du degre
!     d hydratation

!     variables externes
      real(kind=8) :: hyd0,hydr,hyds,phi00,phi0,dfl00,dfl0
      real(kind=8) :: epspt600(6),epspt60(6)
      real(kind=8) :: epspg600(6),epspg60(6)
      real(kind=8) :: epspc600(6),epspc60(6)
      real(kind=8) :: epsk006(6),epsk06(6)
      real(kind=8) :: epsm006(6),epsm06(6)
      real(kind=8) :: ett600(6),ett60(6)
      integer j
      real(kind=8) :: wplt006(6),wplt06(6),wpltx006(6),wpltx06(6)
      real(kind=8) :: dth00,dth0,epleq00,epleq0
   
      
!     reinitialisation dissipation visqeuse      
      call hydrvari(phi00,phi0,hyd0,hydr,hyds)
!     en dommagement thermique      
      call hydrvari(dth00,dth0,hyd0,hydr,hyds)        
!     deformation plastique equivalente de cisaillement
      call hydrvari(epleq00,epleq0,hyd0,hydr,hyds) 
!     endommagement effectif de fluage
      call hydrvari(dfl00,dfl0,hyd0,hydr,hyds)       
!     deformation plastique
      do j=1,6
         call hydrvari(epspt600(j),epspt60(j),hyd0,hydr,hyds)
         call hydrvari(epspg600(j),epspg60(j),hyd0,hydr,hyds)
         call hydrvari(epspc600(j),epspc60(j),hyd0,hydr,hyds)  
         call hydrvari(epsk006(j),epsk06(j),hyd0,hydr,hyds) 
         call hydrvari(epsm006(j),epsm06(j),hyd0,hydr,hyds)
         call hydrvari(ett600(j),ett60(j),hyd0,hydr,hyds)
         call hydrvari(wplt006(j),wplt06(j),hyd0,hydr,hyds)
         call hydrvari(wpltx006(j),wpltx06(j),hyd0,hydr,hyds)
      end do 
      
end subroutine
