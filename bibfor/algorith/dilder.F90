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

subroutine dilder(interp, dimdef, dimcon, ndim, regula,&
                  rpena, dsde2g, drde)
! ======================================================================
    implicit     none
    integer :: dimdef, dimcon, ndim, regula(6)
    real(kind=8) :: dsde2g(ndim, ndim), drde(dimcon, dimdef), rpena
    character(len=2) :: interp
! ======================================================================
! person_in_charge: romeo.fernandes at edf.fr
! --- BUT : MISE A JOUR DE L OPERATEUR TANGENT POUR LA PARTIE ----------
! ---       SECOND GRADIENT A MIDCRO DILATATION AU POINT D INTEGRATION -
! ======================================================================
    integer :: i, j, adder1, adder2, adder3, adcor1, adcor2, adcor3
! ======================================================================
    adder1=regula(1)
    adder2=regula(2)
    adder3=regula(3)
    adcor1=regula(4)
    adcor2=regula(5)
    adcor3=regula(6)
! ======================================================================
    do 10 i = 1, dimdef
        do 20 j = 1, dimcon
            drde(j,i)=0.0d0
20      continue
10  end do
! ======================================================================
    drde(adcor1,adder1)=drde(adcor1,adder1)+rpena
    do 30 i = 1, ndim
        do 40 j = 1, ndim
            drde(adcor2-1+j,adder2-1+i)=drde(adcor2-1+j,adder2-1+i)+&
            dsde2g(j,i)
40      continue
30  end do
    if (interp .ne. 'SL') then
        drde(adcor1,adder3)=drde(adcor1,adder3)+1.0d0
        drde(adcor3,adder1)=drde(adcor3,adder1)-1.0d0
    endif
! ======================================================================
end subroutine
