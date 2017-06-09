! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine xsolveurtria(coor_nod, x, y, z, D, indmax, solution )

   implicit none

#include "asterc/r8gaem.h"

    integer                           ::  indmax    
    real(kind=8),dimension(3,3)       ::  coor_nod
    real(kind=8)                      ::  D(:),x(:),y(:),z(:) ,solution
  
! person_in_charge: patrick.massin at edf.fr

    integer                           ::  i, j, Id(2)
    real(kind=8)                      ::  valphi(2), term(3), delta, n(2), p, detT
    real(kind=8),dimension(3,2)       ::  V
    real(kind=8),dimension(2,2)       ::  T, invT

    
    do i = 1 , 3

        j = mod(i,3) + 1 

        !   première colonne 
        V(1,1)  = coor_nod(1,i)-x(indmax)
        V(2,1)  = coor_nod(2,i)-y(indmax)
        V(3,1)  = coor_nod(3,i)-z(indmax)

        !   deuxième colonne    
        V(1,2)  = coor_nod(1,j)-x(indmax)
        V(2,2)  = coor_nod(2,j)-y(indmax)
        V(3,2)  = coor_nod(3,j)-z(indmax)            

        !   valeur de phi au noeud
        valphi(1) = D(i) 
        valphi(2) = D(j)

        !   vecteur unité
        Id(1) = 1
        Id(2) = 1


        !!!!!!!!!!!!!!!!!!!!!!!!!!!CALCUL DES TERMES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        T= matmul(transpose(V),V)
        
        detT = T(1,1)*T(2,2)-T(1,2)*T(2,1)
        
        invT(1,1) = (1/detT)*T(2,2)
        invT(1,2) = (-1/detT)*T(1,2)

        invT(2,1) = (-1/detT)*T(2,1)
        invT(2,2) = (1/detT)*T(1,1)

                                            
        term(1)=dot_product(Id,matmul(invT,Id))
        term(2)=dot_product(Id,matmul(invT,valphi))
        term(3)=dot_product(valphi,matmul(invT,valphi))                
                                                                     
        !!!!!!!!!!!!!!!!!!!!CALCUL DE LA LEVEL SET AU POINT INCONNU!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!       Calcul du discriminant
        delta = (term(2))**2.d0-term(1)*(term(3)-1)
                              
        if ( delta < 0 ) cycle
        
        p = (1/term(1))*(term(2)+sqrt(delta)) 
        
!       Test sur la direction de propagation
        n = matmul(invT,valphi-p*Id)
        
        if (n(1) .lt. 0 .and. n(2) .lt. 0 ) then
            solution = min( p, solution)
        endif

    enddo

end subroutine    
