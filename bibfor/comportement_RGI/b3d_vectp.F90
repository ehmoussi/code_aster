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

subroutine b3d_vectp(aa,vp,x,n)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!   A.Sellier dim. 29 août 2010 08:00:41 CEST 
!   passage en double precision des constantes des vecteurs      
!    recherche vecteur propre associe a une valeur propre (matrice 3x3)
!    n : multiplicite de la valeur propre
 implicit none    
#include "asterc/r8prem.h"
#include "asterfort/utmess.h"

      real(kind=8) :: a,b,c,d,e,f
      integer n
      real(kind=8) :: aa(3,3),x(*),vp,det1,det2,det3,xn,xsc
      real(kind=8), dimension(9) :: valr

      a=aa(1,1)-vp
      b=aa(1,2)
      c=aa(1,3)
      d=aa(2,2)-vp
      e=aa(2,3)
      f=aa(3,3)-vp
      if (n.eq.1) then
      det3=a*d-b*b
      det2=a*f-c*c
      det1=d*f-e*e
      if (dabs(det3).ge.dabs(det1).and.dabs(det3).ge.dabs(det2)) then
       x(1)=(b*e-c*d)
       x(2)=(b*c-a*e)
       x(3)=det3
      elseif(dabs(det1).ge.dabs(det2).and.dabs(det1).ge.dabs(det3)) then
       x(1)=det1
       x(2)=(c*e-b*f)
       x(3)=(b*e-c*d)
      elseif(dabs(det2).ge.dabs(det1).and.dabs(det2).ge.dabs(det3)) then
       x(1)=(c*e-b*f)
       x(2)=det2
       x(3)=(b*c-a*e)
      endif
!    normalisation du vecteur      
      xn=dsqrt(x(1)**2+x(2)**2+x(3)**2)
      if (xn.ge.r8prem()) then
       x(1)=x(1)/xn
       x(2)=x(2)/xn
       x(3)=x(3)/xn
      else
        valr(1) = aa(1,1)
        valr(2) = aa(1,2)
        valr(3) = aa(1,3)
        valr(4) = aa(2,1)
        valr(5) = aa(2,2)
        valr(6) = aa(2,3)
        valr(7) = aa(3,1)
        valr(8) = aa(3,2)
        valr(9) = aa(3,3)
        call utmess('A', 'COMPOR3_13', nr=9, valr=valr)
      end if
      elseif (n.eq.2) then
       if (dabs(a).ge.dabs(d).and.dabs(a).ge.dabs(f)) then
       x(1)=-b/a
       x(2)=1.d0
       x(3)=0.d0
       x(4)=-c/a
       x(5)=0.d0
       x(6)=1.d0
       elseif (dabs(d).ge.dabs(a).and.dabs(d).ge.dabs(f)) then
       x(1)=1.d0
       x(2)=-b/d
       x(3)=0.d0
       x(4)=0.d0
       x(5)=-e/d
       x(6)=1.d0
       elseif (dabs(f).ge.dabs(a).and.dabs(f).ge.dabs(d)) then
       x(1)=1.d0
       x(2)=0.d0
       x(3)=-c/f
       x(4)=0.d0
       x(5)=1.d0
       x(6)=-e/f
       endif
!     normalisations       
       xn=dsqrt(x(1)**2+x(2)**2+x(3)**2)
       x(1)=x(1)/xn
       x(2)=x(2)/xn
       x(3)=x(3)/xn
       xn=dsqrt(x(4)**2+x(5)**2+x(6)**2)
       x(4)=x(4)/xn
       x(5)=x(5)/xn
       x(6)=x(6)/xn
!     verif produit scalaire       
       xsc=x(1)*x(4)+x(2)*x(5)+x(3)*x(6)
       if(dabs(xsc).gt.1.d-4) then
         x(4)=x(4)-xsc*x(1)
         x(5)=x(5)-xsc*x(2)
         x(6)=x(6)-xsc*x(3)
         xn=dsqrt(x(4)**2+x(5)**2+x(6)**2)
         x(4)=x(4)/xn
         x(5)=x(5)/xn
         x(6)=x(6)/xn
       end if
      elseif (n.eq.3) then
       x(1)=1.d0
       x(2)=0.d0
       x(3)=0.d0
       x(4)=0.d0
       x(5)=1.d0
       x(6)=0.d0
       x(7)=0.d0
       x(8)=0.d0
       x(9)=1.d0
      endif
end subroutine
