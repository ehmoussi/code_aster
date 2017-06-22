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

subroutine regder(dimdef, dimcon, ndim, regula, dsde2g,&
                  drde)
! ======================================================================
    implicit none
    integer :: dimdef, dimcon, ndim, regula(6)
    real(kind=8) :: dsde2g(ndim*ndim*ndim, ndim*ndim*ndim)
    real(kind=8) :: drde(dimcon, dimdef)
! --- BUT : MISE A JOUR DE L OPERATEUR TANGENT POUR LA PARTIE ----------
! ---       SECOND GRADIENT AU POINT D INTEGRATION ---------------------
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i, j, adder1, adder2, adder3, adcor1, adcor2, adcor3
    integer :: dimde1, dimde2, dimde3
! ======================================================================
    adder1 = regula(1)
    adder2 = regula(2)
    adder3 = regula(3)
    adcor1 = regula(4)
    adcor2 = regula(5)
    adcor3 = regula(6)
    dimde1 = adder2-adder1
    dimde2 = adder3-adder2
    dimde3 = dimdef-adder3+1
! ======================================================================
    do 10 i = 1, dimdef
        do 20 j = 1, dimcon
            drde(j,i)=0.0d0
20      continue
10  end do
! ======================================================================
    do 30 i = 1, dimde1
        drde(adcor1-1+i,adder3-1+i)=drde(adcor1-1+i,adder3-1+i)+1.0d0
30  end do
    do 40 i = 1, dimde2
        do 50 j = 1, dimde2
            drde(adcor2-1+j,adder2-1+i)=drde(adcor2-1+j,adder2-1+i)+&
            dsde2g(j,i)
50      continue
40  end do
    do 60 i = 1, dimde3
        drde(adcor3-1+i,adder1-1+i)=drde(adcor3-1+i,adder1-1+i)-1.0d0
60  end do
! ======================================================================
end subroutine
