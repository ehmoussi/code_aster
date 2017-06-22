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

subroutine jacbm1(epais, vectg, vectt, matj, jm1,&
                  detj)
!
    implicit none
    real(kind=8) :: epais, vectg(2, 3), vectt(3, 3)
    real(kind=8) :: matj(3, 3), jm1(3, 3), detj
!
!     CONSTRUCTION DU JACOBIEN J (3,3) AUX X PTS D'INTEGRATION
!                                          X=REDUIT OU NORMAL
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    matj(1,1)=vectg(1,1)
    matj(1,2)=vectg(1,2)
    matj(1,3)=vectg(1,3)
!
    matj(2,1)=vectg(2,1)
    matj(2,2)=vectg(2,2)
    matj(2,3)=vectg(2,3)
!
    matj(3,1)=vectt(3,1)*epais/2.d0
    matj(3,2)=vectt(3,2)*epais/2.d0
    matj(3,3)=vectt(3,3)*epais/2.d0
!
!     CONSTRUCTION DE J-1 AUX X PTS D'INTEGRATION
!
!     CALCUL DU DETERMINANT
!
    detj= matj(1,1)*(matj(2,2)*matj(3,3)-matj(3,2)*matj(2,3))&
     &     -matj(1,2)*(matj(2,1)*matj(3,3)-matj(3,1)*matj(2,3))&
     &     +matj(1,3)*(matj(2,1)*matj(3,2)-matj(3,1)*matj(2,2))
!
    jm1(1,1)= (matj(2,2)*matj(3,3)-matj(2,3)*matj(3,2))/detj
    jm1(1,2)=-(matj(1,2)*matj(3,3)-matj(1,3)*matj(3,2))/detj
    jm1(1,3)= (matj(1,2)*matj(2,3)-matj(1,3)*matj(2,2))/detj
!
    jm1(2,1)=-(matj(2,1)*matj(3,3)-matj(2,3)*matj(3,1))/detj
    jm1(2,2)= (matj(1,1)*matj(3,3)-matj(1,3)*matj(3,1))/detj
    jm1(2,3)=-(matj(1,1)*matj(2,3)-matj(1,3)*matj(2,1))/detj
!
    jm1(3,1)= (matj(2,1)*matj(3,2)-matj(2,2)*matj(3,1))/detj
    jm1(3,2)=-(matj(1,1)*matj(3,2)-matj(1,2)*matj(3,1))/detj
    jm1(3,3)= (matj(1,1)*matj(2,2)-matj(1,2)*matj(2,1))/detj
!
end subroutine
