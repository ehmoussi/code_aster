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

subroutine foc2in(method, nbpts, var, fon, cste,&
                  res)
    implicit none
    character(len=*) :: method
    integer :: nbpts
    real(kind=8) :: var(*), fon(*), cste, res(*)
!     INTEGRATION D'UNE FONCTION PAR LA METHODE DE SIMPSON.
!     ------------------------------------------------------------------
! IN  METHOD : K  : NOM DE LA METHODE D'INTEGRATION
!                       TRAPEZES   : DISPONIBLE
!                       SIMPSON    : DISPONIBLE
! IN  NBPTS  : IS : NOMBRE DE PAS DE TEMPS
! IN  VAR    : R8 : TABLEAU DE LA VARIABLE (LES INSTANTS)
! IN  FON    : R8 : TABLEAU DE LA FONCTION A INTEGRER
! IN  CSTE   : R8 : CONSTANTE D'INTEGRATION
! OUT RES    : R8 : TABLEAU DE LA FONCTION INTEGREE
!     ------------------------------------------------------------------
!
    real(kind=8) :: fa, fm, fb
    real(kind=8) :: h1, h2, bma, deltah, epsi
    real(kind=8) :: ct1, ct2, ct3
    real(kind=8) :: zero, un, deux, quatre, six, eps
!
!     COEF(1) POUR LES IMPAIRS, COEF(2) POUR LES PAIRS
    real(kind=8) :: coef(2)
    integer :: ip(2)
!-----------------------------------------------------------------------
    integer :: i, iperm
!-----------------------------------------------------------------------
    data      ip/2,1/
!     ------------------------------------------------------------------
    zero = 0.0d0
    un = 1.0d0
    deux = 2.0d0
    quatre = 4.0d0
    six = 6.0d0
    eps = 1.0d-04
!
!
!
    if (method .eq. 'TRAPEZE') then
!
        res(1) = cste
        do 100 i = 2, nbpts
            res(i) = res(i-1) + (var(i)-var(i-1)) * (fon(i)+fon(i-1)) * 0.5d0
100      end do
!
    else if (method.eq.'SIMPSON') then
!
        fm = fon(1)
        fb = fon(2)
        h2 = var(2) - var(1)
        coef(1) = cste
        coef(2) = cste +(fb+fm)*h2/deux
        res(1) = coef(1)
        res(2) = coef(2)
        iperm = 1
        do 200 i = 3, nbpts
            h1 = h2
            h2 = var(i) - var(i-1)
            bma = h1 + h2
            fa = fm
            fm = fb
            fb = fon(i)
            if (h1 .eq. zero .or. h2 .eq. zero) then
                ct1 = un
                ct2 = quatre
                ct3 = un
            else
                deltah = h2 - h1
                if (abs( deltah / h1 ) .le. eps) then
                    ct1 = un
                    ct2 = quatre
                    ct3 = un
                else
!              EXPRESSION "SIMPLE" DES COEFFICIENTS
!              CT1  = DEUX - H2/H1
!              CT2  = (H1+H2)*(H1+H2)/(H1*H2)
!              CT3  = DEUX - H1/H2
!
!              EXPRESSION "INFORMATIQUE" DES COEFFICIENTS
                    epsi = deltah / (h1*h2)
                    ct1 = un - epsi * h2
                    ct2 = quatre + epsi * deltah
                    ct3 = un + epsi * h1
                endif
            endif
            coef(iperm) = coef(iperm) + (bma/six)*(ct1*fa+ct2*fm+ct3* fb)
            res(i) = coef(iperm)
            iperm = ip(iperm)
200      end do
!
    endif
!
end subroutine
