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

subroutine chrep6(x6,vp33,controle,xp6)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!   changement de base d'un pseudo vecteur de deformation
!   contenant des gama si controle=vrai
      
    implicit none
#include "asterf_types.h"
#include "asterfort/x6x33.h"
#include "asterfort/chrep3d.h"
#include "asterfort/x33x6.h"
      
!   variables externes           
    real(kind=8) :: x6(6),vp33(3,3),xp6(6)
    aster_logical :: controle
      
!   variables locales
    integer :: j
    real(kind=8) :: x33(3,3),xp33(3,3)

!   chargement et passage des deformations

      if (controle) then   
!     gama->epsilon             
        do j=4,6
           x6(j)=0.5d0*x6(j)
        end do
      end if
      
      call x6x33(x6,x33)         
      call chrep3d(xp33,x33,vp33)
      call x33x6(xp33,xp6)
      
      if(controle) then
!     epsilon->gama si controle         
        do j=4,6
           x6(j)=2.d0*x6(j)
           xp6(j)=2.d0*xp6(j)
        end do
      end if
!
end subroutine
