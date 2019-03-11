! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
!
subroutine elrfvf(elrefz, x, dimf, ff, nno)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
    character(len=*), intent(in) :: elrefz
    real(kind=8), intent(in)     :: x(*)
    integer, intent(in)          :: dimf
    real(kind=8), intent(out)    :: ff(*)
    integer, intent(out)         :: nno
!
! person_in_charge: jacques.pellet at edf.fr
!
!
! BUT:   CALCUL DES FONCTIONS DE FORMES ET DE LEURS DERIVEES
!        AU POINT DE COORDONNEES X,Y,Z
!
! ----------------------------------------------------------------------
!   IN   ELREFZ : NOM DE L'ELREFE (K8)
!        X      : VECTEUR DU POINT DE CALCUL DES F FORMES ET DERIVEES
!        DIMF   : DIMENSION DE FF
!   OUT  FF     : FONCTIONS DE FORMES EN X,Y,Z
!        NNO    : NOMBRE DE NOEUDS
!   -------------------------------------------------------------------
    integer :: i
    real(kind=8) ::  x0=0.0, y0=0.0, z0=0.0, al=0.0, z01=0.0, z02=0.0, z04=0.0, pface1=0.0
    real(kind=8) :: pface2 = 0.0
    real(kind=8) :: pface3 =0.0, pface4=0.0, pmili1=0.0, pmili2=0.0, pmili3=0.0, pmili4=0.0
    real(kind=8) :: x1=0.0, x2=0.0, x3=0.0, x4=0.0, d1=0.0, d2=0.0, d3=0.0, d4=0.0
    real(kind=8), parameter :: zero = 0.d0, un = 1.d0, deux = 2.d0, quatre = 4.d0
    real(kind=8), parameter :: undemi = 0.5d0, uns4 = 0.25d0, uns8 = 0.125d0
!
! -----  FONCTIONS FORMULES
!
#define al31(u)   0.5d0*(u)* (u-1.d0)
#define al32(u)   (-(u+1.d0)*(u-1.d0))
#define al33(u)   0.5d0*(u)* (u+1.d0)
!
! DEB ------------------------------------------------------------------
!
    select case (elrefz)
        case('HE8')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
            nno = 8
            ASSERT(dimf.ge.nno)
!
            ff(1) = (un-x0)* (un-y0)* (un-z0)*uns8
            ff(2) = (un+x0)* (un-y0)* (un-z0)*uns8
            ff(3) = (un+x0)* (un+y0)* (un-z0)*uns8
            ff(4) = (un-x0)* (un+y0)* (un-z0)*uns8
            ff(5) = (un-x0)* (un-y0)* (un+z0)*uns8
            ff(6) = (un+x0)* (un-y0)* (un+z0)*uns8
            ff(7) = (un+x0)* (un+y0)* (un+z0)*uns8
            ff(8) = (un-x0)* (un+y0)* (un+z0)*uns8
!
!         ------------------------------------------------------------------
        case('H20')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
            nno = 20
            ASSERT(dimf.ge.nno)
!
            ff(1) = (un-x0)* (un-y0)* (un-z0)* (-x0-y0-z0-deux)*uns8
            ff(2) = (un+x0)* (un-y0)* (un-z0)* (x0-y0-z0-deux)*uns8
            ff(3) = (un+x0)* (un+y0)* (un-z0)* (x0+y0-z0-deux)*uns8
            ff(4) = (un-x0)* (un+y0)* (un-z0)* (-x0+y0-z0-deux)*uns8
            ff(5) = (un-x0)* (un-y0)* (un+z0)* (-x0-y0+z0-deux)*uns8
            ff(6) = (un+x0)* (un-y0)* (un+z0)* (x0-y0+z0-deux)*uns8
            ff(7) = (un+x0)* (un+y0)* (un+z0)* (x0+y0+z0-deux)*uns8
            ff(8) = (un-x0)* (un+y0)* (un+z0)* (-x0+y0+z0-deux)*uns8
            ff(9) = (un-x0*x0)* (un-y0)* (un-z0)*uns4
            ff(10) = (un+x0)* (un-y0*y0)* (un-z0)*uns4
            ff(11) = (un-x0*x0)* (un+y0)* (un-z0)*uns4
            ff(12) = (un-x0)* (un-y0*y0)* (un-z0)*uns4
            ff(13) = (un-x0)* (un-y0)* (un-z0*z0)*uns4
            ff(14) = (un+x0)* (un-y0)* (un-z0*z0)*uns4
            ff(15) = (un+x0)* (un+y0)* (un-z0*z0)*uns4
            ff(16) = (un-x0)* (un+y0)* (un-z0*z0)*uns4
            ff(17) = (un-x0*x0)* (un-y0)* (un+z0)*uns4
            ff(18) = (un+x0)* (un-y0*y0)* (un+z0)*uns4
            ff(19) = (un-x0*x0)* (un+y0)* (un+z0)*uns4
            ff(20) = (un-x0)* (un-y0*y0)* (un+z0)*uns4
