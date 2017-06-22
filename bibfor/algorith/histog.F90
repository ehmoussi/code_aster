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

subroutine histog(nbpt, v, vmin, vmax, x,&
                  y, ndec)
!        CACUL DE L'HISTOGRAMME AMV
!
! IN  : NBPT   : NB DE POINTS DU SIGNAL
! IN  : V      : TABLEAU DU SIGNAL
! IN  : NDEC   : NOMBRE DE CLASSES DE L'HISTOGRAMME
! OUT : VMIN   : VALEUR MINIMALE DU SIGNAL
! OUT : VMAX   : VALEUR MAXIMALE DU SIGNAL
! OUT : X      : TABLEAU DE VALEUR DES ABSCISSES DE L'HISTOGRAMME
! OUT : Y      : TABLEAU DES DENSITES DE PROBABILITE DES CLASSES
! ----------------------------------------------------------------------
!
    implicit none
    real(kind=8) :: v(*), x(*), y(*)
    real(kind=8) :: vmin, vmax
    integer :: nbpt, ndec
    real(kind=8) :: dx
    integer :: i, icel
    real(kind=8) :: coef
!-----------------------------------------------------------------------
!
    do 5 i = 1, ndec
        x(i)=0.d0
        y(i)=0.d0
 5  end do
    do 10 i = 1, nbpt
        if (v(i) .ge. vmax) vmax = v(i)
        if (v(i) .le. vmin) vmin = v(i)
10  end do
    if (nbpt .ne. 0) then
        dx = (vmax-vmin)/ndec
        coef = 1.d0/nbpt
    else
        dx =0.d0
        coef = 1.d0
        vmin = 0.d0
        vmax = 0.d0
    endif
    do 20 i = 1, nbpt
        if (dx .ne. 0.d0) then
            icel = int((v(i)-vmin)/dx)+1
        else
            icel = 1
        endif
        if (icel .gt. ndec) icel = ndec
        y(icel)=y(icel)+1
20  end do
    do 30 i = 1, ndec
        x(i)=vmin+i*dx
        y(i)=y(i)*coef
30  end do
end subroutine
