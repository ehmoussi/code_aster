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

subroutine b3d_jacob3(a,idim1,d,x,control,&
                       epsv)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!   version modifiee par A.Sellier le sam. 28 août 2010 18:16:10 CEST 
!   pour corriger le pb (rencontre sous linux)  de non detection de 
!   deux valeurs propres petites considerees a tort comme non double :
!   1)on definit deps en valeur absolue pour eviter les pb liees aux vp
!   negative
!   2)dans le cas ou les deux valeur propre sont egales et de 
!   signes opposes, la difference est superieure au test ce qui est correct
!   mais difficile a traiter numeriquement lorsque les valeurs sont toutes deux
!   petites par rapport à la troisieme ( elle pourrait alors etre toute
!   deux considerees comme nulle), il faut donc tester si la somme des
!   valeurs absolue peut etre considere comme negligeable par rapport 
!   à la troisieme, si c est le cas on impose a ces deux valeurs considere
!   d etre egales a leur moyenne...
      
!======================================================================         
!     OBJET                                                                     
!     -----                                                                     
!     DIAGONALISATION D UNE MATRICE 3*3 SYMETRIQUE                              
!                                                                               
!     ENTREES                                                                   
!     -------                                                                   
!     A(3,3) = MATRICE SYMETRIQUE                                               
!     idim1   = 2 OU 3  SI 2 ON NE S OCCUPE QUE DE A(2,2)                        
!                      SI 3                    DE A(3,3)                        
!     SORTIES                                                                   
!     -------                                                                   
!     D(3)   = VALEURS PROPRES ORDONNEES D(1)>D(2)>D(3)
!
!     S(3,3) = VECTEURS PROPRES ( S(IP,2) EST LE VECTEUR
!                                 ASSOCIE A D(2) )
!
!===============================================================
    implicit none
#include "asterfort/jacob2.h"
#include "asterfort/b3d_vectp.h"
#include "asterfort/b3d_degre3.h"

      integer idim1
      real(kind=8) :: a(3,3),d(3),x(3,3),xmaxi
!   variables supplémentaires...      
      aster_logical ::  control   
      real(kind=8) :: ad(3),epsv,aux,c0,c1,c2,d1,XI1,d2,XI2,d3,XI3,deps



      if (idim1.ne.3) then
        call jacob2(a,d,x)
        go to 999
      endif
      c2=-a(1,1)-a(2,2)-a(3,3)
      c1= (a(1,1)*a(2,2)+a(2,2)*a(3,3)+a(3,3)*a(1,1))&
        - a(1,3)**2 - a(1,2)**2 - a(2,3)**2
      c0=-2.d0*a(1,2)*a(1,3)*a(2,3) + a(1,1)*a(2,3)**2&
        + a(2,2)*a(1,3)**2 + a(3,3)*a(1,2)**2&
        - a(1,1)*a(2,2)*a(3,3)
      call b3d_degre3(c0,c1,c2,d1,XI1,d2,XI2,d3,XI3)
      d(1)=dmax1(d1,d2,d3)
      d(3)=dmin1(d1,d2,d3)
      d(2)=d1+d2+d3-d(1)-d(3)
!   on impose aux petites valeurs propres d etres exactement egale
!   pour eviter les pb de test de valeurs double
      ad(1)=dabs(d(1))
      ad(2)=dabs(d(2))  
      ad(3)=dabs(d(3)) 
      xmaxi=dmax1(ad(1),ad(2),ad(3))
      deps=xmaxi*epsv
      if((ad(2)+ad(3)).le.deps)then
       aux=0.5d0*(d(2)+d(3))
       d1=d(1)
       d2=aux
       d3=aux
      else
       if(ad(1)+ad(3).le.deps)then
        aux=0.5d0*(d(1)+d(3))
        d1=aux
        d2=d(2)
        d3=aux
       else
        if (ad(1)+ad(2).le.deps)then
         aux=0.5d0*(d(1)+d(2))
         d1=aux
         d2=aux
         d3=d(3)
        end if
       end if
      end if
!   on reclasse les valeurs propres      
      d(1)=dmax1(d1,d2,d3)
      d(3)=dmin1(d1,d2,d3)
      d(2)=d1+d2+d3-d(1)-d(3)       
       
                    
!   rajout du dabs ds le deps     
         deps=dabs(d(1)*epsv)
      if (d(1)-d(2).le.deps) then
!     valeur propre double
       control=.true.
       if (d(2)-d(3).le.deps) then
!      valeur propre triple
        call b3d_vectp(a,d(1),x(1,1),3)
       else
        call b3d_vectp(a,d(1),x(1,1),2)
        call b3d_vectp(a,d(3),x(1,3),1)
       endif
      else
!    rajout du dabs ds le deps
       deps=dabs(d(2)*epsv)
       if (d(2)-d(3).le.deps) then
!      valeur propre double
        control=.true.
        call b3d_vectp(a,d(1),x(1,1),1)
        call b3d_vectp(a,d(2),x(1,2),2)
       else
!      cas normal
        control=.false.
        call b3d_vectp(a,d(1),x(1,1),1)
        call b3d_vectp(a,d(2),x(1,2),1)
        call b3d_vectp(a,d(3),x(1,3),1)
       endif
      endif
999 continue
end subroutine
