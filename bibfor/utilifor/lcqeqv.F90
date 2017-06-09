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

function lcqeqv(x, y)
    implicit none
!       EGALITE DE 2 VECTEURS  X =? Y
!       IN  X      :  VECTEUR
!       IN  Y      :  VECTEUR
!       OUT LCQEQV :  REPONSE = 'OUI' OU 'NON'
!       ----------------------------------------------------------------
    real(kind=8) :: epsi
!-----------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------
    parameter       ( epsi = 1.d-9 )
    integer :: n, nd
    real(kind=8) :: x(6), y(6)
    character(len=3) :: lcqeqv
    common /tdim/   n , nd
!       ----------------------------------------------------------------
    do 1 i = 1, n
        if (abs (x(i) - y(i)) .gt. epsi) then
            lcqeqv = 'NON'
            goto 9999
        endif
 1  continue
    lcqeqv = 'OUI'
!
9999  continue
end function
