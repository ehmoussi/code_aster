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

subroutine masstg(matin, matout)
    implicit none
! -----------------------------------------------------------
! ---  BUT : MISE SOUS LA FORME DES MATRICES DE MASSE DES
!            POU_D_TG(M) DE LA MATRICE ISSUE DE PTMA01
! -----------------------------------------------------------
    real(kind=8), intent(in) :: matin(78)
    real(kind=8), intent(out) :: matout(105)
!
    matout(1:21)   = matin(1:21)
    matout(22:28)  = 0.d0
    matout(29:34)  = matin(22:27)
    matout(35)     = 0.d0
    matout(36:42)  = matin(28:34)
    matout(43)     = 0.d0
    matout(44:51)  = matin(35:42)
    matout(52)     = 0.d0
    matout(53:61)  = matin(43:51)
    matout(62)     = 0.d0
    matout(63:72)  = matin(52:61)
    matout(73)     = 0.d0
    matout(74:84)  = matin(62:72)
    matout(85)     = 0.d0
    matout(86:91)  = matin(73:78)
    matout(92:105) = 0.d0
!
end subroutine
