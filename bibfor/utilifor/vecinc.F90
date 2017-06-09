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

subroutine vecinc(n, s, x, inc)
    implicit none
#include "asterfort/assert.h"
!     INITIALISATION DU VECTEUR COMPLEXE   X = S
!     IN  S      :  COMPLEXE POUR INITIALISER
!     IN  N      :  DIMENSION DE X SI INC=1 (SINON LA DIMENSION EST N*INC)
!     IN  INC    :  INCREMENT SUR LES INDICES DE X A INITIALISER
!     OUT X      :  VECTEUR COMPLEXE RESULTAT
!     POUR TOUS LES TYPES DE DONNEES VOIR AUSSI VECINI, VECINT, VECINK
!     ET VECINC.
!     ----------------------------------------------------------------
!   Obligatory arguments
    integer,         intent(in)   :: n
    complex(kind=8), intent(in)   :: s
    complex(kind=8)               :: x(*)
!   Optional argument
    integer, optional, intent(in) :: inc
!   ------------------------------------------------------------------
    integer :: i, inc2, ninc
!   ------------------------------------------------------------------
    ASSERT(n .ge. 1)
    inc2 = 1
    if (present(inc)) then
        ASSERT(inc .ge. 1)
        inc2 = inc
    endif
    ninc = n*inc2
    do i = 1, ninc, inc2
        x(i) = s
    end do
!
end subroutine
