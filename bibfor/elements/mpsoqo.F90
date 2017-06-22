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

subroutine mpsoqo(p33, p66)
    implicit none
!
! Matrice de Passage du Second Ordre au Quatrième Ordre
!
!
! Transform second order transformation matrix (3,3) to
! fourth order transformation matrix (6,6)
!
!
! IN  p33      second order transformation matrix
! OUT p66      fourth order transformation matrix
!
    real(kind=8), intent(in) :: p33(3,3)
    real(kind=8), intent(out) :: p66(6,6)
!
! ......................................................................
!
! ---- INITIALISATIONS
!      ---------------
    real(kind=8) :: deux
    deux = 2.0d0
!
    p66(1,1) = p33(1,1)*p33(1,1)
    p66(1,2) = p33(1,2)*p33(1,2)
    p66(1,3) = p33(1,3)*p33(1,3)
    p66(1,4) = p33(1,1)*p33(1,2)
    p66(1,5) = p33(1,1)*p33(1,3)
    p66(1,6) = p33(1,2)*p33(1,3)
!
    p66(2,1) = p33(2,1)*p33(2,1)
    p66(2,2) = p33(2,2)*p33(2,2)
    p66(2,3) = p33(2,3)*p33(2,3)
    p66(2,4) = p33(2,1)*p33(2,2)
    p66(2,5) = p33(2,1)*p33(2,3)
    p66(2,6) = p33(2,2)*p33(2,3)
!
    p66(3,1) = p33(3,1)*p33(3,1)
    p66(3,2) = p33(3,2)*p33(3,2)
    p66(3,3) = p33(3,3)*p33(3,3)
    p66(3,4) = p33(3,1)*p33(3,2)
    p66(3,5) = p33(3,1)*p33(3,3)
    p66(3,6) = p33(3,2)*p33(3,3)
!
    p66(4,1) = deux*p33(1,1)*p33(2,1)
    p66(4,2) = deux*p33(1,2)*p33(2,2)
    p66(4,3) = deux*p33(1,3)*p33(2,3)
    p66(4,4) = p33(1,1)*p33(2,2) + p33(1,2)*p33(2,1)
    p66(4,5) = p33(1,1)*p33(2,3) + p33(1,3)*p33(2,1)
    p66(4,6) = p33(1,2)*p33(2,3) + p33(1,3)*p33(2,2)
!
    p66(5,1) = deux*p33(1,1)*p33(3,1)
    p66(5,2) = deux*p33(1,2)*p33(3,2)
    p66(5,3) = deux*p33(1,3)*p33(3,3)
    p66(5,4) = p33(1,1)*p33(3,2) + p33(1,2)*p33(3,1)
    p66(5,5) = p33(1,1)*p33(3,3) + p33(1,3)*p33(3,1)
    p66(5,6) = p33(1,2)*p33(3,3) + p33(1,3)*p33(3,2)
!
    p66(6,1) = deux*p33(2,1)*p33(3,1)
    p66(6,2) = deux*p33(2,2)*p33(3,2)
    p66(6,3) = deux*p33(2,3)*p33(3,3)
    p66(6,4) = p33(2,1)*p33(3,2) + p33(2,2)*p33(3,1)
    p66(6,5) = p33(2,1)*p33(3,3) + p33(2,3)*p33(3,1)
    p66(6,6) = p33(2,2)*p33(3,3) + p33(3,2)*p33(2,3)
!    
end subroutine
