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

function rcexistvarc(varc_name_)
!
use calcul_module, only : ca_jvcnom_, ca_nbcvrc_
!
implicit none
!
#include "jeveux.h"
#include "asterc/indik8.h"
!
    character(len=*), intent(in) :: varc_name_
    logical:: rcexistvarc
!
! --------------------------------------------------------------------------------------------------
!
! Material - External state variables (VARC)
!
! Is external state variable exist ?
!
! --------------------------------------------------------------------------------------------------
!
! In  varc_name     : name of external state variable
!
! Out true    if exist on the current element
!     false   if not exist on the current element
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: varc_name
    integer :: varc_indx
!
! --------------------------------------------------------------------------------------------------
!
    varc_name = varc_name_
!
!   If no external state variable
    if (ca_nbcvrc_ .eq. 0) then
        rcexistvarc = .false.
    else
        varc_indx = indik8(zk8(ca_jvcnom_), varc_name, 1, ca_nbcvrc_)
        rcexistvarc = ( varc_indx .gt. 0 )
    endif
!
end function