!
!         ------------------------------------------------------------------
        case('H27')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
            nno = 27
            ASSERT(dimf.ge.nno)
!
            ff(1) = al31(x0)*al31(y0)*al31(z0)
            ff(2) = al33(x0)*al31(y0)*al31(z0)
            ff(3) = al33(x0)*al33(y0)*al31(z0)
            ff(4) = al31(x0)*al33(y0)*al31(z0)
            ff(5) = al31(x0)*al31(y0)*al33(z0)
            ff(6) = al33(x0)*al31(y0)*al33(z0)
            ff(7) = al33(x0)*al33(y0)*al33(z0)
            ff(8) = al31(x0)*al33(y0)*al33(z0)
            ff(9) = al32(x0)*al31(y0)*al31(z0)
            ff(10) = al33(x0)*al32(y0)*al31(z0)
            ff(11) = al32(x0)*al33(y0)*al31(z0)
            ff(12) = al31(x0)*al32(y0)*al31(z0)
            ff(13) = al31(x0)*al31(y0)*al32(z0)
            ff(14) = al33(x0)*al31(y0)*al32(z0)
            ff(15) = al33(x0)*al33(y0)*al32(z0)
            ff(16) = al31(x0)*al33(y0)*al32(z0)
            ff(17) = al32(x0)*al31(y0)*al33(z0)
            ff(18) = al33(x0)*al32(y0)*al33(z0)
            ff(19) = al32(x0)*al33(y0)*al33(z0)
            ff(20) = al31(x0)*al32(y0)*al33(z0)
            ff(21) = al32(x0)*al32(y0)*al31(z0)
            ff(22) = al32(x0)*al31(y0)*al32(z0)
            ff(23) = al33(x0)*al32(y0)*al32(z0)
            ff(24) = al32(x0)*al33(y0)*al32(z0)
            ff(25) = al31(x0)*al32(y0)*al32(z0)
            ff(26) = al32(x0)*al32(y0)*al33(z0)
            ff(27) = al32(x0)*al32(y0)*al32(z0)
!
!         ------------------------------------------------------------------
        case('SH6')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
            nno = 6
            ASSERT(dimf.ge.nno)
            al = un - x0 - y0
!
            ff(1) = undemi*x0*(un-z0)
            ff(2) = undemi*y0*(un-z0)
            ff(3) = undemi*al*(un-z0)
            ff(4) = undemi*x0*(un+z0)
            ff(5) = undemi*y0*(un+z0)
            ff(6) = undemi*al*(un+z0)
!         ------------------------------------------------------------------
        case('PE6')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
            nno = 6
            ASSERT(dimf.ge.nno)
!
            ff(1) = undemi*y0* (un-x0)
            ff(2) = undemi*z0* (un-x0)
            ff(3) = undemi* (un-y0-z0)* (un-x0)
            ff(4) = undemi*y0* (un+x0)
            ff(5) = undemi*z0* (un+x0)
            ff(6) = undemi* (un-y0-z0)* (un+x0)
!
!         ------------------------------------------------------------------
        case('S15')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
            nno = 15
            ASSERT(dimf.ge.nno)
            al = un - x0 - y0
