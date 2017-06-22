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

subroutine lcvalp(t, valp)
    implicit none
    real(kind=8),intent(in) :: t(6)
    real(kind=8),intent(out):: valp(3)
! --------------------------------------------------------------------------------------------------
!  CALCUL DES VALEURS PROPRES D'UN TENSEUR SYMETRIQUE
! --------------------------------------------------------------------------------------------------
!  T      IN  TENSEUR (1:6) CODE AVEC RAC2 SUR LE CISAILLEMENT
!  VALP   OUT VALEURS PROPRES (1:3) DANS L'ORDRE DECROISSANT
! --------------------------------------------------------------------------------------------------
    real(kind=8),parameter,dimension(6):: kr=(/1.d0,1.d0,1.d0,0.d0,0.d0,0.d0/)
    real(kind=8),parameter:: pi = 4*atan(1.d0)
    real(kind=8),parameter:: rac2 = sqrt(2.d0)
! --------------------------------------------------------------------------------------------------
    real(kind=8) :: p, d(6), s, s3, quatj3, ratio, th
! --------------------------------------------------------------------------------------------------
!
!  PREMIER INVARIANT
    p = (t(1)+t(2)+t(3))/3
!
!  DEVIATEUR ET SECOND INVARIANT (2/3 VON MISES)
    d = t - p*kr
    s = sqrt(2.d0*dot_product(d,d)/3.d0)
    s3 = s**3
!
!  TROISIEME INVARIANT (4 X DETERMINANT DE DEV)
    quatj3 = 4*d(1)*d(2)*d(3)-2*d(3)*d(4)**2+2*rac2*d(4)*d(5)*d(6)-2*d(1)*d(6)**2-2*d(2)*d(5)**2
!
!  ANGLE DE LODE
    if (abs(quatj3) .ge. s3) then
        ratio = sign(1.d0,quatj3)
    else
        ratio = quatj3/s3
        ratio = max(ratio,-1.d0)
        ratio = min(ratio, 1.d0)
    endif
    th = acos(ratio)/3
!
!  VALEURS PROPRES RANGEES DANS L'ORDRE DECROISSANT
    valp(1) = p + s*cos(th)
    valp(2) = p + s*cos(th-2*pi/3.d0)
    valp(3) = p + s*cos(th+2*pi/3.d0)
!
end subroutine
