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

subroutine matcc3d(cc3,vcc33,vcc33t,v33,v33t,cc6)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!     matrice de consolidation dans une base quelconque v33 presentation
!     en coeff cc6 dans la base v33
implicit none
#include "asterf_types.h"
#include "asterfort/chrep6.h"
#include "asterfort/indice0.h"
      
      real(kind=8) :: cc3(3),vcc33(3,3),vcc33t(3,3),v33(3,3),v33t(3,3),cc6(6)
      
      real(kind=8) :: eps6(6),epsp6(6)
      integer i,j,k,l
      aster_logical ::  faux
      faux=.false.

      do i=1,6
!         on adopte une deformation virtuelle unitaire dans la base 
!         principale  actulle (v33) pour estimer chaque coeff independament
          do j=1,6
             if(j.eq.i) then
                 eps6(j)=1.d0
             else 
                 eps6(j)=0.d0
             end if
          end do 
!         passage de la deformation virtuelle dans la base prin des cc
          call chrep6(eps6,v33t,faux,epsp6) 
          call chrep6(epsp6,vcc33,faux,eps6) 
!         on affecte les consolidations
          do j=1,6
            if(j.le.3) then
                 eps6(j)=eps6(j)/cc3(j)
            else
                 call indice0(j,k,l)
                 eps6(j)=eps6(j)/dmin1(cc3(k),cc3(l))
            end if
          end do
!         retour en base principale actuelle
          call chrep6(eps6,vcc33t,faux,epsp6) 
          call chrep6(epsp6,v33,faux,eps6)
!         recuperation du coeff de consolidation pour la composante i
          cc6(i)=1.d0/eps6(i)
       end do
end subroutine