!
            ff(1)  = x0* (un-z0)* ((deux*x0)-deux-z0)/deux
            ff(2)  = y0* (un-z0)* ((deux*y0)-deux-z0)/deux
            ff(3)  = al* (z0-un)* (z0+ (deux*x0)+ (deux*y0))/deux
            ff(4)  = x0* (un+z0)* ((deux*x0)-deux+z0)/deux
            ff(5)  = y0* (un+z0)* ((deux*y0)-deux+z0)/deux
            ff(6)  = al* (-z0-un)* (-z0+ (deux*x0)+(deux*y0))/deux
!
            ff(7)  = deux*x0*y0* (un-z0)
            ff(8)  = deux*y0*al* (un-z0)
            ff(9)  = deux*x0*al* (un-z0)
!
            ff(10) = x0* (un-z0*z0)
            ff(11) = y0* (un-z0*z0)
            ff(12) = al* (un-z0*z0)
!
            ff(13) = deux*x0*y0* (un+z0)
            ff(14) = deux*y0*al* (un+z0)
            ff(15) = deux*x0*al* (un+z0)
!
!         ------------------------------------------------------------------
        case('P15')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
            nno = 15
            ASSERT(dimf.ge.nno)
            al = un - y0 - z0
!
            ff(1) = y0* (un-x0)* ((deux*y0)-deux-x0)/deux
            ff(2) = z0* (un-x0)* ((deux*z0)-deux-x0)/deux
            ff(3) = al* (x0-un)* (x0+ (deux*y0)+ (deux*z0))/deux
            ff(4) = y0* (un+x0)* ((deux*y0)-deux+x0)/deux
            ff(5) = z0* (un+x0)* ((deux*z0)-deux+x0)/deux
            ff(6) = al* (-x0-un)* (-x0+ (deux*y0)+ (deux*z0))/deux
!
            ff(7) = deux*y0*z0* (un-x0)
            ff(8) = deux*z0*al* (un-x0)
            ff(9) = deux*y0*al* (un-x0)
!
            ff(10) = y0* (un-x0*x0)
            ff(11) = z0* (un-x0*x0)
            ff(12) = al* (un-x0*x0)
!
            ff(13) = deux*y0*z0* (un+x0)
            ff(14) = deux*z0*al* (un+x0)
            ff(15) = deux*y0*al* (un+x0)
!
!         ------------------------------------------------------------------
        case('P18')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
            nno = 18
            ASSERT(dimf.ge.nno)
!
            ff(1) = x0*y0*(x0-un)*(deux*y0-un)/deux
            ff(2) = x0*z0*(x0-un)*(deux*z0-un)/deux
            ff(3) = x0*(x0-un)*(z0+y0-un)*(deux*z0+deux*y0-un)/deux
            ff(4) = x0*y0*(x0+un)*(deux*y0-un)/deux
            ff(5) = x0*z0*(x0+un)*(deux*z0-un)/deux
            ff(6) = x0*(x0+un)*(z0+y0-un)*(deux*z0+deux*y0-un)/deux
!
            ff(7) = deux*x0*y0*z0*(x0-un)
            ff(8) = -deux*x0*z0*(x0-un)*(z0+y0-un)
            ff(9) = -deux*x0*y0*(x0-un)*(z0+y0-un)
!
            ff(10) = -y0*(x0-un)*(x0+un)*(deux*y0-un)
            ff(11) = -z0*(x0-un)*(x0+un)*(deux*z0-un)
            ff(12) = -(x0-un)*(x0+un)*(z0+y0-un)*(deux*z0+deux*y0-un)
!
            ff(13) = deux*x0*y0*z0*(x0+un)
            ff(14) = -deux*x0*z0*(x0+un)*(z0+y0-un)
            ff(15) = -deux*x0*y0*(x0+un)*(z0+y0-un)
!
            ff(16) = -quatre*y0*z0*(x0-un)*(x0+un)
            ff(17) = quatre*z0*(x0-un)*(x0+un)*(z0+y0-un)
            ff(18) = quatre*y0*(x0-un)*(x0+un)*(z0+y0-un)
!
!         ------------------------------------------------------------------
        case('TE4')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
            nno = 4
            ASSERT(dimf.ge.nno)
!
            ff(1) = y0
            ff(2) = z0
            ff(3) = un - x0 - y0 - z0
            ff(4) = x0
