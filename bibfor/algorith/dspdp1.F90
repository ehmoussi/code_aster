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

subroutine dspdp1(net, bishop, signe, tbiot, sat,&
                  dsdp1)
    implicit none
#include "asterf_types.h"
#include "asterfort/utmess.h"
!
    integer :: i
    real(kind=8) :: signe, tbiot(6), sat, dsdp1(6)
    aster_logical :: net, bishop
! ======================================================================
!
! --- CALCUL DE LA DERIVEE DE LA CONTRAINTE DE PRESSION PAR RAPPORT ----
! --- A LA PRESSION CAPILLAIRE -----------------------------------------
! ======================================================================
    do 10 i = 1, 6
        if (bishop) then
            dsdp1(i) = signe*tbiot(i)*sat
        else if (net) then
            dsdp1(i) = 0.d0
        else
            call utmess('F', 'ALGORITH17_4')
        endif
 10 end do
! ======================================================================
end subroutine
