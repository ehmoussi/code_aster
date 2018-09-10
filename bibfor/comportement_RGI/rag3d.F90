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

subroutine rag3d(taar,nrjg,tref0,aar0,sr1,&
                                      srsrag,teta1,dt,vrag00,aar1,&
                                      vrag1)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!    sous programme de calcul de l avancement chimique de rag


! ********************************************************************
      implicit none
#include "asterc/r8prem.h"
! ********************************************************************

      real(kind=8) :: taar,nrjg,tref0,aar0,sr1,srsrag,temp1,teta1,dt  
      real(kind=8) :: vrag00,aar1,vrag1
      real(kind=8) :: alpharag,Ear,ar,tempr
    

!   constante cinetique a tref 
      if (abs(taar).ge.r8prem()) then
!       la reaction est lente      
          alpharag=taar**(-1)
!       prise en compte de l activation thermique
          Ear=nrjg/8.31d0
          temp1=teta1+273.15d0
          tempr=tref0+273.15d0
!       activation thermique de la reaction      
          AR=dEXP(-EaR*((1.d0/temp1)-(1.d0/tempr)))
          alpharag=alpharag*AR
!       calcul de l avancement chimique
          if(aar0.lt.sr1) then 
             if (sr1.gt.srsrag) then
                 alpharag=alpharag*(((sr1-srsrag)/(1.d0-srsrag))**(4.0/2.0))
                 aar1=sr1-(sr1-aar0)*exp(-alpharag*dt)
!                  aar1=aar0+(sr1-aar0)*alpharag*dt
             else
                 aar1=aar0
             end if
          else
             aar1=aar0
          end if
      else
!       la reaction est instantanee, son amplitude est bornee par la 
!       la saturation en eau     
          aar1=dmax1(aar0,sr1)
      end if
!   volume de rag fin de pas      
      vrag1=vrag00*aar1
end subroutine
