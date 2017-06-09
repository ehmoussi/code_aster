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

subroutine fcepai(zr)
    implicit none
    real(kind=8) :: zr(*), vf(3)
!
!---  DEFINITION DES 3 POINTS DE D'INTEGRATION SUR L'EPAISSEUR DE LA
!---  COUCHE
!
!-----------------------------------------------------------------------
    integer :: i, i1, j, l, ll
    real(kind=8) :: xi3
!-----------------------------------------------------------------------
    j=1500
!
    zr(j+1)= -1.d0
    zr(j+2)=  0.d0
    zr(j+3)=  1.d0
!
!     DEFINITION DES 3 POIDS DE NEWTON-COTES CORRESPONDANTS
!
    zr(j+4)=  0.333333333333333d0
    zr(j+5)=  1.333333333333333d0
    zr(j+6)=  0.333333333333333d0
!
!     VALEURS DES 3 PARABOLES (POUR LA DISTRIBUTION DE LA TEMPERATURE)
!     AUX 3 PTS DE D'INTEGRATION PRECEDANTS
!
    do 100 i = 1, 3
        xi3=zr(j+i)
!
        vf(1)= 1-xi3*xi3
        vf(2)=-xi3*(1-xi3)/2.d0
        vf(3)= xi3*(1+xi3)/2.d0
!
        ll=3*(i-1)
        do 110 l = 1, 3
            i1=6+ll+l
            zr(j+i1)=vf(l)
110      continue
100  continue
!
end subroutine
