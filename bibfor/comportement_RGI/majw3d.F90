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

subroutine majw3d(epspt60,epspt6,t33,&
       wplt06,wplt6,wpltx06,wpltx6,wpl3,vwpl33,vwpl33t,&
       wplx3,vwplx33,vwplx33t,local,dim3,ndim,ifour)

! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
implicit none
#include "asterf_types.h"
#include "asterfort/x6x33.h"
#include "asterfort/b3d_valp33.h"
#include "asterfort/transpos1.h"
#include "asterfort/tail_reel.h"
#include "asterfort/chrep6.h"

!     mise a jour du tenseur des ouvertures: Sellier mai 2015

      integer i
     
!     variables externes
      real(kind=8) :: epspt60(6),epspt6(6)
      real(kind=8) :: t33(3,3),dim3
      integer ndim, ifour
      real(kind=8) :: wplt06(6),wplt6(6),wpltx06(6),wpltx6(6)
      real(kind=8) :: wpl3(3),vwpl33(3,3),vwpl33t(3,3)
      real(kind=8) :: wplx3(3),vwplx33(3,3),vwplx33t(3,3)
      aster_logical ::  local,vrai
      
!     variables locales
      real(kind=8) :: depspt6(6),depspt33(3,3),depspt3(3)
      real(kind=8) :: vdepspt33(3,3),vdepspt33t(3,3)
      real(kind=8) :: long3(3),dwp6(6),dw6(6)
      real(kind=8) :: wplt33(3,3)
      real(kind=8) :: wpltx061(6),wpltx61(6)
      real(kind=8) :: wpltx33(3,3),wplt61(6),aux6(6),aux3(3)

      vrai=.true.
!     *** actualisation ouvertures de fissures actuelles  ************** 
      do i=1,6
        depspt6(i)=epspt6(i)-epspt60(i)
      end do
!     digonalisation de l'increment
      do i=4,6
         depspt6(i)=depspt6(i)/2.d0
      end do
!     passage 33      
      call x6x33(depspt6,depspt33)      
!     diagonalisation  
      call b3d_valp33(depspt33,depspt3,vdepspt33)
!     construction matrice de passage inverse         
      call transpos1(vdepspt33t,vdepspt33,3)
!     calcul des tailles dans les directions principales 
      if(local)then
         call tail_reel(long3, vdepspt33, dim3, ndim, ifour)
      else
         do i=1,3
             long3(i)=t33(i,i)
         end do
      end if
!     increment des ouvertures
      do i=1,3
        dwp6(i)=depspt3(i)*long3(i)
      end do
      do i=4,6
         dwp6(i)=0.d0
      end do
!     passage des increments en base fixe 
      call chrep6(dwp6,vdepspt33t,vrai,dw6)
!     actualisation de l ouverture actuelle (stockage en gamma)
      do i=1,6
        wplt6(i)=wplt06(i)+dw6(i)
      end do
!     direction principale des ouvertures actuelles
!     passage en epsilon pour diagonaliser
      do i=1,3
          aux6(i)=wplt6(i)
      end do
      do i=4,6
          aux6(i)=0.5d0*wplt6(i)
      end do
!     passage 33      
      call x6x33(aux6,wplt33)      
!     diagonalisation     
      call b3d_valp33(wplt33,wpl3,vwpl33)
      do i=1,3
!        utilisation variable auxiliaire pour erreur sur systeme 32b(?)      
         aux3(i)=wpl3(i)
      end do
!     construction matrice de passage inverse         
      call transpos1(vwpl33t,vwpl33,3)  
!     on s assure que les valeurs propres sont positives
      do i=1,3
        wpl3(i)=dmax1(wpl3(i),0.d0)
        wplt61(i)=wpl3(i)
      end do
      do i=4,6
        wplt61(i)=0.d0
      end do
      call chrep6(wplt61,vwpl33t,vrai,wplt6)      
!     ***** ouvertures maximales ***************************************
!     passage des ouvertures maximale dans la base prin actuelle 
      call chrep6(wpltx06,vwpl33,vrai,wpltx061)
!     comparaison des valeurs normales maxi
      do i=1,3
        wpltx61(i)=dmax1(wpltx061(i),wpl3(i))        
      end do
!     completion      
      do i=4,6
        wpltx61(i)=wpltx061(i)
      end do
!     retour en base fixe des ouvertures maximales
      call chrep6(wpltx61,vwpl33t,vrai,wpltx6)
!     diagonalisation des ouvertures maxi pour la base d endommagement
!     passage 33 pour diagonalisation (apres passage en epsilon)
!     passage en epsilon pour diagonaliser
      do i=1,3
          aux6(i)=wpltx6(i)
      end do
      do i=4,6
          aux6(i)=0.5d0*wpltx6(i)
      end do     
      call x6x33(aux6,wpltx33)      
!     diagonalisation   
      call b3d_valp33(wpltx33,wplx3,vwplx33)
!     construction matrice de passage inverse 
      call transpos1(vwplx33t,vwplx33,3)
      do i=1,3
         wpl3(i)=aux3(i)
      end do

end subroutine
