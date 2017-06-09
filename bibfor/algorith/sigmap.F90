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

subroutine sigmap(net, bishop, sat, signe, tbiot,&
                  dp2, dp1, sigmp)
!
    implicit none
#include "asterf_types.h"
#include "asterfort/utmess.h"
    integer :: i
    real(kind=8) :: signe, sat, tbiot(6), dp2, dp1, sigmp(6)
    aster_logical :: net, bishop
! --- CALCUL DES CONTRAINTES DE PRESSIONS ------------------------------
! ======================================================================
!
    do 10 i = 1, 6
        if (bishop) then
            sigmp(i) = tbiot(i)*sat*signe*dp1 - tbiot(i)*dp2
        else if (net) then
            sigmp(i) = - tbiot(i)*dp2
        else
            call utmess('F', 'ALGORITH17_4')
        endif
 10 end do
! ======================================================================
end subroutine
