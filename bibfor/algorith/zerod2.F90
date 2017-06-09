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

subroutine zerod2(x, y, z)
!
    implicit none
#include "asterfort/utmess.h"
    real(kind=8) :: x(3), y(3), z(3)
! ----------------------------------------------------------------------
!  RESOLUTION D'EQUATIONS SCALAIRES PAR UNE METHODE DE DICHOTOMIE
!    ON PERMUTE AUSSI LES VALEURS DES DERIVEES PLACEES EN Z
! ----------------------------------------------------------------------
! VAR X(1) BORNE DE L'INTERVALLE DE RECHERCHE  TQ Y(1) < 0
! VAR X(2) BORNE DE L'INTERVALLE DE RECHERCHE  TQ Y(2) > 0
! VAR X(3) SOLUTION X(N-1) PUIS SOLUTION EN X(N)  (NE SERT PAS)
! VAR X(4) SOLUTION X(N)   PUIS SOLUTION EN X(N+1)
! VAR Y(I) VALEUR DE LA FONCTION EN X(I)
! ----------------------------------------------------------------------
!
    real(kind=8) :: xp
!
!    REACTUALISATION DE L'INTERVALLE DE RECHERCHE
    if (y(3) .lt. 0.d0) then
        x(1) = x(3)
        y(1) = y(3)
        z(1) = z(3)
    endif
!
    if (y(3) .gt. 0.d0) then
        x(2) = x(3)
        y(2) = y(3)
        z(2) = z(3)
    endif
!
!    CONSTRUCTION D'UN NOUVEL ESTIME
    if (x(1) .eq. x(2)) then
        call utmess('F', 'ALGORITH9_84')
    endif
    xp = (x(1) + x(2)) / 2.d0
!
!    DECALAGE DES ITERES
    x(3) = xp
!
end subroutine
