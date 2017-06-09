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

subroutine dgmpla(eb, nub, ea, sya, num,&
                  nuf, h, a, b1, b,&
                  nnap, rx, ry, mp, drp,&
                  w)
!
    implicit   none
!
! - PARAMETRES ENTRANTS
!
    real(kind=8) :: eb, nub, ea(*), sya(*), num, nuf
    real(kind=8) :: h, a, b1, b, mp, rx(*), ry(*)
    integer :: nnap, ilit1
!
! - PARAMETRES SORTANTS
    real(kind=8) :: drp, d3, w
!
! person_in_charge: sebastien.fayolle at edf.fr
! ----------------------------------------------------------------------
!
! BUT : CALCUL DES INFORMATIONS NECESSAIRES A LA DETERMINATION DES
! PENTES POST ELASTIQUE EN FLEXION DE GLRC_DM OPTION PLAS
!
! ----------------------------------------------------------------------
!
! - PARAMETRES INTERMEDIAIRES
    real(kind=8) :: delta, x1, x2, m, f, p
    real(kind=8) :: d1, d2, d4, d5, a1, z, c
!
    m=eb/(1.d0-nub**2)*(1.d0-nub*num)
    f=eb/(1.d0-nub**2)*(1.d0-nub*nuf)
    a1=(f+m)*h**2
    z=-(b*h+m*h**2/2.d0)
    c=-f*h**2/4.d0-h*b1
!
    delta=z*z-4.d0*a1*c
    x1=(z-sqrt(delta))/(2.d0*a1)
    x2=(z+sqrt(delta))/(2.d0*a1)
!
    if ((x1 .gt. 0.d0) .and. (x1 .lt. 1.d0)) then
        w=x1
    else if ((x2 .gt. 0.d0) .and. (x2 .lt. 1.d0)) then
        w=x2
    endif
!
    d1=eb/(1.d0-nub**2)*(1.d0-nub*num)*h/2.d0*(1.d0-2.d0*w)+b
    d2=-eb/(1.d0-nub**2)*(1.d0-nub*nuf)*h**2/8.d0*&
     &   (1.d0-4.d0*w**2)-h*b1
    d3=-d2/d1
    p=(rx(1)+ry(1))/2.d0
    drp=abs(sya(1)/(ea(1)*(d3+p*h)))
!
    do 10, ilit1 = 1,nnap
    p=(rx(ilit1)+ry(ilit1))/2.d0
    if (abs(sya(ilit1)/(ea(ilit1)*(d3-p*h))) .lt. drp) then
        drp=abs(sya(ilit1)/(ea(ilit1)*(d3-p*h)))
    endif
    10 end do
!
    ilit1 = nnap
    d4=eb/(1.d0-nub**2)*(-(1.d0-nub*num)*d3*h**2/8.d0*&
     &   (1.d0-4.d0*w**2)+(1.d0-nub*nuf)*h**3/24.d0*(1.d0-8.d0*w**3))
    d5=h*(-b1*d3+a*h)
    c=d4+d5
    mp=c*drp
!
end subroutine
