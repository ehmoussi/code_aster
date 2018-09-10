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

subroutine conso3d(epsmk,epser,ccmin,ccmax,&
        epsm6,epse6,cc3,vepsm33,vepsm33t,CWp,CMp,CTD,CTV)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!   calcul coeff de consolidation principaux et de leur base 
!   pour le fluage non lineaire

implicit none
#include "asterf_types.h"
#include "asterfort/x6x33.h"
#include "asterfort/b3d_valp33.h"
#include "asterfort/transpos1.h"
#include "asterfort/chrep6.h"
     
      integer i
      
      aster_logical ::  log1
      
      real(kind=8) :: epsmk,ccmin,epser,ccmax
      real(kind=8) :: CWp,CMp,CTD,CTV,xx1,xx2,xxk
      real(kind=8) :: epsm6(6),epse6(6),cc3(3)
      real(kind=8) :: vepsm33(3,3),vepsm33t(3,3)
!     endommagement asymptotique pour le fluage non lineaire      
      
!     deformation minimale prise en compte pour le calcul de potentiel
!     de fluage      
      real(kind=8) :: epsemin
      parameter (epsemin=1.d-6)     
      real(kind=8) :: epsm33(3,3),epsm3(3)
      real(kind=8) :: epse16(6)
      
!     deformation equivalente de Maxwell incluant la deformation thermique transitoire      
      real(kind=8) :: epsmeq6(6)
      
       epsm3(:)=0.d0
       epse16(:)=0.d0
       cc3(:)=0.d0 
       xx2=0.d0
       xxk=0.d0
      
!     diagonalisation du tenseur des deformations de fluage + def therm transitoire
      do i=1,3
         epsmeq6(i)=epsm6(i)
      end do
      do i=4,6
          epsmeq6(i)=epsm6(i)/2.d0         
      end do
!     passage 33      
      call x6x33(epsmeq6,epsm33)       
!     diagonalisation      
      call b3d_valp33(epsm33,epsm3,vepsm33)
!     construction matrice de passage inverse         
      call transpos1(vepsm33t,vepsm33,3)   
      
!     passage des deformations elastiques dans la base principale 
!     des deformations de fluage
        log1=.true.
      call chrep6(epse6,vepsm33,log1,epse16)      
      
!     calcul des coefficients de consolidation principaux
!     coeff de consolidation spherique
      do i=1,3
!       potentiel dans la direction de fluage
        xx1=dmax1(dabs(epse16(i)),epsemin)
        xxk=(epsmk/epser)*CWp*CMp*(CTD*CTV)         
        xx2=xxk*xx1    
!       coeff de consolidation directionnel
        if(epse16(i)*epsm3(i).ge.0.d0) then
             cc3(i)=(dexp(dmin1(dabs(epsm3(i))/xx2,25.d0)))/xxk
        else
             cc3(i)=1.d0/xxk
        end if         
      end do
      
      ccmin=dmax1(dmin1(cc3(1),cc3(2),cc3(3)),1.d0/xxk) 
      ccmax=dmax1(cc3(1),cc3(2),cc3(3),1.d0/xxk)   
      
      
end subroutine
