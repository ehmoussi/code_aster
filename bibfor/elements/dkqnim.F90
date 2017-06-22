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

subroutine dkqnim(shp, shpr1, shpr2, shpmem1, shpmem2, gm1, gm2)
    implicit  none
    real(kind=8) :: shp(3,4), shpr1(3,4), shpr2(3,4)
    real(kind=8) :: shpmem1(8), shpmem2(8), gm1(4), gm2(4)
!     MATRICES DES FONCTIONS DE BASE POUR LE COMPOSANTES u1 et u2 
!       DU DEPLACEMENT DE LA MEMBRANE AU POINT QSI ETA POUR ELEMENTS DKQ 
!     ------------------------------------------------------------------
!     person_in_charge: ayaovi-dzifa.kudawoo at edf.fr


    integer :: j, j1
    

        j1 = 0
        
        do j = 1, 4
        
         shpmem1(1+j1) = shp(3,j)
         shpmem1(2+j1) = 0.d0

         shpmem2(1+j1) = 0.d0
         shpmem2(2+j1) = shp(3,j)

         j1 = j1+2
         
         gm1(j) = shpr1(3,j)
         gm2(j) = shpr2(3,j)

        end do
   
!
end subroutine