!
!         ------------------------------------------------------------------
        case('T10')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
            nno = 10
            ASSERT(dimf.ge.nno)
            al = un - x0 - y0 - z0
!
            ff(1) = (deux*y0-un)*y0
            ff(2) = (deux*z0-un)*z0
            ff(3) = (deux*al-un)*al
            ff(4) = (deux*x0-un)*x0
            ff(5) = quatre*z0*y0
            ff(6) = quatre*z0*al
            ff(7) = quatre*al*y0
            ff(8) = quatre*x0*y0
            ff(9) = quatre*x0*z0
            ff(10) = quatre*x0*al
!
!         ------------------------------------------------------------------
        case('PY5')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
            nno = 5
            ASSERT(dimf.ge.nno)
            z04 = (un-z0)*quatre
!
            pface1 = x0 + y0 + z0 - un
            pface2 = -x0 + y0 + z0 - un
            pface3 = -x0 - y0 + z0 - un
            pface4 = x0 - y0 + z0 - un
!
            if (abs(z0-un) .lt. 1.0d-6) then
                do 10 i = 1, 4
                    ff(i) = zero
10              continue
                ff(5) = un
            else
                ff(1) = pface2*pface3/z04
                ff(2) = pface3*pface4/z04
                ff(3) = pface1*pface4/z04
                ff(4) = pface1*pface2/z04
                ff(5) = z0
            endif
!
!         ------------------------------------------------------------------
        case('P13')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
            nno = 13
            ASSERT(dimf.ge.nno)
            z01 = un - z0
            z02 = (un-z0)*deux
!
            pface1 = x0 + y0 + z0 - un
            pface2 = -x0 + y0 + z0 - un
            pface3 = -x0 - y0 + z0 - un
            pface4 = x0 - y0 + z0 - un
!
            pmili1 = x0 - undemi
            pmili2 = y0 - undemi
            pmili3 = -x0 - undemi
            pmili4 = -y0 - undemi
!
            if (abs(z0-un) .lt. 1.0d-6) then
                do 20 i = 1, 13
                    ff(i) = zero
20              continue
                ff(5) = un
            else
                ff(1) = pface2*pface3*pmili1/z02
                ff(2) = pface3*pface4*pmili2/z02
                ff(3) = pface4*pface1*pmili3/z02
                ff(4) = pface1*pface2*pmili4/z02
                ff(5) = deux*z0* (z0-undemi)
                ff(6) = -pface2*pface3*pface4/z02
                ff(7) = -pface3*pface4*pface1/z02
                ff(8) = -pface4*pface1*pface2/z02
                ff(9) = -pface1*pface2*pface3/z02
                ff(10) = z0*pface2*pface3/z01
                ff(11) = z0*pface3*pface4/z01
                ff(12) = z0*pface4*pface1/z01
                ff(13) = z0*pface1*pface2/z01
            endif
!
!         ------------------------------------------------------------------
        case('TR3')
!
            x0 = x(1)
            y0 = x(2)
            nno = 3
            ASSERT(dimf.ge.nno)
!
            ff(1) = un - x0 - y0
            ff(2) = x0
            ff(3) = y0
!
!         ------------------------------------------------------------------
        case('TR6')
!
            x0 = x(1)
            y0 = x(2)
            nno = 6
            ASSERT(dimf.ge.nno)
            al = un - x0 - y0
!
            ff(1) = -al* (un-deux*al)
            ff(2) = -x0* (un-deux*x0)
            ff(3) = -y0* (un-deux*y0)
            ff(4) = quatre*x0*al
            ff(5) = quatre*x0*y0
            ff(6) = quatre*y0*al
!
!         ------------------------------------------------------------------
        case('TR7')
!
            x0 = x(1)
            y0 = x(2)
            nno = 7
            ASSERT(dimf.ge.nno)
