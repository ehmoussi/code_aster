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

subroutine b3d_valp33(x33,x3,v33)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!   A.Sellier jeu. 02 sept. 2010 18:13:24 CEST 
!   diagonalisagion 33 a partir de jacobi + quelques controles
implicit none
#include "asterf_types.h"
#include "asterfort/b3d_jacobi.h"
#include "asterfort/indice1.h"
#include "asterfort/matmat.h"
#include "asterfort/matini.h"
#include "asterfort/utmess.h"
!   declarations externes

      integer k,l
      real(kind=8) :: x33(3,3),x3(3),v33(3,3),y33(3,3)
!   declarations locales      
      real(kind=8) :: epsv,eps1,xn
      integer i,j
      real(kind=8) :: un
!   une matrice est consideree comme deja diagonale si test 20 verifie
!   fonction de la prescision relative epsv
!   epsv est aussi utilise   dans jacob3 pour decider si deux valeurs
!   propres petites par rapport a la troisieme peuvent etre consideree
!   comme des doubles, ce qui evite de rechercher des vecteurs propres
!   avec une matrice mal conditonnee
!   enfin epsv est utilise en fin de programme pour tester si la matrice
!   de passage fonctionne correctement, pour cela on verifie si la propriete
!   vt*v est verifiee  a epsv pres hors diagonale si ce n est pas le cas
!   on affiche un message non bloquant
      parameter(un=1.d0,epsv=1.d-6)
      real(kind=8) :: v33t(3,3)
      real(kind=8) :: u33(3,3)
      aster_logical ::  vpmultiple,erreur,diago,ordre     
      real(kind=8), dimension(9) :: valr

     xn=0.d0
     eps1=0.d0
     u33(:,:)=0.d0

!   epsv*d(1) valeur en dessous la quelle un terme hors diagonale est negligee
!   lors du calcul des vecteurs propres
      vpmultiple=.false.
      diago=.false.
      ordre=.true.  

!     STOCKAGE de x33 dans y33 pour diagonalisation par jacobi iterative
!     car cette methode ecrit sur y33
      do i=1,3
         do j=1,3
            y33(i,j)=x33(i,j)
         end do
      end do
      call b3d_jacobi(y33,v33,x3)
        
!   controle des normes de v33
      do i=1,3
        xn=dsqrt(v33(1,i)**2+v33(2,i)**2+v33(3,i)**2)
        if(dabs(xn-1.d0).gt.1.d-4) then
          call indice1(i,k,l)
          v33(1,i)=v33(2,k)*v33(3,l)-v33(3,k)*v33(2,l)
          v33(2,i)=v33(3,k)*v33(1,l)-v33(1,k)*v33(3,l)
          v33(3,i)=v33(1,k)*v33(2,l)-v33(2,k)*v33(1,l) 
          xn=dsqrt(v33(1,i)**2+v33(2,i)**2+v33(3,i)**2)
            do k=1,3
               v33(k,i)=v33(k,i)/xn
            end do
        end if
      end do
      
      
!   **verif produit scalaire entre v1 et v2*****
      eps1=0.d0
      do i=1,3
       eps1=eps1+v33(i,1)*v33(i,2)
      end do
      if(dabs(eps1).gt.1.d-4) then
!      test produit scalaire v1 v3         
         eps1=0.d0
         do i=1,3
           eps1=eps1+v33(i,1)*v33(i,3)
         end do
         if(dabs(eps1).gt.1.d-4) then
!         correction de v1
            do i=1,3
              v33(i,1)=v33(i,1)-eps1*v33(i,3)
            end do
!         renormalisation
            xn=dsqrt(v33(1,1)**2+v33(2,1)**2+v33(3,1)**2)
            do i=1,3
               v33(i,1)=v33(i,1)/xn
            end do               
         end if
