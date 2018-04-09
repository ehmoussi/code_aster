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

subroutine hydracomp3d(we0,we0s,epse06,souplesse66,sig06,&
                       deps6r,deps6r2,sigke06,&
                       epsk06,psik,fl3d)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!   compatibilites des deformations elastique et de kelvin
!   avec le materiau ayant subi un increment d hydratation
!   pour eviter la surevaluation de la deformation de fluage

!   tables de dimension fixe pour resolution des sytemes lineaires 
      implicit none
#include "asterf_types.h"
      integer i,j

!   declaration des variables externes
      real(kind=8) :: we0,we0s,epse06(6),souplesse66(6,6),sig06(6),deps6r(6)
      real(kind=8) :: deps6r2(6),sigke06(6),epsk06(6),psik
      real(kind=8) :: epss0,sigs0,we0d
      aster_logical :: fl3d

      we0=0.d0
      sigs0=0.d0
      epss0=0.d0
      do i=1,6
        epse06(i)=0.d0
        epsk06(i)=0.d0
        do j=1,6
!          deformation elastique actualisee pour rester
!          coherente avec le niveau de contrainte de 
!          l etage elastique   apres increment d hydratation         
             epse06(i)=epse06(i)+souplesse66(i,j)*sig06(j)
             if(fl3d) then
                 epsk06(i)=epsk06(i)+souplesse66(i,j)*sigke06(j)/psik
             end if
        end do
        if(i.le.3) then
            sigs0=sigs0+sig06(i)
            epss0=epss0+epse06(i)
        end if        
!     actualisation du potentiel elastique            
        we0=we0+0.5d0*(sig06(i)*epse06(i))       
!     deduction de la deformation de solidification 
!     de l etage elastique (creation d une deformation permanente)
!     et contribution de l etage de Kelvin si pas le premier pas

             deps6r2(i)=deps6r(i)
       end do 
!    energie elestique spherique        
       we0s=(sigs0/6.d0)*epss0
!    energie elastique deviatorique        
       we0d=we0-we0s 
end subroutine
