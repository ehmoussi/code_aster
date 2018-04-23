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

subroutine b3d_jacob2(x33,x3,v33,epsv)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!   digonalisation d'une matrice 33 dont la direction 3 a deja ete reperee comme principale

      implicit none
#include "asterfort/utmess.h"


! Variables globales
      real(kind=8) :: x33(3,3),v33(3,3),x3(3),epsv
! Variables locales
      real(kind=8) :: v22(2,2),x2(2),delta,epsv1,scal,vnorm  
      real(kind=8) :: a,b,c
      real(kind=8), dimension(4) :: valr

!   valeurs propres 
  
      a=x33(1,1)
      b=x33(2,2)
      c=x33(1,2)
      epsv1=epsv*dmax1(dabs(a),dabs(b))
      if(dabs(c).lt.epsv1)then
!      matrice deja digonale
       if(a.ge.b)then
         x2(1)=a
         x2(2)=b
         v22(1,1)=1.d0
         v22(2,1)=0.d0
         v22(1,2)=0.d0
         v22(2,2)=1.d0
        else         
         x2(1)=b
         x2(2)=a
         v22(1,1)=0.d0
         v22(2,1)=1.d0
         v22(1,2)=1.d0
         v22(2,2)=0.d0
        end if
       else
!       il faut digonaliser la sous matrice 22       
        delta=(a-b)**2+4.d0*c**2
        x2(1)=0.5d0*((a+b)+dsqrt(delta))
        x2(2)=0.5d0*((a+b)-dsqrt(delta))
!       1 er vecteur propre
        if(dabs(a-x2(1)).ge.dabs(c))then 
           v22(1,1)=-c/(a-x2(1)) 
           v22(2,1)=1.d0
        else
           v22(1,1)=1.d0 
           v22(2,1)=-(a-x2(1))/c
        endif
        vnorm=dsqrt(v22(1,1)**2+v22(2,1)**2)
        v22(1,1)=v22(1,1)/vnorm
        v22(2,1)=v22(2,1)/vnorm
!       2 emme vecteur propre
        if(dabs(a-x2(2)).ge.dabs(c))then 
           v22(1,2)=-c/(a-x2(2)) 
           v22(2,2)=1.d0
        else
           v22(1,2)=1.d0 
           v22(2,2)=-(a-x2(2))/c
        endif
        vnorm=dsqrt(v22(1,2)**2+v22(2,2)**2)
        v22(1,2)=v22(1,2)/vnorm
        v22(2,2)=v22(2,2)/vnorm 
        scal=v22(1,1)*v22(1,2)+v22(2,1)*v22(2,2)
        if(dabs(scal).gt.1.d-5)then
            call utmess('A', 'COMPOR3_11', nr=4, valr=valr)
        end if
      end if
!     matrice de passage
      if(x33(3,3).ge.x2(1))then
!       la direction ortho au plan de calcul qui est principale
        x3(1)=x33(3,3)
        x3(2)=x2(1)
        x3(3)=x2(2)
        v33(1,1)=0.d0
        v33(2,1)=0.d0
        v33(3,1)=1.d0
        v33(1,2)=v22(1,1)
        v33(2,2)=v22(2,1)
        v33(3,2)=0.d0
        v33(1,3)=v22(1,2)
        v33(2,3)=v22(2,2)
        v33(3,3)=0.D0
       else
!       x2(1) est principale
        x3(1)=x2(1)
        v33(1,1)=v22(1,1)
        v33(2,1)=v22(2,1)
        v33(3,1)=0.d0
        if(x2(2).ge.x33(3,3))then
          x3(2)=x2(2)
          x3(3)=x33(3,3)
          v33(1,2)=v22(1,2)
          v33(2,2)=v22(2,2)
          v33(3,2)=0.d0
          v33(1,3)=0.d0
          v33(2,3)=0.d0
          v33(3,3)=1.d0  
        else
          x3(2)=x33(3,3)
          x3(3)=x2(2)
          v33(1,2)=0.d0
          v33(2,2)=0.d0
          v33(3,2)=1.d0
          v33(1,3)=v22(1,2)
          v33(2,3)=v22(2,2)
          v33(3,3)=0.d0
         end if
      end if
end subroutine
