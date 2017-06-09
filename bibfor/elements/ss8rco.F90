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

subroutine ss8rco(x, rr)
!        ELEMENT SHB8-PS A.COMBESCURE, S.BAGUET INSA LYON 2003         !
!-----------------------------------------------------------------------
    implicit none
!
! Solid-Shell 8-node Repère Corotationnel
! Evaluation of (3,3) transformation matrix from global to local corotational frame
!
!
! Evaluation of (3,3) transformation matrix from global to local corotational frame
! for solide-shell element SHB8.
!
!
! IN  x        element nodal coordinates in global coordinate system
! OUT rr       (3,3) transformation matrix from global to corotational coordinate system
!
    real(kind=8), intent(in) :: x(24)
    real(kind=8), intent(out) :: rr(3, 3)
!
    real(kind=8) :: aux, aa, un, unsaux
!
! ......................................................................
!
    un = 1.0d0
!
    rr(1,1)= - x(1)  +  x(4)  +  x(7)  -   x(10) - x(13) +  x(16) +  x(19) -  x(22)
    rr(1,2)= - x(2)  +  x(5)  +  x(8)  -   x(11) - x(14) +  x(17) +  x(20) -  x(23)
    rr(1,3)= - x(3)  +  x(6)  +  x(9)  -   x(12) - x(15) +  x(18) +  x(21) -  x(24)
!
    rr(2,1)= - x(1)  -  x(4)  +  x(7)  +   x(10) - x(13) -  x(16) +  x(19) +  x(22)
    rr(2,2)= - x(2)  -  x(5)  +  x(8)  +   x(11) - x(14) -  x(17) +  x(20) +  x(23)
    rr(2,3)= - x(3)  -  x(6)  +  x(9)  +   x(12) - x(15) -  x(18) +  x(21) +  x(24)
!
    aux= rr(1,1)*rr(1,1)+rr(1,2)*rr(1,2)+rr(1,3)*rr(1,3)
    aa = rr(1,1)*rr(2,1)+rr(1,2)*rr(2,2)+rr(1,3)*rr(2,3)
    aa = -(aa/aux)
!
    rr(2,1)= rr(2,1) + aa*rr(1,1)
    rr(2,2)= rr(2,2) + aa*rr(1,2)
    rr(2,3)= rr(2,3) + aa*rr(1,3)
!
    rr(3,1)= rr(1,2)*rr(2,3) - rr(1,3)*rr(2,2)
    rr(3,2)= rr(1,3)*rr(2,1) - rr(1,1)*rr(2,3)
    rr(3,3)= rr(1,1)*rr(2,2) - rr(1,2)*rr(2,1)
!
    aux = sqrt(aux)
    unsaux = un / aux
    rr(1,1)= rr(1,1) * unsaux
    rr(1,2)= rr(1,2) * unsaux
    rr(1,3)= rr(1,3) * unsaux
!
    aux = sqrt(rr(2,1)*rr(2,1)+rr(2,2)*rr(2,2)+rr(2,3)*rr(2,3))
    unsaux = un / aux
    rr(2,1)= rr(2,1) * unsaux
    rr(2,2)= rr(2,2) * unsaux
    rr(2,3)= rr(2,3) * unsaux
!
    aux = sqrt(rr(3,1)*rr(3,1)+rr(3,2)*rr(3,2)+rr(3,3)*rr(3,3))
    unsaux = un / aux
    rr(3,1)= rr(3,1) * unsaux
    rr(3,2)= rr(3,2) * unsaux
    rr(3,3)= rr(3,3) * unsaux
!
end subroutine