!      v1 et v3 etant orthogonaux on reconstruit v2 par produit
!      vectoriel
         v33(1,2)=v33(2,1)*v33(3,3)-v33(3,1)*v33(2,3)
         v33(2,2)=v33(3,1)*v33(1,3)-v33(1,1)*v33(3,3)
         v33(3,2)=v33(1,1)*v33(2,3)-v33(2,1)*v33(1,3)
      else
!    test produit scalaire v2 v3
       eps1=0.d0
       do i=1,3
        eps1=eps1+v33(i,2)*v33(i,3)
       end do 
       if(dabs(eps1).gt.1.d-4) then
!      test produit scalaire v1 v3         
         eps1=0.d0
         do i=1,3
           eps1=eps1+v33(i,1)*v33(i,3)
         end do
         if(dabs(eps1).gt.1.d-4) then
!         correction de v3
            do i=1,3
              v33(i,3)=v33(i,3)-eps1*v33(i,1)
            end do
!         renormalisation
            xn=dsqrt(v33(1,3)**2+v33(2,3)**2+v33(3,3)**2)
            do i=1,3
               v33(i,3)=v33(i,3)/xn
            end do 
         end if
!      v1 et v3 etant orthogonaux on reconstruit v2 par produit
!      vectoriel
         v33(1,2)=v33(2,1)*v33(3,3)-v33(3,1)*v33(2,3)
         v33(2,2)=v33(3,1)*v33(1,3)-v33(1,1)*v33(3,3)
         v33(3,2)=v33(1,1)*v33(2,3)-v33(2,1)*v33(1,3)
        else
!      test du produit scalaire entre v1 v3
         eps1=0.d0
         do i=1,3
          eps1=eps1+v33(i,1)*v33(i,3)
         end do 
         if(dabs(eps1).gt.1.d-4) then
!        test produit scalaire v3 v2         
           eps1=0.d0
           do i=1,3
             eps1=eps1+v33(i,2)*v33(i,3)
           end do
           if(dabs(eps1).gt.1.d-4) then
!         correction de v3 avec v2
            do i=1,3
              v33(i,3)=v33(i,3)-eps1*v33(i,2)
            end do
!         renormalisation
            xn=dsqrt(v33(1,3)**2+v33(2,3)**2+v33(3,3)**2)
            do i=1,3
               v33(i,3)=v33(i,3)/xn
            end do 
!         v2 et v3 etant orthogonaux on reconstruit v1 par produit
!         vectoriel
            v33(1,1)=v33(2,2)*v33(3,3)-v33(3,2)*v33(2,3)
            v33(2,1)=v33(3,2)*v33(1,3)-v33(1,2)*v33(3,3)
            v33(3,1)=v33(1,2)*v33(2,3)-v33(2,2)*v33(1,3)             
           end if 
        end if        
       end if
      end if

      do i=1,3
       do j=1,3
        v33t(i,j)=v33(j,i)
       end do
      end do 
 
!   verif validite des matrice de passage
!   (on change de nase une matrice unitaire)
      erreur=.false.
      call matmat(v33,v33t,3,3,3,u33)
      do i=1,3
       do j=1,3
        if (i.eq.j)then
         if( dabs(u33(i,i)-un) .gt. dsqrt(epsv))then
          erreur=.true.
          goto 10
         endif
        else
         if( dabs(u33(i,j)) .gt. dsqrt(epsv))then
          erreur=.true.
          goto 10
         endif
        end if
       end do
      end do 



!   affichage des variables en cas de pb de diagonalisation  
10    continue
      if(erreur)then
        valr(1) = v33(1,1)
        valr(2) = v33(1,2)
        valr(3) = v33(1,3)
        valr(4) = v33(2,1)
        valr(5) = v33(2,2)
        valr(6) = v33(2,3)
        valr(7) = v33(3,1)
        valr(8) = v33(3,2)
        valr(9) = v33(3,3)
        call utmess('E', 'COMPOR3_12', nr=9, valr=valr)
      end if
end subroutine
