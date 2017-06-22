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

subroutine vecint(n, s, x)
    implicit none
!     INITIALISATION DU VECTEUR D'ENTIER   X = S
!     IN  S      :  ENTIER POUR INITIALISER
!     IN  N      :  DIMENSION DE X
!     OUT X      :  VECTEUR D'ENTIER RESULTAT
!     POUR TOUS LES TYPES DE DONNEES VOIR AUSSI VECINI, VECINT, VECINK
!     ET VECINC.
!     ----------------------------------------------------------------
    integer :: n, i
    integer :: x(n), s
    do 1 i = 1, n
        x(i)=s
 1  end do
end subroutine
