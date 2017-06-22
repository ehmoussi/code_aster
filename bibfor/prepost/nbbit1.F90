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

subroutine nbbit1(ec, nb1)
    implicit none
!
!
    integer :: ec, nb1
!
!*********************************************************************
!
!       NB1 := NBR DE BIT A 1 DANS LA REPRESENTATION BINAIRE DE EC
!
!       (APPLICATION DIRECT AU COMPTAGE DE COMPOSANTES ACTIVES
!        D' UNE GRANDEUR DECRITE PAR ENTIER CODE)
!
!*********************************************************************
!
    integer :: test, i
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    nb1 = 0
    test = 1
!
    do 10, i= 1, 30, 1
!
    test = 2*test
!
    if (iand(ec,test) .gt. 0) then
!
        nb1 = nb1 + 1
!
    endif
!
    10 end do
!
end subroutine
