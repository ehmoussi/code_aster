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

subroutine chrep3d(M,A,P)
!   changement de repère d'une matrice 3*3
!   M = P'AP  où P'=transposée(P)
!   M, P, A sont des matrices 3*3

! ======================================================================
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
 implicit none
#include "asterfort/matmat3d.h"      


      real(kind=8) :: M(3,3),A(3,3),P(3,3)
      real(kind=8) :: TP(3,3),R(3,3)
      integer i,j

!   on calcule la transposée de P => TP
      do i=1,3
        do j=1,3
          TP(i,j)=P(j,i)
          M(i,j)=0.D0
        enddo
      enddo                                          
      call matmat3d(A,P,3,3,3,R)
      call matmat3d(TP,R,3,3,3,M)
end subroutine