!
            ff(1) = un - 3.0d0*(x0+y0) + 2.0d0*(x0*x0+y0*y0) + 7.0d0*x0* y0 - 3.0d0*x0*y0*(x0+y0)
            ff(2) = x0*( -un + 2.0d0*x0 + 3.0d0*y0 - 3.0d0*y0*(x0+y0) )
            ff(3) = y0*( -un + 3.0d0*x0 + 2.0d0*y0 - 3.0d0*x0*(x0+y0) )
            ff(4) = quatre*x0*( un - x0 - 4.0d0*y0 + 3.0d0*y0*(x0+y0) )
            ff(5) = quatre*x0*y0*( -deux + 3.0d0*(x0+y0) )
            ff(6) = quatre*y0*( un - y0 - 4.0d0*x0 + 3.0d0*x0*(x0+y0) )
            ff(7) = 27.0d0*x0*y0*( un - x0 - y0 )
!
!         ------------------------------------------------------------------
        case('QU4')
!
            x0 = x(1)
            y0 = x(2)
            nno = 4
            ASSERT(dimf.ge.nno)
!
            ff(1) = uns4* (un-x0)* (un-y0)
            ff(2) = uns4* (un+x0)* (un-y0)
            ff(3) = uns4* (un+x0)* (un+y0)
            ff(4) = uns4* (un-x0)* (un+y0)
!
!         ------------------------------------------------------------------
        case('QU8')
!
            x0 = x(1)
            y0 = x(2)
            nno = 8
            ASSERT(dimf.ge.nno)
!
            ff(1) = uns4* (un-x0)* (un-y0)* (-un-x0-y0)
            ff(2) = uns4* (un+x0)* (un-y0)* (-un+x0-y0)
            ff(3) = uns4* (un+x0)* (un+y0)* (-un+x0+y0)
            ff(4) = uns4* (un-x0)* (un+y0)* (-un-x0+y0)
            ff(5) = undemi* (un-x0*x0)* (un-y0)
            ff(6) = undemi* (un-y0*y0)* (un+x0)
            ff(7) = undemi* (un-x0*x0)* (un+y0)
            ff(8) = undemi* (un-y0*y0)* (un-x0)
!
!         ------------------------------------------------------------------
        case('QU9')
!
            x0 = x(1)
            y0 = x(2)
            nno = 9
            ASSERT(dimf.ge.nno)
!
            ff(1) = al31(x0)*al31(y0)
            ff(2) = al33(x0)*al31(y0)
            ff(3) = al33(x0)*al33(y0)
            ff(4) = al31(x0)*al33(y0)
            ff(5) = al32(x0)*al31(y0)
            ff(6) = al33(x0)*al32(y0)
            ff(7) = al32(x0)*al33(y0)
            ff(8) = al31(x0)*al32(y0)
            ff(9) = al32(x0)*al32(y0)
!
!         ------------------------------------------------------------------
        case('PO1')
            nno = 1
            ASSERT(dimf.ge.nno)
            ff(1) = un
!
!         ------------------------------------------------------------------
        case('SE2')
!
            x0 = x(1)
            nno = 2
            ASSERT(dimf.ge.nno)
!
            ff(1) = (un-x0)/deux
            ff(2) = (un+x0)/deux
!
!         ------------------------------------------------------------------
        case('SE3')
!
            x0 = x(1)
            nno = 3
            ASSERT(dimf.ge.nno)
!
            ff(1) = - (un-x0)*x0/deux
            ff(2) = (un+x0)*x0/deux
            ff(3) = (un+x0)* (un-x0)
!
!         ------------------------------------------------------------------
        case('SE4')
            nno = 4
            ASSERT(dimf.ge.nno)
            x0 = x(1)
!
            x1 = -1.d0
            x2 = 1.d0
            x3 = -1.d0/3.d0
            x4 = 1.d0/3.d0
            d1 = (x1-x2)* (x1-x3)* (x1-x4)
!
            ff(1) = (x0-x2)* (x0-x3)* (x0-x4)/d1
            d2 = (x2-x1)* (x2-x3)* (x2-x4)
!
            ff(2) = (x0-x1)* (x0-x3)* (x0-x4)/d2
            d3 = (x3-x1)* (x3-x2)* (x3-x4)
!
            ff(3) = (x0-x1)* (x0-x2)* (x0-x4)/d3
            d4 = (x4-x1)* (x4-x2)* (x4-x3)
!
            ff(4) = (x0-x1)* (x0-x2)* (x0-x3)/d4
!
!         ------------------------------------------------------------------
!
        case default
            ASSERT(ASTER_FALSE)
    end select
!
end subroutine
