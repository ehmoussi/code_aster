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

subroutine trgfct(fcttab)
!_____________________________________________________________________
!
!     TRGFCT
!
!      CALCUL DES PARAMETRES TRIGONOMÉTRIQUES POUR LES (36) FACETTES
!
!_____________________________________________________________________
!
!
    implicit none
!
!
!     ! FACETTES POUR METHODE DE CAPRA ET MAURY
!
!       36 FACETTES
!       NOMBRE DE DIVISIONS ENTRE -PI/2 ET +PI/2
    real(kind=8) :: fcttab(36, 3)
!
!       ANGLE DE LA FACETTE (-PI/2 <= X < +PI/2)
    real(kind=8) :: angle
    real(kind=8) :: pas
    integer :: i
!
    fcttab(1,1) = 0d0
!
    fcttab(1,2) = 1d0
    fcttab(1,3) = 0d0
!
!       -PI
    angle = -4d0 * atan2(1.d0,1.d0)
!       2PI/N
    pas = -2d0 * angle / 36d0
!
!       POUR CHAQUE FACETTE, LES VALEURS SONT
!         C = COS^2
!         S = SIN^2
!         R = 2 SIN COS
    do 20 i = 2, 36
        angle = angle + pas
        fcttab(i,1) = 0.5d0 * (1d0 + cos(angle))
        fcttab(i,2) = 1d0 - fcttab(i,1)
        fcttab(i,3) = sin(angle)
20  continue
end subroutine
