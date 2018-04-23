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

subroutine tail_reel(l3, vss33, dim3, ndim, ifour)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!---------------------------------------------------------------------
!     BUT: DONNER LES TAILLES DE L'ELEMENT DANS LES DIRECTIONS PRINCIPALES
!---------------------------------------------------------------------
! DECLARATIONS LOCALES

    implicit none
#include "asterfort/tecael.h"
#include "asterfort/jevech.h"
#include "asterfort/jeveuo.h"
#include "jeveux.h"
#include "asterc/r8prem.h"
!-----------------------------------------------------------------------
    integer :: i, j, k
!-----------------------------------------------------------------------


    integer :: ima, nbno, iadzi, iazk24, a, IGEOM, ndim, ifour
    real(kind=8) ::  coorproj(27), s, maxi, mini, maximu, l3(3), dim3
    real(kind=8) ::  vss33(3,3)

    maxi = 0.d0
    mini = 0.d0
    maximu = 0.d0

! Recherche du nom du maillage, du numéro pour y accéder, du numéro
! de la maille, et du nombre de noeuds
   call tecael(iadzi, iazk24,1)
    nbno=zi(iadzi-1+2)
    ima=zi(iadzi-1+1)

! Routine visant à remplir un vecteur avec les coordonnées des points d'une maille
   call jevech('PGEOMER','L',IGEOM)

! DEBUT DU CALCUL DU PRODUIT SCALAIRE DES VECTEURS PROPRES DES DIRECTIONS 
!PRINCIPALES AVEC LES COORDONNEES POUR PROJECTION
! Il y a 3 vecteurs propres quel que soit la dimension du maillage
        do 5 i = 1, 3
                l3(i)=0.d0

! nbno points à projeter par maille    
                  do 6 j = 1, nbno
                        s=0.d0  
                      do 7 k = 1, ndim
                              a = ndim*(j-1)+k-1
                              s = vss33(k,i)*zr(IGEOM+a) + s
                         7      continue                              
                              coorproj(j) = s
                              if (j .eq. 1) then 
                                  maxi=s
                                  mini=s
                              endif 
                              if (s .gt. maxi) then 
                              maxi=s
                              endif
                              if (s .lt. mini) then 
                              mini=s
                              endif
 6      continue

                l3(i) = maxi-mini


! Avec dim3 qui est un paramètre matériau on peut régler la taille 
! de la dimension 3 en 2D
                if (l3(i).lt.r8prem()) then
!           si en AXIS DIM3 permet de définir l'angle en radians
!           sur laquelle la fissure va pouvoir se propager (0< DIM3 < 2 PI)
                    if (ifour .eq. 0) then
                         do  j = 1, nbno
                           if (j .eq. 1) then
                           maximu = abs(zr(IGEOM))
                           endif
                              a = ndim*(j-1)    
                              maximu = max(abs(zr(IGEOM+a)),maximu)
                          end do                  
                    l3(i) = (maximu)*dim3                       
                    else 
                    l3(i)= dim3
                    endif
                endif
 5      continue
end subroutine
