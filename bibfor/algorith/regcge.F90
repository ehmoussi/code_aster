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

subroutine regcge(dimdef, dimcon, regula, ndim, defgep,&
                  sigp, r)
! --- BUT : MISE A JOUR DU CHAMP DE CONTRAINTES GENERALISEES -----------
! ======================================================================
    implicit      none
    integer :: dimdef, dimcon, regula(6), ndim
    real(kind=8) :: sigp(ndim*ndim*ndim), defgep(dimdef), r(dimcon)
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i, adder1, adder2, adder3, adcor1, adcor2, adcor3
    integer :: dimde1, dimde2, dimde3
! ======================================================================
! --- DEFINITION DES DONNEES INITIALES ---------------------------------
! ======================================================================
    adder1 = regula(1)
    adder2 = regula(2)
    adder3 = regula(3)
    adcor1 = regula(4)
    adcor2 = regula(5)
    adcor3 = regula(6)
    dimde1 = adder2 - adder1
    dimde2 = adder3 - adder2
    dimde3 = dimdef - adder3 + 1
    do 10 i = 1, dimde1
        r(adcor1-1+i) = defgep(adder3-1+i)
10  end do
    do 20 i = 1, dimde2
        r(adcor2-1+i) = sigp(i)
20  end do
    do 30 i = 1, dimde3
        r(adcor3-1+i) = -defgep(adder1-1+i)
30  end do
! ======================================================================
end subroutine
