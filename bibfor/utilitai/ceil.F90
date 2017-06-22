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

function ceil(x)
!
!
    implicit none
    integer :: ceil
    real(kind=8) :: x
!
! FONCTION CEIL (CEILING EN FORTRAN90) :
!        RENVOIE L'ENTIER IMMEDIATEMENT SUPERIEUR A LA VALEUR DU REEL X
!
! IN  X      : VALEUR DU REEL A ARRONDIR
! OUT CEIL : VALEUR DE L'ENTIER IMMEDIATEMENT SUPERIEUR A X
!
    integer :: n
!
    n = nint(x)
!
    if (x .gt. n) then
        ceil = n+1
    else
        ceil = n
    endif
!
end function
