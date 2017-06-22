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

subroutine dgmmax(eb, nub, num, nuf, h,&
                  a, b1, b, mp, drp,&
                  w, c)
!
    implicit none
!
! PARAMETRES ENTRANTS
    real(kind=8) :: eb, nub, num, nuf
    real(kind=8) :: h, a, b1, b, drp
!
! PARAMETRES SORTANTS
    real(kind=8) :: d3, w, mp, c
!
! person_in_charge: sebastien.fayolle at edf.fr
! ----------------------------------------------------------------------
!
! BUT : CALCUL DES INFORMATIONS NECESSAIRES A LA DETERMINATION DES
! PENTES POST ELASTIQUE EN FLEXION DE GLRC_DM OPTION EPSI_MAX
! OU PENTE_LIM
!
! ----------------------------------------------------------------------
!
! PARAMETRES INTERMEDIAIRES
    real(kind=8) :: delta, x1, x2, m, f
    real(kind=8) :: d1, d2, d4, d5, a1, z
!
    m=eb/(1.d0-nub**2)*(1.d0-nub*num)
    f=eb/(1.d0-nub**2)/2.d0*(1.d0-nub*nuf)
    a1=f-m
    z=(b+m*h/2.d0)
    c=-f*h**2/4.d0-h*b1
!
    delta=z*z-4.d0*a1*c
    x1=(z-sqrt(delta))/(2.d0*a1)
    x2=(z+sqrt(delta))/(2.d0*a1)
!
    if (abs(x1) .ge. abs(x2)) then
        w=abs(x2)
    else
        w=abs(x1)
    endif
!
    d1=eb/(1.d0-nub**2)*(1.d0-nub*num)*(h/2.d0-w)+b
    d2=-eb/(1.d0-nub**2)/2.d0*(1.d0-nub*nuf)*(h**2/4.d0-w**2)-h*b1
    d3=-d2/d1
    d4=eb/(1.d0-nub**2)*(-(1.d0-nub*num)*d3/2.d0*(h**2/4.d0-w**2)+&
     &   (1.d0-nub*nuf)/3.d0*(h**3/8.d0-w**3))
    d5=h*(-b1*d3+a*h)
    c=d4+d5
    mp=c*drp
end subroutine
