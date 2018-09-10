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

subroutine couplagf3d(a,b,ngf,kveve66,kmm66,&
       kmve66,kvem66,bve6,bm6)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!      construction de la mattrice de couplage
!      entre le fluage de kelvin et le fluage de maxwell

!   ************************************************************************
implicit none
       
       integer ngf,i,j
       real(kind=8) :: a(ngf,ngf+1),b(ngf)
       real(kind=8) :: kveve66(6,6),kmm66(6,6),kmve66(6,6),kvem66(6,6)
       real(kind=8) :: bve6(6),bm6(6)
       
      
!      remise a zero de la matrice de couplage globale
       do i=1,ngf
        do j=1,(ngf+1)
           a(i,j)=0.d0
        end do
        b(i)=0.d0
       end do        

!      remplssage des termes de couplage fluage->fluage
!    a=  |kveve kvem |
!        |kmve  kmm  |  
       do i=1,6
        do j=1,6
!         cas des deux matrices de couplage directe        
          a(i,j)=kveve66(i,j)
          a(i+6,j+6)=kmm66(i,j)
!         matrices de couplage indirecte
          a(i+6,j)=kmve66(i,j)   
          a(i,j+6)=kvem66(i,j)   
        end do
!       second membres
        b(i)=bve6(i) 
        b(i+6)=bm6(i)        
      end do
end subroutine
