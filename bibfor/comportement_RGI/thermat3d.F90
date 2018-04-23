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

subroutine thermat3d(teta1,nrjm,tetas,tetar,DT80,&
                                             dth0,DTH,CTHP,CTHV)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!   influence de la temperature sur les parametres de fluage    

!   declarations externes
      implicit none
      
!   variables externes
      real(kind=8) :: nrjm,teta1,DT80
      real(kind=8) :: tetas,tetar,dth0,DTH,CTHP,CTHV

!   variables locales      
      real(kind=8) :: easurrm,easurrw,unsurtr,unsurts,unsurt,unsurt80
      real(kind=8) :: xxx180,xxx1,xxx2,xxx280,ath,cth80
 
!**********************************************************************
!   reglage des activation thermiques pour le fluage
!   +++ les teta sont en degres Celsius +++
!**********************************************************************
!   pour utiliser cette routine avec endo seul
      nrjm=dmax1(nrjm,1.0) 
!   calcul du terme d activation d Arrhenius pour le potentiel      
      easurrm=nrjm/8.314D0
!   cas de l'activation des viscostés
      easurrw=2059.d0
!   la temperature de reference est 20°C      
      unsurtr=1.d0/(tetar+273.15d0)
!   unsurts la temperature de seuil pour la modif du potentiel 
      unsurts=1.d0/(tetas+273.15d0)
!   calcul des coeff d activation thermique
      unsurt=(1.D0/(teta1+273.15D0))   
!   cas de l eau      
      CTHV=exp(-easurrw*(unsurt-unsurtr)) 
!   cas de l endommagement thermique      
      xxx1=unsurts-unsurt
      xxx2=0.5D0*(xxx1+dabs(xxx1))
      CTHP=exp(easurrm*xxx2)     

      
!************************************************************************
!   endommagement thermique
!************************************************************************
      if(tetas.lt.80.d0) then
          unsurt80=2.8316d-3
          xxx180=unsurts-unsurt80
          xxx280=0.5D0*(xxx180+dabs(xxx180))
          Cth80=exp(easurrm*xxx280)
          Ath=1.d0/(Cth80-1.d0)*(DT80/(1.d0-DT80))
          Dth=1.d0-1.d0/(1.d0+Ath*(CTHP-1.d0))     
      else
          Dth=0.d0
      end if
      DTH=dmax1(dth0,dth)
!***********************************************************************!     
end subroutine
