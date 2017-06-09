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

function rgcmpg(icode, irgcmp)
    implicit none
    integer :: rgcmpg
#include "asterfort/exisdg.h"
    integer :: icode, irgcmp
!
! --- ------------------------------------------------------------------
!
!        RANG DE LA VALEUR DANS LA CARTE EN DECODANT L'ENTIER CODE
!
! --- ------------------------------------------------------------------
!
! IN
!     ICODE  : ENTIER CODE DE LA ZONE DE LA CARTE
!     IRGCMP : RANG DE LA COMPOSANTE DANS LA CARTE
!
! OUT
!     RGCMPG : RANG DE LA VALEUR DANS L'ENTIER CODE
! --- ------------------------------------------------------------------
    integer :: icmp, irgval
! --- ------------------------------------------------------------------
!
    irgval = 0
    do icmp = 1, irgcmp
        if (exisdg([icode],icmp)) irgval = irgval + 1
    end do
!     SORTIE
    rgcmpg = irgval
!
end function
