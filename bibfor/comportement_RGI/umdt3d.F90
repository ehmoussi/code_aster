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

subroutine umdt3d(souplesse66,dt3,umdt66,a,b,&
                                          x,ipzero,ngf,errg,iso)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!   calcul du tensseur d endommagement de traction directe
      implicit none
#include "asterf_types.h"
#include "asterfort/b3d_d66.h"
#include "asterfort/indice0.h"
#include "asterfort/gauss3d.h"
#include "asterfort/utmess.h"

      integer i,j,k,l
      
      real(kind=8) :: souplesse66(6,6)
      real(kind=8) :: souplesse66d(6,6),raideur66d(6,6)
      real(kind=8) :: dt3(3)
      integer ngf
      real(kind=8) :: x(ngf),b(ngf),a(ngf,(ngf+1))
      integer errg,ipzero(ngf)
      real(kind=8) :: umdt66(6,6)
      aster_logical ::  iso      
      real(kind=8) :: dx
      real(kind=8) :: sn3(3),d66(6,6)
      real(kind=8) :: nu,E0
      aster_logical ::  faux
      faux=.false.

      if (iso) then
         E0=1.d0/souplesse66(1,1)
         nu=-souplesse66(1,2)*E0
!      cas de la loi elastique isotrope
!      determination via solution type      
         do i=1,3
             sn3(i)=1.d0/(1.d0-dt3(i))
         end do
         call b3d_d66(nu,sn3,d66,faux,faux)
         do i=1,6
             do j=1,6
                 if(i.eq.j) then
                     umdt66(i,j)=1.d0-d66(i,j)
                 else
                     umdt66(i,j)=-d66(i,j)
                 end if
             end do
         end do
!      call affiche66(umdt66)
      else
        call utmess('A', 'COMPOR3_39')
!    cas general : 1-d=(sd^-1)(s)       
!    matrice de souplesse endommagee
!    seuls les termes de la diaginale sont affectes
       do i=1,6
         do j=1,6
            if(i.eq.j) then
               if(i.le.3) then
                  souplesse66d(i,j)=souplesse66(i,j)/(1.d0-dt3(i))
               else
                  call indice0(i,k,l)
                  dx=dmax1(dt3(k),dt3(l))
                  souplesse66d(i,j)=souplesse66(i,j)/(1.d0-dx)
               end if
            else
               souplesse66d(i,j)=souplesse66(i,j)
            end if
         end do
       end do
!    matrice de la raideur endommagee 
!    obtenue par inversion de souplesse66d
       do i=1,6
!     chaque colonne est solution de ax=b        
        do j=1,6
          do k=1,6 
            a(j,k)=souplesse66d(j,k)  
          end do
          if(j.eq.i) then
              b(j)=1.d0 
          else
              b(j)=0.d0  
          end if
        end do
        call gauss3d(6,a,x,b,ngf,errg,ipzero)
        do j=1,6
            raideur66d(j,i)=x(j)
        end do
       end do  
!    construction du tenseur umdt66
       do i=1,6
        do j=1,6
            umdt66(i,j)=0.d0
            do k=1,6            
               umdt66(i,j)=umdt66(i,j)+raideur66d(i,k)*souplesse66(k,j)
            end do
        end do
       end do
      end if
end subroutine
