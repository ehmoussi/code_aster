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

subroutine dtmcase_coder(input_, koutput)
    implicit none
!
! person_in_charge: hassan.berro at edf.fr
!
! dtmcase_coder : Code, inside a string, a given non-linearity case given 
!                 as an integer. 63 ASCII characters are used for the encoding.
!                 Case-0  is '0'
!                 Case-63 is '.'
!
#include "jeveux.h"
!
!   -0.1- Input/output arguments
    integer          , intent(in)   :: input_
    character(len=*) , intent(out)  :: koutput
!
!   -0.2- Local variables
    integer          :: input, length, base, ind, digit
    character(len=1) :: charac(0:62)

    data        charac / '0','1','2','3','4','5','6','7','8','9',&
                         'A','B','C','D','E','F','G','H','I','J',&
                         'K','L','M','N','O','P','Q','R','S','T',&
                         'U','V','W','X','Y','Z','a','b','c','d',&
                         'e','f','g','h','i','j','k','l','m','n',&
                         'o','p','q','r','s','t','u','v','w','x',&
                         'y','z','.'/
    koutput = ' '
!
    input = input_
    if (input.lt.0) input = -input
    length = len(koutput)
!
    base = 63
    ind  = length
    do while (ind.gt.0)
        digit            = input - int(input/base)*base
        input            = (input - digit)/base
        koutput(ind:ind) = charac(digit)
        ind              = ind - 1
    end do

end subroutine
