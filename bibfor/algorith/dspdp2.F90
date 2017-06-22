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

subroutine dspdp2(net, bishop, tbiot, dsdp2)
    implicit none
#include "asterf_types.h"
#include "asterfort/utmess.h"
    integer :: i
    real(kind=8) :: tbiot(6), dsdp2(6)
    aster_logical :: net, bishop
! ======================================================================
!
! --- CALCUL DE LA DERIVEE DE LA CONTRAINTE DE PRESSION PAR RAPPORT ----
! --- A LA PRESSION DE GAZ ---------------------------------------------
! ======================================================================
    do 10 i = 1, 6
        if (bishop) then
            dsdp2(i) = - tbiot(i)
        else if (net) then
            dsdp2(i) = - tbiot(i)
        else
            call utmess('F', 'ALGORITH17_4')
        endif
 10 end do
! ======================================================================
end subroutine
